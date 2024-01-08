import cloudinary
import cloudinary.uploader
import cloudinary.api
from config import CLOUD_NAME, API_KEY, API_SECRET

config = cloudinary.config(secure=True)

def upload_video_to_cloudinary(filepath):
    cloudinary_response = cloudinary.uploader.upload(
        filepath,
        resource_type = "video",
        # categorization = "google_video_tagging", 
        # auto_tagging = 0.4,
        categorization = "azure_video_indexer", 
        auto_tagging = 0.6,
        notification_url = "http://34.125.61.118:5000/v1/cloudinary_webhook"
    )
    print("++++++++++++++")
    print(cloudinary_response)

    print("Cloudinary Response: ",
          cloudinary_response['url'],  
          cloudinary_response['public_id'], 
          cloudinary_response['asset_id']
    )
    print("--------------")
    return cloudinary_response

def get_video_tags(video_id):
    return cloudinary.api.resource(
        video_id,
        resource_type = "video",
        categorization = "google_video_tagging", 
        auto_tagging = 0.4
    )['info']['categorization']['google_video_tagging']['data']