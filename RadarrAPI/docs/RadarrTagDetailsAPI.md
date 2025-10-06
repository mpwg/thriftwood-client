# RadarrTagDetailsAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3TagDetailGet**](RadarrTagDetailsAPI.md#apiv3tagdetailget) | **GET** /api/v3/tag/detail | 
[**apiV3TagDetailIdGet**](RadarrTagDetailsAPI.md#apiv3tagdetailidget) | **GET** /api/v3/tag/detail/{id} | 


# **apiV3TagDetailGet**
```swift
    open class func apiV3TagDetailGet(completion: @escaping (_ data: [TagDetailsResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrTagDetailsAPI.apiV3TagDetailGet() { (response, error) in
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

[**[TagDetailsResource]**](TagDetailsResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3TagDetailIdGet**
```swift
    open class func apiV3TagDetailIdGet(id: Int, completion: @escaping (_ data: TagDetailsResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrTagDetailsAPI.apiV3TagDetailIdGet(id: id) { (response, error) in
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

[**TagDetailsResource**](TagDetailsResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

