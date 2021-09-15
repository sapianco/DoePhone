# DoePhone

![](https://ceph.sapian.cloud/sapian-hackmd-public-bucket/uploads/upload_8255ef2cde808f2e00752ea25cb979ab.png)

el Softphone WebRTC de [DialBox Online Edition](http://www.sapian.co/dialbox-online-edition) te permitira realizar y atender llamadas directamente desde un navegador, no necesitas hacer ninguna instalación ni actualización.

## Test whit Docker local

``` bash 
docker run -v /home/arpagon/Workspace/DoePhone/DoePhone:/var/www/html/DoePhone --network host --rm -p 30080:8080 us.gcr.io/ccoe-246623/sapian/doephone:latest

```

## Test whit https
``` bash 
docker run --network host --rm -p 2020:2020 -v /home/arpagon/Workspace/DoePhone/config/caddy/Caddyfile:/etc/caddy/Caddyfile caddy:2-alpine
```
https://localhost:2020/DoePhone

## Build

``` bash
docker build --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg VCS_REF=$(git rev-parse --short HEAD) -t sapian/vicidial-ccweb-agc:1602 -t us.gcr.io/ccoe-246623/sapian/doephone:latest -t us.gcr.io/ccoe-246623/sapian/doephone:1602-r17 --build-arg VERSION=1602-r17  .
```


## Build helm package

``` bash
helm package --destination release/ helm/ccagc/
```

## Upload new Version of Chart
curl -u sapian:superpassword --data-binary "@release/doephone-7.9.2.tgz" https://chartmuseum.voe.sapian.cloud/api/charts
