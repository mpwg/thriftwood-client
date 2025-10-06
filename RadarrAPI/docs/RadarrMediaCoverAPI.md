# RadarrMediaCoverAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3MediacoverMovieIdFilenameGet**](RadarrMediaCoverAPI.md#apiv3mediacovermovieidfilenameget) | **GET** /api/v3/mediacover/{movieId}/{filename} | 


# **apiV3MediacoverMovieIdFilenameGet**
```swift
    open class func apiV3MediacoverMovieIdFilenameGet(movieId: Int, filename: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = 987 // Int | 
let filename = "filename_example" // String | 

RadarrMediaCoverAPI.apiV3MediacoverMovieIdFilenameGet(movieId: movieId, filename: filename) { (response, error) in
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
 **movieId** | **Int** |  | 
 **filename** | **String** |  | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

