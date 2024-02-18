from flask import Blueprint
from controller.controller import *

blueprint = Blueprint('blueprint', __name__)

blueprint.route('/upload/cloudinary_webhook', methods=['POST'])(cloudinary_webhook_controller)
blueprint.route('/upload/videos', methods=['POST'])(upload_videos_controller)

blueprint.route('/library/get_videos', methods=['GET'])(get_videos_controller)
blueprint.route('/library/delete_videos', methods=['DELETE'])(delete_videos_controller)
blueprint.route('/library/search', methods=['GET'])(query_videos_controller)

blueprint.route('/projects', methods=['GET'])(get_project_controller)
blueprint.route('/projects', methods=['POST'])(create_project_controller)
blueprint.route('/projects', methods=['PUT'])(update_project_controller)
blueprint.route('/projects', methods=['DELETE'])(delete_project_controller)
blueprint.route('/projects/get_projects', methods=['GET'])(get_projects_controller)

blueprint.route('/query/get_video_info', methods=['GET'])(get_video_info_controller)
blueprint.route('/query/query_videos', methods=['GET'])(query_videos_controller)

blueprint.route('/debug/manual_insert_tags', methods=['POST'])(insert_video_to_indexer_controller)