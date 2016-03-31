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
echo "In directory: " `pwd`
pattern="min:[ ]*{(.*)}[ ]*max:[ ]*{(.*)}"
export prefix_min="magnetometer_accelerometer[.]m_min"
export prefix_max="magnetometer_accelerometer[.]m_max"
if [[ $1 =~ $pattern ]]
then
export newmin="$BASH_REMATCH[1]"
export newmax="$BASH_REMATCH[2]"
fi
read -d '' scriptVariable << 'EOF'
BEGIN {
NEWMIN = ENVIRON["newmin"]
NEWMAX = ENVIRON["newmax"]
prefmin = ENVIRON["prefix_min"]
prefmax = ENVIRON["prefix_max"]
}
{

if ($0 ~ /prefmin/){
print "CHANGE:" $0
} else {
print $0
}
}

EOF
cat Swarmathon_Arduino.ino | awk "$scriptVariable"
# magnetometer_accelerometer.m_min = (LSM303::vector<int16_t>)
# magnetometer_accelerometer.m_max = (LSM303::vector<int16_t>)




mv ~/.ssh/id_rsa_pub ~/.ssh/id_rsa.pub  
mv ~/.ssh/id_rsa_priv ~/.ssh/id_rsa
