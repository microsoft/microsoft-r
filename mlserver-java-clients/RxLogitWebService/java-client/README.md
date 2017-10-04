# swagger-java-client

## Requirements

Building the API client library requires [Maven](https://maven.apache.org/) to be installed.

## Installation

To install the API client library to your local Maven repository, simply execute:

```shell
mvn install
```

To deploy it to a remote Maven repository instead, configure the settings of the repository and execute:

```shell
mvn deploy
```

Refer to the [official documentation](https://maven.apache.org/plugins/maven-deploy-plugin/usage.html) for more information.

### Maven users

Add this dependency to your project's POM:

```xml
<dependency>
    <groupId>io.swagger</groupId>
    <artifactId>swagger-java-client</artifactId>
    <version>1.0.0</version>
    <scope>compile</scope>
</dependency>
```

### Gradle users

Add this dependency to your project's build file:

```groovy
compile "io.swagger:swagger-java-client:1.0.0"
```

### Others

At first generate the JAR by executing:

    mvn package

Then manually install the following JARs:

* target/swagger-java-client-1.0.0.jar
* target/lib/*.jar

## Getting Started

Please follow the [installation](#installation) instruction and execute the following Java code:

```java

import io.swagger.client.*;
import io.swagger.client.auth.*;
import io.swagger.client.model.*;
import io.swagger.client.api.RxLogitServiceApi;

import java.io.File;
import java.util.*;

public class RxLogitServiceApiExample {

    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        
        // Configure API key authorization: Bearer
        ApiKeyAuth Bearer = (ApiKeyAuth) defaultClient.getAuthentication("Bearer");
        Bearer.setApiKey("YOUR API KEY");
        // Uncomment the following line to set a prefix for the API key, e.g. "Token" (defaults to null)
        //Bearer.setApiKeyPrefix("Token");

        RxLogitServiceApi apiInstance = new RxLogitServiceApi();
        String executionId = "executionId_example"; // String | Execution id of the execution.
        try {
            List<String> result = apiInstance.cancelAndDeleteBatchExecution(executionId);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling RxLogitServiceApi#cancelAndDeleteBatchExecution");
            e.printStackTrace();
        }
    }
}

```

## Documentation for API Endpoints

All URIs are relative to *http://localhost*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*RxLogitServiceApi* | [**cancelAndDeleteBatchExecution**](docs/RxLogitServiceApi.md#cancelAndDeleteBatchExecution) | **DELETE** /api/rxLogitService/1.0/batch/{executionId} | Cancels and deletes all batch executions for rxLogitService.
*RxLogitServiceApi* | [**getBatchExecutionFile**](docs/RxLogitServiceApi.md#getBatchExecutionFile) | **GET** /api/rxLogitService/1.0/batch/{executionId}/{index}/files/{fileName} | Gets a specific file from an execution in rxLogitService.
*RxLogitServiceApi* | [**getBatchExecutionFiles**](docs/RxLogitServiceApi.md#getBatchExecutionFiles) | **GET** /api/rxLogitService/1.0/batch/{executionId}/{index}/files | Gets all files from an individual execution in rxLogitService.
*RxLogitServiceApi* | [**getBatchExecutionStatus**](docs/RxLogitServiceApi.md#getBatchExecutionStatus) | **GET** /api/rxLogitService/1.0/batch/{executionId} | Gets all batch executions for rxLogitService.
*RxLogitServiceApi* | [**getBatchExecutions**](docs/RxLogitServiceApi.md#getBatchExecutions) | **GET** /api/rxLogitService/1.0/batch | Gets all batch executions for rxLogitService.
*RxLogitServiceApi* | [**scoreRxLogit**](docs/RxLogitServiceApi.md#scoreRxLogit) | **POST** /api/rxLogitService/1.0 | 
*RxLogitServiceApi* | [**startBatchExecution**](docs/RxLogitServiceApi.md#startBatchExecution) | **POST** /api/rxLogitService/1.0/batch | 
*UserApi* | [**login**](docs/UserApi.md#login) | **POST** /login | Logs the user in
*UserApi* | [**renewToken**](docs/UserApi.md#renewToken) | **POST** /login/refreshToken | The user renews access token and refresh token
*UserApi* | [**revokeRefreshToken**](docs/UserApi.md#revokeRefreshToken) | **DELETE** /login/refreshToken | The user revokes a refresh token


## Documentation for Models

 - [AccessTokenResponse](docs/AccessTokenResponse.md)
 - [BatchWebServiceResult](docs/BatchWebServiceResult.md)
 - [Error](docs/Error.md)
 - [InputParameters](docs/InputParameters.md)
 - [LoginRequest](docs/LoginRequest.md)
 - [OutputParameters](docs/OutputParameters.md)
 - [RenewTokenRequest](docs/RenewTokenRequest.md)
 - [StartBatchExecutionResponse](docs/StartBatchExecutionResponse.md)
 - [WebServiceResult](docs/WebServiceResult.md)


## Documentation for Authorization

Authentication schemes defined for the API:
### Bearer

- **Type**: API key
- **API key parameter name**: Authorization
- **Location**: HTTP header


## Recommendation

It's recommended to create an instance of `ApiClient` per thread in a multithreaded environment to avoid any potential issues.

## Author



