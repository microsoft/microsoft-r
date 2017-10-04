# ServicesManagementAPIsApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteWebServiceVersion**](ServicesManagementAPIsApi.md#deleteWebServiceVersion) | **DELETE** /services/{name}/{version} | Delete Service
[**getAllWebServiceVersionsByName**](ServicesManagementAPIsApi.md#getAllWebServiceVersionsByName) | **GET** /services/{name} | Get Service by &#x60;name&#x60;
[**getAllWebServices**](ServicesManagementAPIsApi.md#getAllWebServices) | **GET** /services | Get Services
[**getWebServiceVersion**](ServicesManagementAPIsApi.md#getWebServiceVersion) | **GET** /services/{name}/{version} | Get Service by &#x60;name&#x60; and &#x60;version&#x60;
[**patchRealtimeWebServiceByNameVersion**](ServicesManagementAPIsApi.md#patchRealtimeWebServiceByNameVersion) | **PATCH** /realtime-services/{name}/{version} | Patch realtime web service
[**patchWebServiceVersion**](ServicesManagementAPIsApi.md#patchWebServiceVersion) | **PATCH** /services/{name}/{version} | Patch Service
[**publishRealtimeWebServiceByName**](ServicesManagementAPIsApi.md#publishRealtimeWebServiceByName) | **POST** /realtime-services/{name} | Create realtime web service by &#x60;name&#x60;
[**publishRealtimeWebServiceByNameVersion**](ServicesManagementAPIsApi.md#publishRealtimeWebServiceByNameVersion) | **POST** /realtime-services/{name}/{version} | Create realtime web service by &#x60;name&#x60; and &#x60;version&#x60;.
[**publishWebService**](ServicesManagementAPIsApi.md#publishWebService) | **POST** /services/{name} | Create Service by &#x60;name&#x60;
[**publishWebServiceVersion**](ServicesManagementAPIsApi.md#publishWebServiceVersion) | **POST** /services/{name}/{version} | Create Service by &#x60;name&#x60; and &#x60;version&#x60;


<a name="deleteWebServiceVersion"></a>
# **deleteWebServiceVersion**
> deleteWebServiceVersion(name, version)

Delete Service

Deletes the published web service for the logged in user.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | The name of the published web service.
String version = "version_example"; // String | The version of the published web service.
try {
    apiInstance.deleteWebServiceVersion(name, version);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#deleteWebServiceVersion");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| The name of the published web service. |
 **version** | **String**| The version of the published web service. |

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getAllWebServiceVersionsByName"></a>
# **getAllWebServiceVersionsByName**
> List&lt;WebService&gt; getAllWebServiceVersionsByName(name)

Get Service by &#x60;name&#x60;

Lists all the published services with the provided &#x60;name&#x60;.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | name of the published web service.
try {
    List<WebService> result = apiInstance.getAllWebServiceVersionsByName(name);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#getAllWebServiceVersionsByName");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| name of the published web service. |

### Return type

[**List&lt;WebService&gt;**](WebService.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getAllWebServices"></a>
# **getAllWebServices**
> List&lt;WebService&gt; getAllWebServices()

Get Services

Lists all the published services.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
try {
    List<WebService> result = apiInstance.getAllWebServices();
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#getAllWebServices");
    e.printStackTrace();
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;WebService&gt;**](WebService.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getWebServiceVersion"></a>
# **getWebServiceVersion**
> List&lt;WebService&gt; getWebServiceVersion(name, version)

Get Service by &#x60;name&#x60; and &#x60;version&#x60;

Lists all the published services with the provided &#x60;name&#x60; and &#x60;version&#x60;.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | The name of the published web service.
String version = "version_example"; // String | The version of the published web service.
try {
    List<WebService> result = apiInstance.getWebServiceVersion(name, version);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#getWebServiceVersion");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| The name of the published web service. |
 **version** | **String**| The version of the published web service. |

### Return type

[**List&lt;WebService&gt;**](WebService.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="patchRealtimeWebServiceByNameVersion"></a>
# **patchRealtimeWebServiceByNameVersion**
> String patchRealtimeWebServiceByNameVersion(name, version, description, operationId, model)

Patch realtime web service

Updates the published realtime web service.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | Name of the published realtime web service
String version = "version_example"; // String | Version of the published realtime web service
String description = "description_example"; // String | The description of the realtime web service to be published.
String operationId = "operationId_example"; // String | Swagger operationId/alias for the realtime web service to be published.
File model = new File("/path/to/file.txt"); // File | The binary serialized model to be used for realtime web service.
try {
    String result = apiInstance.patchRealtimeWebServiceByNameVersion(name, version, description, operationId, model);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#patchRealtimeWebServiceByNameVersion");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| Name of the published realtime web service |
 **version** | **String**| Version of the published realtime web service |
 **description** | **String**| The description of the realtime web service to be published. | [optional]
 **operationId** | **String**| Swagger operationId/alias for the realtime web service to be published. | [optional]
 **model** | **File**| The binary serialized model to be used for realtime web service. | [optional]

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

<a name="patchWebServiceVersion"></a>
# **patchWebServiceVersion**
> String patchWebServiceVersion(name, version, patchRequest)

Patch Service

Updates the published service.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | The name of the published web service.
String version = "version_example"; // String | The version of the published web service.
PublishWebServiceRequest patchRequest = new PublishWebServiceRequest(); // PublishWebServiceRequest | Publish Web Service request details.
try {
    String result = apiInstance.patchWebServiceVersion(name, version, patchRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#patchWebServiceVersion");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| The name of the published web service. |
 **version** | **String**| The version of the published web service. |
 **patchRequest** | [**PublishWebServiceRequest**](PublishWebServiceRequest.md)| Publish Web Service request details. |

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="publishRealtimeWebServiceByName"></a>
# **publishRealtimeWebServiceByName**
> String publishRealtimeWebServiceByName(name, model, description, operationId)

Create realtime web service by &#x60;name&#x60;

Publish the realtime web services for the logged in user with given name and a unique version.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | name of the realtime web service to be published.
File model = new File("/path/to/file.txt"); // File | The binary serialized model to be used for realtime web service.
String description = "description_example"; // String | The description of the realtime web service to be published.
String operationId = "operationId_example"; // String | Swagger operationId/alias for the realtime web service to be published.
try {
    String result = apiInstance.publishRealtimeWebServiceByName(name, model, description, operationId);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#publishRealtimeWebServiceByName");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| name of the realtime web service to be published. |
 **model** | **File**| The binary serialized model to be used for realtime web service. |
 **description** | **String**| The description of the realtime web service to be published. | [optional]
 **operationId** | **String**| Swagger operationId/alias for the realtime web service to be published. | [optional]

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

<a name="publishRealtimeWebServiceByNameVersion"></a>
# **publishRealtimeWebServiceByNameVersion**
> String publishRealtimeWebServiceByNameVersion(name, version, model, description, operationId)

Create realtime web service by &#x60;name&#x60; and &#x60;version&#x60;.

Publish the realtime web services for the logged in user with given name and given version.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | The name of the realtime web service to be published.
String version = "version_example"; // String | The version of the realtime web service to be published.
File model = new File("/path/to/file.txt"); // File | The binary serialized model to be used for realtime web service.
String description = "description_example"; // String | The description of the realtime web service to be published.
String operationId = "operationId_example"; // String | Swagger operationId/alias for the realtime web service to be published.
try {
    String result = apiInstance.publishRealtimeWebServiceByNameVersion(name, version, model, description, operationId);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#publishRealtimeWebServiceByNameVersion");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| The name of the realtime web service to be published. |
 **version** | **String**| The version of the realtime web service to be published. |
 **model** | **File**| The binary serialized model to be used for realtime web service. |
 **description** | **String**| The description of the realtime web service to be published. | [optional]
 **operationId** | **String**| Swagger operationId/alias for the realtime web service to be published. | [optional]

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

<a name="publishWebService"></a>
# **publishWebService**
> String publishWebService(name, publishRequest)

Create Service by &#x60;name&#x60;

Publish the web services for the logged in user with given name and a unique version.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | name of the published web service.
PublishWebServiceRequest publishRequest = new PublishWebServiceRequest(); // PublishWebServiceRequest | Publish Web Service request details.
try {
    String result = apiInstance.publishWebService(name, publishRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#publishWebService");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| name of the published web service. |
 **publishRequest** | [**PublishWebServiceRequest**](PublishWebServiceRequest.md)| Publish Web Service request details. |

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="publishWebServiceVersion"></a>
# **publishWebServiceVersion**
> String publishWebServiceVersion(name, version, publishRequest)

Create Service by &#x60;name&#x60; and &#x60;version&#x60;

Publish the web service for the logged in user with given name and version.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.ServicesManagementAPIsApi;


ServicesManagementAPIsApi apiInstance = new ServicesManagementAPIsApi();
String name = "name_example"; // String | name of the published web service.
String version = "version_example"; // String | version of the published web service.
PublishWebServiceRequest publishRequest = new PublishWebServiceRequest(); // PublishWebServiceRequest | Publish Service request details.
try {
    String result = apiInstance.publishWebServiceVersion(name, version, publishRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling ServicesManagementAPIsApi#publishWebServiceVersion");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| name of the published web service. |
 **version** | **String**| version of the published web service. |
 **publishRequest** | [**PublishWebServiceRequest**](PublishWebServiceRequest.md)| Publish Service request details. |

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

