# sslscan Docker Image

Docker image with static build of *sslscan* based on alpine linux. A multi-stage build is used to keep the image small. Whereby *sslscan* is statically compiled directly based a fork of [rbsec/sslscan](https://github.com/rbsec/sslscan). The final image is small and just contains sslscan and a few other mandatory files.

## Usage

*sslscan* is the only binary in the Docker image and defined as *entrypoint*. The usage is therefore quite straightforward.

```bash
docker run -it --rm oehrlis/sslscan <OPTIONS>
```

Display usage for *sslscan*:

```bash
docker run -it --rm oehrlis/sslscan --help
```

For example a scan from *google.com*

```bash
docker run -it --rm oehrlis/sslscan google.com
```

If you like to scan other docker networks you can specify the network as `docker run` parameter. The following statement does scan the OUD server *eusoud* on port *1636* in the network *trivadislabs.com*.

```bash
docker run -it --rm --network="trivadislabs.com" oehrlis/sslscan eusoud:1636
```

To avoid specifying docker all the time, you can also define an alias

```bash
alias sslscan='docker run -it --rm oehrlis/sslscan'

sslscan --help
```

## Build

If you plan to alter or extend this Docker image you could get the corresponding files from [GitHub](https://github.com/oehrlis/docker-sslscan) and build the image manually.

```bash
git clone git@github.com:oehrlis/docker-sslscan.git
$ cd docker-sslscan
$ docker build -t oehrlis/sslscan .
```

## Issues

Please file your bug reports, enhancement requests, questions and other support requests within [Github's issue tracker](https://help.github.com/articles/about-issues/):

* [Existing issues](https://github.com/oehrlis/docker-sslscan/issues)
* [submit new issue](https://github.com/oehrlis/docker-sslscan/issues/new)
