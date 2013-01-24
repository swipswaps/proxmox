class hosts {
   # clear host file of unmanaged entries
   resources { 'host': purge => true }

   host { 'localhost.localdomain':
      ip => '$ipaddress_lo',
      host_aliases =>  'localhost',
   }

   host { 'manchester.cs.uchicago.edu':
      ip => $ipaddress_eth0,
      host_aliases => [ $hostname, 'pvelocalhost' ],
   }

}

# /etc/hosts
# 127.0.0.1 localhost.localdomain localhost
# 128.135.164.115 manchester.cs.uchicago.edu manchester pvelocalhost

}
