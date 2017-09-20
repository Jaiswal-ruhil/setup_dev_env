# dev-env-test:0.2.0
# Build using: docker build -t "dev-env-test:0.2.0" --rm=true --no-cache .
#
# NAME             dev-env-test
# VERSION          0.2.0

FROM  ubuntu

RUN apt update
RUN apt upgrade -y
ENV PATH /dev_env:$PATH


WORKDIR /proj
