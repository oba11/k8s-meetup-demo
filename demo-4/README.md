# Demo 4

* Install nginx-ingress controller for AWS

```
kubectl create -f https://raw.githubusercontent.com/kubernetes/ingress/master/examples/aws/nginx/nginx-ingress-controller.yaml
```

* Create the python app

```
kubectl create -f python-app-svc.yml
kubectl create -f python-app.yml
kubectl create -f python-app-ingress-v1.yml
```

* Lets scale the python app to 2 replicas

```
kubectl scale deployment/python-app --replicas=2
```


* Lets add new paths to ingress

```
kubectl apply -f coffee-svc.yml
kubectl apply -f coffee.yml
kubectl apply -f python-app-ingress-v2.yml
```

* Lets scale our apps

```
kubectl scale deployment/coffee --replicas=2
```
