from decouple import config as decouple_config
import os

BASE_DIR = os.path.dirname(os.path.realpath(__file__))


class Config:
    SECRET_KEY = decouple_config('SECRET_KEY')
    SQLALCHEMY_TRACK_MODIFICAITONS = decouple_config('SQLALCHEMY_TRACK_MODIFICAITONS', cast = bool)
    
class DevConfig(Config):
    SQLALCHEMY_DATABASE_URI = "sqlite:///" + os.path.join(BASE_DIR, 'dev.db')
    DEBUG = True
    SQLALCHEMY_ECHO = True
    
class ProdConfig(Config):
    pass

class TestConfig(Config):
    pass

