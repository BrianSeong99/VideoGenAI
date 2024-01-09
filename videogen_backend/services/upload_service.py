# coding: utf-8
from flask import request, redirect, Response, current_app as app
from utils import keyframe_extractor
from werkzeug.utils import secure_filename
import os
import time
import json
from models.cloudinary_model import upload_video_to_cloudinary, get_video_tags
from utils.tmp_folder_manager import save_file_to_tmp_folder, get_filenames, rename_file, delete_file_from_tmp_folder

def cloudinary_webhook():
    data = request.json
    print(data)
    public_id = data['public_id']
    filenames_without_extension, filenames_with_extension = get_filenames(app.config['UPLOAD_FOLDER'])
    if public_id in filenames_without_extension:
        index = filenames_without_extension.index(public_id)
        delete_file_from_tmp_folder(os.path.join(app.config['UPLOAD_FOLDER'], filenames_with_extension[index]))

def upload_video():
    if 'video' not in request.files:
        return redirect(request.url)

    file = request.files['video']

    if file.filename == '':
        return redirect(request.url)

    if file:  # If a file is present
        filename = str(int(time.time())) + '_' + secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        save_file_to_tmp_folder(file, filepath)
        # Upload to Cloudinary
        cloudinary_response = upload_video_to_cloudinary(filepath)
        root, ext = os.path.splitext(filepath)
        new_file_path = os.path.join(app.config['UPLOAD_FOLDER'], cloudinary_response['public_id'] + ext)
        rename_file(filepath, new_file_path) # Rename file to match cloudinary public_id
        # Save to local cache tmp folder
        # result = keyframe_extractor.extract_keyframes(app.config['UPLOAD_FOLDER'], filename)
        resp = Response(
            # response=str(result),
            status=200,
            mimetype='application/json'
        )

        return resp
    else: 
        return Response(
            response="No file found",
            status=400,
            mimetype='application/json'
        )
