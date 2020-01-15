This is my development environment.
When possible, I run this as a docker container.
When not possible, I copy over the dot files and awkwardly install the dependencies.

* On host machine, install docker: `./scripts/get-docker.sh`
* `docker build -t garan .`
* `./dev.sh`
