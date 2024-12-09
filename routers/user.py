import logging
import jwt
import random
import string
from pydantic import BaseModel
from sqlalchemy import or_, and_
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import RedirectResponse
import os

from auth import get_password_hash, create_access_token, verify_password, get_current_user, oauth2_scheme
from database import get_db
from schemas import UserRegister, UserLogin, TokenResponse, UserUpdate
from models import User, GroupMembership, Message, Group, UserMessageStatus
from utils import generate_rsa_key_pair, send_verification_email, send_password_reset_email

logging.basicConfig(level=logging.INFO)

router = APIRouter()

SECRET_KEY = os.getenv("SECRET_KEY", "Zsigg2rvbk/BHUaj")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", '30'))
ALGORITHM = "HS256"
BASE_URL = "http://localhost:8000"


@router.post("/register", response_model=TokenResponse)
def register(user: UserRegister, db: Session = Depends(get_db)):
    hashed_password = get_password_hash(user.password)

    private_key, public_key = generate_rsa_key_pair()

    db_user = User(
        username=user.username,
        full_name=user.full_name,
        hashed_password=hashed_password,
        profile_picture=user.profile_picture,
        public_key=public_key.decode('utf-8'),
        private_key=private_key.decode('utf-8'),
        email=user.email,
        role=user.role
    )

    db.add(db_user)
    try:
        db.commit()
        db.refresh(db_user)
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Username already exists")

    access_token = create_access_token(data={"sub": db_user.username})
    verification_link = f"{BASE_URL}/users/verify?token={access_token}"
    send_verification_email(user.email, verification_link)
    return {
        "access_token": access_token,
        "user_id": db_user.id,
        "role": db_user.role
    }


class PasswordResetRequest(BaseModel):
    email: str


@router.post("/request_password_reset")
def request_password_reset(request: PasswordResetRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == request.email).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    reset_token = create_access_token(data={"sub": user.username})
    reset_link = f"{BASE_URL}/users/reset_password?token={reset_token}"
    send_password_reset_email(user.email, reset_link)
    return {"message": "Password reset email sent"}


def generate_random_password(length: int = 12) -> str:
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for i in range(length))


@router.post("/reset_password/{user_id}")
def reset_password(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    new_password = generate_random_password()
    user.hashed_password = get_password_hash(new_password)
    db.commit()

    # Optionally, send the new password to the user's email
    send_password_reset_email(user.email, f"Your account: {user.username}. Your new password: {new_password}")

    return {"message": "Password reset successfully, check your email for the new password"}


@router.post("/login", response_model=TokenResponse)
def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.username == user.username).first()
    if not db_user or not verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail="Incorrect username or password")
    if not db_user.is_verify:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Please verify your email address")

    access_token = create_access_token(data={"sub": db_user.username})

    return {
        "access_token": access_token,
        "user_id": db_user.id,
        "public_key": db_user.public_key,
        "private_key": db_user.private_key,
        "role": db_user.role
    }


