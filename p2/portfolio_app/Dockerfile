# FROM debian:buster

FROM debian:buster

RUN apt-get update -y

RUN apt-get install -y python3 python3-pip

RUN pip3 install Flask

COPY . .

EXPOSE 5000

CMD ["python3", "app.py"]
