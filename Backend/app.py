# coding: utf-8
from flask import Flask, request, redirect
import pinecone    
from utils import keyframe_extractor
from werkzeug.utils import secure_filename
import os

pinecone.init(      
	api_key='46a39a53-b884-4cf9-9516-ed27b297eaef',      
	environment='gcp-starter'      
)      
index = pinecone.Index('video-gen')

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'cache/'

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

# Upload a video to the server and added to the Pinecone index
@app.route("/upload", methods=["POST"])
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
        return {
            "ResponseCode": result,
        }
    else: 
        return {
            "ResponseCode": 500,
        }

# Upload multiple videos to the server and added to the Pinecone index
# @app.route("/uploads", methods=["POST"])
# def upload_videos():
#     result = keyframe_extractor.extract_keyframes(file_path, file_name)
#     return {
#         "ResponseCode": result,
#     }