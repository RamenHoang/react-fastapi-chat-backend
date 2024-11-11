import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import User, Group, Message, GroupMembership, UserMessageStatus, Entity

DATABASE_URL = os.getenv(
    "DATABASE_URL", "mysql+pymysql://root:@localhost:3306/chatapp")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
session = SessionLocal()


def delete_all_entries():
    try:
        session.query(UserMessageStatus).delete()
        session.query(GroupMembership).delete()
        session.query(Message).delete()
        session.query(Group).delete()
        session.query(User).delete()
        session.query(Entity).delete()

        session.commit()
        print("All entries deleted successfully.")
    except Exception as e:
        session.rollback()
        print(f"An error occurred: {e}")
    finally:
        session.close()


if __name__ == "__main__":
    delete_all_entries()
