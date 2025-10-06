# RadarrNamingConfigAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ConfigNamingExamplesGet**](RadarrNamingConfigAPI.md#apiv3confignamingexamplesget) | **GET** /api/v3/config/naming/examples | 
[**apiV3ConfigNamingGet**](RadarrNamingConfigAPI.md#apiv3confignamingget) | **GET** /api/v3/config/naming | 
[**apiV3ConfigNamingIdGet**](RadarrNamingConfigAPI.md#apiv3confignamingidget) | **GET** /api/v3/config/naming/{id} | 
[**apiV3ConfigNamingIdPut**](RadarrNamingConfigAPI.md#apiv3confignamingidput) | **PUT** /api/v3/config/naming/{id} | 


# **apiV3ConfigNamingExamplesGet**
```swift
    open class func apiV3ConfigNamingExamplesGet(renameMovies: Bool? = nil, replaceIllegalCharacters: Bool? = nil, colonReplacementFormat: ColonReplacementFormat? = nil, standardMovieFormat: String? = nil, movieFolderFormat: String? = nil, id: Int? = nil, resourceName: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let renameMovies = true // Bool |  (optional)
let replaceIllegalCharacters = true // Bool |  (optional)
let colonReplacementFormat = ColonReplacementFormat() // ColonReplacementFormat |  (optional)
let standardMovieFormat = "standardMovieFormat_example" // String |  (optional)
let movieFolderFormat = "movieFolderFormat_example" // String |  (optional)
let id = 987 // Int |  (optional)
let resourceName = "resourceName_example" // String |  (optional)

RadarrNamingConfigAPI.apiV3ConfigNamingExamplesGet(renameMovies: renameMovies, replaceIllegalCharacters: replaceIllegalCharacters, colonReplacementFormat: colonReplacementFormat, standardMovieFormat: standardMovieFormat, movieFolderFormat: movieFolderFormat, id: id, resourceName: resourceName) { (response, error) in
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
 **renameMovies** | **Bool** |  | [optional] 
 **replaceIllegalCharacters** | **Bool** |  | [optional] 
 **colonReplacementFormat** | [**ColonReplacementFormat**](.md) |  | [optional] 
 **standardMovieFormat** | **String** |  | [optional] 
 **movieFolderFormat** | **String** |  | [optional] 
 **id** | **Int** |  | [optional] 
 **resourceName** | **String** |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigNamingGet**
```swift
    open class func apiV3ConfigNamingGet(completion: @escaping (_ data: NamingConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI


RadarrNamingConfigAPI.apiV3ConfigNamingGet() { (response, error) in
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

[**NamingConfigResource**](NamingConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigNamingIdGet**
```swift
    open class func apiV3ConfigNamingIdGet(id: Int, completion: @escaping (_ data: NamingConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrNamingConfigAPI.apiV3ConfigNamingIdGet(id: id) { (response, error) in
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

[**NamingConfigResource**](NamingConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ConfigNamingIdPut**
```swift
    open class func apiV3ConfigNamingIdPut(id: String, namingConfigResource: NamingConfigResource? = nil, completion: @escaping (_ data: NamingConfigResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let namingConfigResource = NamingConfigResource(id: 123, renameMovies: false, replaceIllegalCharacters: false, colonReplacementFormat: ColonReplacementFormat(), standardMovieFormat: "standardMovieFormat_example", movieFolderFormat: "movieFolderFormat_example") // NamingConfigResource |  (optional)

RadarrNamingConfigAPI.apiV3ConfigNamingIdPut(id: id, namingConfigResource: namingConfigResource) { (response, error) in
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
 **namingConfigResource** | [**NamingConfigResource**](NamingConfigResource.md) |  | [optional] 

### Return type

[**NamingConfigResource**](NamingConfigResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

