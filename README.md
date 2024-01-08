# VideoGenAI
An AI-driven tool that suggests relevant footage for certain frame descriptions by automatically organizing/ summarizing/ tagging/ selecting video footage on mobile phone to assist video creation.

Setup Environment:
```bash
pip install -e .
```

To run backend:
```bash
cd videogen_backend
flask --app app.py run 
```

## Features to includes

### v0.1
Features:
- [x] [Backend]: Video file database, static database, support video preview (keyframes slideshow).
- [x] [Backend]: Relevant keyframe extractions of video files
- [ ] [Backend]: Video footage content categorization, tagging, summary generation, meta data storing.
- [ ] [Backend]: Indexer for video data indexing
- [ ] [Backend]: NLP searching of relevant footage with indexer
- [ ] [Frontend]: Select and upload relevant footages
- [ ] [Frontend]: Search page for relevant footage queries and preview.

Steps:
1. Upload Video to Backend as Cache.
2. Upload video in the cache to Cloudinary, and store video id on Cloudinary.
3. Extract Key frames, and Store Summary, Tags, and Cloudinary ID in the pinecone database.
4. Query Using Natural Language and Parse into Pinecone DB Queries
5. Search and return Pinecone DB Ranks
6. Show in frontend

### v0.2
- [ ] [Frontend]: Video Timeline page for multiple video selection and place the selected footage in a desired sequence.
- [ ] [Frontend]: Video downloads as well as export to third party apps like CapCut.

### v0.3
- [ ] [Backend]: Script to Video Footage selections in sequence generation
- [ ] [Backend]: Auto Video length trimming functionality.
- [ ] [Frontend]: Script & video gen result preview page.

### v1
- [ ] [Backend]: User database and session management.

