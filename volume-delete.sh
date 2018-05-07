#!/bin/bash



safe_list =('aws ec2 describe-volumes --filters Name=status,Values=available --output text')




# This will give you a list of volumes without instances tied to them in table format
# aws ec2 describe-volumes --filters Name=status,Values=available --output table

# Will need to come up with a safety check to ensure that volumes are not tied to running instances
# Safety check will consist of a check of volume state. Available=safe(no running instances) in-use=not safe(will require override option)


# Thinking something like "Volumes not attached to any running instances: Safe to proceed"
# "Deleting volume..." 
# aws ec2 delete-volume --volume-id $VOLUMEID
