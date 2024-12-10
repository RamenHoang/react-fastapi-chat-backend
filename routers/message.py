import json
from typing import List
from pydantic import BaseModel
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from constants import ROLE_ADMIN, ROLE_MODERATOR
from models import Message, User, Group, GroupMembership, UserMessageStatus
from schemas import MessageCreate
from database import get_db
from auth import get_current_user, oauth2_scheme
from routers.websocket_manager import manager

router = APIRouter()


@router.post("/send_message")
async def send_message(message: MessageCreate, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)

    group = db.query(Group).filter(Group.id == message.receiver_id).first()
    if group:
        db_message = Message(
            sender_id=current_user.id,
            receiver_id=group.id,
            content=message.content,
            is_group_message=True
        )
        db.add(db_message)
        db.commit()
        db.refresh(db_message)

        group_members = db.query(GroupMembership).filter(
            GroupMembership.group_id == group.id).all()

        for member in group_members:
            status = "read" if member.user_id == current_user.id else "sent"
            user_message_status = UserMessageStatus(
                message_id=db_message.id,
                user_id=member.user_id,
                status=status
            )
            db.add(user_message_status)

    else:
        recipient = db.query(User).filter(
            User.id == message.receiver_id).first()
        if not recipient:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Recipient not found")

        db_message = Message(
            sender_id=current_user.id,
            receiver_id=recipient.id,
            content=message.content,
            is_group_message=False,
            encrypted_for_user_id=message.encrypted_for_user_id
        )
        db.add(db_message)
        db.commit()
        db.refresh(db_message)

        sender_status = UserMessageStatus(
            message_id=db_message.id,
            user_id=current_user.id,
            status="read"
        )
        recipient_status = UserMessageStatus(
            message_id=db_message.id,
            user_id=recipient.id,
            status="sent"
        )
        db.add(sender_status)
        db.add(recipient_status)

    db.commit()

    notification_message = {
        "type": "message",
    }
    await manager.broadcast(json.dumps(notification_message))

    return {"message": "Message sent"}


class ReadMessagesRequest(BaseModel):
    user_id: int
    message_ids: List[int]


@router.put("/read")
async def mark_messages_as_read(
    request: ReadMessagesRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.id != request.user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    db.query(UserMessageStatus).filter(
        UserMessageStatus.user_id == request.user_id,
        UserMessageStatus.message_id.in_(request.message_ids)
    ).update({"status": "read"}, synchronize_session=False)

    db.commit()

    await manager.broadcast(f"Messages {request.message_ids} marked as 'read'")

    return {"message": f"Status for messages {request.message_ids} set to 'read'"}


@router.delete("/delete_message/{message_id}")
async def delete_message(message_id: int, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)
    message = db.query(Message).filter(Message.id == message_id).first()

    if not message:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Message not found")

    if not current_user.role in [ROLE_ADMIN, ROLE_MODERATOR]:
        if message.sender_id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    db.query(UserMessageStatus).filter(UserMessageStatus.message_id == message_id).delete()
    db.delete(message)
    db.commit()

    await manager.broadcast(f"Message {message_id} deleted")

    return {"message": "Message deleted successfully"}


@router.put("/pin_message/{message_id}")
async def pin_message(message_id: int, db: Session = Depends(get_db)):
    message = db.query(Message).filter(Message.id == message_id).first()

    if not message:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Message not found")

    # if message.sender_id != current_user.id and current_user.role not in [ROLE_ADMIN, ROLE_MODERATOR]:
    #     raise HTTPException(
    #         status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    message.is_pin = not message.is_pin
    db.commit()

    await manager.broadcast(f"Message {message_id} {'pinned' if message_id else 'unpinned'}")

    return {"message": f"Message {'pinned' if message_id else 'unpinned'} successfully"}

@router.post("/send_image_message")
async def send_image_message(message: MessageCreate, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)

    group = db.query(Group).filter(Group.id == message.receiver_id).first()
    db_message = Message(
        sender_id=current_user.id,
        receiver_id=group.id,
        is_group_message=True,
        file_data=message.content
    )
    db.add(db_message)
    db.commit()
    db.refresh(db_message)

    group_members = db.query(GroupMembership).filter(
        GroupMembership.group_id == group.id).all()

    for member in group_members:
        status = "read" if member.user_id == current_user.id else "sent"
        user_message_status = UserMessageStatus(
            message_id=db_message.id,
            user_id=member.user_id,
            status=status
        )
        db.add(user_message_status)

    db.commit()

    notification_message = {
        "type": "message",
    }
    await manager.broadcast(json.dumps(notification_message))

    return {"message": "Message sent"}

# @router.get("/chats")
# def get_user_chats(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
#     messages = db.query(Message).filter(
#         or_(
#             Message.sender_id == current_user.id,
#             Message.receiver_id == current_user.id
#         )
#     ).order_by(Message.timestamp).all()

#     chats = {}
#     for message in messages:
#         partner_id = message.receiver_id if message.sender_id == current_user.id else message.sender_id
#         if partner_id not in chats:
#             chats[partner_id] = []

#         chats[partner_id].append({
#             "message_id": message.id,
#             "sender_id": message.sender_id,
#             "receiver_id": message.receiver_id,
#             "content": message.content,
#             "status": message.status,
#             "timestamp": message.timestamp
#         })

#     return {"chats": chats}
