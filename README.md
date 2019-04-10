# [underscorgan/vanagon](https://github.com/underscorgan/vanagon-docker-builds)

** NOTE: ** This is still experimental and may change! This README is geared towards building puppet-bolt, since that was the request that led to the container's creation. This container is built with ruby 2.6.2 using a centos:7 base image. To enable builds, this image also has the `pl-gcc` and `pl-cmake` packages installed.

## Changes needed to build outside of the Puppet network

You will need to remove the pl-build-tools repository and any `pl-*` packages from the list of packages to install in the el-7-x86_64.rb platform config. See an example [here](https://github.com/underscorgan/puppet-runtime/compare/master...maint/master/out-of-network).

## Runtime dependency

If you're building a project that uses puppet-runtime, you may need to make some additional changes. This container currently ships with `bolt-runtime-201903260` and `bolt-runtime-201904090`, which were the most recent runtime and the runtime included in the most recent release as of 2019-04-09. If one of those runtimes works for you, you will just need to update the location in `./configs/components/puppet-runtime.json` to "file:///runtime/".

If you need to build a different version of the runtime, I recommend using this container to build the version you need and storing the artifacts in a separate directory locally that you can then mount over the /runtime directory on the container. Then it will continue to work with the same change.

The runtime repo is at https://github.com/puppetlabs/puppet-runtime. Check configs/projects for the available runtimes.

## Configuration

* `VANAGON_USE_MIRRORS` - Whether or not to use the internal Puppet network mirrors for downloading sources. Defaults to 'n'. Do not change unless you're on the internal network, it will make the build go extremely slowly.
* `VANAGON_PROJECT` - **REQUIRED** This should be set the the name of the vanagon project you're building. This should match the name of the file in ./configs/projects/<project>.rb.
* `REPO_URL` - **REQUIRED** The URL for the git repo you're building. Ex: https://github.com/puppetlabs/puppet-runtime
* `REPO_REF` - The ref or branch to checkout for the build. Defaults to master.

## Volumes

* /artifacts - This is the directory all build artifacts will be copied to this directory before the container exits. Mount a volume to this location to preserve the artifacts.
* /runtime - This directory has a few runtimes in it already, but if you need something different I suggest mounting a volume in to this directory with the artifacts from a puppet-runtime build.

## Other quirks

Vanagon projects are often versioned based on the `git describe`. To ensure you're able to build the project, push an annotated tag up to the repo you're building from (`git tag -a -m "1.0.0" 1.0.0`)

## Example, building bolt-runtime and puppet-bolt (using the newly built runtime)

### build bolt-runtime

1) Update the el-7-x86_64.rb platform to not add the pl-build-tools repo / pre-loaded pl-gcc and pl-cmake [here](https://github.com/underscorgan/puppet-runtime/commit/e544aa85cff78fb6a0ec2f59bb4d5f577d7cded0)
2) Make a `runtime` directory locally to store the runtime artifacts
3) `docker run -v $(PWD)/runtime:/artifacts -e VANAGON_PROJECT=bolt-runtime REPO_URL=https://github.com/underscorgan/puppet-runtime -e REPO_REF=maint/master/out-of-network vanagon:el7`
4) You'll now have runtime artifacts in the 'runtime' directory. Look in there and make a note of the version (something like '201904091.1.ge544aa8')

### build puppet-bolt

1) Remove unnecessary build repos from the el-7-x86_64.rb platform [here](https://github.com/underscorgan/bolt-vanagon/commit/86feb223829a46f58bdd232c04ba73eb3c91b29c)
2) Update configs/components/puppet_runtime.json to use local runtime files [here](https://github.com/underscorgan/bolt-vanagon/commit/dc4b97a5282c6fe4821d00c5cfb04d7f41909e86)
3) If using a custom-built runtime, edit the runtime version [here](https://github.com/underscorgan/bolt-vanagon/commit/b54867831a338e490ec7d2e72a989206f4e7b966) to match the version noted during the runtime build
4) Make an `output` directory locally to store the puppet-bolt artifacts
5) `docker run -v /path/to/built/runtime -v $(PWD)/output:/artifacts -e VANAGON_PROJECT=puppet-bolt REPO_URL=https://github.com/underscorgan/bolt-vanagon -e REPO_REF=b54867831a338e490ec7d2e72a989206f4e7b966 vanagon:el7`
6) Your puppet-bolt rpms are now in the output directory!
