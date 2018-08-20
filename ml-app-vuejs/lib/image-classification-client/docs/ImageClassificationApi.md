# ImageClassification.ImageClassificationApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cancelAndDeleteBatchExecution**](ImageClassificationApi.md#cancelAndDeleteBatchExecution) | **DELETE** /api/ImageClassification/1.0.0/batch/{executionId} | Cancels and deletes all batch executions for ImageClassification.
[**getBatchExecutionFile**](ImageClassificationApi.md#getBatchExecutionFile) | **GET** /api/ImageClassification/1.0.0/batch/{executionId}/{index}/files/{fileName} | Gets a specific file from an execution in ImageClassification.
[**getBatchExecutionFiles**](ImageClassificationApi.md#getBatchExecutionFiles) | **GET** /api/ImageClassification/1.0.0/batch/{executionId}/{index}/files | Gets all files from an individual execution in ImageClassification.
[**getBatchExecutionStatus**](ImageClassificationApi.md#getBatchExecutionStatus) | **GET** /api/ImageClassification/1.0.0/batch/{executionId} | Gets all batch executions for ImageClassification.
[**getBatchExecutions**](ImageClassificationApi.md#getBatchExecutions) | **GET** /api/ImageClassification/1.0.0/batch | Gets all batch executions for ImageClassification.
[**runInferenceOnImage**](ImageClassificationApi.md#runInferenceOnImage) | **POST** /api/ImageClassification/1.0.0 | 
[**startBatchExecution**](ImageClassificationApi.md#startBatchExecution) | **POST** /api/ImageClassification/1.0.0/batch | 


<a name="cancelAndDeleteBatchExecution"></a>
# **cancelAndDeleteBatchExecution**
> [&#39;String&#39;] cancelAndDeleteBatchExecution(executionId)

Cancels and deletes all batch executions for ImageClassification.

### Example
```javascript
var ImageClassification = require('image_classification');
var defaultClient = ImageClassification.ApiClient.instance;

// Configure API key authorization: Bearer
var Bearer = defaultClient.authentications['Bearer'];
Bearer.apiKey = 'YOUR API KEY';
// Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
//Bearer.apiKeyPrefix = 'Token';

var apiInstance = new ImageClassification.ImageClassificationApi();

var executionId = "executionId_example"; // String | Execution id of the execution.


var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.cancelAndDeleteBatchExecution(executionId, callback);
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **executionId** | **String**| Execution id of the execution. | 

### Return type

**[&#39;String&#39;]**

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getBatchExecutionFile"></a>
# **getBatchExecutionFile**
> File getBatchExecutionFile(executionId, index, fileName)

Gets a specific file from an execution in ImageClassification.

### Example
```javascript
var ImageClassification = require('image_classification');
var defaultClient = ImageClassification.ApiClient.instance;

// Configure API key authorization: Bearer
var Bearer = defaultClient.authentications['Bearer'];
Bearer.apiKey = 'YOUR API KEY';
// Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
//Bearer.apiKeyPrefix = 'Token';

var apiInstance = new ImageClassification.ImageClassificationApi();

var executionId = "executionId_example"; // String | Execution id of the execution

var index = 56; // Number | Index of the execution in the batch.

var fileName = "fileName_example"; // String | Name of the file to be returned.


var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.getBatchExecutionFile(executionId, index, fileName, callback);
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **executionId** | **String**| Execution id of the execution | 
 **index** | **Number**| Index of the execution in the batch. | 
 **fileName** | **String**| Name of the file to be returned. | 

### Return type

**File**

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getBatchExecutionFiles"></a>
# **getBatchExecutionFiles**
> [&#39;String&#39;] getBatchExecutionFiles(executionId, index)

Gets all files from an individual execution in ImageClassification.

### Example
```javascript
var ImageClassification = require('image_classification');
var defaultClient = ImageClassification.ApiClient.instance;

// Configure API key authorization: Bearer
var Bearer = defaultClient.authentications['Bearer'];
Bearer.apiKey = 'YOUR API KEY';
// Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
//Bearer.apiKeyPrefix = 'Token';

var apiInstance = new ImageClassification.ImageClassificationApi();

var executionId = "executionId_example"; // String | Execution id of the execution

var index = 56; // Number | Index of the execution in the batch.


var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.getBatchExecutionFiles(executionId, index, callback);
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **executionId** | **String**| Execution id of the execution | 
 **index** | **Number**| Index of the execution in the batch. | 

### Return type

**[&#39;String&#39;]**

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getBatchExecutionStatus"></a>
# **getBatchExecutionStatus**
> BatchWebServiceResult getBatchExecutionStatus(executionId, opts)

Gets all batch executions for ImageClassification.

### Example
```javascript
var ImageClassification = require('image_classification');
var defaultClient = ImageClassification.ApiClient.instance;

// Configure API key authorization: Bearer
var Bearer = defaultClient.authentications['Bearer'];
Bearer.apiKey = 'YOUR API KEY';
// Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
//Bearer.apiKeyPrefix = 'Token';

var apiInstance = new ImageClassification.ImageClassificationApi();

var executionId = "executionId_example"; // String | Execution id of the execution

var opts = { 
  'showPartialResults': true // Boolean | Returns the already processed results of the batch execution even if it hasn't been fully completed.
};

var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.getBatchExecutionStatus(executionId, opts, callback);
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **executionId** | **String**| Execution id of the execution | 
 **showPartialResults** | **Boolean**| Returns the already processed results of the batch execution even if it hasn&#39;t been fully completed. | [optional] 

### Return type

[**BatchWebServiceResult**](BatchWebServiceResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getBatchExecutions"></a>
# **getBatchExecutions**
> [&#39;String&#39;] getBatchExecutions()

Gets all batch executions for ImageClassification.

### Example
```javascript
var ImageClassification = require('image_classification');
var defaultClient = ImageClassification.ApiClient.instance;

// Configure API key authorization: Bearer
var Bearer = defaultClient.authentications['Bearer'];
Bearer.apiKey = 'YOUR API KEY';
// Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
//Bearer.apiKeyPrefix = 'Token';

var apiInstance = new ImageClassification.ImageClassificationApi();

var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.getBatchExecutions(callback);
```

### Parameters
This endpoint does not need any parameter.

### Return type

**[&#39;String&#39;]**

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="runInferenceOnImage"></a>
# **runInferenceOnImage**
> WebServiceResult runInferenceOnImage(webServiceParameters)



Consume the ImageClassification web service.

### Example
```javascript
var ImageClassification = require('image_classification');
var defaultClient = ImageClassification.ApiClient.instance;

// Configure API key authorization: Bearer
var Bearer = defaultClient.authentications['Bearer'];
Bearer.apiKey = 'YOUR API KEY';
// Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
//Bearer.apiKeyPrefix = 'Token';

var apiInstance = new ImageClassification.ImageClassificationApi();

var webServiceParameters = new ImageClassification.InputParameters(); // InputParameters | Input parameters to the web service.


var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.runInferenceOnImage(webServiceParameters, callback);
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **webServiceParameters** | [**InputParameters**](InputParameters.md)| Input parameters to the web service. | 

### Return type

[**WebServiceResult**](WebServiceResult.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="startBatchExecution"></a>
# **startBatchExecution**
> StartBatchExecutionResponse startBatchExecution(batchWebServiceParameters, opts)



Consume the ImageClassification web service asynchronously.

### Example
```javascript
var ImageClassification = require('image_classification');
var defaultClient = ImageClassification.ApiClient.instance;

// Configure API key authorization: Bearer
var Bearer = defaultClient.authentications['Bearer'];
Bearer.apiKey = 'YOUR API KEY';
// Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
//Bearer.apiKeyPrefix = 'Token';

var apiInstance = new ImageClassification.ImageClassificationApi();

var batchWebServiceParameters = [new ImageClassification.InputParameters()]; // [InputParameters] | Input parameters to the web service.

var opts = { 
  'parallelCount': 56 // Number | Number of threads used to process entries in the batch. Default value is 10. Please make sure not to use too high of a number because it might negatively impact performance.
};

var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.startBatchExecution(batchWebServiceParameters, opts, callback);
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **batchWebServiceParameters** | [**[InputParameters]**](InputParameters.md)| Input parameters to the web service. | 
 **parallelCount** | **Number**| Number of threads used to process entries in the batch. Default value is 10. Please make sure not to use too high of a number because it might negatively impact performance. | [optional] 

### Return type

[**StartBatchExecutionResponse**](StartBatchExecutionResponse.md)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

