{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "impala-SEQID"
  },
  "spec": {
    "type" : "NodePort",
    "ports": [
      {
        "port": 21050,
        "targetPort":21050 ,
        "name": "impala"
      }
    ],
    "selector": {
      "app": "impala-SEQID"
    }
  }
}





