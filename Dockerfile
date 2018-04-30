FROM ubuntu:latest
RUN apt-get update && apt-get install -y wget git
#dh-autoreconf pkg-config unzip

COPY jdk.tar.gz /tmp/jdk.tar.gz
RUN mkdir /usr/java && tar xvfz /tmp/jdk.tar.gz -C /usr/java --strip-components=1
RUN update-alternatives --install /usr/bin/java java /usr/java/bin/java 0

RUN wget "http://download.nextag.com/apache/tomcat/tomcat-9/v9.0.7/bin/apache-tomcat-9.0.7.tar.gz" -O /tmp/apache-tomcat.tar.gz
#COPY apache-tomcat.tar.gz /tmp/apache-tomcat.tar.gz
RUN mkdir /opt/tomcat && tar xvfz /tmp/apache-tomcat.tar.gz -C /opt/tomcat --strip-components=1
RUN groupadd tomcat && useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN chgrp -R tomcat /opt/tomcat
RUN chmod -R g+r /opt/tomcat/conf
RUN chmod g+x /opt/tomcat/conf
RUN chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV  SRC_ROOT /src
ENV OPENGROK_TOMCAT_BASE /opt/tomcat
ENV PATH /opt/opengrok/bin:$PATH

ENV CATALINA_BASE /opt/tomcat
ENV CATALINA_HOME /opt/tomcat
ENV CATALINA_TMPDIR /opt/tomcat/temp
#ENV JRE_HOME /usr
ENV CLASSPATH /opt/tomcat/bin/bootstrap.jar:/opt/tomcat/bin/tomcat-juli.jar


#WORKDIR /tmp
#RUN git clone https://github.com/universal-ctags/ctags.git
#WORKDIR ctags
#RUN ./autogen.sh && ./configure --program-transform-name='s/ctags/my_ctags/; s/etags/myemacs_tags/'
#RUN make && make install && rm -fr /usr/bin/ctags && ln -s /usr/local/bin/my_ctags /usr/bin/ctags
ADD ctags /usr/bin/ctags
RUN wget "https://github.com/oracle/opengrok/releases/download/1.1-rc25/opengrok-1.1-rc25.tar.gz" -O /tmp/opengrok.tar.gz
RUN mkdir /opt/opengrok && tar xvfz /tmp/opengrok.tar.gz -C /opt/opengrok --strip-components=1

RUN mkdir -p /src /data /var/opengrok
RUN ln -s /src /var/opengrok/src
RUN ln -s /data /var/opengrok/data

WORKDIR $CATALINA_HOME
RUN /opt/opengrok/bin/OpenGrok deploy
#RUN mkdir webapps/source
#RUN unzip webapps/source.war -d webapps/source
#RUN chown -R tomcat:tomcat .
#RUN apt-get purge -y dh-autoreconf pkg-config && apt-get autoremove -y
RUN rm -fr /tmp/*

EXPOSE 8080
CMD ["catalina.sh", "run"]
