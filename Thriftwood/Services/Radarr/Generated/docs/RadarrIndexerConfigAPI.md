# RadarrIndexerConfigAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ConfigIndexerGet**](RadarrIndexerConfigAPI.md#apiv3configindexerget) | **GET** /api/v3/config/indexer | 
[**apiV3ConfigIndexerIdGet**](RadarrIndexerConfigAPI.md#apiv3configindexeridget) | **GET** /api/v3/config/indexer/{id} | 
[**apiV3ConfigIndexerIdPut**](RadarrIndexerConfigAPI.md#apiv3configindexeridput) | **PUT** /api/v3/config/indexer/{id} | 


# **apiV3ConfigIndexerGet**
```swift
    open class func apiV3ConfigIndexerGet(completion: @escaping (_ data: IndexerConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrIndexerConfigAPI.apiV3ConfigIndexerGet() { (response, error) in
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

[**IndexerConfigResource**](IndexerConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigIndexerIdGet**
```swift
    open class func apiV3ConfigIndexerIdGet(id: Int, completion: @escaping (_ data: IndexerConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrIndexerConfigAPI.apiV3ConfigIndexerIdGet(id: id) { (response, error) in
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

[**IndexerConfigResource**](IndexerConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigIndexerIdPut**
```swift
    open class func apiV3ConfigIndexerIdPut(id: String, indexerConfigResource: IndexerConfigResource? = nil, completion: @escaping (_ data: IndexerConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let indexerConfigResource = IndexerConfigResource(id: 123, minimumAge: 123, maximumSize: 123, retention: 123, rssSyncInterval: 123, preferIndexerFlags: false, availabilityDelay: 123, allowHardcodedSubs: false, whitelistedHardcodedSubs: "whitelistedHardcodedSubs_example") // IndexerConfigResource |  (optional)

RadarrIndexerConfigAPI.apiV3ConfigIndexerIdPut(id: id, indexerConfigResource: indexerConfigResource) { (response, error) in
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
 **indexerConfigResource** | [**IndexerConfigResource**](IndexerConfigResource.md) |  | [optional] 

### Return type

[**IndexerConfigResource**](IndexerConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

