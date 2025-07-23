from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from backend.firebase_setup import send_push_notification

router = APIRouter()

class NotificationRequest(BaseModel):
    token: str
    title: str
    body: str
    data: dict = None

@router.post("/send")
async def send_notification(request: NotificationRequest):
    try:
        resp = send_push_notification(
            token=request.token,
            title=request.title,
            body=request.body,
            data=request.data
        )
        return {"message_id": resp}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
