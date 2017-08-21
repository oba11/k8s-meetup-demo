#!/usr/bin/env python

__author__ = 'oba'

import uuid
import boto3
import fire

client = boto3.client('route53', region_name='us-east-1')

def create_zone(zone):
  print('creating zone: {}'.format(zone))
  ref = str(uuid.uuid4().hex)
  resp = client.create_hosted_zone(
    Name=zone,
    CallerReference=ref
  )
  if 200 <= resp['ResponseMetadata']['HTTPStatusCode'] <= 204:
    print('zone was successfully created')
    return resp['DelegationSet']['NameServers']
  else:
    print('Error: creating zone: {}'.format(zone))
    return False

def get_zone_id(zone):
  response = client.list_hosted_zones_by_name(
    DNSName=zone
  )
  zone_id = response['HostedZones'][0]['Id']
  print('zone id for zone: {} is {}'.format(zone,zone_id))
  return zone_id

def get_record(record, zone):
  zone_id = get_zone_id(zone=zone)
  resp = client.list_resource_record_sets(
    HostedZoneId=zone_id,
    StartRecordName=record,
    StartRecordType='NS'
  )
  if 200 <= resp['ResponseMetadata']['HTTPStatusCode'] <= 204:
    record = '{}.'.format(record)
    try:
      records = list(filter(lambda x: x['Name'] == record, resp['ResourceRecordSets']))[0]['ResourceRecords']
      result = [ r['Value'] for r in records ]
      return result
    except IndexError as e:
      return False

def update_ns_record(record, values, zone, action='UPSERT', ttl=10):
  zone_id = get_zone_id(zone=zone)

  if isinstance(values, str):
    values = [values]
  print('updating {} NS record to {}'.format(record, values))
  resp = client.change_resource_record_sets(
    HostedZoneId=zone_id,
    ChangeBatch={
      'Changes': [
        {
          'Action': action,
          'ResourceRecordSet': {
            'Name': record,
            'Type': 'NS',
            'TTL': ttl,
            'ResourceRecords': [{'Value': v} for v in values]
          }
        }
      ]
    }
  )
  if 200 <= resp['ResponseMetadata']['HTTPStatusCode'] <= 204:
    print ('Successfully updated {} NS record'.format(record))
    return True
  return False

def delete_zone(zone):
  zone_id = get_zone_id(zone=zone)
  print('deleting zone: {}'.format(zone))
  resp = client.delete_hosted_zone(
    Id=zone_id
  )
  if 200 <= resp['ResponseMetadata']['HTTPStatusCode'] <= 204:
    print('zone was successfully deleted')
    return True
  else:
    print('Error: deleting zone: {}'.format(zone))
    return False

def update_zone(action,zone,parent_zone):
  if action == 'create':
    values = create_zone(zone=zone)
    update_ns_record(record=zone, values=values, zone=parent_zone)
  elif action == 'destroy':
    print('cleaning zone: {}'.format(zone))
    answer = input("Do you want to destroy the domain: ")
    if answer in ['y','yes']:
      delete_zone(zone=zone)
      values = get_record(record=zone, zone=parent_zone)
      if values:
        update_ns_record(record=zone, values=values, zone=parent_zone, action='DELETE')

def main():
  fire.Fire(update_zone)

if __name__ == '__main__':
  main()
