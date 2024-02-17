import os

SECRET_KEY = os.urandom(32)
DEBUG = True
UPLOAD_FOLDER = 'tmp/'

basedir = os.path.abspath(os.path.dirname(__file__))

# PINECONE
PINECONE_KEY = os.environ.get('PINECONE_KEY')
PINECONE_ENV = os.environ.get('PINECONE_ENV')
PINECONE_INDEX_NAME = os.environ.get('PINECONE_INDEX_NAME')

# CLOUDINARY
CLOUD_NAME = os.environ.get('CLOUDINARY_CLOUD_NAME')
API_KEY = os.environ.get('CLOUDINARY_API_KEY')
API_SECRET = os.environ.get('CLOUDINARY_API_SECRET')

MONGO_URI = os.environ.get('MONGO_URI')