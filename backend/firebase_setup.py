import firebase_admin
from firebase_admin import credentials, messaging

# Initialize Firebase Admin SDK
def initialize_firebase():
    cred = credentials.Certificate("path/to/firebase-service-account.json")
    firebase_admin.initialize_app(cred)

# Example function to send a notification
def send_push_notification(token: str, title: str, body: str):
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        token=token,
    )
    response = messaging.send(message)
    return response
