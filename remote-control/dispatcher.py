#!/usr/bin/env python3

from flask import Flask
from flask import Response

app = Flask(__name__)

@app.route("/get_payload")
def get_payload():
    payload = open('gpu-payload.js','r')
    return Response(payload, mimetype='text/javascript')


if __name__ == '__main__':
    app.run(debug=True)
