from services import upload_service
from services import query_service
from services import library_service

# upload service controller

def cloudinary_webhook_controller():
    return upload_service.cloudinary_webhook()

def upload_video_controller():
    return upload_service.upload_video()

# query service controller

def get_video_info_controller():
    return query_service.get_video_info()

async def query_videos_controller():
    result = await query_service.query_videos()
    return result

# library service controller

def get_videos_controller():
    return library_service.get_videos()

# debug service controller

def insert_video_to_indexer_controller():
    return upload_service.insert_video_metadata_to_indexer()