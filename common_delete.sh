#!/bin/bash

if [ $# -lt 4 ] || [ $# -gt 6 ]; then
 echo "Usage: $0  <namespace> <servicename> <seq-id> <timeout> "
 exit
fi
namespace=$1
seqid=$3
svname=$2
tout=$4

basepath=$(cd `dirname $0`; pwd)
deployfile="${basepath}/instances/${namespace}/${svname}_deploy-${seqid}.json"
deploytmplate="${basepath}/${svname}_deploy.json.tpl"
pvfile="${basepath}/instances/${namespace}/${svname}_pv-${seqid}.yaml"
pvtemplate="${basepath}/${svname}_pv.json.tpl"
#mkdir -p ./instances/${namespace}
#cpcp=`which cp`
#$cpcp -f $deploytmplate $deployfile

#echo "===> delete config pv ..."
#$cpcp -f $pvtemplate $pvfile
#kubectl delete -f $pvfile  --namespace=${namespace}
echo "===> Delete deployment ..."
#kubectl delete deployment/${svname}-${seqid} --namespace=${namespace}
#kubectl delete statefulset/${svname}-${seqid} --namespace=${namespace}
if [ -f $deployfile ]; then
  kubectl delete -f $deployfile --namespace=${namespace}
else
  kubectl delete deployment/${svname}-${seqid} --namespace=${namespace}
  kubectl delete statefulset/${svname}-${seqid} --namespace=${namespace}
fi
i=1
ready="ds"
while [[ -n "$ready" ]]
do
 sleep 1
  ready=`kubectl get deployment --namespace=${namespace} |grep ${svname}-${seqid}`
  i=$(($i+1))
  if [ $i -gt $4 ];then
    break
  fi
done

if [ $i -gt $4 ];then
  echo "Timeout"
else
  echo "Finished"
fi

i=1
ready1="dss"
while [[ -n "$ready1" ]]
do
 sleep 1
  ready1=`kubectl get statefulset --namespace=${namespace} |grep ${svname}-${seqid}`
  i=$(($i+1))
  if [ $i -gt $4 ];then
    break
  fi
done
i=1
ready2="dss"
while [[ -n "$ready1" ]]
do
 sleep 1
  ready2=`kubectl get pod --namespace=${namespace} |grep ${svname}-${seqid}`
  i=$(($i+1))
  if [ $i -gt $4 ];then
    break
  fi
done

if [ $i -gt $4 ];then
  echo "Timeout"
else
  echo "Finished"
fi
