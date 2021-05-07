FROM ubuntu:latest

MAINTAINER @dgalact

RUN apt-get -qq update

RUN apt-get install -y git

RUN apt-get install -y python-pip

RUN apt-get install -y lsb-release 

RUN apt-get install -y sudo

RUN apt-get install -y software-properties-common

RUN git clone -b stable_4 --depth 1 https://github.com/crits/crits.git 

ADD bootstrap /crits/script/bootstrap

WORKDIR crits

RUN mv requirements.txt requirements.old && grep -v m2crypto requirements.old > requirements.txt && rm requirements.old

RUN TERM=xterm sh ./script/bootstrap < docker_inputs

RUN pip install mongoengine==0.17.0

RUN pip install pymongo==3.0

RUN sh contrib/mongo/mongod_start.sh && python manage.py users -u admin -p "P@$$w0rd!" -s -i -a -A -e admin@ctrits.crits -f Admin -l User -o none

EXPOSE 8080

CMD sh contrib/mongo/mongod_start.sh && python manage.py runserver 0.0.0.0:8080
