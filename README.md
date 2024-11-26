# Bio Embeddings (Lacinak ✌️)

## Build and run

```sh
$ ./build-image.sh
$ ./run.sh
```

## Customization

The entrypoint is `bioemb.sh` in Dockerfile. This can be changed to change running apps/parameters in the running container.
`examples/docker` is mounted under `/mnt`. This is where `config.yml` exposed to the app.

`config.yml`:

- can be edited - as `fasta.fa2` already set in instead of `fasta.fa`
- can be mounted from different directory - see related `docker run` option in `run.sh` (`-v`)
- can be built into the image, in this case customize the `Dockerfile`

## License and others

For more details check `README.ORIGINAL.md`.
