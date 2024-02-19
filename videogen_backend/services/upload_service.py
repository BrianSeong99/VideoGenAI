# coding: utf-8
from flask import request, redirect, Response, current_app as app
from utils import keyframe_extractor, video_file_processor
from werkzeug.utils import secure_filename
import os
import time
import json
from services.query_service import get_video_info
from models.cloudinary_model import upload_video_to_cloudinary
from models.openai_model import get_video_metadata_embedding
from models.pinecone_model import upsert_video_to_pinecone
from utils.tmp_folder_manager import save_file_to_tmp_folder, get_filenames, rename_file, delete_file_from_tmp_folder
from config import CLOUD_NAME

def cloudinary_webhook():
    data = request.json
    print(data)
    if 'public_id' not in data:
        return Response(
            response="No public_id found",
            status=400,
            mimetype='application/json'
        )
    public_id = data['public_id']
    if 'info_status' not in data or data['info_status'] != 'complete':
        return Response(
            response="info_status not found or not complete",
            status=201,
            mimetype='application/json'
        )
    
    filenames_without_extension, filenames_with_extension = get_filenames(app.config['UPLOAD_FOLDER'])
    if public_id in filenames_without_extension:
        index = filenames_without_extension.index(public_id)
        delete_file_from_tmp_folder(os.path.join(app.config['UPLOAD_FOLDER'], filenames_with_extension[index]))
    
    print("deleted file from tmp folder", public_id)
    
    # Get video info from cloudinary and upsert to indexer
    resp = get_video_info(public_id)
    if 'tags' in resp and len(resp['tags']) > 0 and 'secure_url' in resp and 'version' in resp:
        tags = resp['tags']
        url = resp['secure_url']
        preview_url = "https://res.cloudinary.com/" \
            + CLOUD_NAME \
            + "/video/upload/" \
            + 'e_preview:duration_12:max_seg_2:min_seg_dur_1' \
            + '/v' \
            + str(resp['version']) \
            + '/'+ public_id
        video_metadata = {
            'tags': tags,
            'url': url,
            'preview_url': preview_url,
            'public_id': public_id,
            'version': resp['version'],
            'summary': '' # TODO, add summary feature later.
        }
        metadata_embeddings = get_video_metadata_embedding(video_metadata)
        status = upsert_video_to_pinecone(public_id, metadata_embeddings, video_metadata)
        if status is False:
            return Response(
                response="Failed to insert video metadata to indexer",
                status=400,
                mimetype='application/json'
            )
        print("result", status)
        return Response(
            response="Successfully inserted video metadata to indexer",
            status=200,
            mimetype='application/json'
        )
    else:
        print("Failed to insert video metadata to indexer")
        return Response(
            response="Failed to insert video metadata to indexer",
            status=400,
            mimetype='application/json'
        )
    
def upload_videos():
    num_videos = request.args.get('num_videos', None)
    if num_videos is None:
        return Response(
            response="No num_videos found",
            status=400,
            mimetype='application/json'
        )
    elif int(num_videos) > 10:
        return Response(
            response="num_videos should be less than 10",
            status=400,
            mimetype='application/json'
        )
    num_videos = int(num_videos)

    files = []
    for i in range(num_videos):
        file, message = video_file_processor.request_body_to_video(request, f'video{i}')
        if file is None:
            return Response(
                response=message,
                status=400,
                mimetype='application/json'
            )
        files.append(request.files[f'video{i}'])

    filepaths = []

    for file in files: # If a file is present
        filename = str(int(time.time())) + '_' + secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        filepaths.append(filepath)
        save_file_to_tmp_folder(file, filepath)
    
    for filepath in filepaths:
        # Upload to Cloudinary
        cloudinary_response = upload_video_to_cloudinary(filepath)
        root, ext = os.path.splitext(filepath)
        new_file_path = os.path.join(app.config['UPLOAD_FOLDER'], cloudinary_response['public_id'] + ext)
        rename_file(filepath, new_file_path) # Rename file to match cloudinary public_id
        # Save to local cache tmp folder
        # result = keyframe_extractor.extract_keyframes(app.config['UPLOAD_FOLDER'], filename)
    
    resp = Response(
        status=200,
        mimetype='application/json'
    )

    return resp

def insert_video_metadata_to_indexer():
    public_id = request.args.get('public_id', None)
    if public_id is None:
        return Response(
            response="No public_id found",
            status=400,
            mimetype='application/json'
        )
    resp = get_video_info(public_id)
    if 'tags' in resp and len(resp['tags']) > 0 and 'secure_url' in resp and 'version' in resp:
        tags = resp['tags']
        url = resp['secure_url']
        preview_url = "https://res.cloudinary.com/" \
            + CLOUD_NAME \
            + "/video/upload/" \
            + 'e_preview:duration_12:max_seg_2:min_seg_dur_1' \
            + '/v' \
            + str(resp['version']) \
            + '/'+ public_id
        video_metadata = {
            'tags': tags,
            'url': url,
            'preview_url': preview_url,
            'public_id': public_id,
            'version': resp['version'],
            'summary': '' # TODO, add summary feature later.
        }
        metadata_embeddings = get_video_metadata_embedding(video_metadata)
        status = upsert_video_to_pinecone(public_id, metadata_embeddings, video_metadata)
        if status is False:
            return Response(
                response="Failed to insert video metadata to indexer",
                status=400,
                mimetype='application/json'
            )
        print("result", status)
        return Response(
            response="Successfully inserted video metadata to indexer",
            status=200,
            mimetype='application/json'
        )