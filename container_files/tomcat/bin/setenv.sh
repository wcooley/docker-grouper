CLASSPATH=/opt/tomcat/bin/*
GROUPER_ADD_OPENS="--add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.sql/java.sql=ALL-UNNAMED"
#JAVA_OPTS="-Dlog4j.configurationFile=/opt/tomcat/conf/log4j2.xml -DENV=$ENV -DUSERTOKEN=$USERTOKEN"
CATALINA_OPTS="-Xmx$GROUPER_MAX_MEMORY -XX:+UseG1GC -XX:+UseStringDeduplication -Dlog4j.configurationFile=/opt/tomcat/conf/log4j2.xml -DENV='$ENV' -DUSERTOKEN='$USERTOKEN' -Dfile.encoding=UTF-8 $GROUPER_ADD_OPENS $GROUPER_EXTRA_CATALINA_OPTS"
LOGGING_MANAGER=-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
