{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "mysql-SEQID"
  },
  "spec": {
    "type" : "NodePort",
    "ports": [
      {
        "port": 3306,
        "targetPort":3306 ,
        "name": "mysql"
      }
    ],
    "selector": {
      "app": "mysql-SEQID"
    }
  }
}





