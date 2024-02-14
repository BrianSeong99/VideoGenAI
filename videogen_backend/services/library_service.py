import json
from flask import request, Response, current_app as app
from models.cloudinary_model import get_videos_from_cloudinary

def get_videos():
    print("here")
    next_cursor = request.args.get('next_cursor', None)
    limit = request.args.get('limit', 30)
    resp = get_videos_from_cloudinary(next_cursor, limit)
    print(resp)
    return Response(
        response=json.dumps(resp),
        status=200,
        mimetype='application/json'
    )
