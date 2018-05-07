#!/bin/bash


IFS=$'\n'

# get all autoscaling groups with their relevant configs
ALL_AUTOSCALING_GROUPS_AND_CONFIGS=$(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].[AutoScalingGroupName,LaunchConfigurationName]' --output text )

# all launch configurations
ALL_LAUNCH_CONFIGURATIONS_AND_AMIS=$(aws autoscaling describe-launch-configurations  --query 'LaunchConfigurations[*].[LaunchConfigurationName,ImageId]' --output text)

# all ami info
ALL_AMIS=$(aws ec2 describe-images --query 'Images[*].[ImageId, Name, CreationDate]' --owners self --output text)

# foreach launch configuration...
for GROUP_AND_CONFIG in $(echo "$ALL_AUTOSCALING_GROUPS_AND_CONFIGS"); do
    # put just the autoscaling group into a variable
    ASG=$(echo "$GROUP_AND_CONFIG" | awk '{print $1}')

    # put just the launch confiruation into its own variable
    LAUNCH_CONFIG=$(echo "$GROUP_AND_CONFIG" | awk '{print $2'})
    #echo -e "\nthe autoscaling group $ASG is using the $LAUNCH_CONFIG launch config"

    # ami launch config
    LAUNCH_CONFIG_AMI=$(echo "$ALL_LAUNCH_CONFIGURATIONS_AND_AMIS" | grep $LAUNCH_CONFIG| awk '{print $2}')
    AMI_IN_USE=$(echo "$ALL_AMIS" | grep $LAUNCH_CONFIG_AMI)
    echo -e "\n$ASG, $AMI_IN_USE"
done


