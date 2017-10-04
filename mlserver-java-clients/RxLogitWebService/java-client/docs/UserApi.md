# UserApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**login**](UserApi.md#login) | **POST** /login | Logs the user in
[**renewToken**](UserApi.md#renewToken) | **POST** /login/refreshToken | The user renews access token and refresh token
[**revokeRefreshToken**](UserApi.md#revokeRefreshToken) | **DELETE** /login/refreshToken | The user revokes a refresh token


<a name="login"></a>
# **login**
> AccessTokenResponse login(loginRequest)

Logs the user in

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.UserApi;


UserApi apiInstance = new UserApi();
LoginRequest loginRequest = new LoginRequest(); // LoginRequest | 
try {
    AccessTokenResponse result = apiInstance.login(loginRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling UserApi#login");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  |

### Return type

[**AccessTokenResponse**](AccessTokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="renewToken"></a>
# **renewToken**
> AccessTokenResponse renewToken(renewTokenRequest)

The user renews access token and refresh token

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.UserApi;


UserApi apiInstance = new UserApi();
RenewTokenRequest renewTokenRequest = new RenewTokenRequest(); // RenewTokenRequest | 
try {
    AccessTokenResponse result = apiInstance.renewToken(renewTokenRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling UserApi#renewToken");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **renewTokenRequest** | [**RenewTokenRequest**](RenewTokenRequest.md)|  |

### Return type

[**AccessTokenResponse**](AccessTokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="revokeRefreshToken"></a>
# **revokeRefreshToken**
> AccessTokenResponse revokeRefreshToken(refreshToken)

The user revokes a refresh token

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.UserApi;


UserApi apiInstance = new UserApi();
String refreshToken = "refreshToken_example"; // String | The refresh token to be revoked
try {
    AccessTokenResponse result = apiInstance.revokeRefreshToken(refreshToken);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling UserApi#revokeRefreshToken");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshToken** | **String**| The refresh token to be revoked |

### Return type

[**AccessTokenResponse**](AccessTokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

