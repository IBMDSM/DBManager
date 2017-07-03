#!/bin/bash
if [ $# -lt 3 ] ; then
 echo "Usage: $0  <namespace> <servicename> <seq-id>"
 exit
fi
namespace=$1
seqid=$3
svname=$2

podip=`kubectl get pod -o wide --namespace=${namespace} |grep impala-${seqid}| awk '{print $6}'` 
podname=`kubectl get pod -o wide --namespace=${namespace} |grep impala-${seqid}| awk '{print $1}'`