@router.delete("/delete_user/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db), token: str = Depends(oauth2_scheme)):
    current_user = get_current_user(token, db)
    if current_user.id != user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    db.query(GroupMembership).filter(
        GroupMembership.user_id == user_id).delete()
    db.query(Message).filter((Message.sender_id == user_id)
                             | (Message.receiver_id == user_id)).delete()

    db.delete(user)
    db.commit()

    return {"message": "User, their group memberships, and their messages deleted successfully"}


@router.delete("/admin_delete_user/{user_id}")
def admin_delete_user(user_id: int, db: Session = Depends(get_db), token: str = Depends(oauth2_scheme)):
    current_user = get_current_user(token, db)
    if current_user.role != 1:  # Assuming role 1 is admin
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    db.query(GroupMembership).filter(
        GroupMembership.user_id == user_id).delete()
    db.query(Message).filter((Message.sender_id == user_id)
                             | (Message.receiver_id == user_id)).delete()

    db.delete(user)
    db.commit()

    return {"message": "User, their group memberships, and their messages deleted successfully"}


@router.get("/user_id/{username}")
def get_user_id(username: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return {"user_id": user.id, "public_key": user.public_key}

# Route für die Umwandlung von User ID zu Username


@router.get("/username/{user_id}")
def get_username(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return {"username": user.username}


@router.get("/{user_id}/all_data")
def get_all_user_data(user_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    if current_user.id != user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    memberships = db.query(GroupMembership).all()

    group_ids = [membership.group_id for membership in memberships]

    messages = db.query(Message).filter(
        or_(
            and_(
                Message.is_group_message == True,
                Message.receiver_id.in_(group_ids)
            ),

            and_(
                Message.is_group_message == False,
                or_(
                    Message.sender_id == user_id,
                    Message.receiver_id == user_id
                ),
            )
        )
    ).all()

    groups = db.query(Group).filter(Group.id.in_(group_ids)).all()

    user_ids = set(
        [message.sender_id for message in messages] +
        [message.receiver_id for message in messages]
    )
    user_ids.discard(user_id)
    interacting_users = db.query(User).all()

    message_status_map = {
        status.message_id: status.status
        for status in db.query(UserMessageStatus).filter(UserMessageStatus.user_id == user_id).all()
    }

    return {
        "messages": [
            {
                "id": msg.id,
                "sender_id": msg.sender_id,
                "receiver_id": msg.receiver_id,
                "content": msg.content,
                "timestamp": msg.timestamp,
                "status": message_status_map.get(msg.id, "unknown")
            }
            for msg in messages
        ],
        "memberships": [
            {
                "group_id": membership.group_id,
                "user_id": membership.user_id,
                "joined_at": membership.joined_at
            }
            for membership in memberships
        ],
        "groups": [
            {
                "id": group.id,
                "name": group.name,
                "privateKey": group.private_key,
                "publicKey": group.public_key
            }
            for group in groups
        ],
        "interacting_users": [
            {
                "id": user.id,
                "isTyping": user.is_typing,
                "typingChatId": user.typing_chat_id,
                "username": user.username,
                "fullname": user.full_name,
                "publicKey": user.public_key
            }
            for user in interacting_users
        ]
    }


class TypingStatus(BaseModel):
    is_typing: bool
    typing_chat_id: int


@router.post("/set_typing_status")
def set_typing_status(typing_status: TypingStatus, token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)

    user = db.query(User).filter(User.id == current_user.id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    user.is_typing = typing_status.is_typing
    user.typing_chat_id = typing_status.typing_chat_id

    db.commit()

    return {
        "message": f"Typing status set to {typing_status.is_typing} for user {current_user.username}",
        "typing_chat_id": typing_status.typing_chat_id
    }


@router.get("")
def list_users(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    current_username = payload.get("sub")
    if current_username is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
        )

    users = db.query(User).filter(User.username != current_username).order_by(User.id.desc()).all()
    return [
        {
            "id": user.id,
            "username": user.username,
            "full_name": user.full_name,
            "email": user.email,
            "role": user.role
        }
        for user in users
    ]


@router.put("/update_user/{user_id}")
def update_user(user_id: int, user_update: UserUpdate, db: Session = Depends(get_db), token: str = Depends(oauth2_scheme)):
    current_user = get_current_user(token, db)
    if current_user is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Operation not allowed")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    if user_update.username is not None:
        existing_user = db.query(User).filter(User.username == user_update.username).first()
        if existing_user and existing_user.id != user_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, detail="Username already exists")
        user.username = user_update.username

    if user_update.full_name is not None:
        user.full_name = user_update.full_name
    if user_update.email is not None:
        user.email = user_update.email
    if user_update.role is not None:
        user.role = user_update.role
    if user_update.password is not None:
        user.hashed_password = get_password_hash(user_update.password)

    db.commit()
    db.refresh(user)

    return {
        "id": user.id,
        "username": user.username,
        "full_name": user.full_name,
        "email": user.email,
        "role": user.role
    }


@router.get("/verify")
def verify_user(token: str, db: Session = Depends(get_db)):
    payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    username = payload.get("sub")
    if username is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token",
        )

    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    user.is_verify = True
    db.commit()

    return RedirectResponse(url="http://localhost:3000?toast=Your account is verified. Please login to continue using app.")


@router.get("/me")
def get_current_user_data(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    current_user = get_current_user(token, db)
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="Could not validate credentials")

    return {
        "id": current_user.id,
        "username": current_user.username,
        "full_name": current_user.full_name,
        "email": current_user.email,
        "role": current_user.role,
        "profile_picture": current_user.profile_picture,
        "public_key": current_user.public_key
    }
