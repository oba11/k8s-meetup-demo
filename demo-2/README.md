# Demo2

* Install nginx-ingress controller

```
kubectl create -f https://raw.githubusercontent.com/kubernetes/ingress/master/examples/deployment/nginx/default-backend.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes/ingress/master/examples/deployment/nginx/nginx-ingress-controller.yaml
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
kubectl apply -f tea-svc.yml
kubectl apply -f coffee.yml
kubectl apply -f tea.yml
kubectl create -f python-app-ingress-v2.yml
```

* Lets scale our apps

```
kubectl scale deployment/coffee --replicas=3
kubectl scale deployment/tea --replicas=3
```
