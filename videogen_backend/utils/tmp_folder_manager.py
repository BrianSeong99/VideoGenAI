import os
import shutil
from flask import current_app as app

def save_file_to_tmp_folder(file, filepath):
    file.save(filepath)
    app.logger.info(f"File saved to {filepath}")

def delete_file_from_tmp_folder(filepath):
    os.remove(filepath)
    app.logger.info(f"File deleted from {filepath}")

def delete_all_files_from_tmp_folder(folderpath):
    for filename in os.listdir(folderpath):
        file_path = os.path.join(folderpath, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
        except Exception as e:
            app.logger.exception(f"Failed to delete {file_path}. Reason: {e}")
    app.logger.info(f"All files deleted from {folderpath}")

def delete_all_folders_from_tmp_folder(folderpath):
    for filename in os.listdir(folderpath):
        file_path = os.path.join(folderpath, filename)
        try:
            if os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            app.logger.exception(f"Failed to delete {file_path}. Reason: {e}")
    app.logger.info(f"All folders deleted from {folderpath}")

# get two lists back, one is the file names without extensions, the other is the file names with extensions
def get_filenames(folderpath):
    filenames_without_extension = []
    filenames_with_extension = []
    for filename in os.listdir(folderpath):
        filenames_without_extension.append(os.path.splitext(filename)[0])
        filenames_with_extension.append(filename)
    return filenames_without_extension, filenames_with_extension

def rename_file(filepath, new_filepath):
    os.rename(filepath, new_filepath)
    app.logger.info(f"File renamed from {filepath} to {new_filepath}")