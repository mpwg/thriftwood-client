# RadarrDownloadClientConfigAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ConfigDownloadclientGet**](RadarrDownloadClientConfigAPI.md#apiv3configdownloadclientget) | **GET** /api/v3/config/downloadclient | 
[**apiV3ConfigDownloadclientIdGet**](RadarrDownloadClientConfigAPI.md#apiv3configdownloadclientidget) | **GET** /api/v3/config/downloadclient/{id} | 
[**apiV3ConfigDownloadclientIdPut**](RadarrDownloadClientConfigAPI.md#apiv3configdownloadclientidput) | **PUT** /api/v3/config/downloadclient/{id} | 


# **apiV3ConfigDownloadclientGet**
```swift
    open class func apiV3ConfigDownloadclientGet(completion: @escaping (_ data: DownloadClientConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrDownloadClientConfigAPI.apiV3ConfigDownloadclientGet() { (response, error) in
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

[**DownloadClientConfigResource**](DownloadClientConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigDownloadclientIdGet**
```swift
    open class func apiV3ConfigDownloadclientIdGet(id: Int, completion: @escaping (_ data: DownloadClientConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrDownloadClientConfigAPI.apiV3ConfigDownloadclientIdGet(id: id) { (response, error) in
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

[**DownloadClientConfigResource**](DownloadClientConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigDownloadclientIdPut**
```swift
    open class func apiV3ConfigDownloadclientIdPut(id: String, downloadClientConfigResource: DownloadClientConfigResource? = nil, completion: @escaping (_ data: DownloadClientConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let downloadClientConfigResource = DownloadClientConfigResource(id: 123, downloadClientWorkingFolders: "downloadClientWorkingFolders_example", enableCompletedDownloadHandling: false, checkForFinishedDownloadInterval: 123, autoRedownloadFailed: false, autoRedownloadFailedFromInteractiveSearch: false) // DownloadClientConfigResource |  (optional)

RadarrDownloadClientConfigAPI.apiV3ConfigDownloadclientIdPut(id: id, downloadClientConfigResource: downloadClientConfigResource) { (response, error) in
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
 **downloadClientConfigResource** | [**DownloadClientConfigResource**](DownloadClientConfigResource.md) |  | [optional] 

### Return type

[**DownloadClientConfigResource**](DownloadClientConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

