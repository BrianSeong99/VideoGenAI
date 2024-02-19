import cloudinary
import cloudinary.uploader
import cloudinary.api
from config import CLOUD_NAME, API_KEY, API_SECRET

config = cloudinary.config(secure=True)

def upload_video_to_cloudinary(filepath):
    
    cloudinary_response = cloudinary.uploader.upload_large(
        filepath,
        resource_type = "video",
        # categorization = "google_video_tagging", 
        # auto_tagging = 0.4,
        categorization = "azure_video_indexer", 
        auto_tagging = 0.6,
        notification_url = "http://34.125.61.118:5000/v1/upload/cloudinary_webhook"
    )
    print()
    print("++++++++++++++")
    print(cloudinary_response)

    print("Cloudinary Response: ",
          cloudinary_response['url'],  
          cloudinary_response['public_id'], 
          cloudinary_response['asset_id']
    )
    print("--------------")
    return cloudinary_response

def get_video_info_from_cloudinary(public_id):
    return cloudinary.api.resource(
        public_id,
        resource_type = "video",
        categorization = "azure_video_indexer", 
        auto_tagging = 0.4
    )

def get_videos_from_cloudinary(next_cursor, limit):
    result = None
    if next_cursor is None:
        result = cloudinary.api.resources(
            resource_type = "video",
            max_results = limit,
        )
    else:
        result = cloudinary.api.resources(
            resource_type = "video",
            max_results = limit,
            next_cursor = next_cursor
        )
    return result

def delete_video_from_cloudinary(public_id):
    return cloudinary.uploader.destroy(public_id, resource_type = "video")

def search_video_in_cloudinary(expression, max_results = 10):
    return cloudinary.Search()\
        .expression(expression)\
        .fields("context")\
        .fields("tags")\
        .fields("format")\
        .fields("version")\
        .fields("created_at")\
        .fields("bytes")\
        .fields("width")\
        .fields("height")\
        .fields("url")\
        .fields("secure_url")\
        .max_results(str(max_results))\
        .execute()