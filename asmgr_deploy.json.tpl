
{
  "apiVersion": "extensions/v1beta1",
  "kind": "Deployment",
  "metadata": {
    "name": "asmgr-SEQID"
  },
  "spec": {
    "replicas": REPLICA_NUM,
    "template": {
      "metadata": {
        "labels": {
          "app": "asmgr-SEQID"
        }
      },
      "spec": {
        "imagePullSecrets": [ { "name": "myregistrykey"} ],
        "containers": [
          {
            "name": "asmgr-SEQID",
            "image": "<image name>",
            "command": ["/bin/bash", "-c", "/opt/start_mgr.sh"],
            "env": [
              {
                "name": "POD_NAMESPACE",
                "valueFrom": {
                  "fieldRef": {
                    "fieldPath": "metadata.namespace"
                  }
                }
              }

            ],
            "resources": {
                  "limits": {
                         "cpu": "CPU",
                         "memory": "MEM"
                   },
                  "requests": {
                         "cpu": "CPU",
                         "memory": "MEM"
                   }
             }

          }
        ]

      }
    }
  }
}




