# Dependencies

1. Apache-tomcat
   1. http://download.nextag.com/apache/tomcat/tomcat-9/v9.0.7/bin/apache-tomcat-9.0.7.tar.gz
2. JDK 1.8 or later
3. Universal ctags: https://github.com/universal-ctags/ctags.git
4. Opengrok: https://github.com/oracle/opengrok/releases/download/1.1-rc25/opengrok-1.1-rc25.tar.gz

> NOTE: if all the dependencies are download manually, Dockerfile needs to be modified.

# RUN

```bash
docker run -d \
    -v /path/to/source:/src \
    -v /path/to/data:/data \
    -p 8888:8080 \
    docker-opengrok
```

```bash
docker exec <CONTAINER_NAME> bash -c "/opt/opengrok/bin/OpenGrok index"
```

