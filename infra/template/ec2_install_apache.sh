#!/usr/bin/env bash
set -euo pipefail

# ---- Config ----
WORKDIR="/home/ubuntu"
REPO="https://github.com/DogukanUrker/flaskBlog.git"
REPO_DIR="flaskBlog"
PYTHON_BIN="python3"
VENV_DIR="$WORKDIR/$REPO_DIR/venv"
LOGFILE="$WORKDIR/flaskblog_app.log"
# ------------------

cd "$WORKDIR"

# Update & install basic deps
yes | sudo apt update
yes | sudo apt install -y git $PYTHON_BIN $PYTHON_BIN-venv

# Clone or update repo
if [ -d "$REPO_DIR" ]; then
  echo "FlaskBlog repo exists; pulling latest..."
  cd "$REPO_DIR"
  git fetch --all
  git reset --hard origin/HEAD
  git pull --ff-only || true
else
  git clone "$REPO" "$REPO_DIR"
  cd "$REPO_DIR"
fi

# Set up virtualenv if missing
if [ ! -d "$VENV_DIR" ]; then
  $PYTHON_BIN -m venv "$VENV_DIR"
fi

# Activate virtualenv
source "$VENV_DIR/bin/activate"

# Install python requirements
if [ -f requirements.txt ]; then
  pip install --upgrade pip
  pip install -r requirements.txt
else
  echo "requirements.txt not found — installing Flask"
  pip install flask
fi

# Export env vars if needed
export FLASK_APP=app/app.py    # adjust path if app entry is inside app folder
export FLASK_ENV=production

# Start the app in background
echo "Starting FlaskBlog app..."
setsid python3 -u app/app.py &> "$LOGFILE" &

echo "App started. Tail logs with: tail -f $LOGFILE"
