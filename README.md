# docker-xldeploy-commercial

docker build --build-arg customerid={credentials} --build-arg password={credentials} -t xldeploy

docker run -p 4516:4516 --name xldeploy xldeploy
