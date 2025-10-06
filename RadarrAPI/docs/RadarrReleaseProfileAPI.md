# RadarrReleaseProfileAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ReleaseprofileGet**](RadarrReleaseProfileAPI.md#apiv3releaseprofileget) | **GET** /api/v3/releaseprofile | 
[**apiV3ReleaseprofileIdDelete**](RadarrReleaseProfileAPI.md#apiv3releaseprofileiddelete) | **DELETE** /api/v3/releaseprofile/{id} | 
[**apiV3ReleaseprofileIdGet**](RadarrReleaseProfileAPI.md#apiv3releaseprofileidget) | **GET** /api/v3/releaseprofile/{id} | 
[**apiV3ReleaseprofileIdPut**](RadarrReleaseProfileAPI.md#apiv3releaseprofileidput) | **PUT** /api/v3/releaseprofile/{id} | 
[**apiV3ReleaseprofilePost**](RadarrReleaseProfileAPI.md#apiv3releaseprofilepost) | **POST** /api/v3/releaseprofile | 


# **apiV3ReleaseprofileGet**
```swift
    open class func apiV3ReleaseprofileGet(completion: @escaping (_ data: [ReleaseProfileResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrReleaseProfileAPI.apiV3ReleaseprofileGet() { (response, error) in
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

[**[ReleaseProfileResource]**](ReleaseProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ReleaseprofileIdDelete**
```swift
    open class func apiV3ReleaseprofileIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrReleaseProfileAPI.apiV3ReleaseprofileIdDelete(id: id) { (response, error) in
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

# **apiV3ReleaseprofileIdGet**
```swift
    open class func apiV3ReleaseprofileIdGet(id: Int, completion: @escaping (_ data: ReleaseProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrReleaseProfileAPI.apiV3ReleaseprofileIdGet(id: id) { (response, error) in
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

[**ReleaseProfileResource**](ReleaseProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ReleaseprofileIdPut**
```swift
    open class func apiV3ReleaseprofileIdPut(id: String, releaseProfileResource: ReleaseProfileResource? = nil, completion: @escaping (_ data: ReleaseProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let releaseProfileResource = ReleaseProfileResource(id: 123, name: "name_example", enabled: false, _required: 123, ignored: 123, indexerId: 123, tags: [123]) // ReleaseProfileResource |  (optional)

RadarrReleaseProfileAPI.apiV3ReleaseprofileIdPut(id: id, releaseProfileResource: releaseProfileResource) { (response, error) in
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
 **releaseProfileResource** | [**ReleaseProfileResource**](ReleaseProfileResource.md) |  | [optional] 

### Return type

[**ReleaseProfileResource**](ReleaseProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ReleaseprofilePost**
```swift
    open class func apiV3ReleaseprofilePost(releaseProfileResource: ReleaseProfileResource? = nil, completion: @escaping (_ data: ReleaseProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let releaseProfileResource = ReleaseProfileResource(id: 123, name: "name_example", enabled: false, _required: 123, ignored: 123, indexerId: 123, tags: [123]) // ReleaseProfileResource |  (optional)

RadarrReleaseProfileAPI.apiV3ReleaseprofilePost(releaseProfileResource: releaseProfileResource) { (response, error) in
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
 **releaseProfileResource** | [**ReleaseProfileResource**](ReleaseProfileResource.md) |  | [optional] 

### Return type

[**ReleaseProfileResource**](ReleaseProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

