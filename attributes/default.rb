# raids configuration
default['mdadm']['raids']['/dev/md0']['level'] = 6 
default['mdadm']['raids']['/dev/md0']['chunk'] = 64 
default['mdadm']['raids']['/dev/md0']['devices'] = ['/dev/sdd', '/dev/sde', '/dev/sdf', '/dev/sdg']

default['mdadm']['raids']['/dev/md1']['level'] = 6 
default['mdadm']['raids']['/dev/md1']['chunk'] = 64 
default['mdadm']['raids']['/dev/md1']['devices'] = ['/dev/sdh', '/dev/sdi', '/dev/sdj', '/dev/sdk']

default['mdadm']['raids']['/dev/md2']['level'] = 0 
default['mdadm']['raids']['/dev/md2']['chunk'] = 64 
default['mdadm']['raids']['/dev/md2']['devices'] = ['/dev/md0', '/dev/md1']
