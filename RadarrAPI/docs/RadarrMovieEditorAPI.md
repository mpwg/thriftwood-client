# RadarrMovieEditorAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3MovieEditorDelete**](RadarrMovieEditorAPI.md#apiv3movieeditordelete) | **DELETE** /api/v3/movie/editor | 
[**apiV3MovieEditorPut**](RadarrMovieEditorAPI.md#apiv3movieeditorput) | **PUT** /api/v3/movie/editor | 


# **apiV3MovieEditorDelete**
```swift
    open class func apiV3MovieEditorDelete(movieEditorResource: MovieEditorResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieEditorResource = MovieEditorResource(movieIds: [123], monitored: false, qualityProfileId: 123, minimumAvailability: MovieStatusType(), rootFolderPath: "rootFolderPath_example", tags: [123], applyTags: ApplyTags(), moveFiles: false, deleteFiles: false, addImportExclusion: false) // MovieEditorResource |  (optional)

RadarrMovieEditorAPI.apiV3MovieEditorDelete(movieEditorResource: movieEditorResource) { (response, error) in
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
 **movieEditorResource** | [**MovieEditorResource**](MovieEditorResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MovieEditorPut**
```swift
    open class func apiV3MovieEditorPut(movieEditorResource: MovieEditorResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieEditorResource = MovieEditorResource(movieIds: [123], monitored: false, qualityProfileId: 123, minimumAvailability: MovieStatusType(), rootFolderPath: "rootFolderPath_example", tags: [123], applyTags: ApplyTags(), moveFiles: false, deleteFiles: false, addImportExclusion: false) // MovieEditorResource |  (optional)

RadarrMovieEditorAPI.apiV3MovieEditorPut(movieEditorResource: movieEditorResource) { (response, error) in
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
 **movieEditorResource** | [**MovieEditorResource**](MovieEditorResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

