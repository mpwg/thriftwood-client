# RadarrQueueStatusAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3QueueStatusGet**](RadarrQueueStatusAPI.md#apiv3queuestatusget) | **GET** /api/v3/queue/status | 


# **apiV3QueueStatusGet**
```swift
    open class func apiV3QueueStatusGet(completion: @escaping (_ data: QueueStatusResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrQueueStatusAPI.apiV3QueueStatusGet() { (response, error) in
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

[**QueueStatusResource**](QueueStatusResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

