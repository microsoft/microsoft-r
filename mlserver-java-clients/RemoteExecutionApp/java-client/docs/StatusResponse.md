
# StatusResponse

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**statusCode** | [**StatusCodeEnum**](#StatusCodeEnum) | Health of the system. |  [optional]
**details** | **Map&lt;String, Object&gt;** | Details about the health of the system other than the status of its components. |  [optional]
**components** | [**Map&lt;String, StatusResponse&gt;**](StatusResponse.md) | The status of the components that make up the system. |  [optional]


<a name="StatusCodeEnum"></a>
## Enum: StatusCodeEnum
Name | Value
---- | -----
FAIL | &quot;fail&quot;
PASS | &quot;pass&quot;
WARN | &quot;warn&quot;



