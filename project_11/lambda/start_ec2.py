import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    ec2.start_instances(InstanceIds=[event['instance_id']])
    return "Instance started"
