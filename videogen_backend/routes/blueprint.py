from flask import Blueprint
from controller.controller import upload_video

blueprint = Blueprint('blueprint', __name__)

# blueprint.route('/', methods=['GET'])(index)
blueprint.route('/upload', methods=['POST'])(upload_video)
# blueprint.route('/upload_multiple', methods=['POST'])(upload_videos)
