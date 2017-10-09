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
import io.swagger.client.api.AuthenticationAPIsApi;

import java.io.File;
import java.util.*;

public class AuthenticationAPIsApiExample {

    public static void main(String[] args) {
        
        AuthenticationAPIsApi apiInstance = new AuthenticationAPIsApi();
        LoginRequest loginRequest = new LoginRequest(); // LoginRequest | Login properties for athentication.
        try {
            AccessTokenResponse result = apiInstance.login(loginRequest);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling AuthenticationAPIsApi#login");
            e.printStackTrace();
        }
    }
}

```

## Documentation for API Endpoints

All URIs are relative to *http://localhost*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*AuthenticationAPIsApi* | [**login**](docs/AuthenticationAPIsApi.md#login) | **POST** /login | Login User
*AuthenticationAPIsApi* | [**renewToken**](docs/AuthenticationAPIsApi.md#renewToken) | **POST** /login/refreshToken | Refresh User Access Token
*AuthenticationAPIsApi* | [**revokeRefreshToken**](docs/AuthenticationAPIsApi.md#revokeRefreshToken) | **DELETE** /login/refreshToken | Delete User Access Token
*SessionAPIsApi* | [**cancelSession**](docs/SessionAPIsApi.md#cancelSession) | **POST** /sessions/{id}/cancel | Cancel Session
*SessionAPIsApi* | [**closeSession**](docs/SessionAPIsApi.md#closeSession) | **DELETE** /sessions/{id} | Delete Session
*SessionAPIsApi* | [**closeSessionByForce**](docs/SessionAPIsApi.md#closeSessionByForce) | **DELETE** /sessions/{id}/force | Delete Session by &#x60;force&#x60;
*SessionAPIsApi* | [**createSession**](docs/SessionAPIsApi.md#createSession) | **POST** /sessions | Create Session
*SessionAPIsApi* | [**deleteSessionFile**](docs/SessionAPIsApi.md#deleteSessionFile) | **DELETE** /sessions/{id}/files/{fileName} | Delete File
*SessionAPIsApi* | [**deleteWorkspaceObject**](docs/SessionAPIsApi.md#deleteWorkspaceObject) | **DELETE** /sessions/{id}/workspace/{objectName} | Delete Workspace Object
*SessionAPIsApi* | [**executeCode**](docs/SessionAPIsApi.md#executeCode) | **POST** /sessions/{id}/execute | Execute Code
*SessionAPIsApi* | [**getSessionConsoleOutput**](docs/SessionAPIsApi.md#getSessionConsoleOutput) | **GET** /sessions/{id}/console-output | Get Console Output
*SessionAPIsApi* | [**getSessionFile**](docs/SessionAPIsApi.md#getSessionFile) | **GET** /sessions/{id}/files/{fileName} | Get File
*SessionAPIsApi* | [**getWorkspaceObject**](docs/SessionAPIsApi.md#getWorkspaceObject) | **GET** /sessions/{id}/workspace/{objectName} | Get Workspace Object
*SessionAPIsApi* | [**listSessionFiles**](docs/SessionAPIsApi.md#listSessionFiles) | **GET** /sessions/{id}/files | Get Files
*SessionAPIsApi* | [**listSessionHistory**](docs/SessionAPIsApi.md#listSessionHistory) | **GET** /sessions/{id}/history | Get History
*SessionAPIsApi* | [**listSessions**](docs/SessionAPIsApi.md#listSessions) | **GET** /sessions | Get Sessions
*SessionAPIsApi* | [**listWorkspaceObjects**](docs/SessionAPIsApi.md#listWorkspaceObjects) | **GET** /sessions/{id}/workspace | Get Workspace Object Names
*SessionAPIsApi* | [**setWorkspaceObject**](docs/SessionAPIsApi.md#setWorkspaceObject) | **POST** /sessions/{id}/workspace/{objectName} | Create Workspace Object
*SessionAPIsApi* | [**uploadSessionFile**](docs/SessionAPIsApi.md#uploadSessionFile) | **POST** /sessions/{id}/files | Load File
*SnapshotAPIsApi* | [**createSnapshot**](docs/SnapshotAPIsApi.md#createSnapshot) | **POST** /sessions/{id}/snapshot | Create Snapshot
*SnapshotAPIsApi* | [**listSnapshots**](docs/SnapshotAPIsApi.md#listSnapshots) | **GET** /snapshots | Get Snapshots
*SnapshotAPIsApi* | [**loadSnapshot**](docs/SnapshotAPIsApi.md#loadSnapshot) | **POST** /sessions/{id}/loadsnapshot/{snapshotId} | Load Snapshot


## Documentation for Models

 - [AccessTokenResponse](docs/AccessTokenResponse.md)
 - [ConsoleOutputResponse](docs/ConsoleOutputResponse.md)
 - [CreateSessionRequest](docs/CreateSessionRequest.md)
 - [CreateSessionResponse](docs/CreateSessionResponse.md)
 - [CreateSnapshotRequest](docs/CreateSnapshotRequest.md)
 - [CreateSnapshotResponse](docs/CreateSnapshotResponse.md)
 - [Error](docs/Error.md)
 - [ExecuteRequest](docs/ExecuteRequest.md)
 - [ExecuteResponse](docs/ExecuteResponse.md)
 - [LoginRequest](docs/LoginRequest.md)
 - [ParameterDefinition](docs/ParameterDefinition.md)
 - [RenewTokenRequest](docs/RenewTokenRequest.md)
 - [Session](docs/Session.md)
 - [Snapshot](docs/Snapshot.md)
 - [WorkspaceObject](docs/WorkspaceObject.md)


## Documentation for Authorization

All endpoints do not require authorization.
Authentication schemes defined for the API:

## Recommendation

It's recommended to create an instance of `ApiClient` per thread in a multithreaded environment to avoid any potential issues.

## Author



