# RadarrMediaManagementConfigAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ConfigMediamanagementGet**](RadarrMediaManagementConfigAPI.md#apiv3configmediamanagementget) | **GET** /api/v3/config/mediamanagement | 
[**apiV3ConfigMediamanagementIdGet**](RadarrMediaManagementConfigAPI.md#apiv3configmediamanagementidget) | **GET** /api/v3/config/mediamanagement/{id} | 
[**apiV3ConfigMediamanagementIdPut**](RadarrMediaManagementConfigAPI.md#apiv3configmediamanagementidput) | **PUT** /api/v3/config/mediamanagement/{id} | 


# **apiV3ConfigMediamanagementGet**
```swift
    open class func apiV3ConfigMediamanagementGet(completion: @escaping (_ data: MediaManagementConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrMediaManagementConfigAPI.apiV3ConfigMediamanagementGet() { (response, error) in
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

[**MediaManagementConfigResource**](MediaManagementConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigMediamanagementIdGet**
```swift
    open class func apiV3ConfigMediamanagementIdGet(id: Int, completion: @escaping (_ data: MediaManagementConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrMediaManagementConfigAPI.apiV3ConfigMediamanagementIdGet(id: id) { (response, error) in
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

[**MediaManagementConfigResource**](MediaManagementConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigMediamanagementIdPut**
```swift
    open class func apiV3ConfigMediamanagementIdPut(id: String, mediaManagementConfigResource: MediaManagementConfigResource? = nil, completion: @escaping (_ data: MediaManagementConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let mediaManagementConfigResource = MediaManagementConfigResource(id: 123, autoUnmonitorPreviouslyDownloadedMovies: false, recycleBin: "recycleBin_example", recycleBinCleanupDays: 123, downloadPropersAndRepacks: ProperDownloadTypes(), createEmptyMovieFolders: false, deleteEmptyFolders: false, fileDate: FileDateType(), rescanAfterRefresh: RescanAfterRefreshType(), autoRenameFolders: false, pathsDefaultStatic: false, setPermissionsLinux: false, chmodFolder: "chmodFolder_example", chownGroup: "chownGroup_example", skipFreeSpaceCheckWhenImporting: false, minimumFreeSpaceWhenImporting: 123, copyUsingHardlinks: false, useScriptImport: false, scriptImportPath: "scriptImportPath_example", importExtraFiles: false, extraFileExtensions: "extraFileExtensions_example", enableMediaInfo: false) // MediaManagementConfigResource |  (optional)

RadarrMediaManagementConfigAPI.apiV3ConfigMediamanagementIdPut(id: id, mediaManagementConfigResource: mediaManagementConfigResource) { (response, error) in
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
 **mediaManagementConfigResource** | [**MediaManagementConfigResource**](MediaManagementConfigResource.md) |  | [optional] 

### Return type

[**MediaManagementConfigResource**](MediaManagementConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

