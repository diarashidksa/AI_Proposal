import os
import json
import uuid
from flask import Flask, render_template, request, jsonify, send_from_directory
from werkzeug.utils import secure_filename
from proposal_generator import generate_proposal, OUTPUT_FOLDER

app = Flask(__name__)

# Configure upload and output folders
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

if not os.path.exists(OUTPUT_FOLDER):
    os.makedirs(OUTPUT_FOLDER)

# Define allowed file extensions
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'docx'}


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


# Main route for the front-end interface
@app.route('/')
def index():
    return render_template('index.html')


# Route to generate the proposal
@app.route('/generate', methods=['POST'])
def generate():
    if 'files' not in request.files:
        return jsonify({'success': False, 'error': 'No file part'}), 400

    files = request.files.getlist('files')
    brief = request.form.get('brief', '')

    file_paths = []
    for file in files:
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)
            file_paths.append(filepath)

    try:
        # Call the corrected generate_proposal function from your other file
        output_filename, finance_items, sources_data = generate_proposal(file_paths, brief)

        # Build the correct URL for the download route
        download_url = f'/download/{output_filename}'

        # Pass all the data to the result.html template
        return render_template(
            'result.html',
            filename=output_filename,
            download_url=download_url,
            finance_items=finance_items,
            sources_data=sources_data
        )

    except Exception as e:
        # Clean up uploaded files in case of an error
        for p in file_paths:
            if os.path.exists(p):
                os.remove(p)
        return render_template('error.html', error=str(e)), 500


# Route to download the generated file
@app.route('/download/<path:filename>')
def download_file(filename):
    try:
        return send_from_directory(OUTPUT_FOLDER, filename, as_attachment=True)
    except FileNotFoundError:
        return "File not found.", 404


if __name__ == '__main__':
    app.run(debug=True)