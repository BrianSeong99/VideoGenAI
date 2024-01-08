# coding: utf-8
from flask import request, redirect, Response, current_app as app
from utils import keyframe_extractor
from werkzeug.utils import secure_filename
import os
import time
import json
from models.cloudinary_model import upload_video_to_cloudinary, get_video_tags

def cloudinary_webhook():
    data = request.json
    print(data)
    return Response(
            response="Hello World!",
            status=200,
            mimetype='application/json'
        )

def upload_video():
    if 'video' not in request.files:
        return redirect(request.url)

    file = request.files['video']

    if file.filename == '':
        return redirect(request.url)

    if file:  # If a file is present
        filename = str(int(time.time())) + '_' + secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        # Upload to Cloudinary
        cloudinary_response = upload_video_to_cloudinary(filepath)
        # get_video_tags(cloudinary_response['public_id'])
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
