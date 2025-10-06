# RadarrRenameMovieAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3RenameGet**](RadarrRenameMovieAPI.md#apiv3renameget) | **GET** /api/v3/rename | 


# **apiV3RenameGet**
```swift
    open class func apiV3RenameGet(movieId: [Int]? = nil, completion: @escaping (_ data: [RenameMovieResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = [123] // [Int] |  (optional)

RadarrRenameMovieAPI.apiV3RenameGet(movieId: movieId) { (response, error) in
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
 **movieId** | [**[Int]**](Int.md) |  | [optional] 

### Return type

[**[RenameMovieResource]**](RenameMovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

