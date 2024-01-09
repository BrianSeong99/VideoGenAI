from flask import Blueprint
from controller.controller import upload_video, cloudinary_webhook, get_tags

blueprint = Blueprint('blueprint', __name__)

blueprint.route('/cloudinary_webhook', methods=['POST'])(cloudinary_webhook)
blueprint.route('/upload', methods=['POST'])(upload_video)
blueprint.route('/get_video_tags', methods=['GET'])(get_tags)
# blueprint.route('/upload_multiple', methods=['POST'])(upload_videos)
