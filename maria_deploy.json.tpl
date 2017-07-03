
{
  "apiVersion": "extensions/v1beta1",
  "kind": "Deployment",
  "metadata": {
    "name": "maria-SEQID"
  },
  "spec": {
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "app": "maria-SEQID"
        }
      },
      "spec": {

        "containers": [
          {
            "name": "maria",
            "image": "mariadb",
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
                "name": "MYSQL_ROOT_PASSWORD",
                "value": "password"
              },
	      {
                "name": "MYSQL_DATABASE",
                "value": "sample"
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




