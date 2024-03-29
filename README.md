# VideoGenAI
An AI-driven tool that suggests relevant footage for certain frame descriptions by automatically organizing/ summarizing/ tagging/ selecting video footage on mobile phone to assist video creation.

- [Project Introduction Video](https://drive.google.com/file/d/1AyiP8GEQCJY1lPvCdcWaGOoItRfBml5f/view?usp=sharing)
- [Demo Video](https://drive.google.com/file/d/13xYiv4tF0TFChq-FWNaDlC_DhihoemfS/view?usp=sharing)

## Setup
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

Frontend:
- Just open the frontend folder in xcode. Remember to install ios simulator, 16+ is recommended.

## Features to includes

### v0.1
#### Features(Higher Priority):
Infrastructure:
- [x] [Backend]: Video file database, static database, support video preview (keyframes slideshow).
- [x] [Backend]: Relevant keyframe extractions of video files
- [x] [Backend]: Video footage content categorization, tagging, meta data storing.
- [x] [Backend]: Indexer for video data indexing
- [x] [Backend]: NLP searching of relevant footage with indexer
- [x] [Backend]: Database for editing progress
- [-] [Backend]: Generate Video Summary

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
- [x] [Frontend]: Implement actions for preview buttons of videos, copy video url & safe video file.
- [x] [Frontend]: Video List Pagination Loading

Projects Page:
- [x] [Backend]: Create Project and Save Project
- [x] [Backend]: Update Current Editing Process in Database
- [x] [Backend]: Delete a Project
- [x] [Backend]: Return Projects List in Pagination
- [x] [Frontend]: Video Projects Page with Pagination to select desired project to work on.
- [x] [Frotnend]: Create Project & direct to Timeline Page
- [x] [Frontend]: Remove Project

Timeline Page:
- [x] [Frontend]: Project Title updates
- [x] [Frontend]: Q&A Block Component
- [x] [Frontend]: Video Timeline page for multiple video selection blocks and place the selected footage in a desired sequence.
- [-] [Frontend]: Update Video Sequence in frontend and reflects in the database
- [x] [Frontend]: Preview Entire Timeline
- [ ] [Frontend]: Video downloads as well as export to third party apps like CapCut.
- [x] [Backend]: Get Project Details

Block Page:
- [x] [Frontend]: Block page for relevant footage queries and preview.
- [x] [Frontend]: Remove Video if disliked
- [-] [Frontend]: Reorder Responses

#### Improvements/Known Issues (Lower Priority):
- [x] [Backend][Improvement] Upload Large files that are larger than 100MB per upload request
- [x] [Frontend][Bug] Efficient Library Videos Loading, app crashing because all videos are taking up the main thread.
- [x] [Frontend][Improvement] Preview of the entire video clip
- [x] [Frontend][Improvement] For files returned without "tags", mark them as "INDEXING" instead
- [ ] [Frontend][Improvement] Hide Search Bar when in edit mode.
- [ ] [Backend][Bug] Remove video meta data in pinecone indexer when removing the video from cloudinary.
- [x] [Frontend][Improvement] Navigation Bar Title Style.
- [x] [Frontend][Bug] Projects Page Long Press Position Error
- [x] [Frontend][Bug] Library Page and Projects page Pagination not working after actions(ex. Delete, Search, etc).

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
