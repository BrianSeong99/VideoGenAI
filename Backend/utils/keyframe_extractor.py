import videokf as vf
import logging
import os

def extract_keyframes(filepath, filename):
    try:
        file_name_without_extension, _ = os.path.splitext(filename)
        vf.extract_keyframes(filepath + filename, output_dir_keyframes=os.path.join(file_name_without_extension, "keyframes"))
    except Exception as e:
        logging.error(e)
        return 500
    return 200