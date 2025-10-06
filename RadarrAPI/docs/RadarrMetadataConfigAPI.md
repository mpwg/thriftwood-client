# RadarrMetadataConfigAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ConfigMetadataGet**](RadarrMetadataConfigAPI.md#apiv3configmetadataget) | **GET** /api/v3/config/metadata | 
[**apiV3ConfigMetadataIdGet**](RadarrMetadataConfigAPI.md#apiv3configmetadataidget) | **GET** /api/v3/config/metadata/{id} | 
[**apiV3ConfigMetadataIdPut**](RadarrMetadataConfigAPI.md#apiv3configmetadataidput) | **PUT** /api/v3/config/metadata/{id} | 


# **apiV3ConfigMetadataGet**
```swift
    open class func apiV3ConfigMetadataGet(completion: @escaping (_ data: MetadataConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrMetadataConfigAPI.apiV3ConfigMetadataGet() { (response, error) in
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

[**MetadataConfigResource**](MetadataConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigMetadataIdGet**
```swift
    open class func apiV3ConfigMetadataIdGet(id: Int, completion: @escaping (_ data: MetadataConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrMetadataConfigAPI.apiV3ConfigMetadataIdGet(id: id) { (response, error) in
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

[**MetadataConfigResource**](MetadataConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigMetadataIdPut**
```swift
    open class func apiV3ConfigMetadataIdPut(id: String, metadataConfigResource: MetadataConfigResource? = nil, completion: @escaping (_ data: MetadataConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let metadataConfigResource = MetadataConfigResource(id: 123, certificationCountry: TMDbCountryCode()) // MetadataConfigResource |  (optional)

RadarrMetadataConfigAPI.apiV3ConfigMetadataIdPut(id: id, metadataConfigResource: metadataConfigResource) { (response, error) in
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
 **metadataConfigResource** | [**MetadataConfigResource**](MetadataConfigResource.md) |  | [optional] 

### Return type

[**MetadataConfigResource**](MetadataConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

