apt-get update
apt-get upgrade
apt-get install nfs-common -y
NFS_SERVER="10.10.50.75"
NFS_SHARE="/mnt/cache-00/cache-gdrive/jmg-hel-swarm-00"
MOUNT_POINT="/nfs"

cd /
mkdir /nfs

# Mount NFS share persistently
echo "$NFS_SERVER:$NFS_SHARE $MOUNT_POINT nfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
echo "Task OK"
