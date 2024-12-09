import logging
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os

SMTP_SERVER = os.getenv("SMTP_SERVER", "smtp.example.com")
SMTP_PORT = int(os.getenv("SMTP_PORT", 587))
SMTP_USERNAME = os.getenv("SMTP_USERNAME", "your_email@example.com")
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD", "your_password")


logging.basicConfig(level=logging.INFO)


def generate_rsa_key_pair():
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048
    )
    public_key = private_key.public_key()

    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )

    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    logging.info(
        "New RSA key pair generated: %s... %s...", public_pem[:50], private_pem[:50])

    return private_pem, public_pem


def send_email(subject: str, recipient: str, body: str):
    msg = MIMEMultipart()
    msg['From'] = SMTP_USERNAME
    msg['To'] = recipient
    msg['Subject'] = subject

    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SMTP_USERNAME, SMTP_PASSWORD)
        server.sendmail(SMTP_USERNAME, recipient, msg.as_string())
        server.quit()
        print(f"Email sent to {recipient}")
    except Exception as e:
        print(f"Failed to send email to {recipient}: {e}")

def send_verification_email(email: str, verification_link: str):
    subject = "Verify your email address"
    body = f"Please click the following link to verify your email address: {verification_link}"
    send_email(subject, email, body)

def send_password_reset_email(email: str, content: str):
    subject = "Reset your password"
    body = f"{content}"
    send_email(subject, email, body)