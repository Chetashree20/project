FROM tomcat:9.0

# remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# copy WAR
COPY target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh","run"]
