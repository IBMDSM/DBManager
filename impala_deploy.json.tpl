
{
  "apiVersion": "extensions/v1beta1",
  "kind": "Deployment",
  "metadata": {
    "name": "impala-SEQID"
  },
  "spec": {
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "app": "impala-SEQID"
        }
      },
      "spec": {
        "imagePullSecrets": [ { "name": "myregistrykey"} ],
        "containers": [
          {
            "name": "impala",
            "image": ".../impala:v1.0",
            "env": [
              {
                "name": "POD_NAMESPACE",
                "valueFrom": {
                  "fieldRef": {
                    "fieldPath": "metadata.namespace"
                  }
                }
              },
              {
                "name": "IMPALA_PASSWORD",
                "value": "password"
              }
            ],
            "resources": {
                  "limits": {
                         "cpu": "2",
                         "memory": "4Gi"
                   },
                  "requests": {
                         "cpu": "2",
                         "memory": "4Gi"
                   }
             },

            "securityContext": {
              "privileged": true
            }

          }

        ]
      }
    }
  }
}




