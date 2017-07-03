#!/bin/bash
/start-hdfs.sh
/start-impala.sh
while true
do
  line=`netstat -apln|grep "0.0.0.0:21000" |grep LISTEN`
  if [ -n "$line" ];then
     break
  fi
  sleep 1
done
while true
do
  line=`netstat -apln|grep "0.0.0.0:24000" |grep LISTEN`
  if [ -n "$line" ];then
     break
  fi
  sleep 1
done
while true
do
  line=`netstat -apln|grep "0.0.0.0:23020" |grep LISTEN`
  if [ -n "$line" ];then
     break
  fi
  sleep 1
done
while true
do
  line=`netstat -apln|grep "0.0.0.0:25010" |grep LISTEN`
  if [ -n "$line" ];then
     break
  fi
  sleep 1
done
while true
do
  line=`netstat -apln|grep "0.0.0.0:25020" |grep LISTEN`
  if [ -n "$line" ];then
     break
  fi
  sleep 1
done
while true
do
  line=`netstat -apln|grep "0.0.0.0:25000" |grep LISTEN`
  if [ -n "$line" ];then
     break
  fi
  sleep 1
done
while true
do
  line=`netstat -apln|grep "0.0.0.0:21050" |grep LISTEN`
  if [ -n "$line" ];then
     break
  fi
  sleep 1
done
while true
do
  line=`impala-shell -i 127.0.0.1 -q 'create table if not exists test ( test STRING ); insert into test values ("test")'`
  if [[ "$line"x =~ "ERROR" ]];then
     sleep 1
  else
     break
  fi
done

echo "Impala is Started, Enjoy!"
while true
do
	sleep 30
	echo "Impala is still up"
done
