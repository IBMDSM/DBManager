{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "greenplum-SEQID"
  },
  "spec": {
    "type" : "NodePort",
    "ports": [
      {
        "port": 5432,
        "targetPort":5432,
        "name": "greenplum"
      }
    ],
    "selector": {
      "app": "greenplum-SEQID-m"
    }
  }
}





