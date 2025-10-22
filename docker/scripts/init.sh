#!/bin/sh
set -e

# Set default repository path if not provided
GIT_REPO_PATH=${GIT_REPO_PATH:-/git/repo}
echo "starting git initialization in ${GIT_REPO_PATH}..."

# Install git-daemon package
echo "installing git daemon..."
apk add --no-cache git-daemon

# Create repository directory if it doesn't exist
echo "creating repository directory..."
mkdir -p "${GIT_REPO_PATH}"
cd "${GIT_REPO_PATH}"

# Initialize git if not already initialized
if [ ! -d .git ]; then
    echo "creating new git repository..."
    git init --bare
fi

# Configure git with proper quoting
echo "configuring git..."
git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_EMAIL}"
git config --global --add safe.directory "${GIT_REPO_PATH}"

# Start git daemon with absolute path
echo "starting git daemon..."
/usr/libexec/git-core/git-daemon \
    --reuseaddr \
    --base-path="${GIT_REPO_PATH}" \
    --export-all \
    --enable=receive-pack \
    --verbose \
    "${GIT_REPO_PATH}" &

echo "git repository is ready at ${GIT_REPO_PATH}"
exec tail -f /dev/null
