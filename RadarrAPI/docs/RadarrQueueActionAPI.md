# RadarrQueueActionAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3QueueGrabBulkPost**](RadarrQueueActionAPI.md#apiv3queuegrabbulkpost) | **POST** /api/v3/queue/grab/bulk | 
[**apiV3QueueGrabIdPost**](RadarrQueueActionAPI.md#apiv3queuegrabidpost) | **POST** /api/v3/queue/grab/{id} | 


# **apiV3QueueGrabBulkPost**
```swift
    open class func apiV3QueueGrabBulkPost(queueBulkResource: QueueBulkResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let queueBulkResource = QueueBulkResource(ids: [123]) // QueueBulkResource |  (optional)

RadarrQueueActionAPI.apiV3QueueGrabBulkPost(queueBulkResource: queueBulkResource) { (response, error) in
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
 **queueBulkResource** | [**QueueBulkResource**](QueueBulkResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3QueueGrabIdPost**
```swift
    open class func apiV3QueueGrabIdPost(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrQueueActionAPI.apiV3QueueGrabIdPost(id: id) { (response, error) in
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

