# RadarrRemotePathMappingAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3RemotepathmappingGet**](RadarrRemotePathMappingAPI.md#apiv3remotepathmappingget) | **GET** /api/v3/remotepathmapping | 
[**apiV3RemotepathmappingIdDelete**](RadarrRemotePathMappingAPI.md#apiv3remotepathmappingiddelete) | **DELETE** /api/v3/remotepathmapping/{id} | 
[**apiV3RemotepathmappingIdGet**](RadarrRemotePathMappingAPI.md#apiv3remotepathmappingidget) | **GET** /api/v3/remotepathmapping/{id} | 
[**apiV3RemotepathmappingIdPut**](RadarrRemotePathMappingAPI.md#apiv3remotepathmappingidput) | **PUT** /api/v3/remotepathmapping/{id} | 
[**apiV3RemotepathmappingPost**](RadarrRemotePathMappingAPI.md#apiv3remotepathmappingpost) | **POST** /api/v3/remotepathmapping | 


# **apiV3RemotepathmappingGet**
```swift
    open class func apiV3RemotepathmappingGet(completion: @escaping (_ data: [RemotePathMappingResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrRemotePathMappingAPI.apiV3RemotepathmappingGet() { (response, error) in
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

[**[RemotePathMappingResource]**](RemotePathMappingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3RemotepathmappingIdDelete**
```swift
    open class func apiV3RemotepathmappingIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrRemotePathMappingAPI.apiV3RemotepathmappingIdDelete(id: id) { (response, error) in
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

# **apiV3RemotepathmappingIdGet**
```swift
    open class func apiV3RemotepathmappingIdGet(id: Int, completion: @escaping (_ data: RemotePathMappingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrRemotePathMappingAPI.apiV3RemotepathmappingIdGet(id: id) { (response, error) in
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

[**RemotePathMappingResource**](RemotePathMappingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3RemotepathmappingIdPut**
```swift
    open class func apiV3RemotepathmappingIdPut(id: String, remotePathMappingResource: RemotePathMappingResource? = nil, completion: @escaping (_ data: RemotePathMappingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let remotePathMappingResource = RemotePathMappingResource(id: 123, host: "host_example", remotePath: "remotePath_example", localPath: "localPath_example") // RemotePathMappingResource |  (optional)

RadarrRemotePathMappingAPI.apiV3RemotepathmappingIdPut(id: id, remotePathMappingResource: remotePathMappingResource) { (response, error) in
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
 **id** | **String** |  | 
 **remotePathMappingResource** | [**RemotePathMappingResource**](RemotePathMappingResource.md) |  | [optional] 

### Return type

[**RemotePathMappingResource**](RemotePathMappingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3RemotepathmappingPost**
```swift
    open class func apiV3RemotepathmappingPost(remotePathMappingResource: RemotePathMappingResource? = nil, completion: @escaping (_ data: RemotePathMappingResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let remotePathMappingResource = RemotePathMappingResource(id: 123, host: "host_example", remotePath: "remotePath_example", localPath: "localPath_example") // RemotePathMappingResource |  (optional)

RadarrRemotePathMappingAPI.apiV3RemotepathmappingPost(remotePathMappingResource: remotePathMappingResource) { (response, error) in
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
 **remotePathMappingResource** | [**RemotePathMappingResource**](RemotePathMappingResource.md) |  | [optional] 

### Return type

[**RemotePathMappingResource**](RemotePathMappingResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

