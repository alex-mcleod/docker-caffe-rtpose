from flask import Flask, request, jsonify

from livereload import Server

import subprocess

import json

import os

NUM_GPUS = 1  #4

app = Flask(__name__)

app.debug = True


@app.route('/run/', methods=['GET', 'POST'])
def run():
    args = json.loads(request.data)
    cmd = [
        '/home/openpose/build/examples/openpose/openpose.bin',

        # Camera value must be set...this is just an oddity of my
        # updates to the rtpose program.
        # '--camera',
        # '0',

        # Pass on stream address
        '--video',
        args[
            'rtmp_addr'],  #'/home/openpose/build/examples/openpose/examples/media/video.avi',  #
        '--write_pose_json',
        args['json_output_dir'],
        '--no_display',
        '--num_gpu',
        str(NUM_GPUS),
        '--resolution',
        '1280x720',
        '--net_resolution',
        '656x368',
        '--num_scales',
        '1',
        # '--logging_level',
        # '255'
    ]
    # if args.get('no_frame_drops'):
    #     cmd.append('--no_frame_drops')

    # Join the cmd into a string when using shell=True, or else arguments to
    # openpose.bin will not be passed through
    p = subprocess.Popen(
        ' '.join(cmd),
        stdout=subprocess.PIPE,
        shell=True,
        cwd='/home/openpose')
    #### THIS WILL BLOCK ####
    for line in p.stdout:
        print line
    return jsonify({'pid': p.pid})


if __name__ == "__main__":
    server = Server(app.wsgi_app)
    server.serve(host='0.0.0.0', port=5000)
