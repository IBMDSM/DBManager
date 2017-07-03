{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "maria-SEQID"
  },
  "spec": {
    "type" : "NodePort",
    "ports": [
      {
        "port": 3306,
        "targetPort":3306 ,
        "name": "maria"
      }
    ],
    "selector": {
      "app": "maria-SEQID"
    }
  }
}





