from flask import Blueprint
from controller.controller import *

blueprint = Blueprint('blueprint', __name__)

blueprint.route('/upload/cloudinary_webhook', methods=['POST'])(cloudinary_webhook_controller)
blueprint.route('/upload/video', methods=['POST'])(upload_video_controller)

blueprint.route('/query/get_video_info', methods=['GET'])(get_video_info_controller)
blueprint.route('/query/query_videos', methods=['GET'])(query_videos_controller)

blueprint.route('/debug/manual_insert_tags', methods=['POST'])(insert_video_to_indexer_controller)