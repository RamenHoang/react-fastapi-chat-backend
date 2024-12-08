from pydantic import BaseModel
from typing import Optional

from constants import ROLE_MEMBER


class UserRegister(BaseModel):
    username: str
    full_name: str
    password: str
    profile_picture: Optional[str] = None
    email: str
    role: int = ROLE_MEMBER


class UserLogin(BaseModel):
    username: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    user_id: int
    token_type: str = "bearer"
    private_key: Optional[str] = None
    public_key: Optional[str] = None
    role: int


class GroupCreate(BaseModel):
    name: str


class MessageCreate(BaseModel):
    receiver_id: int
    content: str
    encrypted_for_user_id: Optional[int] = None
