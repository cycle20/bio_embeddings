#
# run.sh: run everything in container,
#         but some directory is accessible from it.
#
# Usage: ./run.sh [<fasta/file/path>]
#

function info() {
  echo "INFO: $1"
}

function warning() {
  echo "WARNING: $1" > /dev/stderr
}

function error() {
  echo "ERROR: $1" > /dev/stderr
  exit 1
}

# check docker group membership
if id -nG "$USER" | grep -qw "docker"; then
  SUDO_PREFIX=""
else
  warning "'$USER' is not member of docker group. sudo permission is needed."
  SUDO_PREFIX="sudo"
fi

# check fasta parameter
if [ $# -gt 1 ]; then
  warning "More than one arguments: Only first parameter used as FASTA file."
fi

if [ $# -gt 0 ]; then
  if [ ! -e "$1" ]; then
    error "File does not exist: $1"
  fi
  if [ ! -f "$1" ]; then
    error "'$1' is not a regular file"
  fi
  FASTA_MOUNT=$(eval echo "-v '$(readlink -f ${1})':/mnt/fasta.fa")
  info "'$1' will be mounted as /mnt/fasta.fa"
fi

# prepare cache directory
WEIGHTS_CACHE="$(pwd)/bio_embeddings_weights_cache"
mkdir -p "$WEIGHTS_CACHE"

# prepare command line
CMD='$SUDO_PREFIX docker run --rm -ti
  -v '$(pwd)/examples/docker':/mnt
  -v '$WEIGHTS_CACHE':/.cache/bio_embeddings
  -v '$(pwd)':/app
  $FASTA_MOUNT
  -u $(id -u ${USER}):$(id -g ${USER})
  lacinak:1.0.3'

# run command
eval $CMD
