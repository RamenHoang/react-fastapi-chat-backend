from pydantic import BaseModel
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from constants import ROLE_ADMIN, ROLE_MODERATOR
from models import Group, GroupMembership, User, Message, UserMessageStatus
from schemas import GroupCreate
from database import get_db
from auth import get_current_user, oauth2_scheme
from routers.websocket_manager import manager
from utils import generate_rsa_key_pair

router = APIRouter()


@router.post("/create_group")
async def create_group(group: GroupCreate, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)

    private_key, public_key = generate_rsa_key_pair()

    db_group = Group(
        name=group.name,
        public_key=public_key.decode('utf-8'),
        private_key=private_key.decode('utf-8')
    )

    db.add(db_group)
    db.commit()
    db.refresh(db_group)

    membership = GroupMembership(user_id=current_user.id, group_id=db_group.id)
    db.add(membership)
    
    if current_user.role != ROLE_ADMIN:
        admin = db.query(User).filter(User.role == ROLE_ADMIN).first()
        db.add(GroupMembership(user_id=admin.id, group_id=db_group.id))
        
    db.commit()

    await manager.broadcast(f"New group {group.name} created by {current_user.username}")

    return {"group_id": db_group.id, "name": db_group.name}


class AddUserToGroupRequest(BaseModel):
    user_id: int
    group_id: int


@router.post("/add_user_to_group")
async def add_user_to_group(
    request: AddUserToGroupRequest,
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    current_user = get_current_user(token, db)
    print(current_user)

    group = db.query(Group).filter(Group.id == request.group_id).first()
    user = db.query(User).filter(User.id == request.user_id).first()

    print(group)
    print(user)

    if not group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    membership = GroupMembership(
        user_id=request.user_id, group_id=request.group_id)
    db.add(membership)
    db.commit()

    await manager.broadcast(f"User {request.user_id} added to group {request.group_id}")

    return {"message": f"User {request.user_id} added to group {request.group_id}"}


class GroupLeaveRequest(BaseModel):
    group_id: int


@router.post("/leave_group")
async def leave_group(request: GroupLeaveRequest, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    group_id = request.group_id
    current_user = get_current_user(token, db)

    membership = db.query(GroupMembership).filter(
        GroupMembership.user_id == current_user.id,
        GroupMembership.group_id == group_id
    ).first()

    if not membership:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Group membership not found")

    group_messages = db.query(Message).filter(
        Message.sender_id == current_user.id,
        Message.receiver_id == group_id,
        Message.is_group_message == True
    ).all()

    for message in group_messages:
        status_entries = db.query(UserMessageStatus).filter(
            UserMessageStatus.message_id == message.id
        ).all()

        if len(status_entries) == 1 and status_entries[0].user_id == current_user.id:
            db.delete(message)

        db.query(UserMessageStatus).filter(
            UserMessageStatus.message_id == message.id,
            UserMessageStatus.user_id == current_user.id
        ).delete()

    db.delete(membership)
    db.commit()

    await manager.broadcast(f"User {current_user.username} left group {group_id}")

    return {"message": f"User {current_user.id} left group {group_id}"}


@router.delete("/delete_group/{group_id}")
async def delete_group(group_id: int, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)
    group = db.query(Group).filter(Group.id == group_id).first()

    if not group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    if current_user.role != 1:  # Assuming role 1 is admin
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    db.query(GroupMembership).filter(GroupMembership.group_id == group_id).delete()
    db.query(Message).filter(Message.receiver_id == group_id, Message.is_group_message == True).delete()
    db.delete(group)
    db.commit()

    await manager.broadcast(f"Group {group_id} deleted")

    return {"message": "Group and its related data deleted successfully"}


class RenameGroupRequest(BaseModel):
    name: str

@router.put("/rename_group/{group_id}")
async def rename_group(group_id: int, request: RenameGroupRequest, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)
    group = db.query(Group).filter(Group.id == group_id).first()

    if not group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    if current_user.role != ROLE_ADMIN:  # Assuming role 1 is admin
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    group.name = request.name
    db.commit()

    await manager.broadcast(f"Group {group_id} renamed to {request.name}")

    return {"message": "Group renamed successfully", "group_id": group.id, "new_name": group.name}


@router.get("/group_users/{group_id}")
def get_group_users(group_id: int, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)
    group = db.query(Group).filter(Group.id == group_id).first()

    if current_user.role != ROLE_ADMIN and current_user.role != ROLE_MODERATOR:  # Assuming role 1 is admin
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    if not group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    memberships = db.query(GroupMembership).filter(GroupMembership.group_id == group_id).all()
    user_ids = [membership.user_id for membership in memberships]
    
    users = db.query(User).filter(User.id.in_(user_ids)).all()
    users = [user for user in users if user.role != ROLE_ADMIN]
    users = [user for user in users if user.id != current_user.id]

    return [
        {
            "id": user.id,
            "username": user.username,
            "full_name": user.full_name,
            "email": user.email,
            "role": user.role,
            "profile_picture": user.profile_picture,
            "public_key": user.public_key
        }
        for user in users
    ]

class KickUserRequest(BaseModel):
    user_id: int

@router.post("/kick_user/{group_id}")
async def kick_user_from_group(
    group_id: int,
    request: KickUserRequest,
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    current_user = get_current_user(token, db)
    group = db.query(Group).filter(Group.id == group_id).first()
    user = db.query(User).filter(User.id == request.user_id).first()

    if not group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Group not found")

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    if current_user.role != ROLE_ADMIN and current_user.role != ROLE_MODERATOR:  # Assuming role 1 is admin
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    membership = db.query(GroupMembership).filter(
        GroupMembership.user_id == request.user_id,
        GroupMembership.group_id == group_id
    ).first()

    if not membership:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User is not a member of the group")

    db.delete(membership)
    db.commit()

    await manager.broadcast(f"User {request.user_id} kicked from group {group_id}")

    return {"message": f"User {request.user_id} kicked from group {group_id}"}
