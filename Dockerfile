FROM continuumio/miniconda3:latest

RUN apt-get -y update
RUN apt-get -y upgrade

RUN pip install --upgrade pip
RUN pip install mlflow==1.10.0 boto3 awscli

# Install Mysql connector required by SQLAlchemy (https://docs.sqlalchemy.org/en/13/dialects/mysql.html#module-sqlalchemy.dialects.mysql.mysqlconnector)
RUN apt-get -y install default-libmysqlclient-dev build-essential
RUN pip install mysqlclient

# If you want to use file store as backend store and wants to improve tracking server's performance, uncomment following lines. See https://mlflow.org/docs/latest/tracking.html#id53
#RUN apt-get -y install libyaml-cpp-dev libyaml-dev
#RUN pip --no-cache-dir install --force-reinstall -I pyyaml

RUN mkdir /app
RUN cd /app
RUN mkdir mlflow

COPY run.sh /app/mlflow/run.sh

RUN chmod 777 /app/mlflow/run.sh

ENTRYPOINT ["/app/mlflow/run.sh"]
