#################
# Script to add python and files and update arduino code 
# usage: 
# 	updateArduino.sh <string output from calibration>

sudo apt-get install python python-pip
sudo pip install enum numpy
mv ~/.ssh/id_rsa.pub ~/.ssh/id_rsa_pub 
mv ~/.ssh/id_rsa ~/.ssh/id_rsa_priv
cp id_* ~/.ssh/ 
git clone git@github.com:doku/Swarmathon-Arduino.git
cd Swarmathon-Arduino/Swarmathon_Arduino
prefix_min="magnetometer_accelerometer\.m_min"
cat Swarmathon_Arduino.ino | awk -f update.awk <  
# magnetometer_accelerometer.m_min = (LSM303::vector<int16_t>)
# magnetometer_accelerometer.m_max = (LSM303::vector<int16_t>)




mv ~/.ssh/id_rsa_pub ~/.ssh/id_rsa.pub  
mv ~/.ssh/id_rsa_priv ~/.ssh/id_rsa
