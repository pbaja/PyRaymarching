import logging, os, datetime, sys
from .window import Window

config = {
    "shaders_path": "app/shaders",
    "version": "1.00"
}

class App:

    def __init__(self):
        # Configure logging format
        logFormatter = logging.Formatter(fmt="[%(asctime)-15s][%(levelname)s] %(message)s", datefmt='%d.%m.%Y %H:%M:%S')
        log = logging.getLogger()
        log.setLevel(logging.DEBUG)

        # Logging to file
        fileName = "logs/"+"flatslicer_{}_".format(datetime.datetime.now().strftime("%d-%m-%Y"))+"{}.log"
        fileNum = 0
        if not os.path.isdir("logs"): os.mkdir("logs")
        while os.path.isfile(fileName.format(fileNum)): fileNum += 1
        fileHandler = logging.FileHandler(fileName.format(fileNum))
        fileHandler.setFormatter(logFormatter)
        log.addHandler(fileHandler)

        # Logging to console
        consoleHandler = logging.StreamHandler(sys.stdout)
        consoleHandler.setFormatter(logFormatter)
        consoleHandler.setLevel(logging.INFO)
        log.addHandler(consoleHandler)
        logging.info(f"Starting ShaderTest v{config['version']}")

        # Intialize window
        self.window = Window(config)

    def run(self):
        '''Starts endless loop'''
        self.window.loop()