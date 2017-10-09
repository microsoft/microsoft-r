# AuthenticationAPIsApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**login**](AuthenticationAPIsApi.md#login) | **POST** /login | Login User
[**renewToken**](AuthenticationAPIsApi.md#renewToken) | **POST** /login/refreshToken | Refresh User Access Token
[**revokeRefreshToken**](AuthenticationAPIsApi.md#revokeRefreshToken) | **DELETE** /login/refreshToken | Delete User Access Token


<a name="login"></a>
# **login**
> AccessTokenResponse login(loginRequest)

Login User

Logs the user in.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.AuthenticationAPIsApi;


AuthenticationAPIsApi apiInstance = new AuthenticationAPIsApi();
LoginRequest loginRequest = new LoginRequest(); // LoginRequest | Login properties for athentication.
try {
    AccessTokenResponse result = apiInstance.login(loginRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling AuthenticationAPIsApi#login");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)| Login properties for athentication. |

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

Refresh User Access Token

The user renews access token and refresh token.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.AuthenticationAPIsApi;


AuthenticationAPIsApi apiInstance = new AuthenticationAPIsApi();
RenewTokenRequest renewTokenRequest = new RenewTokenRequest(); // RenewTokenRequest | Renew access token properties for athentication.
try {
    AccessTokenResponse result = apiInstance.renewToken(renewTokenRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling AuthenticationAPIsApi#renewToken");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **renewTokenRequest** | [**RenewTokenRequest**](RenewTokenRequest.md)| Renew access token properties for athentication. |

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

Delete User Access Token

The user revokes a refresh token.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.AuthenticationAPIsApi;


AuthenticationAPIsApi apiInstance = new AuthenticationAPIsApi();
String refreshToken = "refreshToken_example"; // String | The refresh token to be revoked.
try {
    AccessTokenResponse result = apiInstance.revokeRefreshToken(refreshToken);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling AuthenticationAPIsApi#revokeRefreshToken");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshToken** | **String**| The refresh token to be revoked. |

### Return type

[**AccessTokenResponse**](AccessTokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

