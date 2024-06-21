#!/bin/bash

export HOME=/home/ubuntu
sudo apt-get upadate

# Define the disk and mount point
DISK="/dev/disk/by-id/google-persistent-disk-1"  
MOUNT_POINT="/mnt/disks/workdir"

# Check if the mount point directory exists; if not, create it
if [ ! -d "$MOUNT_POINT" ]; then
    echo "Creating mount point directory."
    mkdir -p $MOUNT_POINT
fi

# Check if the disk has a filesystem
FS_CHECK=$(sudo file -s /dev/sdb | grep -o 'filesystem')
if [ "$FS_CHECK" != "filesystem" ]; then
    echo "No filesystem detected, formatting."
    sudo mkfs.ext4 $DISK
fi

# Ensure the disk is not already mounted (to avoid redundancy in /etc/fstab)
if ! mount | grep -q $DISK; then
    echo "Mounting disk."
    sudo mount $DISK $MOUNT_POINT

    # Persist the mounting
    FSTAB_CHECK=$(grep -c "$MOUNT_POINT" /etc/fstab)
    if [ $FSTAB_CHECK -eq 0 ]; then
        echo "$DISK $MOUNT_POINT ext4 defaults 0 2" | sudo tee -a /etc/fstab
    fi
fi

# Provide read/write access to the user
sudo chown $USER:$USER $MOUNT_POINT
sudo chmod 775 $MOUNT_POINT

sudo chown gce:gce $MOUNT_POINT
sudo chmod 775 $MOUNT_POINT

# Install miniconda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
/home/ubuntu/miniconda3/bin/conda init bash
/home/ubuntu/miniconda3/bin/conda activate base
/home/ubuntu/miniconda3/bin/conda install python=3.10 -y

# Install Node
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# source ~/.bashrc
# nvm install v14.10.0

# Ollama installation
cd $MOUNT_POINT
curl -fsSL https://ollama.com/install.sh | sh
mkdir $MOUNT_POINT/models
export OLLAMA_MODELS=$MOUNT_POINT/models

# install code-server service system-wide
sudo curl -fsSL https://code-server.dev/install.sh | sh

# start the visual studio code-server
echo '{
    "workbench.colorTheme": "Kimbie Dark"
}' >> ~/.local/share/code-server/User/settings.json

ollama serve &

PASSWORD=aman code-server $MOUNT_POINT --host 0.0.0.0 --port 10000 &