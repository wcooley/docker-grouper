# Not ready for production or testing yet

[![Build Status](https://jenkins.testbed.tier.internet2.edu/buildStatus/icon?job=docker/grouper/2.5.11-beta)](https://jenkins.testbed.tier.internet2.edu/buildStatus/icon?job=docker/grouper/2.5.11-beta)


# Misc Notes

- [HTTP Strict Transport Security (HSTS)](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) is enabled on the Apache HTTP Server.
- morphStrings functionality in Grouper is supported. It is recommended that the various morphString files be associated with the containers as Docker Secrets. Set the configuration file properties to use `/var/run/secrets/secretname`.
- Grouper UI has been pre-configured to authenticate users via Shibboleth SP. 
- By default, Grouper WS (hosted by `/opt/tomcat/`) and the Grouper SCIM Server (hosted by `/opt/tomee/`) use tomcat-users.xml for authentication, but by default no users are enabled. LDAP-backed authentication or other methods can be used and must be configured by the deployer.

# License

View [license information](https://www.apache.org/licenses/LICENSE-2.0) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
