#!/bin/bash

if [ $# -lt 3 ] || [ $# -gt 6 ]; then
 echo "Usage: $0  <namespace> <servicename> <seq-id> <timeout>"
 exit
fi
namespace=$1
seqid=$3
svname=$2

basepath=$(cd `dirname $0`; pwd)
svctemplate="${basepath}/${svname}_svc.json.tpl"
svcfile="${basepath}/instances/${namespace}/${svname}_svc-${seqid}.json"


echo "===> Delete service ..."
kubectl delete svc ${svname}-${seqid} --namespace=${namespace}

i=1
ready="ds"
while [[ -n "$ready"  && $i -lt 10  ]]
do
 sleep 1
  ready=`kubectl get svc --namespace=${namespace} |grep ${svname}-${seqid}`
  i=$(($i+1))
done
if [ $i -gt 9 ];then
  echo "Timeout"
else
 echo "Finished"
fi
#call post shell
if [ -f $postsh ];then
  echo "call $postsh"
  $postsh 
  exit 0
fi

