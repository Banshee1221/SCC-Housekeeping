# There are two options that can be used here.
# 1. Clone the repository where the Dockerfile exists and build it manually
# 2. Pull the Docker image directly from some external image hosts

mkdir -p $NFS_DIR/git && cd $NFS_DIR/git

# Git repos and setup
REPO_LIST=(
  "https://github.com/Banshee1221/Docklia.git"
  ""
)

for each in ${REPO_LIST[@]}
do
  git clone $each
done


# Image host commands
