#!/bin/bash
list=$(terraform workspace list|cut -b2- | xargs)

ws=$(dialog --stdout --no-items --menu "Workspaces" 14 70 14 $list)
terraform workspace select $ws

