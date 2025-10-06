# RadarrImportListConfigAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ConfigImportlistGet**](RadarrImportListConfigAPI.md#apiv3configimportlistget) | **GET** /api/v3/config/importlist | 
[**apiV3ConfigImportlistIdGet**](RadarrImportListConfigAPI.md#apiv3configimportlistidget) | **GET** /api/v3/config/importlist/{id} | 
[**apiV3ConfigImportlistIdPut**](RadarrImportListConfigAPI.md#apiv3configimportlistidput) | **PUT** /api/v3/config/importlist/{id} | 


# **apiV3ConfigImportlistGet**
```swift
    open class func apiV3ConfigImportlistGet(completion: @escaping (_ data: ImportListConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrImportListConfigAPI.apiV3ConfigImportlistGet() { (response, error) in
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

[**ImportListConfigResource**](ImportListConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigImportlistIdGet**
```swift
    open class func apiV3ConfigImportlistIdGet(id: Int, completion: @escaping (_ data: ImportListConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrImportListConfigAPI.apiV3ConfigImportlistIdGet(id: id) { (response, error) in
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

[**ImportListConfigResource**](ImportListConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigImportlistIdPut**
```swift
    open class func apiV3ConfigImportlistIdPut(id: String, importListConfigResource: ImportListConfigResource? = nil, completion: @escaping (_ data: ImportListConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let importListConfigResource = ImportListConfigResource(id: 123, listSyncLevel: "listSyncLevel_example") // ImportListConfigResource |  (optional)

RadarrImportListConfigAPI.apiV3ConfigImportlistIdPut(id: id, importListConfigResource: importListConfigResource) { (response, error) in
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
 **importListConfigResource** | [**ImportListConfigResource**](ImportListConfigResource.md) |  | [optional] 

### Return type

[**ImportListConfigResource**](ImportListConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

