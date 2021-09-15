# get the Sources

```bash
# install dependencies
git clone --recurse-submodules -j8 --branch agc_2.14_voe git@gogs.sapian.com.co:Sapian/vicidial.git
```

# voe-landing

## Build Setup


```bash
# Goto the Sources
$ cd extras/Sapian/voe-landing/ 

# install dependencies
$ yarn install

# build for production and launch server
$ yarn build --spa

```

For detailed explanation on how things work, check out [Nuxt.js docs](https://nuxtjs.org).

# Docker Buil

```bash
# Goto the Sources
cd ~/Workspace/vicidial
docker build -t sapian/vicidial-ccweb:1602 -t sapian/vicidial-ccweb:latest -t us.gcr.io/ccoe-246623/sapian/vicidial-ccweb:1602-r3 -t us.gcr.io/ccoe-246623/sapian/vicidial-ccweb:latest .
docker push us.gcr.io/ccoe-246623/sapian/vicidial-ccweb:1602-r6
docker push us.gcr.io/ccoe-246623/sapian/vicidial-ccweb:latest
```