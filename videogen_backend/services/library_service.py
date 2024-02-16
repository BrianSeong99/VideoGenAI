import json
from flask import request, Response, current_app as app
from models.cloudinary_model import get_videos_from_cloudinary, delete_video_from_cloudinary, search_video_in_cloudinary

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
    if data is None:
        return Response(
            response=json.dumps({"error": "public_ids is required"}),
            status=400,
            mimetype='application/json'
        )
    public_ids = data['public_ids']
    for public_id in public_ids:
        resp = delete_video_from_cloudinary(public_id)
        if resp['result'] != 'ok':
            return Response(
                response=json.dumps({"error": "failed to delete video with public_id: " + public_id}),
                status=500,
                mimetype='application/json'
            )
    return Response(
        response=json.dumps({}),
        status=200,
        mimetype='application/json'
    )

def search_videos_by_keywords():
    expression = request.args.get('expression', None)
    max_results = request.args.get('max_results', None)
    if expression is None:
        return Response(
            response=json.dumps({"error": "expression is required"}),
            status=400,
            mimetype='application/json'
        )
    resp = search_video_in_cloudinary(expression, max_results == None and 10 or max_results)
    if resp is None:
        return Response(
            response=json.dumps({"error": "failed to search videos"}),
            status=500,
            mimetype='application/json'
        )
    return Response(
        response=json.dumps(resp),
        status=200,
        mimetype='application/json'
    )