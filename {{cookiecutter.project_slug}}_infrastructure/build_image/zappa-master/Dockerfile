FROM lambci/lambda:build-python3.8

COPY yum.conf /etc/yum.conf

RUN yum clean all
RUN yum -y install python38-devel python38-virtualenv vim postgresql postgresql-devel mysql mysql-devel gcc lapack-devel blas-devel libyaml-devel python38-setuptools

RUN python3 -m pip install -U zappa virtualenv

RUN curl –sL https://rpm.nodesource.com/setup_14.x | bash -

RUN yum install nodejs -y

WORKDIR /var/task

RUN virtualenv /var/venv && source /var/venv/bin/activate && pip3 install -U pip && deactivate

COPY bashrc /root/.bashrc

CMD ["zappa"]
