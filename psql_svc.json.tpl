{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "psql-SEQID"
  },
  "spec": {
    "type" : "NodePort",
    "ports": [
      {
        "port": 5432,
        "targetPort":5432 ,
        "name": "psql"
      }
    ],
    "selector": {
      "app": "psql-SEQID"
    }
  }
}





