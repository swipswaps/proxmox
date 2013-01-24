class sources {

   $release = squeeze

   # add key and source for proxmox-ve
   apt::source {'proxmox':
      location    => 'http://download.proxmox.com/debian',
      include_src => false,
      release     => $release,
      repos       => 'pve',
      key         => '9887F95A',
   }

   apt::source { 'primary':
     location => 'deb http://ftp.us.debian.org/',
     release  => "${release}",
     repos    => 'main contrib non-free'
   }

   apt::source { 'debian-security':
     location => 'deb http://security.debian.org/',
     release  => "${release}/updates",
     repos    => 'main contrib non-free'
   }

}
