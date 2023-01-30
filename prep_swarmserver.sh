apt-get update
apt-get upgrade
apt-get autoremove
NFS_SERVER="10.10.50.75"
NFS_SHARE="/mnt/cache-00/cache-gdrive/jmg-hel-swarm-00"
MOUNT_POINT="/mnt"

# Mount NFS share persistently
echo "$NFS_SERVER:$NFS_SHARE $MOUNT_POINT nfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
