# Fossil SCM Repolist-Server Docker Image

## What is fossil?

Fossil is a simple, high-reliability, distributed software configuration management system with many advanced features.

## About this image

1. This image is configured to serve but a whole directory full of repositories via the `--repolist` option

1. It is very small, as it is built atop Alpine Linux and comprised of a single fossil-executable.

## Usage

```
$ docker run -p 8181:8181 lxsystems/fossil-scm-repolist-server

```
You can now access your instance via http://localhost:8181 in your browser.
