# SessionAPIsApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cancelSession**](SessionAPIsApi.md#cancelSession) | **POST** /sessions/{id}/cancel | Cancel Session
[**closeSession**](SessionAPIsApi.md#closeSession) | **DELETE** /sessions/{id} | Delete Session
[**closeSessionByForce**](SessionAPIsApi.md#closeSessionByForce) | **DELETE** /sessions/{id}/force | Delete Session by &#x60;force&#x60;
[**createSession**](SessionAPIsApi.md#createSession) | **POST** /sessions | Create Session
[**deleteSessionFile**](SessionAPIsApi.md#deleteSessionFile) | **DELETE** /sessions/{id}/files/{fileName} | Delete File
[**deleteWorkspaceObject**](SessionAPIsApi.md#deleteWorkspaceObject) | **DELETE** /sessions/{id}/workspace/{objectName} | Delete Workspace Object
[**executeCode**](SessionAPIsApi.md#executeCode) | **POST** /sessions/{id}/execute | Execute Code
[**getSessionConsoleOutput**](SessionAPIsApi.md#getSessionConsoleOutput) | **GET** /sessions/{id}/console-output | Get Console Output
[**getSessionFile**](SessionAPIsApi.md#getSessionFile) | **GET** /sessions/{id}/files/{fileName} | Get File
[**getWorkspaceObject**](SessionAPIsApi.md#getWorkspaceObject) | **GET** /sessions/{id}/workspace/{objectName} | Get Workspace Object
[**listSessionFiles**](SessionAPIsApi.md#listSessionFiles) | **GET** /sessions/{id}/files | Get Files
[**listSessionHistory**](SessionAPIsApi.md#listSessionHistory) | **GET** /sessions/{id}/history | Get History
[**listSessions**](SessionAPIsApi.md#listSessions) | **GET** /sessions | Get Sessions
[**listWorkspaceObjects**](SessionAPIsApi.md#listWorkspaceObjects) | **GET** /sessions/{id}/workspace | Get Workspace Object Names
[**setWorkspaceObject**](SessionAPIsApi.md#setWorkspaceObject) | **POST** /sessions/{id}/workspace/{objectName} | Create Workspace Object
[**uploadSessionFile**](SessionAPIsApi.md#uploadSessionFile) | **POST** /sessions/{id}/files | Load File


<a name="cancelSession"></a>
# **cancelSession**
> String cancelSession(id)

Cancel Session

Cancel a session by aborting the current execution operation, afterwards the session will be alive and ready to accept any calls. Cancel session is **not** guaranteed to interrupt the execution

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session to cancel.
try {
    String result = apiInstance.cancelSession(id);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#cancelSession");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session to cancel. |

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="closeSession"></a>
# **closeSession**
> String closeSession(id)

Delete Session

Close a session and releases all it&#39;s associated resources.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session to delete.
try {
    String result = apiInstance.closeSession(id);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#closeSession");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session to delete. |

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="closeSessionByForce"></a>
# **closeSessionByForce**
> String closeSessionByForce(id)

Delete Session by &#x60;force&#x60;

Attempt to _kill_ a session and releases all it&#39;s associated resources.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session to delete.
try {
    String result = apiInstance.closeSessionByForce(id);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#closeSessionByForce");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session to delete. |

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="createSession"></a>
# **createSession**
> CreateSessionResponse createSession(createSessionRequest)

Create Session

Create a new session.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
CreateSessionRequest createSessionRequest = new CreateSessionRequest(); // CreateSessionRequest | Properties of the new session.
try {
    CreateSessionResponse result = apiInstance.createSession(createSessionRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#createSession");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSessionRequest** | [**CreateSessionRequest**](CreateSessionRequest.md)| Properties of the new session. |

### Return type

[**CreateSessionResponse**](CreateSessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="deleteSessionFile"></a>
# **deleteSessionFile**
> deleteSessionFile(id, fileName)

Delete File

Delete a file from a session&#39;s working directory.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
String fileName = "fileName_example"; // String | Name of the file.
try {
    apiInstance.deleteSessionFile(id, fileName);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#deleteSessionFile");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |
 **fileName** | **String**| Name of the file. |

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="deleteWorkspaceObject"></a>
# **deleteWorkspaceObject**
> deleteWorkspaceObject(id, objectName)

Delete Workspace Object

Delete an object from a session.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
String objectName = "objectName_example"; // String | Name of the object.
try {
    apiInstance.deleteWorkspaceObject(id, objectName);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#deleteWorkspaceObject");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |
 **objectName** | **String**| Name of the object. |

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="executeCode"></a>
# **executeCode**
> ExecuteResponse executeCode(id, executeRequest)

Execute Code

Executes code in the context of a specific session.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
ExecuteRequest executeRequest = new ExecuteRequest(); // ExecuteRequest | code that needs to be executed
try {
    ExecuteResponse result = apiInstance.executeCode(id, executeRequest);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#executeCode");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |
 **executeRequest** | [**ExecuteRequest**](ExecuteRequest.md)| code that needs to be executed |

### Return type

[**ExecuteResponse**](ExecuteResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getSessionConsoleOutput"></a>
# **getSessionConsoleOutput**
> ConsoleOutputResponse getSessionConsoleOutput(id)

Get Console Output

Returns the console output for the current or last execution.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
try {
    ConsoleOutputResponse result = apiInstance.getSessionConsoleOutput(id);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#getSessionConsoleOutput");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |

### Return type

[**ConsoleOutputResponse**](ConsoleOutputResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getSessionFile"></a>
# **getSessionFile**
> File getSessionFile(id, fileName)

Get File

Downloads a file from a session as a stream.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
String fileName = "fileName_example"; // String | Name of the file.
try {
    File result = apiInstance.getSessionFile(id, fileName);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#getSessionFile");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |
 **fileName** | **String**| Name of the file. |

### Return type

[**File**](File.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="getWorkspaceObject"></a>
# **getWorkspaceObject**
> File getWorkspaceObject(id, objectName)

Get Workspace Object

Returns an object from a session. For the &#x60;R&#x60; runtime, the object is serialized as a &#x60;.RData&#x60; file stream. For the &#x60;Python&#x60; runtime, the object is serialized as a &#x60;.dill&#x60; file stream.  **Important** Python objects are not guaranteed to be compatible with versions other than Python &#x60;3.5&#x60;.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
String objectName = "objectName_example"; // String | Name of the R or Python object.
try {
    File result = apiInstance.getWorkspaceObject(id, objectName);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#getWorkspaceObject");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |
 **objectName** | **String**| Name of the R or Python object. |

### Return type

[**File**](File.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="listSessionFiles"></a>
# **listSessionFiles**
> List&lt;String&gt; listSessionFiles(id)

Get Files

Lists all files of a specific session.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
try {
    List<String> result = apiInstance.listSessionFiles(id);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#listSessionFiles");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |

### Return type

**List&lt;String&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="listSessionHistory"></a>
# **listSessionHistory**
> List&lt;String&gt; listSessionHistory(id)

Get History

Lists all history for a specific session.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
try {
    List<String> result = apiInstance.listSessionHistory(id);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#listSessionHistory");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |

### Return type

**List&lt;String&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="listSessions"></a>
# **listSessions**
> List&lt;Session&gt; listSessions()

Get Sessions

Lists all existing sessions for the current user.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
try {
    List<Session> result = apiInstance.listSessions();
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#listSessions");
    e.printStackTrace();
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;Session&gt;**](Session.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="listWorkspaceObjects"></a>
# **listWorkspaceObjects**
> List&lt;String&gt; listWorkspaceObjects(id)

Get Workspace Object Names

Lists all object names of a specific session.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
try {
    List<String> result = apiInstance.listWorkspaceObjects(id);
    System.out.println(result);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#listWorkspaceObjects");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |

### Return type

**List&lt;String&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

<a name="setWorkspaceObject"></a>
# **setWorkspaceObject**
> setWorkspaceObject(id, objectName, serializedObject)

Create Workspace Object

Upload a serialized object into the session.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
String objectName = "objectName_example"; // String | Name of the object.
byte[] serializedObject = BINARY_DATA_HERE; // byte[] | The binary file that contains a serialized object to be uploaded. The binary file `Content-Type` should be `application/octet-stream`.
try {
    apiInstance.setWorkspaceObject(id, objectName, serializedObject);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#setWorkspaceObject");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |
 **objectName** | **String**| Name of the object. |
 **serializedObject** | **byte[]**| The binary file that contains a serialized object to be uploaded. The binary file &#x60;Content-Type&#x60; should be &#x60;application/octet-stream&#x60;. |

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/octet-stream
 - **Accept**: application/json

<a name="uploadSessionFile"></a>
# **uploadSessionFile**
> uploadSessionFile(id, file)

Load File

Loads a file into the session working directory. The uploaded file name is extracted from the file and if another file with the same name already exists in the working directory, the file will be overwritten.

### Example
```java
// Import classes:
//import io.swagger.client.ApiException;
//import io.swagger.client.api.SessionAPIsApi;


SessionAPIsApi apiInstance = new SessionAPIsApi();
String id = "id_example"; // String | Id of the session.
File file = new File("/path/to/file.txt"); // File | The file to be uploaded to the workspace.
try {
    apiInstance.uploadSessionFile(id, file);
} catch (ApiException e) {
    System.err.println("Exception when calling SessionAPIsApi#uploadSessionFile");
    e.printStackTrace();
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Id of the session. |
 **file** | **File**| The file to be uploaded to the workspace. |

### Return type

null (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: text/plain

