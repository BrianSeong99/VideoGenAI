import pinecone
from config import PINECONE_KEY, PINECONE_ENV, PINECONE_INDEX_NAME 

pinecone.init(      
	api_key=PINECONE_KEY,      
	environment=PINECONE_ENV     
)

video_schema = {
    ""
}

index = pinecone.Index(PINECONE_INDEX_NAME)