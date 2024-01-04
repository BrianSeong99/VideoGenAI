import pinecone    

pinecone.init(      
	api_key='46a39a53-b884-4cf9-9516-ed27b297eaef',      
	environment='gcp-starter'      
)      
index = pinecone.Index('video-gen')