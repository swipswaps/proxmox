class packages {

   # install kernel
   package { 'pve-firmware':
     ensure => installed,
   }
   package { 'pve-kernel-2.6.32-16-pve':
     ensure => installed,
   }

   # require reboot here, otherwise install will fail for the pve packages
   package { 'proxmox-ve-2.6.32':
     ensure => installed,
   }

   package { 'ntp':
     ensure => installed,
   }
   package { 'ssh':
     ensure => installed,
   }
   package { 'lvm2':
     ensure => installed,
   }
   package { 'ksm-control-daemon':
     ensure => installed,
   }
   package { 'vzprocps':
     ensure => installed,
   }
}
