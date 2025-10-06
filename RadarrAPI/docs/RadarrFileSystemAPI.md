# RadarrFileSystemAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3FilesystemGet**](RadarrFileSystemAPI.md#apiv3filesystemget) | **GET** /api/v3/filesystem | 
[**apiV3FilesystemMediafilesGet**](RadarrFileSystemAPI.md#apiv3filesystemmediafilesget) | **GET** /api/v3/filesystem/mediafiles | 
[**apiV3FilesystemTypeGet**](RadarrFileSystemAPI.md#apiv3filesystemtypeget) | **GET** /api/v3/filesystem/type | 


# **apiV3FilesystemGet**
```swift
    open class func apiV3FilesystemGet(path: String? = nil, includeFiles: Bool? = nil, allowFoldersWithoutTrailingSlashes: Bool? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let path = "path_example" // String |  (optional)
let includeFiles = true // Bool |  (optional) (default to false)
let allowFoldersWithoutTrailingSlashes = true // Bool |  (optional) (default to false)

RadarrFileSystemAPI.apiV3FilesystemGet(path: path, includeFiles: includeFiles, allowFoldersWithoutTrailingSlashes: allowFoldersWithoutTrailingSlashes) { (response, error) in
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
 **path** | **String** |  | [optional] 
 **includeFiles** | **Bool** |  | [optional] [default to false]
 **allowFoldersWithoutTrailingSlashes** | **Bool** |  | [optional] [default to false]

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3FilesystemMediafilesGet**
```swift
    open class func apiV3FilesystemMediafilesGet(path: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let path = "path_example" // String |  (optional)

RadarrFileSystemAPI.apiV3FilesystemMediafilesGet(path: path) { (response, error) in
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
 **path** | **String** |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3FilesystemTypeGet**
```swift
    open class func apiV3FilesystemTypeGet(path: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let path = "path_example" // String |  (optional)

RadarrFileSystemAPI.apiV3FilesystemTypeGet(path: path) { (response, error) in
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
 **path** | **String** |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

