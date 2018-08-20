# ml-app-vuejs

> Machine Learning VueJS App

This project shows how to consume a Machine Learning Service from a javascript app, using an Tensorflow image classification model as an example.

## Project Template
This project was created from
``` bash
vue init webpack ml-app-vuejs
```
## Build Setup

``` bash
# install dependencies
npm install

# link Swagger generated client package image-classification
npm link lib/image-classification-client

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build

# build for production and view the bundle analyzer report
npm run build --report
```

For a detailed explanation on how things work, check out the [guide](http://vuejs-templates.github.io/webpack/) and [docs for vue-loader](http://vuejs.github.io/vue-loader).

## Implementation
After the ImageClassification ML model has been published to ML Server as a service, download the Swagger file in [Python using azureml-model-management-sdk](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/python/quickstart-application-integration-with-swagger#get-the-swagger-file), or in [R using the mrsdeploy package](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/quickstart-publish-r-web-service#d-get-the-swagger-based-json-file).

Then go to https://editor.swagger.io, upload the `swagger.json` file and choose to generate a javascript client. Extract the generated zip file, and place the folder under `lib` with a meaningful name, e.g `image-classification-client`. Then link in the package and install its dependency `superagent`:
 ```bash
 npm link lib/image-classification-client
 npm install --save superagent
```

Also, we need to disable AMD loader through `webpack.base.conf.js`:
```javascript
module: {
  rules: [
    {
      parser: {
        amd: false
      }
    }
  ]
}
```
See `Webpack Configuration` in [README.md](lib/image-classification-client/README.md) of the Swagger generated client for more details.

After that we can point to the Machine Learning service in `proxyTable` in `config/index.js` and use the generated client package `image_classification` in our javascript code.

The main compoment of the app is `ImageClassification.vue`, in which we login to acquire an access token and use it to make HTTP requests to the ImageClassification service, which wass published and exposed as a REST API endpoint.

In this example, all API requests are sent to the some domain where the web app is hosted and then proxied (see `proxyTable` in `config/index.js`) to Machine Learning service. In production, API requests can be re-routed to the API servers using reverse proxy. You can also [enable CORS to allow cross-domain API requests](https://docs.microsoft.com/en-us/machine-learning-server/operationalize/configure-cors) from the web app in the browser directly.