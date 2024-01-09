from flask import current_app as app
import pinecone
from config import PINECONE_KEY, PINECONE_ENV, PINECONE_INDEX_NAME 

pinecone.init(      
	api_key=PINECONE_KEY,      
	environment=PINECONE_ENV     
)

index = pinecone.Index(PINECONE_INDEX_NAME)

def upsert_video_to_pinecone(public_id, metadata_embeddings, metadata):
	try:
		index.upsert(
			vectors=[
				{
					"id": public_id,
					"values": metadata_embeddings,
					"metadata": metadata
				},
			],
			namespace='ns1' # later can be used for user based index partitioning
		)
		return True
	except Exception as e:
		app.logger.error("upsert_video_to_pinecone", e)
		return False
	
async def search_video_in_pinecone(query_embeddings, top_k=10):
	try:
		results = index.query(
			namespace="ns1",
			vector=query_embeddings, 
			top_k=top_k,
			include_metadata=True
		)
		return results
	except Exception as e:
		app.logger.error(e)
		return None