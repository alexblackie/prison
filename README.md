# prison: php apps can go right to jail

This is a containerized attempt of getting legacy-ridden PHP apps to run in a cloud-native containerized environment.

I originally built this to run Nextcloud on Kubernetes, a topic [you can read more about on my blog][0].

Basically, it is assumed you have modified the app to be able to run at least mostly without mutating the disk. Then you place a tarball of the app webroot in an Azure Storage account. This tarball will be downloaded and extracted to the container's webroot on container boot.

If you make changes inside a container, say running some inline updater, then you can just `prison-update-source` and it'll create a new tarball and upload it back to the Azure Storage account container, thereby updating the source so you can just reboot the containers.

[0]: https://www.alexblackie.com/articles/nextcloud-on-k8s/

## Usage

The Docker container is hosted on the Docker Hub.

```
$ docker pull alexblackie/prison
```

See **Configuration** below for details on the environment variables you have to set. The container just runs Apache HTTPD, so it is available in the container on port `80`.

## Configuration

A single environment variable must be set: `AZURE_STORAGE_WEBROOT_URL`. This must be a full URL to the webroot tarball in Azure Storage, appended with a valid Shared Access Signature (SAS).

For example (with sensitive values removed):

```
AZURE_STORAGE_WEBROOT_URL="https://<account>.blob.core.windows.net/<container>/webroot.tar.gz?sv=2019-12-12&ss=b&srt=co&sp=rwdlac&se=<end>&st=<start>&spr=https&sig=<sig>"
```

You can generate a SAS for your storage account from the "Shared access signature" section of its settings in the Azure Portal. Ensure you set a reasonable expiry date, and rotate regularly as you would any sensitive credential.

## A note on file permissions

On container boot, we forcibly `chown` the entire webroot to `apache:www-data` to make sure everything works.
