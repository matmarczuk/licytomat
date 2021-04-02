# Project overview
Licytomat is a project of webapp for conducting charity auctions. 
App is developed as cloud native and using cloud best practices. The aim is to deliver fully functional service using terraform (IaC).

# AWS cloud infrastructure scheme
App is using s3 static content website written in Vue.js framework. Communication with backend is provided with API Gateway and Serverless Lambdas 
which make queries to NoSQL DynamoDB database.

![licytomat (1)](https://user-images.githubusercontent.com/26739110/113406038-1707a600-93ab-11eb-8af7-1c12f016b633.png)
