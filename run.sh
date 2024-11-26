# run.sh: run everything in container,
#         but some directory is accessible from it.

WEIGHTS_CACHE="$(pwd)/bio_embeddings_weights_cache"
mkdir -p "$WEIGHTS_CACHE"

sudo docker run --rm -ti \
  -v "$(pwd)/examples/docker":/mnt \
  -v "$WEIGHTS_CACHE":/.cache/bio_embeddings \
  -v "$(pwd)":/app \
  -u $(id -u ${USER}):$(id -g ${USER}) \
  lacinak:1.0.3

