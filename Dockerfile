#
# See the top level Makefile in https://github.com/docker/docker for usage.
#
FROM debian:jessie
MAINTAINER Sven Dowideit <SvenDowideit@docker.com> (@SvenDowideit)

RUN apt-get update \
	&& apt-get install -y \
		gettext \
		git \
		libssl-dev \
		make \
		python-dev \
		python-pip \
		python-setuptools \
		vim-tiny

RUN pip install mkdocs

# add MarkdownTools to get transclusion
# (future development)
#RUN easy_install -U setuptools
#RUN pip install MarkdownTools2

# this version works, the current versions fail in different ways
RUN pip install awscli==1.4.4 pyopenssl==0.12

# get my sitemap.xml branch of mkdocs and use that for now
# commit hash of the newest commit of SvenDowideit/mkdocs on
# docker-markdown-merge branch, it is used to break docker cache
# see: https://github.com/SvenDowideit/mkdocs/tree/docker-markdown-merge
RUN git clone -b docker-markdown-merge https://github.com/SvenDowideit/mkdocs \
	&& cd mkdocs/ \
	&& git checkout ad32549c452963b8854951d6783f4736c0f7c5d5 \
	&& ./setup.py install

WORKDIR /docs
EXPOSE 8000
CMD ["mkdocs", "serve"]


COPY . /src
COPY . /docs

# Use the local docs-base/README.md as the example index.md documentation
# when running `make docs` from a docs-base clone.
COPY README.md /docs/sources/index.md

# reset the /docs dir so the meta-data comes from the new documentation files.
ONBUILD RUN rm -rf /docs ; cp -r /src /docs

RUN ./build.sh

