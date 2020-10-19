# prison: php apps can go right to jail

This is a containerized attempt of getting legacy-ridden PHP apps to run in a cloud-native containerized environment.

I originally built this to run Nextcloud on Kubernetes, a topic [you can read more about on my blog][0].

Basically, it is assumed you have modified the app to be able to run at least mostly without mutating the disk. Then you place a tarball of the app webroot in an S3 bucket, and configure it in the env as `PRISON_WEBROOT_S3_URL=s3://mybucketname/webroot.tar.gz`. This tarball will be downloaded and extracted to the container's webroot on container boot.

If you make changes inside a container, say running some inline updater, then you can just `prison-update-source` and it'll create a new tarball and upload it back to S3, thereby updating the source so you can just reboot the containers.

[0]: https://www.alexblackie.com/articles/nextcloud-on-k8s/

## Usage

The Docker container is hosted on Github Packages.

```
$ docker pull docker.pkg.github.com/alexblackie/prison/prison:10
```

See **Configuration** below for details on the environment variables you have to set. The container just runs Apache HTTPD, so it is available in the container on port `80`.

## Configuration

A few environment variables need to be set:

- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to auth to AWS
- `PRISON_WEBROOT_S3_URL` to specify the object in S3 to use and/or write

## A note on file permissions

On container boot, we forcibly `chown` the entire webroot to `apache:www-data` to make sure everything works.
