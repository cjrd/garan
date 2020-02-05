This is my development environment.
When possible, I run this as a docker container.
When not possible, I copy over the dot files and awkwardly install the dependencies.

* On host machine, install docker: `./scripts/get-docker.sh`
* `docker build -t garan .`
* `./dev.sh`




## Helpful tips for new systems that don't support docker
* Installing [conda](https://www.anaconda.com/distribution/) is a good idea: it can manage more than just python
* Installing [emacs from conda](https://anaconda.org/conda-forge/emacs) is a good idea
