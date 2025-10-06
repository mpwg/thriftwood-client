# RadarrMovieLookupAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3MovieLookupGet**](RadarrMovieLookupAPI.md#apiv3movielookupget) | **GET** /api/v3/movie/lookup | 
[**apiV3MovieLookupImdbGet**](RadarrMovieLookupAPI.md#apiv3movielookupimdbget) | **GET** /api/v3/movie/lookup/imdb | 
[**apiV3MovieLookupTmdbGet**](RadarrMovieLookupAPI.md#apiv3movielookuptmdbget) | **GET** /api/v3/movie/lookup/tmdb | 


# **apiV3MovieLookupGet**
```swift
    open class func apiV3MovieLookupGet(term: String? = nil, completion: @escaping (_ data: [MovieResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let term = "term_example" // String |  (optional)

RadarrMovieLookupAPI.apiV3MovieLookupGet(term: term) { (response, error) in
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
 **term** | **String** |  | [optional] 

### Return type

[**[MovieResource]**](MovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MovieLookupImdbGet**
```swift
    open class func apiV3MovieLookupImdbGet(imdbId: String? = nil, completion: @escaping (_ data: MovieResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let imdbId = "imdbId_example" // String |  (optional)

RadarrMovieLookupAPI.apiV3MovieLookupImdbGet(imdbId: imdbId) { (response, error) in
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
 **imdbId** | **String** |  | [optional] 

### Return type

[**MovieResource**](MovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MovieLookupTmdbGet**
```swift
    open class func apiV3MovieLookupTmdbGet(tmdbId: Int? = nil, completion: @escaping (_ data: MovieResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let tmdbId = 987 // Int |  (optional)

RadarrMovieLookupAPI.apiV3MovieLookupTmdbGet(tmdbId: tmdbId) { (response, error) in
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
 **tmdbId** | **Int** |  | [optional] 

### Return type

[**MovieResource**](MovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

