{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "mongo-SEQID"
  },
  "spec": {
    "type" : "NodePort",
    "ports": [
      {
        "port": 27017,
        "targetPort":27017 ,
        "name": "mongo"
      }
    ],
    "selector": {
      "app": "mongo-SEQID"
    }
  }
}





