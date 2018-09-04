#!/bin/bash
echo "Installing Dependencies"
yum install gcc glibc glibc-common
yum install gd gd-devel
echo "Add Nagios User // Type the new password twice"
adduser -m nagios
passwd nagios
echo "Create a new nagcmd group for allowing external commands to be submitted through the web interface"
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd apache
echo "Download the source code tarballs of both Nagios and the Nagios plugins (visit http://www.nagios.org/download/ for links to the latest versions). These directions were tested with Nagios Core 4.0.8 and Nagios Plugins 2.0.3"
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
echo "Extract the Nagios source code tarball."
tar zxvf nagios-4.0.8.tar.gz 
cd nagios-4.0.8
echo "Run the Nagios configure script, passing the name of the group you created earlier like so:"
./configure --with-command-group=nagcmd
echo "Compile the Nagios source code. "
make all
make install 
make install-init 
make install-config 
make install-commandmode
echo "Sample configuration files have now been installed in the /usr/local/nagios/etc directory. These sample files should work fine for getting started with Nagios. You'll need to make just one change before you proceed..."
echo "Edit the /usr/local/nagios/etc/objects/contacts.cfg config file with your favorite editor and change the email address associated with the nagiosadmin contact definition to the address you'd like to use for receiving alerts."
sed -i "s/nagios@localhost/azizzoaib786@hotmail.com/g" /usr/local/nagios/etc/objects/contacts.cfg
echo "Install the Nagios web config file in the Apache conf.d directory."
make install-webconf
echo "Create a nagiosadmin account for logging into the Nagios web interface. Remember the password you assign to this account - you'll need it later."
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
echo "Restart Apache to make the new settings take effect. "
service httpd restart
cd ../
echo "Extract the Nagios plugins source code tarball."
tar zxvf nagios-plugins-2.0.3.tar.gz
echo "Compile and install the plugins."
cd nagios-plugins-2.0.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios 
make
make install
echo "Verify the sample Nagios configuration files."
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
echo "start nagios"
service nagios start
fi