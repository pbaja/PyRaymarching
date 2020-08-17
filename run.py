import sys, os
from threading import Thread
from pathlib import Path
from app import App

app = None

if __name__ == "__main__":
    # Run app
    app = App()
    app.run()    