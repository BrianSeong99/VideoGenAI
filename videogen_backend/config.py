import os

SECRET_KEY = os.urandom(32)

basedir = os.path.abspath(os.path.dirname(__file__))

PINECONE_API_KEY = os.environ.get('PINECONE_KEY')

DEBUG = True

UPLOAD_FOLDER = 'cache/'