# coding: utf-8
from flask import request, redirect, Response, current_app as app
from utils import keyframe_extractor
from werkzeug.utils import secure_filename
import os

def upload_video():
    if 'video' not in request.files:
        return redirect(request.url)

    file = request.files['video']

    if file.filename == '':
        return redirect(request.url)

    if file:  # If a file is present
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        result = keyframe_extractor.extract_keyframes(app.config['UPLOAD_FOLDER'], filename)
        
        resp = Response(
            response=str(result),
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
