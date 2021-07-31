#!/bin/bash

message () {
	echo ""
	echo "-----------------------------------------------------------"
	echo ""
	echo "$1"
	echo ""
	echo "-----------------------------------------------------------"
	echo ""
}

message "Attempting to stop the create_ap access point (if it's running)..."
sudo systemctl stop create_ap

message "Checking for internet connectivity..."
wget -q --spider http://google.com

if ! [ $? -eq 0 ]; then
	message "\nROSpberryPi is not currently connected to the internet.\nPlease connect to the internet and run this script again\nExiting...\n\n"
	exit
fi

cd install

message "Increasing swapfile to 1Gb..."
sudo dphys-swapfile swapoff
sudo cp dphys-swapfile /etc/dphys-swapfile
sudo dphys-swapfile swapon

message "Checking for updates..."
sudo apt update
sudo apt upgrade -y

message "Installing drmngr..."
sudo apt install -y \
	dirmngr

message "Installing cmake-3.15.7..."
wget https://github.com/jazibdawre/rospberrypi-binaries/raw/master/cmake_3.15.7-1_armhf.deb
sudo dpkg -i --force-all ./cmake_3.15.7-1_armhf.deb

message "Installing packages for stretch-lite..."
sudo apt install -y \
	build-essential \
	libtool \
	autoconf \
	unzip \
	wget \
	git

message "Adding ros repositories..."
if ! grep "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" /etc/apt/sources.list.d/ros-latest.list
	then sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
fi
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

message "Checking for updates again after repositories were added..."
sudo apt update
sudo apt upgrade -y

message "Installing ROS dependencies..."
sudo apt install -y \
	python-rosdep \
	python-rosinstall-generator \
	python-wstool \
	python-rosinstall \
	build-essential

message "Running rosdep init and update..."
sudo rm /etc/ros/rosdep/sources.list.d/20-default.list
sudo rosdep init
rosdep update

message "Installing all opencv3 dependencies..."
sudo apt install -y \
	build-essential \
	cmake \
	pkg-config \
	libjpeg-dev \
	libtiff5-dev \
	libjasper-dev \
	libavcodec-dev \
	libavformat-dev \
	libswscale-dev \
	libv4l-dev \
	libxvidcore-dev \
	libx264-dev \
	libgtk2.0-dev \
	libgtk-3-dev \
	libatlas-base-dev \
	gfortran \
	python3-dev \
	python3-pip \
	libhdf5-100 \
	libhdf5-serial-dev \
	libhdf5-dev \
	libhdf5-cpp-100 \
	caffe-cpu

message "Installing ROS Melodic Desktop dependencies..."
sudo apt install -y \
	python-opencv \
	python-matplotlib \
	python-sip-dev \
	libeigen3-dev \
	libqt5widgets5 \
	libapr1-dev \
	libaprutil1-dev \
	libtinyxml2-dev \
	qtbase5-dev \
	liblz4-dev \
	sbcl \
	tango-icon-theme \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	python-nose \
	python-pil \
	libcurl4-openssl-dev \
	curl \
	libassimp-dev \
	liburdfdom-dev \
	python-yaml \
	libbz2-dev \
	python-lxml \
	cmake \
	uuid-dev \
	python-crypto \
	python-empy \
	python-netifaces \
	liburdfdom-headers-dev \
	libgtest-dev \
	libpython2.7-stdlib \
	python-paramiko \
	python-coverage \
	python-pyqt5.qtopengl \
	google-mock \
	libboost-all-dev \
	liblog4cxx-dev \
	libyaml-cpp-dev \
	qt5-qmake \
	python-mock \
	python-wxtools \
	python-cairo \
	python-dev \
	libssl-dev \
	python-numpy \
	libgtk2.0-dev \
	python-rospkg \
	libopencv-dev \
	libgpgme-dev \
	libogg-dev \
	hddtemp \
	libtinyxml-dev \
	libpoco-dev \
	libconsole-bridge-dev \
	graphviz \
	libqt5opengl5 \
	libqt5opengl5-dev \
	python-gnupg \
	libtheora-dev \
	python-opengl \
	libcppunit-dev \
	python-psutil \
	libogre-1.9-dev \
	python-defusedxml \
	python-pygraphviz \
	python-pydot \
	python-catkin-pkg \
	libqt5gui5 \
	libqt5core5a \
	python-rosdep \
	python-pyqt5.qtwebkit \
	joystick \
	pyqt5-dev \
	python-pyqt5 \
	python-pyqt5.qtsvg \
	python-sip-dev \
	qtbase5-dev \
	pkg-config

message "Installing Samba filesharing tools..."
sudo apt-get install -y \
	samba \
	samba-common-bin \
	smbclient cifs-utils

message "Installing gpizero libraries..."
sudo apt install -y \
	python-gpiozero \
	python3-gpiozero

message "Installing ROS compatible version of tinyxml2..."
wget https://github.com/jazibdawre/rospberrypi-binaries/raw/master/tinyxml2_9.0.0-1_armhf.deb
sudo dpkg -i --force-all ./tinyxml2_9.0.0-1_armhf.deb

message "Installing precompiled arm6l compatible version of opencv3 (raspi 0,1,2 compatible)..."
wget https://github.com/jazibdawre/rospberrypi-binaries/raw/master/opencv.deb
sudo dpkg -i --force-all ./opencv.deb

message "Installing precompiled arm6l compatible version of ros melodic + perception + robot + joy(stick)..."
wget https://github.com/jazibdawre/rospberrypi-binaries/raw/master/ros_desktop.tar.bz2
sudo tar xjf ./ros_desktop.tar.bz2 -C /

message "Adding ros pathes to ~/.bashrc..."
if ! grep "source /opt/ros/melodic/setup.bash" ~/.bashrc
	then echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
fi

message "Installing create_ap (Raspi as a wifi access point)..."
sudo apt install -y \
	util-linux \
	procps \
	hostapd \
	iproute2 \
	haveged \
	dnsmasq \
	iptables

wget https://github.com/jazibdawre/rospberrypi-binaries/raw/master/create-ap_0.4.6-1_armhf.deb
sudo dpkg -i --force-all ./create-ap_0.4.6-1_armhf.deb
sudo create_ap -n wlan0 pi rospberry --mkconfig /etc/create_ap.conf

message "Adding desktop shortcut to autorun ifconfig to get IP address"
mkdir ~/.config/autostart -p
cp ifconfig.desktop ~/.config/autostart/

message "Initializing ROS workspace..."
mkdir /home/pi/ros -p
mkdir /home/pi/ros/src

message "Configuring Samba filesharing..."
sudo systemctl stop smbd
sudo cp smb.conf /etc/samba/smb.conf
sudo systemctl start smbd

message "\
\n\
DONE!!!! \n\
\n\
\n\
OK, now there are a few more things that you need to do \n\
 before you can get started. \n\
 \n\
 \n\
First, run the following command in a command prompt \n\
 to set the samba filesharing password \n\
 for user 'pi'\n (Must be at least 8 characters) \n\
 \n\
 sudo smbpasswd -a pi \n\
 \n\
 \n\
Next, disconnect from your wifi network and run \n \
 the following command to set up your pi as an access point \n\
 \n\
 sudo iw wlan0 disconnect (to disconnect wifi) \n\
 sudo systemctl enable create_ap (set access point to begin automatically on startup) \n\
 sudo systemctl start create_ap (to start the create_ap access point)\n\
 \n\
 \n\
Finally, run the following command to enable ssh, the camera and i2c \n\
 \n\
 sudo rc-gui (for the gui config tool) \n\
 sudo raspi-config (for the command line tool) \n"
