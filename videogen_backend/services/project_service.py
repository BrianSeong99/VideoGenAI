import json
import time
from flask import request, Response, current_app as app
from models.mongo_model import *
from bson.objectid import ObjectId

def get_projects():
    page = int(request.args.get('page', 0))
    limit = int(request.args.get('limit', 20))
    resp = get_projects_from_mongodb(page, limit)
    return Response(
        response=json.dumps(resp),
        status=200,
        mimetype='application/json'
    )

def delete_project():
    data = request.get_json()
    if data is None or '_id' not in data:
        return Response(
            response=json.dumps({"error": "_id is required"}),
            status=400,
            mimetype='application/json'
        )
    
    try:
        _id = ObjectId(data['_id'])
    except Exception as e:
        return Response(
            response=json.dumps({"error": "Invalid '_id' format"}),
            status=400,
            mimetype='application/json'
        )
    
    resp = delete_project_from_mongodb(ObjectId(data['_id']))
    
    if resp.deleted_count == 0:
        return Response(
            response=json.dumps({"error": "Project with specified _id not found or could not be deleted"}),
            status=404,
            mimetype='application/json'
        )
    else:
        return Response(
            response=json.dumps({"message": "Project deleted successfully"}),
            status=200,
            mimetype='application/json'
        )

def create_project():
    data = request.get_json()
    if data is None:
        return Response(
            response=json.dumps({"error": "project is required"}),
            status=400,
            mimetype='application/json'
        )
    curr_time = time.time()
    project_data = {
        "created_at": curr_time,
        "updated_at": curr_time,
        "project_title": data['project_title'],
        "thumbnail_url": "",
        "blocks": [],
    }
    resp = create_project_in_mongodb(project_data)
    response_data = {
        "acknowledged": resp.acknowledged,
        "inserted_id": str(resp.inserted_id)
    }
    return Response(
        response=json.dumps(response_data),
        status=200,
        mimetype='application/json'
    )

def update_project():
    data = request.get_json()
    if data is None:
        return Response(
            response=json.dumps({"error": "project is required"}),
            status=400,
            mimetype='application/json'
        )
    project_data = {
        "_id": ObjectId(data['_id']),
        "created_at": data['created_at'],
        "updated_at": time.time(),
        "project_title": data['project_title'],
        "thumbnail_url": data['thumbnail_url'],
        "blocks": data['blocks'],
    }
    resp = update_project_in_mongodb(ObjectId(data['_id']), project_data)
    response_data = {
        "matched_count": resp.matched_count,
        "modified_count": resp.modified_count,
        "acknowledged": resp.acknowledged
    }
    return Response(
        response=json.dumps(response_data),
        status=200,
        mimetype='application/json'
    )