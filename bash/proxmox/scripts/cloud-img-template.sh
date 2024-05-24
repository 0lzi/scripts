#! /bin/bash
#
#Script to download a cloud image and create a vm template

# Default Values
memory="1024"
bridge_id="vmbr0"
storage="local-lvm"

# Get url from user:
read -p "What cloud image do you want to use? : " cloud_url
read -p "What VMID do you want to use? : " vmid
read -p "How many cores? (Default: '1') : " core_count
if [$core_count == ""]; then
    core_count="1"
fi
read -p "How much memory? (Default: '1024'): " memory
if [$memory == ""]; then
    memory="1024"
fi
read -p "Template name? : " vm_name
read -p "Bridge name (Default: vmbr0): " bridge_id
if [$bridge_id == ""]; then
  bridge_id="vmbr0"
fi
read -p "Define storage (Default local-lvm) : " storage
if [$storage == ""]; then
  storage="local-lvm"
fi
# File name fore cleanup
image_file=$(basename $cloud_url)

# Get cloud image
wget $cloud_url

# Create new virtual machine
echo "Creating new Virtual Machine"
qm create $vmid --memory $memory --core $core_count --name $vm_name --net0 virtio,bridge=$bridge_id

# Import disk
echo "Importing Disk"
qm disk import $vmid $image_file $storage

# Attach the new disk to the vm as a scsi drive on the scsi controller
echo "Attaching disk as scsi drive"
qm set $vmid --scsihw virtio-scsi-pci --scsi0 $storage:vm-$vmid-disk-0

# Add cloudinit drive
echo "Adding cloudinit drive"
qm set $vmid --ide2 $storage:cloudinit

# Set boot disk
echo "Setting boot disk"
qm set $vmid --boot c --bootdisk scsi0

# Set serial console
echo "Setting serial console"
qm set $vmid --serial0 socket --vga serial0

# Clean up img files
echo "Cleaning up downloaded file"
rm -f $image_file


