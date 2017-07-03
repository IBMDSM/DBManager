# DBManager
Database Manager on K8s

```Bash
curl -v -X POST -d '{"SERVICEID":"psql","NAMESPACE":"<NS>","USERNAME":"admin","PASSWORD":"password","SERVICENS":"<SNS>","INSTANCEID":"<ID>"}' http://<asmgr ip>:<node port>/instance/create
```
