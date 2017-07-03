FROM ubuntu:16.04
MAINTAINER dsmdev@cn.ibm.com
WORKDIR /opt
ADD start_mgr.sh /opt/

# Putting this EXPOSE line here as a hint for developers
# Download kubectl - we use the "public kubectl" in this example for ease of use.
#  In your production system - you should use the kubectl from hydra build server
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    curl &&\
    curl -sSL "http://storage.googleapis.com/kubernetes-release/release/v1.5.3/bin/linux/amd64/kubectl" > /usr/bin/kubectl &&\
    chmod +x /usr/bin/kubectl 

#RUN apt-get install telnet -y
RUN mkdir /session-manager


# Copy the files into the docker container
# Assumes 
#    the otto-nginx-pod.yml file is in this location
#    the backendmgmt binary of the GoLang webserver is in this location
#    the certificate files (ca.pem, cert.pem, key.pem ) are in this location
#    the config file - to be used with kubectl - is in this location
ADD config /session-manager/
ADD protocol.conf /session-manager/
ADD build/secret.yaml /session-manager/
ADD build/sessionmgr /session-manager/
ADD *.sh /session-manager/
ADD *.json.tpl /session-manager/
ADD *.pem /session-manager/

EXPOSE 11080 11081 11082 8082
ENTRYPOINT ["/opt/start_mgr.sh"]

