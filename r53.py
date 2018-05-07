import boto3

route53_client = boto3.client('route53')
elb_client = boto3.client('elb')
ALL_ELBS=elb_client.describe_load_balancers()

def get_all_route53_zones():
    """returns all zones
    """
    output = []
    # pagination, so we can return more than 100 results
    # http://boto3.readthedocs.io/en/latest/reference/services/route53.html#Route53.Paginator.ListHostedZones
    list_hosted_zones_paginator = route53_client.get_paginator('list_hosted_zones')
    all_zones=list_hosted_zones_paginator.paginate().build_full_result()['HostedZones']

    for zone in all_zones:
        # return non-private zones only
        if zone['Config']['PrivateZone'] == False:
            output.append(zone)

    return output


def get_records_in_zone(zone_id):
    """returns all records in a zone
    """
    # pagination, so we can return more than 100 results
    # http://boto3.readthedocs.io/en/latest/reference/services/route53.html#Route53.Paginator.ListResourceRecordSets
    list_resource_record_sets_paginator = route53_client.get_paginator('list_resource_record_sets')
    output=list_resource_record_sets_paginator.paginate(
        HostedZoneId=zone_id
    ).build_full_result()

    return output['ResourceRecordSets']

def search_elb_by_fqdn(elb_fqdn):
    """
    Input a DNS name, return a matching ELB
    """
    output=None
    elb_dns_name = elb_fqdn.replace('dualstack.','').rstrip('.')
    for elb in ALL_ELBS['LoadBalancerDescriptions']:
        #print elb['LoadBalancerName'] + elb['DNSName']
        if elb['DNSName'] == str(elb_dns_name):
            output=elb['LoadBalancerName']
    return output

def format_record_output(record, zone):
    elb=None
    # if Alias record
    if record.has_key('AliasTarget'):
        # if the word "elb" exists in the dns name, search for ELB name
        if "elb" in record['AliasTarget']['DNSName']:
            elb=search_elb_by_fqdn(record['AliasTarget']['DNSName'])
        print("%s,%s,%s ALIAS,%s,60,%s" % (zone['Name'], record['Name'], record['Type'], record['AliasTarget']['DNSName'],elb))
    # for all other records
    else:
        for resource_record in record['ResourceRecords']:
            if "elb" in resource_record['Value']: 
                elb=search_elb_by_fqdn(resource_record['Value'])
            print("%s,%s,%s,%s,%s,%s" % (zone['Name'], record['Name'], record['Type'], resource_record['Value'], record['TTL'],elb))

def main():
    """Gets all zones
    prints csv header
    then gets all records in the zone
    takes into account the "specialness" of ALIAS records
    formatting specifically for CSV
    """
    all_zones = get_all_route53_zones()

    print("Route53Zone,Name,Type,Value,TTL,ELB")
    for zone in all_zones:
        records=get_records_in_zone(zone['Id'])
        for record in records:
            format_record_output(record, zone)

if __name__ == "__main__":
    main()