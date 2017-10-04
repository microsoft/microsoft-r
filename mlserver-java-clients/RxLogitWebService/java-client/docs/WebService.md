
# WebService

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** | Name of the published service. | 
**version** | **String** | Version of the Published Service. | 
**versionPublishedBy** | **String** | Username of the user who published this version of the published web-service. |  [optional]
**creationTime** | **String** | Creation time for the service. |  [optional]
**snapshotId** | **String** | ID of the snapshot to be used for service. |  [optional]
**runtimeType** | [**RuntimeTypeEnum**](#RuntimeTypeEnum) | Type of the runtime. |  [optional]
**initCode** | **String** | Code to execute before the request. Specific to the runtime type. |  [optional]
**code** | **String** | Code to execute. Specific to the runtime type. |  [optional]
**description** | **String** | Description of the web service. |  [optional]
**operationId** | **String** | Swagger operationId/alias for the web service. |  [optional]
**inputParameterDefinitions** | [**List&lt;ParameterDefinition&gt;**](ParameterDefinition.md) | Input parameters definitions for the execution |  [optional]
**outputParameterDefinitions** | [**List&lt;ParameterDefinition&gt;**](ParameterDefinition.md) | Output parameter definitions for the execution |  [optional]
**outputFileNames** | **List&lt;String&gt;** | Files that are returned by the request |  [optional]
**myPermissionOnService** | **String** | User&#39;s permission for this service, it is either &#39;read/write&#39; or &#39;read only&#39;.&#39;read/write&#39; means that the user can update/delete this service and &#39;read only&#39; means that the user can consume it only. |  [optional]


<a name="RuntimeTypeEnum"></a>
## Enum: RuntimeTypeEnum
Name | Value
---- | -----
R | &quot;R&quot;
PYTHON | &quot;Python&quot;
REALTIME | &quot;Realtime&quot;



