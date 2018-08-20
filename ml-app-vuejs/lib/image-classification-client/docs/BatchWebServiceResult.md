# ImageClassification.BatchWebServiceResult

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**state** | **String** | State of the execution. Can be of the following values:  - Pending: The batch execution was submitted but is not yet scheduled. Ready: The batch execution was submitted and can be executed. InProgress: The batch execution is currently being processed. Complete: The batch execution has been completed. | [optional] 
**completedItemCount** | **Number** | Number of completed items in this batch operation. | [optional] 
**totalItemCount** | **Number** | Number of total items in this batch operation. | [optional] 
**parallelCount** | **Number** | Number of parallel threads that are processing this batch operation. | [optional] 
**batchExecutionResults** | [**[WebServiceResult]**](WebServiceResult.md) | The responses of the individual executions. | [optional] 


<a name="StateEnum"></a>
## Enum: StateEnum


* `pending` (value: `"pending"`)

* `inProgress` (value: `"inProgress"`)

* `ready` (value: `"ready"`)

* `complete` (value: `"complete"`)




