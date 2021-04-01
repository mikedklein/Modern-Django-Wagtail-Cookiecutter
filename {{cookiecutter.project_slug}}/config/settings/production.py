from .base import *  # noqa
from .base import env

# GENERAL
# ------------------------------------------------------------------------------
# https://docs.djangoproject.com/en/dev/ref/settings/#debug
DEBUG = False
# https://docs.djangoproject.com/en/dev/ref/settings/#secret-key
SECRET_KEY = env(
    "DJANGO_SECRET_KEY",
    default="EWsQFPA4udO3qGuDiDL9znbsBnHD0oJoqzLrvQjyMSlIUgO8kGAm1BzgKRxl3JED",
)


THIRD_PARTY_APPS += [
    "zappa_django_utils",
    "django_s3_storage",
]
