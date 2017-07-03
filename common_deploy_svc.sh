#!/bin/bash

if [ $# -lt 3 ] || [ $# -gt 6 ]; then
 echo "Usage: $0  <namespace> <servicename> <seq-id> <user> <passwd>"
 exit
fi
namespace=$1
seqid=$3
svname=$2
user=$4
passwd=$5
basepath=$(cd `dirname $0`; pwd)
svctemplate="${basepath}/${svname}_svc.json.tpl"
svcfile="${basepath}/instances/${namespace}/${svname}_svc-${seqid}.json"
postsh="${basepath}/${svname}_post_deploy_svc.sh"

echo "===> Create namespace ..."
kubectl create ns ${namespace}
mkdir -p ${basepath}/instances/${namespace}
cpcp=`which cp`

rm -rf $svcfile
$cpcp $svctemplate $svcfile
sed -i "s/NAMESPACE/${namespace}/g" $svcfile 
sed -i "s/SEQID/${seqid}/g" $svcfile
echo "===> Create service ..."
err=`kubectl create -f $svcfile --namespace=${namespace} 2>&1`
if [ $? -ne 0 ];then
   echo "Failed to create svc: $err"
   exit 1
fi
node_num=`kubectl get nodes|grep Ready |grep -v master  |wc -l`
r_node=`expr $RANDOM % ${node_num} + 1`
nodeip=`kubectl get nodes |grep Ready|grep -v master |awk '{print $1}'|head -n ${r_node} | tail -n 1`
while true; do

  portr=`kubectl describe svc/${svname}-${seqid} --namespace=${namespace}|grep "NodePort"|grep ${svname} |awk '{print $3}'|sed  "s/\/TCP//"`
  if [ $? -eq 0 ] && [ -n $portr ];then
    break
  else
    sleep 1
  fi
 
done
#proto=`grep ${svname} ${basepath}/protocol.conf|awk '{print $2}'|sed "s/<USER>/${user}/g" | sed "s/<PASSWD>/${passwd}/g"|sed "s/<IP>/${nodeip}/g" | sed "s/<PORT>/${portr}/g"`
if [ -z $nodeip ] || [ -z $portr ];then
  exit 1
else
  proto=`grep ${svname} ${basepath}/protocol.conf|awk '{print $2}'|sed "s/<USER>/${user}/g" | sed "s/<PASSWD>/${passwd}/g"|sed "s/<IP>/${nodeip}/g" | sed "s/<PORT>/${portr}/g"`
  echo $proto
  exit 0
fi
if [ -f $postsh ];then
  $postsh
  exit 0
fi

