import json
from flask import request, Response, current_app as app
from models.cloudinary_model import get_videos_from_cloudinary, delete_video_from_cloudinary

def get_videos():
    next_cursor = request.args.get('next_cursor', None)
    limit = request.args.get('limit', 30)
    resp = get_videos_from_cloudinary(next_cursor, limit)
    return Response(
        response=json.dumps(resp),
        status=200,
        mimetype='application/json'
    )

def delete_videos():
    data = request.get_json()
    print(data)
    public_ids = data['public_ids']
    for public_id in public_ids:
        resp = delete_video_from_cloudinary(public_id)
        print(resp)
    return Response(
        response=json.dumps({}),
        status=200,
        mimetype='application/json'
    )
