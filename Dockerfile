FROM ubuntu:18.04

RUN echo 1

RUN apt update
RUN apt install -y python3 python3-pip

RUN pip3 install Django

ADD server.sh /server.sh
ADD ElcheapoAIS_manhole /ElcheapoAIS_manhole

CMD ["/bin/bash", "/server.sh"]
