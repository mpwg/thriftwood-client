# RadarrRootFolderAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3RootfolderGet**](RadarrRootFolderAPI.md#apiv3rootfolderget) | **GET** /api/v3/rootfolder | 
[**apiV3RootfolderIdDelete**](RadarrRootFolderAPI.md#apiv3rootfolderiddelete) | **DELETE** /api/v3/rootfolder/{id} | 
[**apiV3RootfolderIdGet**](RadarrRootFolderAPI.md#apiv3rootfolderidget) | **GET** /api/v3/rootfolder/{id} | 
[**apiV3RootfolderPost**](RadarrRootFolderAPI.md#apiv3rootfolderpost) | **POST** /api/v3/rootfolder | 


# **apiV3RootfolderGet**
```swift
    open class func apiV3RootfolderGet(completion: @escaping (_ data: [RootFolderResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrRootFolderAPI.apiV3RootfolderGet() { (response, error) in
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

[**[RootFolderResource]**](RootFolderResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3RootfolderIdDelete**
```swift
    open class func apiV3RootfolderIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrRootFolderAPI.apiV3RootfolderIdDelete(id: id) { (response, error) in
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

# **apiV3RootfolderIdGet**
```swift
    open class func apiV3RootfolderIdGet(id: Int, completion: @escaping (_ data: RootFolderResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrRootFolderAPI.apiV3RootfolderIdGet(id: id) { (response, error) in
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

[**RootFolderResource**](RootFolderResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3RootfolderPost**
```swift
    open class func apiV3RootfolderPost(rootFolderResource: RootFolderResource? = nil, completion: @escaping (_ data: RootFolderResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let rootFolderResource = RootFolderResource(id: 123, path: "path_example", accessible: false, freeSpace: 123, unmappedFolders: [UnmappedFolder(name: "name_example", path: "path_example", relativePath: "relativePath_example")]) // RootFolderResource |  (optional)

RadarrRootFolderAPI.apiV3RootfolderPost(rootFolderResource: rootFolderResource) { (response, error) in
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
 **rootFolderResource** | [**RootFolderResource**](RootFolderResource.md) |  | [optional] 

### Return type

[**RootFolderResource**](RootFolderResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

