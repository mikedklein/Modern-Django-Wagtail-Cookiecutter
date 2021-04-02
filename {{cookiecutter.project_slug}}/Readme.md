# {{cookiecutter.project_name}}

# Setting Up

- Upgrading pip usually is a good idea `/Path/to/python -m pip install --upgrade pip`
- Install the local requirements `pip install -r requirements/local.txt`
- Make sure to install the pre-commit hooks before doing anything to make sure python formatting is all working
  - `pre-commit install`
- run `npm install` in you local environment and this will pull the node_modules directory into the container on start
- Once everything is setup you should be able to run `docker-compose up`
