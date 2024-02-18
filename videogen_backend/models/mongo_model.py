from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from config import MONGO_URI
import json

uri = MONGO_URI

# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))

# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)

def get_projects_from_mongodb(page, limit):
    db = client['videogen']
    collection = db['projects']

    resp = collection.find().skip(page * limit).limit(limit)
    projects = []
    for iter in resp:
        iter['_id'] = str(iter['_id'])
        projects.append(iter)
    print(projects)

    return {
        "success": True,
        "totalCount": collection.count_documents({}), 
        "page": page, 
        "pageSize": limit,
        "projects": projects
    }

def delete_project_from_mongodb(id):
    db = client['videogen']
    collection = db['projects']
    return collection.delete_one({"_id": id})

def create_project_in_mongodb(project):
    db = client['videogen']
    collection = db['projects']
    return collection.insert_one(project)

def update_project_in_mongodb(id, project):
    db = client['videogen']
    collection = db['projects']
    return collection.update_one({"_id": id}, {"$set": project})