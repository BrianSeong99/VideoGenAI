from openai import OpenAI
import requests

client = OpenAI()

def get_embedding(text, model="text-embedding-ada-002"):
    text = text.replace("\n", " ")
    return client.embeddings.create(input = [text], model=model).data[0].embedding

def get_video_metadata_embedding(video_metadata, model="text-embedding-ada-002"):
    inputs = video_metadata['tags'] # + video_metadata['summary'].split(" ")
    metadata_embeddings = []

    while inputs:
        token_count = 0
        batched_inputs = []
        while inputs and token_count < 4096:
            input_item = inputs.pop(0)
            batched_inputs.append(input_item)
            token_count += len(input_item.split(' '))

        metadata_embeddings.extend(get_embedding(" ".join(batched_inputs), model))
        
    return metadata_embeddings