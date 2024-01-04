from flask import Flask
from routes.blueprint import blueprint
from config import DEBUG, UPLOAD_FOLDER

def create_app():
    app = Flask(__name__)  # flask app object
    app.config.from_object('config')  # Configuring from Python Files
    app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
    return app

app = create_app()  # Creating the app
app.register_blueprint(blueprint, url_prefix='/v1') # Registering the blueprint

if __name__ == '__main__':  # Running the app
    app.run(host='127.0.0.1', port=5000, debug=DEBUG)