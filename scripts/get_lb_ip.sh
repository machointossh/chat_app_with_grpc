#!/bin/sh

set -eu

ip=`kubectl get svc | awk '
{
  if ($2 == "LoadBalancer") {
    print $4;
  }
}
'
`
# $ kubectl get svc
# [stdout]
# NAME                  TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                        AGE
# chat-server-service   ClusterIP      10.106.74.122   <none>         10000/TCP,10001/TCP            25m
# lb-service            LoadBalancer   10.107.70.75    10.107.70.75   80:31793/TCP,10001:31858/TCP   25m

if [ ip == "" ]; then
    echo "No LoadBalancer exists."
    echo "To learn more, you should run the following command."
    echo "$ kubectl get svc"
    exit 1
else
    echo $ip
fi
