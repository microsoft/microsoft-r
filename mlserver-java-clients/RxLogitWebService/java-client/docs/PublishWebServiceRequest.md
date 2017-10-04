
# PublishWebServiceRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**snapshotId** | **String** | ID of the snapshot to be used for service. **Optional** |  [optional]
**code** | **String** | Code to execute. Specific to the runtime type. **&lt;font color &#x3D; &#39;red&#39;&gt;Required&lt;/font&gt;** |  [optional]
**description** | **String** | Description for the web service. **Optional** |  [optional]
**operationId** | **String** | Swagger operationId/alias for web service. **Optional** |  [optional]
**inputParameterDefinitions** | [**List&lt;ParameterDefinition&gt;**](ParameterDefinition.md) | Input parameters definitions for the execution. **Optional** |  [optional]
**outputParameterDefinitions** | [**List&lt;ParameterDefinition&gt;**](ParameterDefinition.md) | Output parameter definitions for the execution. **Optional** |  [optional]
**runtimeType** | [**RuntimeTypeEnum**](#RuntimeTypeEnum) | Type of the runtime. **Optional [Default R]** |  [optional]
**initCode** | **String** | Code that runs before each request. Specific to the runtime type. **Optional** |  [optional]
**outputFileNames** | **List&lt;String&gt;** | Files that are returned by the response. **Optional** |  [optional]


<a name="RuntimeTypeEnum"></a>
## Enum: RuntimeTypeEnum
Name | Value
---- | -----
R | &quot;R&quot;
PYTHON | &quot;Python&quot;



