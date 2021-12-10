# workstation-images
### Build, test and push
```
copy build-test-push.template.cmd build-test-push.cmd
```
Configure 'build-test-push.cmd'
 - increase the version (V0, V1, V2) for the tag of the images if required (see the 'version' label in dockerfiles)
 - uncomment the proper variables if you want to build with CUDA
 - change the environment variables of `docker run` for test
 - change the 'registryuser' of `docker login` for push
 
Then run 'build-test-push.cmd'
