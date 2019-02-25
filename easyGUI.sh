#!/bin/bashdistro=`python -c 'import platform ; print platform.dist()[0]'`; echo $distro
#Script to Install GUI xfce to Linux on Azure.
#Supported distros:
#CentOS 7.[1-4]
#Ubuntu: 16.04, 17.10, 18.04
#SuSE: 11 SP4, 12 SP[2-4]
#
#

echo "This can take some time, please don't cancel the operation | You can monitor the installation running: sudo tail -f /var/log/GUI.log"

distro=`python -c 'import platform ; print platform.dist()[0]'`; echo $distro
version=`grep -i version= /etc/os-release | head -n 1 | cut -d '"' -f 2 | cut -d ' ' -f 1`; echo $version
logpath=/var/log/easyGUI.log

case $distro in

  redhat)
  centos)
        if [ version == 7.[1-6] ]; then	
	    yum groupinstall 'Server with GUI' -y >> $logpath 2>&1 ; 
	    firewall-cmd --permanent --zone=public --add-port=3389/tcp >> $logpath 2>&1 ; 
	    firewall-cmd --reload >> $logpath 2>&1 ; 
	    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm >> $logpath 2>&1 ; 
	    yum install xrdp tigervnc-server xterm -y >> $logpath 2>&1 ; 
	    systemctl start xrdp >> $logpath 2>&1 ; 
	    systemctl start xrdp-sesman >> $logpath 2>&1 ; 
	    systemctl enable xrdp >> $logpath 2>&1 ; 
	    systemctl enable xrdp-sesman >> $logpath 2>&1 ; 
	    systemctl set-default graphical.target >> $logpath 2>&1 ; 
	    systemctl isolate graphical.target >> $logpath 2>&1 ;          	
	fi;;

  Ubuntu)
	if [ version == 17.* -o version == 18.04* ]; then                                                               	
	    apt-get update -y >> $logpath 2>&1 ;                                        
	    apt-get install xfce4 -y >> $logpath 2>&1 ;
	    apt-get install xrdp -y >> $logpath 2>&1 ;
	    apt-get install xserver-xorg-dev -y >> $logpath 2>&1 ;
	    echo xfce4-session >~/.xsession >> $logpath 2>&1 ;                            
	    /etc/init.d/xrdp start >> $logpath 2>&1 ;
	    systemctl set-default graphical.target >> $logpath 2>&1 ;
	    systemctl isolate graphical.target >> $logpath 2>&1 ;
	    sed 's/allowed_users=console/allowed_users=anybody/g' /etc/X11/Xwrapper.config -i >> $logpath 2>&1  
	    systemctl enable xrdp-sesman.service >> $logpath 2>&1 ;
	    systemctl restart xrdp-sesman.service >> $logpath 2>&1 ;
	    systemctl enable xrdp >> $logpath 2>&1 ;
	    systemctl restart xrdp >> $logpath 2>&1 ;

	elif [ version == 16.* ]; then		                                                                            		
	    apt-get update -y >> $logpath 2>&1 ;
	    sudo apt-get install xfce4 -y >> $logpath 2>&1 ;
	    sudo apt-get install xrdp -y >> $logpath 2>&1 ;
	    echo xfce4-session >~/.xsession >> $logpath 2>&1 ;
	    /etc/init.d/xrdp start >> $logpath 2>&1 ;
	    systemctl set-default graphical.target >> $logpath 2>&1 ;
	    systemctl isolate graphical.target >> $logpath 2>&1 ;                                    
	fi;;
  debian)
	if [ version == 9 ]; then
            apt-get update -y >> $logpath 2>&1 ; 
	    DEBIAN_FRONTEND=noninteractive apt-get install keyboard-configuration -y >> $logpath 2>&1 ;
	    sudo apt-get install xfce4 -y >> $logpath 2>&1 ;
	    sudo apt-get install xrdp -y >> $logpath 2>&1 ;
	    echo xfce4-session >~/.xsession >> $logpath 2>&1 ;
	    /etc/init.d/xrdp start >> $logpath 2>&1 ;
	    systemctl set-default graphical.target >> $logpath 2>&1 ;
	    systemctl isolate graphical.target >> $logpath 2>&1 ;
	fi;;

  SuSE)
	if [ version == 12* ]; then                                                          
	    zypper -n install -t pattern gnome-basic >> $logpath 2>&1 ;
	    zypper -n install xrdp >> $logpath 2>&1 ;
	    sed 's/DEFAULT_WM=""/DEFAULT_WM="gnome"/g' /etc/sysconfig/windowmanager -i >> $logpath 2>&1 ;
	    systemctl start xrdp >> $logpath 2>&1 ;
	    systemctl enable xrdp >> $logpath 2>&1 ;				                  

	elif [ version == 11* ]; then
	    zypper install -y --auto-agree-with-licenses -t pattern x11 gnome
	    zypper -n install xrdp
	    sed 's/DEFAULT_WM=""/DEFAULT_WM="gnome"/g' /etc/sysconfig/windowmanager -i
	    service xrdp start
	    chkconfig -s xrdp 35
	fi;;
  *)
	echo "Unsopported distro" ;;
esac

exit 0;
