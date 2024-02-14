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
Features(Higher Priority):
- [x] [Backend]: Video file database, static database, support video preview (keyframes slideshow).
- [x] [Backend]: Relevant keyframe extractions of video files
- [x] [Backend]: Video footage content categorization, tagging, meta data storing.
- [x] [Backend]: Indexer for video data indexing
- [x] [Backend]: NLP searching of relevant footage with indexer
- [ ] [Backend]: Generate Video Summary
- [ ] [Backend]: Save Current Editing Process in Database
- [x] [Frontend]: Select and upload a relevant footage
- [x] [Frontend]: Query page for relevant footage queries and preview.
- [x] [Frontend]: Total Video Library Page
- [ ] [Frontend]: Fetch and show Video Libraries Efficiently
- [ ] [Frontend]: Video Projects page to select desired project to work on.
- [ ] [Frontend]: Video Timeline page for multiple video selection blocks and place the selected footage in a desired sequence.
- [ ] [Frontend]: Video downloads as well as export to third party apps like CapCut.

Other Feature(Lower Priority):
- [ ] [Backend]: Receive Multiple Video Upload Files
- [ ] [Frontend]: Select and upload multiple relevant footages


Video Assets Pre-process Procedure:
1. Upload Video to Backend as Cache.
2. Upload video in the cache to Cloudinary, and store video id on Cloudinary.
3. Extract Key frames, and Store Summary, Tags, and Cloudinary ID in the pinecone database.
4. Query Using Natural Language and Parse into Pinecone DB Queries
5. Search and return Pinecone DB Ranks
6. Show in frontend

### Future Scope
- [ ] [Backend]: Script to Video Footage selections in sequence generation
- [ ] [Backend]: Auto Video length trimming functionality.
- [ ] [Backend]: User database and session management.
- [ ] [Backend]: Video Indexer per user
- [ ] [Frontend]: Script & video gen result preview page.
- [ ] [Frontend]: User Login and Profile Page

