#!/bin/bash
cd "$(dirname "$0")"

echo "Creating virtual environment"
python3 -m venv venv

echo "Activating venv"
source venv/bin/activate

echo "Installing dependencies"
pip install -r requirements.txt