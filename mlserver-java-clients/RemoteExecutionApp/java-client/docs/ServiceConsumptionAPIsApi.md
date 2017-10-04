# ServiceConsumptionAPIsApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getWebServiceSwagger**](ServiceConsumptionAPIsApi.md#getWebServiceSwagger) | **GET** /api/{name}/{version}/swagger.json | Get API Swagger


<a name="getWebServiceSwagger"></a>
# **getWebServiceSwagger**
> SwaggerJsonResponse getWebServiceSwagger(name, version)

Get API Swagger

Returns a _Swagger_ &#x60;swagger.json&#x60; describing a published web service&#39;s API capabilities.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServiceConsumptionAPIsApi;


ServiceConsumptionAPIsApi apiInstance = new ServiceConsumptionAPIsApi();
String name = "name_example"; // String | The name of the published web service.
String version = "version_example"; // String | The version of the published web service.
try {
    SwaggerJsonResponse result = apiInstance.getWebServiceSwagger(name, version);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServiceConsumptionAPIsApi#getWebServiceSwagger");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| The name of the published web service. |
 **version** | **String**| The version of the published web service. |

### Return type

[**SwaggerJsonResponse**](SwaggerJsonResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

