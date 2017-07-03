
{
  "apiVersion": "apps/v1beta1",
  "kind": "StatefulSet",
  "metadata": {
    "name": "greenplum-SEQID-m"
  },
  "spec": {
    "serviceName": "greenplum",
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "app": "greenplum-SEQID-m"
        }
      },
      "spec": {
        "imagePullSecrets": [ { "name": "myregistrykey"} ],
        "containers": [
          {
            "name": "greenplum-m",
            "image": ".../greenplum:1.2",
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
                "name": "GREENPLUM_PASSWORD",
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


{
  "apiVersion": "apps/v1beta1",
  "kind": "StatefulSet",
  "metadata": {
    "name": "greenplum-SEQID-s"
  },
  "spec": {
    "serviceName": "greenplum",
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "app": "greenplum-SEQID-s"
        }
      },
      "spec": {
        "imagePullSecrets": [ { "name": "myregistrykey"} ],
        "containers": [
          {
            "name": "greenplum-s",
            "image": ".../greenplum:1.2",
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
                "name": "GREENPLUM_PASSWORD",
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




