#!/bin/bash
# ver 0.1
usage() { echo "Usage: $0 [-s servername] [-u api_user] [-p api_password] [-z zabbix_server]" 1>&2; exit 1; }

while getopts ":s:u:p:z:" opt; do
  case "${opt}" in
    s)
      foreman_server=$OPTARG
      echo $foreman_server
      ;;
    u)
      api_user=$OPTARG
      echo $api_user
      ;;
    p)
      api_password=$OPTARG
      echo $api_password
      ;;
    z)
      zabbix_server=$OPTARG
      echo $zabbix_server
      ;;

    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
  esac
done

if [ -z $foreman_server ]; then
  foreman_server="foreman.domain.com"
fi

if [ -z $api_user ]; then
  api_user="api_user"
fi

if [ -z $api_password ]; then
api_password="api_password"
fi

if [ -z $zabbix_server ]; then
zabbix_server="zabbix.domain.com"
fi

sender_path="zabbix_sender"

if [ ! `which jq` ];
 then
 echo "JQ not found, please install"
 exit 1
fi

 query=`curl https://$foreman_server/api/dashboard --insecure -s -u $api_user:$api_password`
 total_hosts=`echo $query|jq ."total_hosts"`
 bad_hosts=`echo $query|jq ."bad_hosts_enabled"`
 ok_hosts=`echo $query|jq ."ok_hosts_enabled"`
 outofsync_hosts=`echo $query|jq ."out_of_sync_hosts_enabled"`
 activehosts=`echo $query|jq ."active_hosts_ok_enabled"`

if [ ! `which zabbix_sender` ];
 then
 echo "zabbix_sender not found, echoing only"
 echo $total_hosts $bad_hosts $ok_hosts $outofsync_hosts $activehosts
 exit 1
fi

 $sender_path -z $zabbix_server -p 10051 -s "$foreman_server" -k total_hosts -o $total_hosts
 $sender_path -z $zabbix_server -p 10051 -s "$foreman_server" -k bad_hosts -o $bad_hosts
 $sender_path -z $zabbix_server -p 10051 -s "$foreman_server" -k ok_hosts -o $ok_hosts
 $sender_path -z $zabbix_server -p 10051 -s "$foreman_server" -k outofsync_hosts -o $outofsync_hosts
 $sender_path -z $zabbix_server -p 10051 -s "$foreman_server" -k active_hosts -o $activehosts
