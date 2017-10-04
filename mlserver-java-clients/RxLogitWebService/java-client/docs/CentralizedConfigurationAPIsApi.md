# CentralizedConfigurationAPIsApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addComputeNode**](CentralizedConfigurationAPIsApi.md#addComputeNode) | **PUT** /computenodes | Add Compute Node
[**getComputeNodes**](CentralizedConfigurationAPIsApi.md#getComputeNodes) | **GET** /computenodes | Get Compute Nodes
[**removeComputeNode**](CentralizedConfigurationAPIsApi.md#removeComputeNode) | **DELETE** /computenodes | Remove Compute Node
[**setComputeNodes**](CentralizedConfigurationAPIsApi.md#setComputeNodes) | **POST** /computenodes | Set Compute Nodes


<a name="addComputeNode"></a>
# **addComputeNode**
> addComputeNode(entries)

Add Compute Node

Add Compute Node URIs or Ranges to list.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.CentralizedConfigurationAPIsApi;


CentralizedConfigurationAPIsApi apiInstance = new CentralizedConfigurationAPIsApi();
UpdateComputeNodesRequest entries = new UpdateComputeNodesRequest(); // UpdateComputeNodesRequest | List of URIs or Ranges to be added.
try {
    apiInstance.addComputeNode(entries);
} catch (ApiException e) {
    System.err.println("Exception when calling CentralizedConfigurationAPIsApi#addComputeNode");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entries** | [**UpdateComputeNodesRequest**](UpdateComputeNodesRequest.md)| List of URIs or Ranges to be added. |

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getComputeNodes"></a>
# **getComputeNodes**
> GetComputeNodesResponse getComputeNodes()

Get Compute Nodes

Lists all existing compute node uris.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.CentralizedConfigurationAPIsApi;


CentralizedConfigurationAPIsApi apiInstance = new CentralizedConfigurationAPIsApi();
try {
    GetComputeNodesResponse result = apiInstance.getComputeNodes();
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling CentralizedConfigurationAPIsApi#getComputeNodes");
    e.printStackTrace();
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetComputeNodesResponse**](GetComputeNodesResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="removeComputeNode"></a>
# **removeComputeNode**
> removeComputeNode(entries)

Remove Compute Node

Remove Compute Node URIs or Ranges from list.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.CentralizedConfigurationAPIsApi;


CentralizedConfigurationAPIsApi apiInstance = new CentralizedConfigurationAPIsApi();
UpdateComputeNodesRequest entries = new UpdateComputeNodesRequest(); // UpdateComputeNodesRequest | List of URIs or Ranges to be removed.
try {
    apiInstance.removeComputeNode(entries);
} catch (ApiException e) {
    System.err.println("Exception when calling CentralizedConfigurationAPIsApi#removeComputeNode");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entries** | [**UpdateComputeNodesRequest**](UpdateComputeNodesRequest.md)| List of URIs or Ranges to be removed. |

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="setComputeNodes"></a>
# **setComputeNodes**
> setComputeNodes(entries)

Set Compute Nodes

Sets entire list of compute node uris, overriding previous entries.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.CentralizedConfigurationAPIsApi;


CentralizedConfigurationAPIsApi apiInstance = new CentralizedConfigurationAPIsApi();
UpdateComputeNodesRequest entries = new UpdateComputeNodesRequest(); // UpdateComputeNodesRequest | List of URIs or Ranges to set. Will override previous entries.
try {
    apiInstance.setComputeNodes(entries);
} catch (ApiException e) {
    System.err.println("Exception when calling CentralizedConfigurationAPIsApi#setComputeNodes");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entries** | [**UpdateComputeNodesRequest**](UpdateComputeNodesRequest.md)| List of URIs or Ranges to set. Will override previous entries. |

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

