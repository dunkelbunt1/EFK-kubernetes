# EFK-kubernetes
Elastic Search(3 master node cluster), Filebeat, Kibana



# EFK-minikube
Non production setup of the EFK stack on minikube.

**Make sure you have a pv**
```
kubectl get pv
```
If not please run the follwoing command
```
kubectl apply -f pv.yaml
```




1. **Create the namespace** 
```
kubectl apply -f namespace.yaml
```
2. **Create the elasticsearch service** 
```
kubectl apply -f elasticsearch-service.yaml 
```
3. **Create the master config for elasticsearch** 
```
kubectl apply -f elasticsearch-config.yaml
```
4. **Crate a stateful set for elasticserach** 
```
kubectl create -f elasticsearch-stateful.yaml
```
5. **Create a secret containing the keystore** 
```
kubectl exec -it es-cluster-0 sh
#Inside the container add your secret and access key to the ES keyring 
echo ACCESS_KEY| bin/elasticsearch-keystore add --stdin --force s3.client.default.access_key 
echo SECRET_KEY | bin/elasticsearch-keystore add --stdin --force s3.client.default.secret_key
#Copy the binary to your computer
kubectl cp NAMESPACE/POD:/usr/share/elasticsearch/config/elasticsearch.keystore .
#Create a secret containing the binary
kubectl create secret generic eskeystore --from-file=elasticsearch.keystore 
```
6. **CCreate credentials which will be used for Filebeat and ES** 
```
kubectl apply -f kibana-secret.yaml
```
7. **Create Kibana and a headless service for it** 
```
kubectl apply -f kibana.yaml 
kubectl apply -f kibana-service.yaml 
```
8. **Configure Filebeat as a Deamonset**
```
kubectl apply -f filebeat-svaccount-rb.yaml
kubectl apply -f filebeat-configmaps.yaml
kubectl apply -f filebeat-ds.yaml 
```
9. **Acess kibana**
Oberserve the name of your Kibana pod:

```
kubectl get pods --namespace=efk-log
NAME                      READY   STATUS    RESTARTS   AGE
es-cluster-0              1/1     Running   0          33m
es-cluster-1              1/1     Running   0          31m
es-cluster-2              1/1     Running   0          30m
filebeat-29rc9            1/1     Running   4          31m
kibana-6c4f8fc66f-ccm9s   1/1     Running   1          32m
```
and configure port forwarding.
```
kubectl port-forward kibana-6c4f8fc66f-ccm9s  5601:5601 --namespace=efk-log
```
visit the following web URL:
```
http://localhost:5601
```



**Version:** 

kubectl version: 1.18.x, minikube version: v1.9.x