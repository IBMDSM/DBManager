#!/bin/bash

if [ $# -lt 4 ] || [ $# -gt 7 ]; then
 echo "Usage: $0  <namespace> <servicename> <seq-id> <timeout> [cpu] [mem] [replica number]"
 exit
fi
namespace=$1
seqid=$3
svname=$2
cpu=$5
mem_sz=$6
tout=$4
if [ $7"x" = "x" ]; then
   rep_num=1
else
   rep_num=$7
fi
basepath=$(cd `dirname $0`; pwd)
deployfile="${basepath}/instances/${namespace}/${svname}_deploy-${seqid}.json"
deploytmplate="${basepath}/${svname}_deploy.json.tpl"
pvfile="${basepath}/instances/${namespace}/${svname}_pv-${seqid}.yaml"
pvtemplate="${basepath}/${svname}_pv.json.tpl"
svctemplate="${basepath}/${svname}_svc.json.tpl"
svcfile="${basepath}/instances/${namespace}/${svname}_svc-${seqid}.json"
passwd=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16`
postsh="${basepath}/${svname}_post_deploy.sh"
echo "===> Create namespace ..."
kubectl create ns ${namespace}
kubectl create -f ${basepath}/secret.yaml --namespace=${namespace}
mkdir -p ${basepath}/instances/${namespace}
rm -rf $deployfile
cpcp=`which cp`
$cpcp -f $deploytmplate $deployfile

sed -i "s/SEQID/${seqid}/g" $deployfile
echo "===> Set replica number ..."
sed -i "s/REPLICA_NUM/$rep_num/g" $deployfile

xmxmem=${mem_sz//M/m}
xmxmem=${xmxmem//G/g}
mem=${mem_sz//m/M}
mem=${mem//g/G}
sed -i "s/XMXMEM/$xmxmem/g" $deployfile
sed -i "s/password/${passwd}/g" $deployfile
sed -i "s/CPU/$cpu/g" $deployfile
sed -i "s/MEM/$mem/g" $deployfile
#echo "===> create config pv ..."
#$cpcp -f $pvtemplate $pvfile
#sed -i "s/SEQID/${seqid}/g" $pvfile
#kubectl create -f $pvfile  --namespace=${namespace}
echo "===> Create deployment ..."
err=`kubectl create -f  $deployfile --namespace=${namespace} 2>&1`
if [ $? -ne 0 ];then
 echo "Failed: $err"
 exit 1
fi
i=1
while [[ -z "$ready"  ||  -z "$podip"  ||  $podip"x" = "<none>x"  ]]
do
 sleep 1
  podip=`kubectl get pod -o wide --namespace=${namespace} |grep ${svname}-${seqid}| awk '{print $6}' `
  ready=`kubectl describe pod ${svname}-${seqid} --namespace=${namespace} |grep -E "Started container|Running"`
  i=$(($i + 1 ))
  if [ $i -gt $tout ];then
     podip="Pod not ready until timeout"
     break
  fi
done

if [ $i -gt $tout ];then
  echo $podip
  exit 1
fi

#call post shell
if [ -f $postsh ];then
  $postsh ${namespace} ${svname} ${seqid}
fi
echo "${podip}"
echo "user ${passwd}"
exit 0

