from ffprobe import FFProbe

metadata=FFProbe('test-media-file.mov')

for stream in metadata.streams:
    if stream.is_video():
        print('Stream contains {} frames.'.format(stream.frames()))