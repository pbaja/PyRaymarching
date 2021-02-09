echo "### Creating venv ### "
python -m venv venv

echo "`n### Activating venv ###"
./venv/Scripts/activate

echo "`n### Installing requirements ###"
pip install -r requirements.txt

echo "`n### Done ###"
pause