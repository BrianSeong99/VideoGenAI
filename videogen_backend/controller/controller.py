from services import upload_service

def cloudinary_webhook():
    return upload_service.cloudinary_webhook()

def upload_video():
    return upload_service.upload_video()