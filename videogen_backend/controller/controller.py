from services import upload_service

def cloudinary_webhook():
    return upload_service.cloudinary_webhook()

def upload_video():
    return upload_service.upload_video()

def get_tags():
    return upload_service.get_tags()