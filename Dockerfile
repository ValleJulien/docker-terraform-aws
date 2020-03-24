FROM alpine:3.10 as terraform

ENV TERRAFORM_VERSION=0.12.24

WORKDIR /tmp

RUN apk update --no-cache && \
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

# Clear WORKDIR && cache
RUN rm -rf /tmp/*

FROM python:3.6-alpine3.10
# Copy all terraform files
COPY --from=terraform /usr/bin/terraform /usr/bin/terraform
# Install base and dev packages
RUN apk -v --no-cache --update add \
        --virtual .build-deps \
        groff \
        less \
        bash \
        curl \
        zip \
        openssh
# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime
# Install aws-cli
RUN pip install awscli
ENV HOME=/build
WORKDIR /build
CMD ["/bin/bash"]
