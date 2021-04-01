FROM python:3.8-slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
  # dependencies for building Python packages
  && apt-get install -y build-essential \
  # psycopg2 dependencies
  && apt-get install -y libpq-dev \
  # Translations dependencies
  && apt-get install -y gettext \
  # Adding node dependencies
  && apt-get install -y xz-utils \
  && apt-get install -y curl \
  # cleaning up unused files
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# Install node
# Download latest nodejs binary
RUN curl https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.xz -O
# Extract & install
RUN tar -xf node-v14.16.0-linux-x64.tar.xz
RUN ln -s /node-v14.16.0-linux-x64/bin/node /usr/local/bin/node
RUN ln -s /node-v14.16.0-linux-x64/bin/npm /usr/local/bin/npm
RUN ln -s /node-v14.16.0-linux-x64/bin/npx /usr/local/bin/npx

# Requirements are installed here to ensure they will be cached.
COPY ./requirements /requirements
RUN pip install -r /requirements/local.txt

# Install Node dependencies
RUN npm install

COPY ./compose/django/entrypoint /entrypoint
RUN sed -i 's/\r$//g' /entrypoint
RUN chmod +x /entrypoint

COPY ./compose/django/start /start
RUN sed -i 's/\r$//g' /start
RUN chmod +x /start

WORKDIR /app

ENTRYPOINT ["/entrypoint"]
