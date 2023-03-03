# Deploy WeatherApp to AKS using ACR

![react-weather-aks-acr-diagram drawio](https://user-images.githubusercontent.com/113396342/221478940-4180565c-1469-4edd-b7e5-1c38a5df5bc8.png)

## Steps

- Create Azure Container Registry (ACR) and Azure Kubernetes Services (AKS) via Terraform.
- Build Docker Image with Dockerfile.
```
docker build -t ycetindilweatherapp.azurecr.io/weatherapp:latest .
```
- Push the image to ACR registry.
```
az acr login --name ycetindilweatherapp
docker push ycetindilweatherapp.azurecr.io/weatherapp:latest
```
- Create Deployment and Service by using the yaml file.
```
az aks get-credentials --resource-group weatherapp-rg --name weatherapp-aks
kubectl get nodes
kubectl create -f weatherapp-deployment.yaml
kubectl get svc
```
- Connect to the app by visiting the external ip of the service.

### Note
Once Azure Kubernetes Cluster is created , Azure automatically creates another resource group starts with "MC" to put the components of the cluster in. But puts the Kubernetes Service itself inside the resource group that we created.

#

Developer of the App: <a href="https://github.com/hamzakoc/Wheather_App_React" target="_blank">Hamza KOC</a>
