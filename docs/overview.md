# Project Overview

## Components

|Component|Description|
|-----|-----|
|**Model**|Model trained and built with **R Code** using **R Studio**. You can prepare the data, wrangle it, modify, visualise and run stats. There are many algorithms to choose from and many ways to parameterise your **AI training process**. You can also set criteria which model to choose for you final published API as well as ways to test accuracy of you chosen model.|
|**Api**|HTTP endpoint for your **trained AI model**. This project gives you an easy way to package your trained model (RDS file) and expose it via HTTP endpoint so that all you need to do from your client applications is to make an **API call** to the endpoint.|
|**Webapp**|Front end webapp for the **ai-titanic R Model**. To accompany this project, you can run an interactive website where you can pass different inputs (gender, class, siblings, etc.) to the AI model and get your **Titanic survival outcome** back.|

## Folders

|Folder|Description|
|-----|-----|
|**.cicd**|**ado**: Azure DevOps Build Yaml<br />**aks**: AKS Deployment<br />**compose**: Docker Compose Yaml<br />**docker**: Dockerfiles<br />**eks**: EKS Deployment<br />**gke**: GKE Deployment<br />**helm**: Helm Chart Yaml<br />**jekyll**: Jekyll Files<br />**kubernetes**: Kubernetes Yaml<br />|
|**docs**|Solution documentation files, refer to **Documentation** section on the home page.|
|**run**|**run-api.sh**: run Api locally<br />**run-rstudio.sh**: run R Studio locally<br />**run-webapp.sh**: run Webapp locally|
|**src**|**model**: R Code source code<br />**webapp**: ASPNET C# Web application source code|