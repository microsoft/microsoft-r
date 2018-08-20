# ImageClassification.UserApi

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
```javascript
var ImageClassification = require('image_classification');

var apiInstance = new ImageClassification.UserApi();

var loginRequest = new ImageClassification.LoginRequest(); // LoginRequest | 


var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.login(loginRequest, callback);
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
```javascript
var ImageClassification = require('image_classification');

var apiInstance = new ImageClassification.UserApi();

var renewTokenRequest = new ImageClassification.RenewTokenRequest(); // RenewTokenRequest | 


var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.renewToken(renewTokenRequest, callback);
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
```javascript
var ImageClassification = require('image_classification');

var apiInstance = new ImageClassification.UserApi();

var refreshToken = "refreshToken_example"; // String | The refresh token to be revoked


var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
};
apiInstance.revokeRefreshToken(refreshToken, callback);
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

