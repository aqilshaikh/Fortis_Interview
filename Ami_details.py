import boto3
import json
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed
from botocore.exceptions import ClientError


# Define a function to provide default values for AMI details
def default_ami_info():
    return {
        "ImageDescription": None,
        "ImageName": None,
        "ImageLocation": None,
        "OwnerId": None,
        "InstanceIds": []
    }


def fetch_ec2_instances(ec2_client):
    """
    Fetch all EC2 instances and group them by their AMI IDs.
    """
    ami_info = defaultdict(default_ami_info)

    try:
        # Paginate through all EC2 instances
        paginator = ec2_client.get_paginator("describe_instances")
        for page in paginator.paginate():
            for reservation in page.get("Reservations", []):
                for instance in reservation.get("Instances", []):
                    ami_id = instance.get("ImageId")
                    instance_id = instance.get("InstanceId")
                    ami_info[ami_id]["InstanceIds"].append(instance_id)
    except ClientError as e:
        print(f"AWS API error while fetching EC2 instances: {e}")
    except Exception as e:
        print(f"Unexpected error while fetching EC2 instances: {e}")

    return ami_info


def fetch_ami_details(ec2_client, ami_id):
    """
    Fetch details for a single AMI.
    """
    try:
        response = ec2_client.describe_images(ImageIds=[ami_id])
        if response.get("Images"):
            ami_data = response["Images"][0]
            return {
                "ImageDescription": ami_data.get("Description"),
                "ImageName": ami_data.get("Name"),
                "ImageLocation": ami_data.get("ImageLocation"),
                "OwnerId": ami_data.get("OwnerId")
            }
    except ClientError as e:
        if e.response['Error']['Code'] == 'InvalidAMIID.NotFound':
            print(f"AMI {ami_id} not found (possibly deregistered).")
        else:
            print(f"Error retrieving details for AMI {ami_id}: {e}")
    except Exception as e:
        print(f"Unexpected error while fetching details for AMI {ami_id}: {e}")

    return None


def get_ec2_instances_by_ami():
    """
    Fetch and group EC2 instances by AMI ID with concurrent retrieval of AMI details.
    """
    try:
        ec2_client = boto3.client("ec2")  # Securely initialize EC2 client
    except ClientError as e:
        print(f"Failed to initialize EC2 client: {e}")
        return {}

    # Step 1: Fetch EC2 instances grouped by AMI IDs
    ami_info = fetch_ec2_instances(ec2_client)

    # Step 2: Concurrently fetch AMI details
    with ThreadPoolExecutor() as executor:
        future_to_ami_id = {
            executor.submit(fetch_ami_details, ec2_client, ami_id): ami_id
            for ami_id in ami_info.keys()
        }

        for future in as_completed(future_to_ami_id):
            ami_id = future_to_ami_id[future]
            try:
                ami_details = future.result()
                if ami_details:
                    ami_info[ami_id].update(ami_details)
            except Exception as e:
                print(f"Error processing AMI {ami_id}: {e}")

    # Output the result as JSON
    print(json.dumps(ami_info, indent=4))
    return ami_info


if __name__ == "__main__":
    get_ec2_instances_by_ami()
