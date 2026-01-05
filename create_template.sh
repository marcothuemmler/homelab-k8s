#!/bin/bash

VMID=9000
CI_IMAGE="/var/lib/vz/template/iso/ubuntu-24.04-server-cloudimg-amd64.img"
STORAGE=local-lvm

set -ex

cleanup() {
    echo "An error occurred. Destroying VM $VMID..."
    qm destroy $VMID --purge || true
}

trap cleanup ERR SIGINT

if qm status $VMID &>/dev/null; then
    echo "VM $VMID already exists. Exiting."
    exit 1
fi

if [[ ! -f "$CI_IMAGE" ]]; then
    echo "Cloud-init image not found at $CI_IMAGE"
    exit 1
fi

# Create base template
qm create $VMID \
    --name ubuntu-24.04-template \
    --memory 2048 \
    --cores 2 \
    --net0 virtio,bridge=vmbr0 \
    --boot c \
    --ostype l26 \
    --machine q35 \
    --cpu host \
    --scsihw virtio-scsi-pci \
    --agent 1

qm importdisk $VMID $CI_IMAGE $STORAGE

qm set $VMID --scsi0 $STORAGE:vm-${VMID}-disk-0
qm set $VMID --ide2 $STORAGE:cloudinit,media=cdrom
qm set $VMID --boot order=scsi0

qm resize $VMID scsi0 20G

qm template $VMID

trap - ERR
