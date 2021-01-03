[![cloudflared](https://github.com/homeall/cloudflared/workflows/CI/badge.svg)](https://github.com/homeall/cloudflared/actions) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![pull](https://img.shields.io/docker/pulls/homeall/cloudflared)](https://img.shields.io/docker/pulls/homeall/cloudflared) [![pull](https://img.shields.io/docker/image-size/homeall/cloudflared)](https://img.shields.io/docker/image-size/homeall/cloudflared)

# Docker image with [cloudflared](https://github.com/cloudflare/cloudflared) for *[DNS over HTTPS](https://www.cloudflare.com/en-gb/learning/dns/dns-over-tls/)*

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#default-settings">Default Settings</a></li>
      </ul>
       <ul>
        <li><a href="#docker-run-command">Docker run command</a></li>
      </ul>
       <ul>
        <li><a href="#custom-upstreams-and-custom-port-number">Custom upstreams and custom port number</a></li>
      </ul>
       <ul>
        <li><a href="#dualstack-ipv4-ipv6">Dualstack Ipv4/IPv6</a></li>
      </ul>
    </li>
    <li><a href="#pihole">PiHole</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

## About The Project

:white_check_mark: The primary purpose of creating a custom docker image with only **[cloudflared](https://github.com/cloudflare/cloudflared)** was to use *[DNS over HTTPS](https://www.cloudflare.com/en-gb/learning/dns/dns-over-tls/)* with only security upstreams :arrow_down: including **four** DNSs (very good for [fail over](https://en.wikipedia.org/wiki/Failover)), :warning: not only like the rest of images on Docker hub. 

:heavy_exclamation_mark: I believe it is useful in Docker environment or Kubernetes where [High Availability](https://en.wikipedia.org/wiki/High-availability_cluster) is a must.

:sparkle: I am using GitHub actions weekly where it will update cloudflared binary in order to keep up to date the docker image and the package.

:mens: You will find in readme page how to use the commands with images.

:eight_pointed_black_star: It is useful for setting up together with :copyright: [PiHole](https://github.com/pi-hole/pi-hole).


:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- GETTING STARTED -->
## Getting Started

:beginner: It will work on any Linux box amd64 or [Raspberry Pi](https://www.raspberrypi.org) with arm64 or arm32. 

### Prerequisites

You will need to have:

* :whale: [Docker](https://docs.docker.com/engine/install/)
* :whale2: [docker-compose](https://docs.docker.com/compose/) 
 >This step is optional

:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- USAGE -->
## Usage

### Default Settings

:8ball: It will come with the following upstreams *in this order*:

* :one: 1.1.1.3
* :two: security.cloudflare-dns.com
* :three: 1.1.1.2
* :four: 1.0.0.2

:nazar_amulet: The default port is **54**.

:bangbang: The IP addres is **0.0.0.0**

:arrow_up: [Go on TOP](#about-the-project) :point_up:

### Docker run command: 

```docker run -d --name cloudflare -p "54:54" -p "54:54/udp" homeall/cloudflared:latest```

:arrow_down: Docker logs output:

```
INFO[2021-01-01T20:03:37Z] Adding DNS upstream - url: https://1.1.1.3/dns-query
INFO[2021-01-01T20:03:37Z] Adding DNS upstream - url: https://security.cloudflare-dns.com/dns-query
INFO[2021-01-01T20:03:37Z] Adding DNS upstream - url: https://1.1.1.2/dns-query
INFO[2021-01-01T20:03:37Z] Adding DNS upstream - url: https://1.0.0.2/dns-query
INFO[2021-01-01T20:03:37Z] Starting metrics server on 127.0.0.1:8080/metrics
INFO[2021-01-01T20:03:37Z] Starting DNS over HTTPS proxy server on: dns://0.0.0.0:54
```
:arrow_down: Simple tests:

```
❯ dig google.com @127.0.0.1 -p 54 +short
216.58.211.174
❯ dig google.com @127.0.0.1 +tcp -p 54 +short
216.58.211.174
```

![](./cloudflared.gif)

:arrow_up: [Go on TOP](#about-the-project) :point_up:

### Custom upstreams and custom port number:  

:biohazard: You can run change first two upstreams **DNS1** and **DNS2** and *port number*.

:fountain_pen: Change to fit your needs:

```docker run -d --name cloudflare -p "5353:5353" -p "5353:5353/udp" -e "DNS1=dns.google" -e "DNS2=1.1.1.1" -e "PORT=5353" homeall/cloudflared:latest```

:arrow_down: Output result:

```
INFO[2021-01-01T20:08:36Z] Starting metrics server on 127.0.0.1:8080/metrics
INFO[2021-01-01T20:08:36Z] Adding DNS upstream - url: https://dns.google/dns-query
INFO[2021-01-01T20:08:36Z] Adding DNS upstream - url: https://1.1.1.1/dns-query
INFO[2021-01-01T20:08:36Z] Adding DNS upstream - url: https://1.1.1.2/dns-query
INFO[2021-01-01T20:08:36Z] Adding DNS upstream - url: https://1.0.0.2/dns-query
INFO[2021-01-01T20:08:36Z] Starting DNS over HTTPS proxy server on: dns://0.0.0.0:5353
```

:arrow_up: [Go on TOP](#about-the-project) :point_up:

### Dualstack Ipv4 IPv6

:warning: You also can use:

`docker run --name cloudflare -d -p "54:54" -p "54:54/udp" -e "ADDRESS=::" homeall/cloudflared`

:arrow_down: Output result:

```
INFO[2021-01-02T14:38:53Z] Adding DNS upstream - url: https://1.1.1.3/dns-query
INFO[2021-01-02T14:38:53Z] Adding DNS upstream - url: https://security.cloudflare-dns.com/dns-query
INFO[2021-01-02T14:38:53Z] Adding DNS upstream - url: https://1.1.1.2/dns-query
INFO[2021-01-02T14:38:53Z] Adding DNS upstream - url: https://1.0.0.2/dns-query
INFO[2021-01-02T14:38:53Z] Starting metrics server on 127.0.0.1:8080/metrics
INFO[2021-01-02T14:38:53Z] Starting DNS over HTTPS proxy server on: dns://[::]:54
```
:arrow_down: Simple tests:

```
❯ dig google.com @::1 +tcp -p 54 +short
216.58.213.14
❯ dig google.com @::1 -p 54 +short
216.58.213.14
```
:arrow_up: [Go on TOP](#about-the-project) :point_up:

## [PiHole](https://github.com/pi-hole/pi-hole)

:yin_yang: :copyright: [PiHole](https://github.com/pi-hole/pi-hole) with **cloudflared** is a match in heaven :bangbang:

:arrow_down: Check out this [docker-compose.yml](https://docs.docker.com/compose/):

```
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    hostname: pihole
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
    environment:
      TZ: 'Europe/London'
      WEBPASSWORD: 'admin'
      ServerIP: '172.18.0.2'
      DNS1: '172.18.0.3#54'
      DNS2: 'no'
    volumes:
      - './etc-pihole/:/etc/pihole/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
    networks:
      pihole_net:
        ipv4_address: 172.18.0.2

  cloudflare:
    restart: unless-stopped
    container_name: cloudflare
    image: homeall/cloudflared:latest
    links:
      - pihole
    ports:
      - "54:54/tcp"
      - "54:54/udp"
    networks:
      pihole_net:
        ipv4_address: 172.18.0.3

networks:
  pihole_net:
    driver: bridge
    ipam:
     config:
       - subnet: 172.18.0.0/24
```

:arrow_up: [Go on TOP](#about-the-project) :point_up:

 <!-- LICENSE -->
 ## License

:newspaper_roll: Distributed under the MIT license. See [LICENSE](https://raw.githubusercontent.com/homeall/cloudflared/main/LICENSE) for more information.

:arrow_up: [Go on TOP](#about-the-project) :point_up:

<!-- CONTACT -->
## Contact

:red_circle: Please free to open a ticket on Github.

:arrow_up: [Go on TOP](#about-the-project) :point_up:

## Acknowledgements

* :tada: [@Visibilityspots](https://github.com/visibilityspots/dockerfile-cloudflared) :trophy:

* :tada: [@Cloudflared](https://github.com/cloudflare/cloudflared) :1st_place_medal:

* :tada: :copyright: [@PiHole](https://github.com/pi-hole/pi-hole) :medal_sports:

:arrow_up: [Go on TOP](#about-the-project) :point_up:
