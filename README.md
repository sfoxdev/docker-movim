# Movim

Movim runs by supervisor with Nginx and php-fpm

[![Docker Build Status](https://img.shields.io/docker/build/sfoxdev/movim.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/automated/sfoxdev/movim.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/pulls/sfoxdev/movim.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/stars/sfoxdev/movim.svg?style=flat-square)]()

## Usage

### Run Movim
```
docker run -d -p 80:80 -p 8080:8080 -p 8170:8170 --net=prosody_network --name movim sfoxdev/movim:latest
```
