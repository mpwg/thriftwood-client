# RadarrReleaseAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3ReleaseGet**](RadarrReleaseAPI.md#apiv3releaseget) | **GET** /api/v3/release | 
[**apiV3ReleasePost**](RadarrReleaseAPI.md#apiv3releasepost) | **POST** /api/v3/release | 


# **apiV3ReleaseGet**
```swift
    open class func apiV3ReleaseGet(movieId: Int? = nil, completion: @escaping (_ data: [ReleaseResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieId = 987 // Int |  (optional)

RadarrReleaseAPI.apiV3ReleaseGet(movieId: movieId) { (response, error) in
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
 **movieId** | **Int** |  | [optional] 

### Return type

[**[ReleaseResource]**](ReleaseResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3ReleasePost**
```swift
    open class func apiV3ReleasePost(releaseResource: ReleaseResource? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let releaseResource = ReleaseResource(id: 123, guid: "guid_example", quality: QualityModel(quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), revision: Revision(version: 123, real: 123, isRepack: false)), customFormats: [CustomFormatResource(id: 123, name: "name_example", includeCustomFormatWhenRenaming: false, specifications: [CustomFormatSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", infoLink: "infoLink_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], presets: [nil])])], customFormatScore: 123, qualityWeight: 123, age: 123, ageHours: 123, ageMinutes: 123, size: 123, indexerId: 123, indexer: "indexer_example", releaseGroup: "releaseGroup_example", subGroup: "subGroup_example", releaseHash: "releaseHash_example", title: "title_example", sceneSource: false, movieTitles: ["movieTitles_example"], languages: [Language(id: 123, name: "name_example")], mappedMovieId: 123, approved: false, temporarilyRejected: false, rejected: false, tmdbId: 123, imdbId: 123, rejections: ["rejections_example"], publishDate: Date(), commentUrl: "commentUrl_example", downloadUrl: "downloadUrl_example", infoUrl: "infoUrl_example", movieRequested: false, downloadAllowed: false, releaseWeight: 123, edition: "edition_example", magnetUrl: "magnetUrl_example", infoHash: "infoHash_example", seeders: 123, leechers: 123, _protocol: DownloadProtocol(), indexerFlags: 123, movieId: 123, downloadClientId: 123, downloadClient: "downloadClient_example", shouldOverride: false) // ReleaseResource |  (optional)

RadarrReleaseAPI.apiV3ReleasePost(releaseResource: releaseResource) { (response, error) in
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
 **releaseResource** | [**ReleaseResource**](ReleaseResource.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

