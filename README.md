# prison: php apps can go right to jail

Running PHP software sucks. This is a containerized attempt of getting
legacy-ridden PHP apps to run in a cloud-native containerized environment.

Basically, it is assumed you have modified the app to be able to run at least
mostly without mutating the disk. Then you mount the "source" app code at
`/appsrc`, which is copied to the webroot on container boot.

If you make changes inside a container, say updating your horrible CMS version,
then you can just `prison-update-source` and it'll sync the changes back to the
mountpoint, thereby updating the source so you can just reboot the containers.

## A note on file permissions

On container boot, we forcibly `chown` the entire webroot to `apache:www-data`
to make sure everything works.
