# RadarrMovieFileAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3MoviefileBulkDelete**](RadarrMovieFileAPI.md#apiv3moviefilebulkdelete) | **DELETE** /api/v3/moviefile/bulk | 
[**apiV3MoviefileBulkPut**](RadarrMovieFileAPI.md#apiv3moviefilebulkput) | **PUT** /api/v3/moviefile/bulk | 
[**apiV3MoviefileEditorPut**](RadarrMovieFileAPI.md#apiv3moviefileeditorput) | **PUT** /api/v3/moviefile/editor | 
[**apiV3MoviefileGet**](RadarrMovieFileAPI.md#apiv3moviefileget) | **GET** /api/v3/moviefile | 
[**apiV3MoviefileIdDelete**](RadarrMovieFileAPI.md#apiv3moviefileiddelete) | **DELETE** /api/v3/moviefile/{id} | 
[**apiV3MoviefileIdGet**](RadarrMovieFileAPI.md#apiv3moviefileidget) | **GET** /api/v3/moviefile/{id} | 
[**apiV3MoviefileIdPut**](RadarrMovieFileAPI.md#apiv3moviefileidput) | **PUT** /api/v3/moviefile/{id} | 


# **apiV3MoviefileBulkDelete**
```swift
    open class func apiV3MoviefileBulkDelete(movieFileListResource: MovieFileListResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieFileListResource = MovieFileListResource(movieFileIds: [123], languages: [Language(id: 123, name: "name_example")], quality: QualityModel(quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), revision: Revision(version: 123, real: 123, isRepack: false)), edition: "edition_example", releaseGroup: "releaseGroup_example", sceneName: "sceneName_example", indexerFlags: 123) // MovieFileListResource |  (optional)

RadarrMovieFileAPI.apiV3MoviefileBulkDelete(movieFileListResource: movieFileListResource) { (response, error) in
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
 **movieFileListResource** | [**MovieFileListResource**](MovieFileListResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MoviefileBulkPut**
```swift
    open class func apiV3MoviefileBulkPut(movieFileResource: [MovieFileResource]? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieFileResource = [MovieFileResource(id: 123, movieId: 123, relativePath: "relativePath_example", path: "path_example", size: 123, dateAdded: Date(), sceneName: "sceneName_example", releaseGroup: "releaseGroup_example", edition: "edition_example", languages: [Language(id: 123, name: "name_example")], quality: QualityModel(quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), revision: Revision(version: 123, real: 123, isRepack: false)), customFormats: [CustomFormatResource(id: 123, name: "name_example", includeCustomFormatWhenRenaming: false, specifications: [CustomFormatSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", infoLink: "infoLink_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], presets: [nil])])], customFormatScore: 123, indexerFlags: 123, mediaInfo: MediaInfoResource(id: 123, audioBitrate: 123, audioChannels: 123, audioCodec: "audioCodec_example", audioLanguages: "audioLanguages_example", audioStreamCount: 123, videoBitDepth: 123, videoBitrate: 123, videoCodec: "videoCodec_example", videoFps: 123, videoDynamicRange: "videoDynamicRange_example", videoDynamicRangeType: "videoDynamicRangeType_example", resolution: "resolution_example", runTime: "runTime_example", scanType: "scanType_example", subtitles: "subtitles_example"), originalFilePath: "originalFilePath_example", qualityCutoffNotMet: false)] // [MovieFileResource] |  (optional)

RadarrMovieFileAPI.apiV3MoviefileBulkPut(movieFileResource: movieFileResource) { (response, error) in
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
 **movieFileResource** | [**[MovieFileResource]**](MovieFileResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MoviefileEditorPut**
```swift
    open class func apiV3MoviefileEditorPut(movieFileListResource: MovieFileListResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieFileListResource = MovieFileListResource(movieFileIds: [123], languages: [Language(id: 123, name: "name_example")], quality: QualityModel(quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), revision: Revision(version: 123, real: 123, isRepack: false)), edition: "edition_example", releaseGroup: "releaseGroup_example", sceneName: "sceneName_example", indexerFlags: 123) // MovieFileListResource |  (optional)

RadarrMovieFileAPI.apiV3MoviefileEditorPut(movieFileListResource: movieFileListResource) { (response, error) in
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
 **movieFileListResource** | [**MovieFileListResource**](MovieFileListResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MoviefileGet**
```swift
    open class func apiV3MoviefileGet(movieId: [Int]? = nil, movieFileIds: [Int]? = nil, completion: @escaping (_ data: [MovieFileResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = [123] // [Int] |  (optional)
let movieFileIds = [123] // [Int] |  (optional)

RadarrMovieFileAPI.apiV3MoviefileGet(movieId: movieId, movieFileIds: movieFileIds) { (response, error) in
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
 **movieFileIds** | [**[Int]**](Int.md) |  | [optional] 

### Return type

[**[MovieFileResource]**](MovieFileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MoviefileIdDelete**
```swift
    open class func apiV3MoviefileIdDelete(id: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrMovieFileAPI.apiV3MoviefileIdDelete(id: id) { (response, error) in
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

# **apiV3MoviefileIdGet**
```swift
    open class func apiV3MoviefileIdGet(id: Int, completion: @escaping (_ data: MovieFileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrMovieFileAPI.apiV3MoviefileIdGet(id: id) { (response, error) in
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

[**MovieFileResource**](MovieFileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MoviefileIdPut**
```swift
    open class func apiV3MoviefileIdPut(id: String, movieFileResource: MovieFileResource? = nil, completion: @escaping (_ data: MovieFileResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let movieFileResource = MovieFileResource(id: 123, movieId: 123, relativePath: "relativePath_example", path: "path_example", size: 123, dateAdded: Date(), sceneName: "sceneName_example", releaseGroup: "releaseGroup_example", edition: "edition_example", languages: [Language(id: 123, name: "name_example")], quality: QualityModel(quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), revision: Revision(version: 123, real: 123, isRepack: false)), customFormats: [CustomFormatResource(id: 123, name: "name_example", includeCustomFormatWhenRenaming: false, specifications: [CustomFormatSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", infoLink: "infoLink_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], presets: [nil])])], customFormatScore: 123, indexerFlags: 123, mediaInfo: MediaInfoResource(id: 123, audioBitrate: 123, audioChannels: 123, audioCodec: "audioCodec_example", audioLanguages: "audioLanguages_example", audioStreamCount: 123, videoBitDepth: 123, videoBitrate: 123, videoCodec: "videoCodec_example", videoFps: 123, videoDynamicRange: "videoDynamicRange_example", videoDynamicRangeType: "videoDynamicRangeType_example", resolution: "resolution_example", runTime: "runTime_example", scanType: "scanType_example", subtitles: "subtitles_example"), originalFilePath: "originalFilePath_example", qualityCutoffNotMet: false) // MovieFileResource |  (optional)

RadarrMovieFileAPI.apiV3MoviefileIdPut(id: id, movieFileResource: movieFileResource) { (response, error) in
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
 **movieFileResource** | [**MovieFileResource**](MovieFileResource.md) |  | [optional] 

### Return type

[**MovieFileResource**](MovieFileResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

