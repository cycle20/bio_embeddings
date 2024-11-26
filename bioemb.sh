# bioemb.sh: for entrypoint of image

# replace to the following to /bin/bash if you need more control or playground
/venv/bin/python -m bio_embeddings.utilities.cli --overwrite ./examples/docker/config.yml
