from flask import Blueprint
from controller.controller import upload_video, cloudinary_webhook

blueprint = Blueprint('blueprint', __name__)

blueprint.route('/cloudinary_webhook', methods=['GET'])(cloudinary_webhook)
blueprint.route('/upload', methods=['POST'])(upload_video)
# blueprint.route('/upload_multiple', methods=['POST'])(upload_videos)
