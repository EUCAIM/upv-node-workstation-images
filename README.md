# workstation-images
### Build, test and push
```
copy build-test-push.template.cmd build-test-push.cmd
```
Configure 'build-test-push.cmd'
 - increase the version in tag of the images? (see the 'version' label in dockerfile)
 - change the environment variables of `docker run` for test
 - change the 'registryuser' of `docker login` for push
 
Then run 'build-test-push.cmd'
