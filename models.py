from datetime import datetime
from sqlalchemy import Column, String, Integer, ForeignKey, Text, DateTime, Boolean
from sqlalchemy.orm import relationship
from constants import ROLE_MEMBER
from database import Base


class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(String(255), unique=True, index=True)
    full_name = Column(String(255))
    hashed_password = Column(String(255))
    profile_picture = Column(Text)
    is_typing = Column(Boolean, default=False)
    typing_chat_id = Column(Integer)
    public_key = Column(Text)
    private_key = Column(Text)
    role = Column(Integer, default=ROLE_MEMBER)
    email = Column(String(255))


class Group(Base):
    __tablename__ = 'groups'
    id = Column(Integer, primary_key=True)
    name = Column(String(255))
    public_key = Column(Text)
    private_key = Column(Text)


class Message(Base):
    __tablename__ = 'messages'
    id = Column(Integer, primary_key=True, index=True)
    sender_id = Column(Integer, ForeignKey('users.id'))
    receiver_id = Column(Integer)
    content = Column(Text)
    timestamp = Column(DateTime, default=datetime.utcnow)
    is_group_message = Column(Boolean, default=False)
    encrypted_for_user_id = Column(Integer)

    sender = relationship("User", foreign_keys=[sender_id])


class GroupMembership(Base):
    __tablename__ = 'group_memberships'
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    group_id = Column(Integer, ForeignKey('groups.id'))
    joined_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User")
    group = relationship("Group")


class UserMessageStatus(Base):
    __tablename__ = 'user_message_status'
    id = Column(Integer, primary_key=True, index=True)
    message_id = Column(Integer, ForeignKey('messages.id'))
    user_id = Column(Integer, ForeignKey('users.id'))
    status = Column(String(255))

    message = relationship("Message")
    user = relationship("User")
