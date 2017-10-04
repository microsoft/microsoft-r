# StatusAPIsApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**status**](StatusAPIsApi.md#status) | **GET** /status | Get Status


<a name="status"></a>
# **status**
> StatusResponse status()

Get Status

Gets the current health of the system.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.StatusAPIsApi;


StatusAPIsApi apiInstance = new StatusAPIsApi();
try {
    StatusResponse result = apiInstance.status();
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling StatusAPIsApi#status");
    e.printStackTrace();
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StatusResponse**](StatusResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

