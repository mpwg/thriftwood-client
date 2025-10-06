# RadarrDelayProfileAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3DelayprofileGet**](RadarrDelayProfileAPI.md#apiv3delayprofileget) | **GET** /api/v3/delayprofile | 
[**apiV3DelayprofileIdDelete**](RadarrDelayProfileAPI.md#apiv3delayprofileiddelete) | **DELETE** /api/v3/delayprofile/{id} | 
[**apiV3DelayprofileIdGet**](RadarrDelayProfileAPI.md#apiv3delayprofileidget) | **GET** /api/v3/delayprofile/{id} | 
[**apiV3DelayprofileIdPut**](RadarrDelayProfileAPI.md#apiv3delayprofileidput) | **PUT** /api/v3/delayprofile/{id} | 
[**apiV3DelayprofilePost**](RadarrDelayProfileAPI.md#apiv3delayprofilepost) | **POST** /api/v3/delayprofile | 
[**apiV3DelayprofileReorderIdPut**](RadarrDelayProfileAPI.md#apiv3delayprofilereorderidput) | **PUT** /api/v3/delayprofile/reorder/{id} | 


# **apiV3DelayprofileGet**
```swift
    open class func apiV3DelayprofileGet(completion: @escaping (_ data: [DelayProfileResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrDelayProfileAPI.apiV3DelayprofileGet() { (response, error) in
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

[**[DelayProfileResource]**](DelayProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DelayprofileIdDelete**
```swift
    open class func apiV3DelayprofileIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrDelayProfileAPI.apiV3DelayprofileIdDelete(id: id) { (response, error) in
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

# **apiV3DelayprofileIdGet**
```swift
    open class func apiV3DelayprofileIdGet(id: Int, completion: @escaping (_ data: DelayProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrDelayProfileAPI.apiV3DelayprofileIdGet(id: id) { (response, error) in
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

[**DelayProfileResource**](DelayProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DelayprofileIdPut**
```swift
    open class func apiV3DelayprofileIdPut(id: String, delayProfileResource: DelayProfileResource? = nil, completion: @escaping (_ data: DelayProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let delayProfileResource = DelayProfileResource(id: 123, enableUsenet: false, enableTorrent: false, preferredProtocol: DownloadProtocol(), usenetDelay: 123, torrentDelay: 123, bypassIfHighestQuality: false, bypassIfAboveCustomFormatScore: false, minimumCustomFormatScore: 123, order: 123, tags: [123]) // DelayProfileResource |  (optional)

RadarrDelayProfileAPI.apiV3DelayprofileIdPut(id: id, delayProfileResource: delayProfileResource) { (response, error) in
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
 **delayProfileResource** | [**DelayProfileResource**](DelayProfileResource.md) |  | [optional] 

### Return type

[**DelayProfileResource**](DelayProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DelayprofilePost**
```swift
    open class func apiV3DelayprofilePost(delayProfileResource: DelayProfileResource? = nil, completion: @escaping (_ data: DelayProfileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let delayProfileResource = DelayProfileResource(id: 123, enableUsenet: false, enableTorrent: false, preferredProtocol: DownloadProtocol(), usenetDelay: 123, torrentDelay: 123, bypassIfHighestQuality: false, bypassIfAboveCustomFormatScore: false, minimumCustomFormatScore: 123, order: 123, tags: [123]) // DelayProfileResource |  (optional)

RadarrDelayProfileAPI.apiV3DelayprofilePost(delayProfileResource: delayProfileResource) { (response, error) in
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
 **delayProfileResource** | [**DelayProfileResource**](DelayProfileResource.md) |  | [optional] 

### Return type

[**DelayProfileResource**](DelayProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3DelayprofileReorderIdPut**
```swift
    open class func apiV3DelayprofileReorderIdPut(id: Int, after: Int? = nil, completion: @escaping (_ data: [DelayProfileResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 
let after = 987 // Int |  (optional)

RadarrDelayProfileAPI.apiV3DelayprofileReorderIdPut(id: id, after: after) { (response, error) in
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
 **after** | **Int** |  | [optional] 

### Return type

[**[DelayProfileResource]**](DelayProfileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

