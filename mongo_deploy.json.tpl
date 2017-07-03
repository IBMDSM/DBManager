
{
  "apiVersion": "extensions/v1beta1",
  "kind": "Deployment",
  "metadata": {
    "name": "mongo-SEQID"
  },
  "spec": {
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "app": "mongo-SEQID"
        }
      },
      "spec": {

        "containers": [
          {
            "name": "mongo",
            "image": "mongo",
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
                "name": "POSTGRES_PASSWORD",
                "value": "password"
              }
            ],
            "resources": {
                  "limits": {
                         "cpu": "1",
                         "memory": "2Gi"
                   },
                  "requests": {
                         "cpu": "1",
                         "memory": "2Gi"
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




