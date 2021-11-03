# antora-centos7
FROM registry.redhat.io/rhel8/s2i-base:latest

#Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building antora and running docs" \
     io.k8s.display-name="antora-rhels2i 1.0.0" \
     io.openshift.expose-services="8080:http" \
     io.openshift.tags="builder,antora,yml,html."

RUN yum install -y --disableplugin=subscription-manager python3 && yum clean all

RUN npm i -g @antora/cli@2.3 @antora/site-generator-default@2.3

# (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# Drop the root user and make the content of /opt/openshift owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
