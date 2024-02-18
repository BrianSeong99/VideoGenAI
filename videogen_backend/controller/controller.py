from services import upload_service, query_service, library_service, project_service

# upload service controller

def cloudinary_webhook_controller():
    return upload_service.cloudinary_webhook()

def upload_videos_controller():
    return upload_service.upload_videos()

# query service controller

def get_video_info_controller():
    return query_service.get_video_info()

async def query_videos_controller():
    result = await query_service.query_videos()
    return result

# library service controller

def get_videos_controller():
    return library_service.get_videos()

def delete_videos_controller():
    return library_service.delete_videos()

def query_videos_controller():
    return library_service.search_videos_by_keywords()

# project service controller

def get_project_controller():
    return project_service.get_project()

def create_project_controller():
    return project_service.create_project()

def update_project_controller():
    return project_service.update_project()

def delete_project_controller():
    return project_service.delete_project()

def get_projects_controller():
    return project_service.get_projects()

# debug service controller

def insert_video_to_indexer_controller():
    return upload_service.insert_video_metadata_to_indexer()