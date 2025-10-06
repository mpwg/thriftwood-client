# RadarrCollectionAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3CollectionGet**](RadarrCollectionAPI.md#apiv3collectionget) | **GET** /api/v3/collection | 
[**apiV3CollectionIdGet**](RadarrCollectionAPI.md#apiv3collectionidget) | **GET** /api/v3/collection/{id} | 
[**apiV3CollectionIdPut**](RadarrCollectionAPI.md#apiv3collectionidput) | **PUT** /api/v3/collection/{id} | 
[**apiV3CollectionPut**](RadarrCollectionAPI.md#apiv3collectionput) | **PUT** /api/v3/collection | 


# **apiV3CollectionGet**
```swift
    open class func apiV3CollectionGet(tmdbId: Int? = nil, completion: @escaping (_ data: [CollectionResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let tmdbId = 987 // Int |  (optional)

RadarrCollectionAPI.apiV3CollectionGet(tmdbId: tmdbId) { (response, error) in
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

[**[CollectionResource]**](CollectionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CollectionIdGet**
```swift
    open class func apiV3CollectionIdGet(id: Int, completion: @escaping (_ data: CollectionResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrCollectionAPI.apiV3CollectionIdGet(id: id) { (response, error) in
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

[**CollectionResource**](CollectionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CollectionIdPut**
```swift
    open class func apiV3CollectionIdPut(id: String, collectionResource: CollectionResource? = nil, completion: @escaping (_ data: CollectionResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let collectionResource = CollectionResource(id: 123, title: "title_example", sortTitle: "sortTitle_example", tmdbId: 123, images: [MediaCover(coverType: MediaCoverTypes(), url: "url_example", remoteUrl: "remoteUrl_example")], overview: "overview_example", monitored: false, rootFolderPath: "rootFolderPath_example", qualityProfileId: 123, searchOnAdd: false, minimumAvailability: MovieStatusType(), movies: [CollectionMovieResource(tmdbId: 123, imdbId: "imdbId_example", title: "title_example", cleanTitle: "cleanTitle_example", sortTitle: "sortTitle_example", status: nil, overview: "overview_example", runtime: 123, images: [nil], year: 123, ratings: Ratings(imdb: RatingChild(votes: 123, value: 123, type: RatingType()), tmdb: nil, metacritic: nil, rottenTomatoes: nil, trakt: nil), genres: ["genres_example"], folder: "folder_example", isExisting: false, isExcluded: false)], missingMovies: 123, tags: [123]) // CollectionResource |  (optional)

RadarrCollectionAPI.apiV3CollectionIdPut(id: id, collectionResource: collectionResource) { (response, error) in
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
 **collectionResource** | [**CollectionResource**](CollectionResource.md) |  | [optional] 

### Return type

[**CollectionResource**](CollectionResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3CollectionPut**
```swift
    open class func apiV3CollectionPut(collectionUpdateResource: CollectionUpdateResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let collectionUpdateResource = CollectionUpdateResource(collectionIds: [123], monitored: false, monitorMovies: false, searchOnAdd: false, qualityProfileId: 123, rootFolderPath: "rootFolderPath_example", minimumAvailability: MovieStatusType()) // CollectionUpdateResource |  (optional)

RadarrCollectionAPI.apiV3CollectionPut(collectionUpdateResource: collectionUpdateResource) { (response, error) in
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
 **collectionUpdateResource** | [**CollectionUpdateResource**](CollectionUpdateResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

