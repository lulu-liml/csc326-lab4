# terminate
import boto.ec2

inst = conn.get_only_instances()
# get the public IP address
ip = inst[0].__dict__['ip_address']
# disassociate the IP address with running instance
conn.disassociate_address(ip)
# get the allocation ID of the address
alloc=conn.get_all_addresses()[0].__dict__['allocation_id']
# release the elaspe IP address
conn.release_address(None,alloc)
inst = ["i-00718e443616ff866"]  
# stop the instance
conn.stop_instances(inst)
# terminate the instance
conn.terminate_instances(inst)
