# confluence
Puppet Module for Atlassian Confluence

#### Table of Contents

1. [Overview](#overview)
2. [Parameters](#parameters)
3. [Contributing](#contributing)
4. [License](#license)

##Overview

Installs Atlassian Confluence. Aids in easier upgrades however some
manual work is still required.

##Parameters

####Confluence parameters####

Listed in order of appearance in the module.

#####`confluence_version`
Version of Confluence to use.
#####`mysql_connector_version`
Version of the MySQL Connector to use. Currently 5.1.11
#####`parent_dir`
Parent Directory that Confluence Data and Home dirs will install into.
#####`server_port` 
The Server Port to specify in Tomcats server.xml file.
#####`connector_port`
The Connector Port to specify in Tomcats server.xml file.
#####`context_path`
The Context Path to specify in Tomcats server.xml file.
#####`docroot`
This is the Apache HTTPd Servers DocumentRoot.
#####`server_alias`
The Apache HTTPd Servers ServerAlias.
#####`heap_min_size`
Specified in the Confluence setenv.sh file, this is the Java Xms setting.
#####`heap_max_size`
Specified in the Confluence setenv.sh file, thi is the Java Xmx setting.
#####`maxmetaspacesize`
Specified in the Confluence setenv.sh file, this is the Java MaxMetaSpaceSize 
setting. Note that this is JDK 8 specific and so if you want to use JDK 7 or 
earlier (not recommended) then replace this with PermGen and MaxPermGen
#####`confluence_license_hash`
Deprecated - In the latest Confluence versions, this is not used.
#####`confluence_license_message`
Your Confluence License Key - Note you should be putting this in an EYAML
file!! This setting is referenced in the server.xml.erb template.
#####`confluence_setup_server_id`
Your Confluence Server ID - Note you should be putting this in an EYAML
file!! This setting is referenced in the server.xml.erb template.
#####`hibernate_connection_password`
Your MySQL Connection password - Note you should be putting this in an EYAML
file!! This setting is referenced in the server.xml.erb template.
#####`hibernate_connection_username`
Your MySQL Connection username - Note you should be putting this in an EYAML
file!! This setting is referenced in the server.xml.erb template.
#####`hibernate_connection_url`
The connection URL to your MySQL server/database. Unless localhost, I
recommend putting this in an EYAML file. This setting is referenced in the server.xml.erb template.
#####`mysql_connector`
You can leave this as is, it constructs the full filename of the connector
filename with the mysql_connector_version.
#####`confluence_build`
You can leave this as is, it constructs the full filename of the Confluence
version to download.
#####`tarball`
You can leave this as is, it constructs the tar file to download.
#####`download_dir`
The Directory to download the Confluence tarball into. Default: /tmp
You may want to change that if /tmp gets cleared out regularly or it
will be downloaded repteadedly.
#####`downloaded_tarball`
You can leave this as is, it constructs the full path and filename of the
downloaded tarball for use later on.
#####`download_url`
You can usually leave this as is, but if the download fails double-check that
Atlassian havent changed the location of downloadable Confluence versions.
#####`install_dir`
You can usually leave this as is, it constructs the location to unpack the 
Confluence tar into, the final destination for the data dir.
#####`confluence_home`
You can usually leave this as is, based on the `parent_dir` it creates the 
Confluence Home directory.
#####`current_dir`
You can leave this as is. It is used to symlink the installation data dir to current.

##Contributing
Pull Requests Welcome!!
This is an active project so please feel free to offer suggestions, improvements, critique etc. File an Issue if you want something looking into, and for those
that want to go a bit further, create a Pull Request with your work and it will
be looked at.

##License

All files contained in this repository are provided under the ASL v2.0 - please read the LICENSE file for what this entitles you to. This also means that any contributions that you provide here via Pull Requests or any other means will also be accepted and provided under those terms.


