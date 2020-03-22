# Murmur Dockerfile

This is a Dockerfile for murmur,
[Mumble](https://www.mumble.info/) server. It uses [two-stage
bulid](https://docs.docker.com/develop/develop-images/multistage-build/),
with a `builder` stage used to build murmur from the source code.

## Setup

Before building, edit
[`murmur.ini`](https://wiki.mumble.info/wiki/Murmur.ini).  It is copied
into the image during build. Set the server password and other settings.

Build the image:
```
docker build -t murmur .
```

Then, run the `murmur` image. Assuming your hostname is
`mumble.example.org` and you are using [Certbot](https://certbot.eff.org/)
for TLS certificates:
```
docker run \
  --name murmur \
  -v /etc/letsencrypt/live/mumble.example.org/:/etc/letsencrypt/live/mumble.example.org:ro \
  -v /etc/letsencrypt/archive/mumble.example.org/:/etc/letsencrypt/archive/archive/mumble.example.org:ro \
  -p 64738:64738 -p 64738:64738/udp murmur
```
