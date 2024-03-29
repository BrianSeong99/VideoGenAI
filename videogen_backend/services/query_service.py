import json
from flask import request, Response, current_app as app
from models.openai_model import get_embedding
from models.pinecone_model import search_video_in_pinecone
from models.cloudinary_model import get_video_info_from_cloudinary
from datetime import datetime

class CustomJSONEncoder(json.JSONEncoder):
    """JSON Encoder that converts datetime objects to ISO format strings."""
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.isoformat()
        return super().default(obj)

def get_video_info():
    public_id = request.args.get('public_id', None)
    if public_id is None:
        return Response(
            response="No public_id found",
            status=400,
            mimetype='application/json'
        )
    resp = get_video_info_from_cloudinary(public_id)
    return Response(
        response=json.dumps(resp),
        status=200,
        mimetype='application/json'
    )

async def query_videos():
    query = request.args.get('query')
    if query is None:
        return Response(
            response="No query found", 
            status=400, 
            mimetype='application/json'
        )
    
    query_embedding = get_embedding(query)
    results = await search_video_in_pinecone(query_embedding)
    if results is None:
        return Response(
            response="No results found", 
            status=400, 
            mimetype='application/json'
        )
    
    # Assuming results.to_dict() converts the results to a dict format suitable for JSON serialization
    serialized_results = json.dumps(results.to_dict(), cls=CustomJSONEncoder)
    return Response(
        response=serialized_results, 
        status=200, 
        mimetype='application/json'
    )
