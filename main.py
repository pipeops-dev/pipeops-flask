import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
  return "<h1>Welcome to PipeOps Flask</h1>"

if __name__ == '__main__':
  # Use PORT environment variable if available, or default to 5000
  port = int(os.environ.get('PORT', 5000))
  app.run(host='0.0.0.0', port=port)

