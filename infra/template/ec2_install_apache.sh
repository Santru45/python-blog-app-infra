#! /bin/bash
cd /home/ubuntu

# Update & install basics
yes | sudo apt update
yes | sudo apt install -y python3 python3-pip python3-venv git

# Clone repo (fresh every time)
git clone https://github.com/DogukanUrker/flaskBlog.git
cd flaskBlog/app

# Create venv + install deps
python3 -m venv venv
# shellcheck disable=SC1091
source venv/bin/activate
pip install --upgrade pip
pip install -r ../requirements.txt || pip install uv Flask

echo 'Starting flaskBlog on port 5000...'
# Run detached (so Jenkins/Terraform doesn’t block)
setsid uv run app.py --host 0.0.0.0 --port 5000 &> /home/ubuntu/flaskblog.log &
