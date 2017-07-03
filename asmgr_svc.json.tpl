{
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": "asmgr-SEQID"

  },
  "spec": {
    "sessionAffinity" : "ClientIP",
    "type" : "NodePort",
    "ports": [
      {
        "port": 8082,
        "targetPort": 8082,
        "name": "sessionmgr"
      }
    ],
    "selector": {
      "app": "asmgr-SEQID"
    }
  }
}





