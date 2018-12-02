# use the key to set aws configure
pip install boto
echo "please make sure that you download aws cli first"
aws configure
us-east-1
None

# use boto to connect the instance
python - << EOF
import boto.ec2
conn = boto.ec2.connect_to_region("us-east-1")
inst = ["i"]
# start to run the instance  
runinst = conn.start_instances(inst)
# allocate an elaspe IP address
eip = conn.allocate_address()
# associate the Ip address with the running instance
eip.associate("i-00718e443616ff866")
EOF

# get the public DNS of running instance 
set dns=`~/.local/bin/aws ec2 describe-instances --query "Reservations[0].Instances[0].PublicDnsName"`
set dnsaddr=`echo $dns | tr -d '"'`
# user can recorn the public DNS
echo "please record the public DNS"
echo $dnsaddr
# use private key to connect the instance
chmod 400 lab2.pem
ssh -i -y lab2.pem ubuntu@${dnsaddr}
rm -rf csc326-lab4
# copy the lab code to instance
git clone https://github.com/lulululululululu/csc326-lab4.git
# install redis
rm -rf redis-stable
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
# run ther redis server
cd src
redis-server
CTRL-Z
# run the redis server in the background 
bg
disown -h
cd ..
cd ..
# run the website server
cd csc326-lab4
# install the environment
sudo apt-get install -y bottle
sudo apt-get install -y BeautifulSoup
sudo apt-get install -y Beaker
sudo apt-get install -y oauth2client
sudo apt-get install -y httplib2
sudo apt-get install -y google-api-python-client
# store the data to database 
sudo python crawler.py 
# start the website server
sudo nohup python server.py 





