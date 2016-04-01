#################
# Script to add python and files and update arduino code 
# usage: 
# 	updateArduino.sh <string output from calibration>

if [[ $1 == "" ]]
then
    echo "usage:"
    echo "   updateArduino.sh <string output from calibration>"
    exit
fi

sudo apt-get install python python-pip
sudo pip install enum numpy
git clone git@github.com:doku/Swarmathon-Arduino.git
cd Swarmathon-Arduino/Swarmathon_Arduino
echo "In directory: " `pwd`
pattern="min:[ ]*{(.*)}[ ]*max:[ ]*{(.*)}"
export prefix_min="^[ ]*magnetometer_accelerometer[.]m_min[ ]+="
export prefix_max="^[ ]*magnetometer_accelerometer[.]m_max[ ]+="
if [[ $1 =~ $pattern ]]
then
    export newmin="${BASH_REMATCH[1]}"
    export newmax="${BASH_REMATCH[2]}"
else 
    echo "usage:"
    echo "   updateArduino.sh <string output from calibration>"
    exit
fi
read -d '' scriptVariable << 'EOF'
BEGIN {
    NEWMIN=ENVIRON["newmin"]
    NEWMAX=ENVIRON["newmax"]
    prefmin=ENVIRON["prefix_min"]
    prefmax=ENVIRON["prefix_max"]
}
{
    if ($0 ~ prefmin){
        print "  magnetometer_accelerometer.m_min = (LSM303::vector<int16_t>){" NEWMIN "}"
    } else if ($0 ~ prefmax) {
        print "  magnetometer_accelerometer.m_max = (LSM303::vector<int16_t>){" NEWMAX "}"
    } else {
        print $0    
    }
}

EOF
cat Swarmathon_Arduino.ino | awk "$scriptVariable"  > Swarmathon_Arduino2.ino
mv -n Swarmathon_Arduino.ino Swarmathon_Arduino.competition
mv -n Swarmathon_Arduino2.ino Swarmathon_Arduino.ino
