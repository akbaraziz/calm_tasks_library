echo "Importing keystore from p12 to jks format"
sudo keytool -importkeystore -srckeystore keystore.p12 -srcstorepass password -destkeystore keystore.jks -deststorepass password -noprompt

sudo cp keystore.jks /opt/nexus/etc/ssl
echo "Deleting alias jetty from JDK cacerts"
#sudo keytool -delete -alias jetty -storepass changeit -keystore /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.282.b08-1.el7_9.x86_64/jre/lib/security/cacerts -noprompt
sudo keytool -delete -alias jetty -storepass changeit -keystore /usr/lib/jvm/jre-1.8.0-openjdk/lib/security/cacerts -noprompt
echo "Importing the nexus_server.pem into JDK cacert"
#sudo keytool -importcert -file nexus_server.pem -alias jetty -storepass changeit -keystore /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.282.b08-1.el7_9.x86_64/jre/lib/security/cacerts -noprompt
sudo keytool -importcert -file nexus_server.pem -alias jetty -storepass changeit -keystore /usr/lib/jvm/jre-1.8.0-openjdk/lib/security/cacerts -noprompt