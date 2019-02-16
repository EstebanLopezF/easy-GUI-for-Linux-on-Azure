#!/bin/bash
#Script to Install GUI xfce to Linux on Azure.
#Supported distros:
#CentOS 7.[1-4]
#Ubuntu: 16.04, 17.10, 18.04
#SuSE: 12-SP3
#
#

echo "This can take some time, please don't cancel the operation | You can monitor the installation running: sudo tail -f /var/log/GUI.log"

distro=`python -c 'import platform ; print platform.dist()[0]'`; echo $distro
version=`grep -i version= /etc/os-release | head -n 1 | cut -d '"' -f 2 | cut -d ' ' -f 1`; echo $version

case $distro in

centos)
    if [ version == 7.[1-4] ]; then	
		yum groupinstall 'Server with GUI' -y >> /var/log/GUI.log 2>&1 ; 
		firewall-cmd --permanent --zone=public --add-port=3389/tcp >> /var/log/GUI.log 2>&1 ; 
		firewall-cmd --reload >> /var/log/GUI.log 2>&1 ; 
		rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm >> /var/log/GUI.log 2>&1 ; 
		yum install xrdp tigervnc-server xterm -y --skip-broken >> /var/log/GUI.log 2>&1 ; 
		systemctl start xrdp >> /var/log/GUI.log 2>&1 ; 
		systemctl start xrdp-sesman >> /var/log/GUI.log 2>&1 ; 
		systemctl enable xrdp >> /var/log/GUI.log 2>&1 ; 
		systemctl enable xrdp-sesman >> /var/log/GUI.log 2>&1 ; 
		systemctl set-default graphical.target >> /var/log/GUI.log 2>&1 ; 
		systemctl isolate graphical.target >> /var/log/GUI.log 2>&1 ;          	
	fi;;
Ubuntu)
	if [ version == 17.* -o version == 18.04* ]; then                                                               	
		apt-get update -y >> /var/log/GUI.log 2>&1 ;                                        
		apt-get install xfce4 -y >> /var/log/GUI.log 2>&1 ;
		apt-get install xrdp -y >> /var/log/GUI.log 2>&1 ;
		apt-get install xserver-xorg-dev -y >> /var/log/GUI.log 2>&1 ;
		echo xfce4-session >~/.xsession >> /var/log/GUI.log 2>&1 ;                            
		/etc/init.d/xrdp start >> /var/log/GUI.log 2>&1 ;
		systemctl set-default graphical.target >> /var/log/GUI.log 2>&1 ;
		systemctl isolate graphical.target >> /var/log/GUI.log 2>&1 ;
		sed 's/allowed_users=console/allowed_users=anybody/g' /etc/X11/Xwrapper.config -i >> /var/log/GUI.log 2>&1  
		systemctl enable xrdp-sesman.service >> /var/log/GUI.log 2>&1 ;
		systemctl restart xrdp-sesman.service >> /var/log/GUI.log 2>&1 ;
		systemctl enable xrdp >> /var/log/GUI.log 2>&1 ;
		systemctl restart xrdp >> /var/log/GUI.log 2>&1 ;
	elif [ version == 16.* ]
		then		                                                                            		
			apt-get update -y >> /var/log/GUI.log 2>&1 ;
			sudo apt-get install xfce4 -y >> /var/log/GUI.log 2>&1 ;
			sudo apt-get install xrdp -y >> /var/log/GUI.log 2>&1 ;
			echo xfce4-session >~/.xsession >> /var/log/GUI.log 2>&1 ;
			/etc/init.d/xrdp start >> /var/log/GUI.log 2>&1 ;
			systemctl isolate graphical.target >> /var/log/GUI.log 2>&1 ;                                    
	fi;;
SuSE)
		if [ version == 12-SP[1-3] ]; then                                                          
			zypper -n install -t pattern gnome-basic >> /var/log/GUI.log 2>&1 ;
			zypper -n install xrdp >> /var/log/GUI.log 2>&1 ;
			sed 's/DEFAULT_WM=""/DEFAULT_WM="gnome"/g' /etc/sysconfig/windowmanager -i >> /var/log/GUI.log 2>&1 ;
			systemctl start xrdp >> /var/log/GUI.log 2>&1 ;
			systemctl enable xrdp >> /var/log/GUI.log 2>&1 ;				                  
		elif [ version == 11-SP* ]
			then	
		#commands;                                              #SUSE 11.SP*		
	fi;;
*)
	echo "Unsopported distro" ;;
esac

exit 0;
