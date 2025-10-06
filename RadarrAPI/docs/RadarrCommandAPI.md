# RadarrCommandAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3CommandGet**](RadarrCommandAPI.md#apiv3commandget) | **GET** /api/v3/command | 
[**apiV3CommandIdDelete**](RadarrCommandAPI.md#apiv3commandiddelete) | **DELETE** /api/v3/command/{id} | 
[**apiV3CommandIdGet**](RadarrCommandAPI.md#apiv3commandidget) | **GET** /api/v3/command/{id} | 
[**apiV3CommandPost**](RadarrCommandAPI.md#apiv3commandpost) | **POST** /api/v3/command | 


# **apiV3CommandGet**
```swift
    open class func apiV3CommandGet(completion: @escaping (_ data: [CommandResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrCommandAPI.apiV3CommandGet() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**[CommandResource]**](CommandResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CommandIdDelete**
```swift
    open class func apiV3CommandIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrCommandAPI.apiV3CommandIdDelete(id: id) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **Int** |  | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CommandIdGet**
```swift
    open class func apiV3CommandIdGet(id: Int, completion: @escaping (_ data: CommandResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrCommandAPI.apiV3CommandIdGet(id: id) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **Int** |  | 

### Return type

[**CommandResource**](CommandResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CommandPost**
```swift
    open class func apiV3CommandPost(commandResource: CommandResource? = nil, completion: @escaping (_ data: CommandResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let commandResource = CommandResource(id: 123, name: "name_example", commandName: "commandName_example", message: "message_example", body: Command(sendUpdatesToClient: false, updateScheduledTask: false, completionMessage: "completionMessage_example", requiresDiskAccess: false, isExclusive: false, isTypeExclusive: false, isLongRunning: false, name: "name_example", lastExecutionTime: Date(), lastStartTime: Date(), trigger: CommandTrigger(), suppressMessages: false, clientUserAgent: "clientUserAgent_example"), priority: CommandPriority(), status: CommandStatus(), result: CommandResult(), queued: Date(), started: Date(), ended: Date(), duration: "duration_example", exception: "exception_example", trigger: nil, clientUserAgent: "clientUserAgent_example", stateChangeTime: Date(), sendUpdatesToClient: false, updateScheduledTask: false, lastExecutionTime: Date()) // CommandResource |  (optional)

RadarrCommandAPI.apiV3CommandPost(commandResource: commandResource) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **commandResource** | [**CommandResource**](CommandResource.md) |  | [optional] 

### Return type

[**CommandResource**](CommandResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

