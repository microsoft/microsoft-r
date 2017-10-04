
# BatchWebServiceResult

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**state** | [**StateEnum**](#StateEnum) | State of the execution. Can be of the following values:  - Pending: The batch execution was submitted but is not yet scheduled. Ready: The batch execution was submitted and can be executed. InProgress: The batch execution is currently being processed. Complete: The batch execution has been completed. |  [optional]
**completedItemCount** | **Integer** | Number of completed items in this batch operation. |  [optional]
**totalItemCount** | **Integer** | Number of total items in this batch operation. |  [optional]
**batchExecutionResults** | [**List&lt;WebServiceResult&gt;**](WebServiceResult.md) | The responses of the individual executions. |  [optional]


<a name="StateEnum"></a>
## Enum: StateEnum
Name | Value
---- | -----
PENDING | &quot;pending&quot;
INPROGRESS | &quot;inProgress&quot;
READY | &quot;ready&quot;
COMPLETE | &quot;complete&quot;



