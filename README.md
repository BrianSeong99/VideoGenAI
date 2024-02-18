# VideoGenAI
An AI-driven tool that suggests relevant footage for certain frame descriptions by automatically organizing/ summarizing/ tagging/ selecting video footage on mobile phone to assist video creation.

Setup Environment:
```bash
cd videogen_backend
pip install -r requirements.txt
```

To run backend:
```bash
cd videogen_backend
flask --app app.py run # locally
python3 -m flask --app app.py run --host 0.0.0.0 -p 5000 # server
```

## Features to includes

### v0.1
#### Features(Higher Priority):
Infrastructure:
- [x] [Backend]: Video file database, static database, support video preview (keyframes slideshow).
- [x] [Backend]: Relevant keyframe extractions of video files
- [x] [Backend]: Video footage content categorization, tagging, meta data storing.
- [x] [Backend]: Indexer for video data indexing
- [x] [Backend]: NLP searching of relevant footage with indexer
- [ ] [Backend]: Database for editing progress
- [ ] [Backend]: Generate Video Summary

Library Page:
- [x] [Backend]: Return all assets for Library via Pagination
- [x] [Backend]: Receive Multiple Video files in one upload
- [x] [Backend]: Delete Video from Library
- [x] [Backend]: Search based on keywords
- [x] [Frontend]: Select and upload a relevant footage
- [x] [Frontend]: Select and upload multiple relevant footages
- [x] [Frontend]: Loading when uploading
- [x] [Frontend]: Fetch and show Video Libraries Efficiently
- [x] [Frontend]: Delete Selected Videos
- [x] [Frontend]: Library Page Layout
- [x] [Frontend]: Show Searched Result
- [-] [Frontend]: Implement actions for preview buttons of videos, copy video url & safe video file.
- [-] [Frontend]: Video List Pagination Loading

Projects Page:
- [-] [Backend]: Create Project and Save Project
- [-] [Backend]: Save Current Editing Process in Database
- [-] [Backend]: Return Projects List in Pagination
- [-] [Frontend]: Video Projects Page with Pagination to select desired project to work on.
- [ ] [Frotnend]: Create Project
- [-] [Frontend]: Remove Project
- [ ] [Frontend]: Video downloads as well as export to third party apps like CapCut.

Timeline Page:
- [ ] [Frontend]: Video Timeline page for multiple video selection blocks and place the selected footage in a desired sequence.
- [ ] [Frontend]: Update Video Sequence in frontend and reflects in the database
- [ ] [Frontend]: Project Title updates

Block Page:
- [x] [Frontend]: Query page for relevant footage queries and preview.

#### Improvements/Known Issues (Lower Priority):
- [x] [Frontend][Bug] Efficient Library Videos Loading, app crashing because all videos are taking up the main thread.
- [x] [Frontend][Improvement] Preview of the entire video clip
- [ ] [Frontend][Improvement] Hide Search Bar when in edit mode.
- [ ] [Backend][Bug] Remove video meta data in pinecone indexer when removing the video from cloudinary.
- [ ] [Frontend][Improvement] Navigation Bar Title Style.

### Future Scope
- [ ] [Backend]: Script to Video Footage selections in sequence generation
- [ ] [Backend]: Auto Video length trimming functionality.
- [ ] [Backend]: User database and session management.
- [ ] [Backend]: Video Indexer per user
- [ ] [Frontend]: Script & video gen result preview page.
- [ ] [Frontend]: User Login and Profile Page

## Video Assets Pre-process Procedure
1. Upload Video to Backend as Cache.
2. Upload video in the cache to Cloudinary, and store video id on Cloudinary.
3. Extract Key frames, and Store Summary, Tags, and Cloudinary ID in the pinecone database.
4. Query Using Natural Language and Parse into Pinecone DB Queries
5. Search and return Pinecone DB Ranks
6. Show in frontend
