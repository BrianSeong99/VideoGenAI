def request_body_to_video(request, tag):
    if tag not in request.files:
        return None, f'No {tag} found'
    file = request.files[tag]

    if file.filename == '':
        return None, f'No file name found for {tag}'
    
    if file:
        return file, None
    else:
        return None, f'No file {tag} found'