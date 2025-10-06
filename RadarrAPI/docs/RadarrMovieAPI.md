# RadarrMovieAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3MovieGet**](RadarrMovieAPI.md#apiv3movieget) | **GET** /api/v3/movie | 
[**apiV3MovieIdDelete**](RadarrMovieAPI.md#apiv3movieiddelete) | **DELETE** /api/v3/movie/{id} | 
[**apiV3MovieIdGet**](RadarrMovieAPI.md#apiv3movieidget) | **GET** /api/v3/movie/{id} | 
[**apiV3MovieIdPut**](RadarrMovieAPI.md#apiv3movieidput) | **PUT** /api/v3/movie/{id} | 
[**apiV3MoviePost**](RadarrMovieAPI.md#apiv3moviepost) | **POST** /api/v3/movie | 


# **apiV3MovieGet**
```swift
    open class func apiV3MovieGet(tmdbId: Int? = nil, excludeLocalCovers: Bool? = nil, languageId: Int? = nil, completion: @escaping (_ data: [MovieResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let tmdbId = 987 // Int |  (optional)
let excludeLocalCovers = true // Bool |  (optional) (default to false)
let languageId = 987 // Int |  (optional)

RadarrMovieAPI.apiV3MovieGet(tmdbId: tmdbId, excludeLocalCovers: excludeLocalCovers, languageId: languageId) { (response, error) in
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
 **excludeLocalCovers** | **Bool** |  | [optional] [default to false]
 **languageId** | **Int** |  | [optional] 

### Return type

[**[MovieResource]**](MovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MovieIdDelete**
```swift
    open class func apiV3MovieIdDelete(id: Int, deleteFiles: Bool? = nil, addImportExclusion: Bool? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 
let deleteFiles = true // Bool |  (optional) (default to false)
let addImportExclusion = true // Bool |  (optional) (default to false)

RadarrMovieAPI.apiV3MovieIdDelete(id: id, deleteFiles: deleteFiles, addImportExclusion: addImportExclusion) { (response, error) in
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
 **deleteFiles** | **Bool** |  | [optional] [default to false]
 **addImportExclusion** | **Bool** |  | [optional] [default to false]

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MovieIdGet**
```swift
    open class func apiV3MovieIdGet(id: Int, completion: @escaping (_ data: MovieResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = 987 // Int | 

RadarrMovieAPI.apiV3MovieIdGet(id: id) { (response, error) in
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

[**MovieResource**](MovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MovieIdPut**
```swift
    open class func apiV3MovieIdPut(id: String, moveFiles: Bool? = nil, movieResource: MovieResource? = nil, completion: @escaping (_ data: MovieResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let id = "id_example" // String | 
let moveFiles = true // Bool |  (optional) (default to false)
let movieResource = MovieResource(id: 123, title: "title_example", originalTitle: "originalTitle_example", originalLanguage: Language(id: 123, name: "name_example"), alternateTitles: [AlternativeTitleResource(id: 123, sourceType: SourceType(), movieMetadataId: 123, title: "title_example", cleanTitle: "cleanTitle_example")], secondaryYear: 123, secondaryYearSourceId: 123, sortTitle: "sortTitle_example", sizeOnDisk: 123, status: MovieStatusType(), overview: "overview_example", inCinemas: Date(), physicalRelease: Date(), digitalRelease: Date(), releaseDate: Date(), physicalReleaseNote: "physicalReleaseNote_example", images: [MediaCover(coverType: MediaCoverTypes(), url: "url_example", remoteUrl: "remoteUrl_example")], website: "website_example", remotePoster: "remotePoster_example", year: 123, youTubeTrailerId: "youTubeTrailerId_example", studio: "studio_example", path: "path_example", qualityProfileId: 123, hasFile: false, movieFileId: 123, monitored: false, minimumAvailability: nil, isAvailable: false, folderName: "folderName_example", runtime: 123, cleanTitle: "cleanTitle_example", imdbId: "imdbId_example", tmdbId: 123, titleSlug: "titleSlug_example", rootFolderPath: "rootFolderPath_example", folder: "folder_example", certification: "certification_example", genres: ["genres_example"], keywords: ["keywords_example"], tags: [123], added: Date(), addOptions: AddMovieOptions(ignoreEpisodesWithFiles: false, ignoreEpisodesWithoutFiles: false, monitor: MonitorTypes(), searchForMovie: false, addMethod: AddMovieMethod()), ratings: Ratings(imdb: RatingChild(votes: 123, value: 123, type: RatingType()), tmdb: nil, metacritic: nil, rottenTomatoes: nil, trakt: nil), movieFile: MovieFileResource(id: 123, movieId: 123, relativePath: "relativePath_example", path: "path_example", size: 123, dateAdded: Date(), sceneName: "sceneName_example", releaseGroup: "releaseGroup_example", edition: "edition_example", languages: [nil], quality: QualityModel(quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), revision: Revision(version: 123, real: 123, isRepack: false)), customFormats: [CustomFormatResource(id: 123, name: "name_example", includeCustomFormatWhenRenaming: false, specifications: [CustomFormatSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", infoLink: "infoLink_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], presets: [nil])])], customFormatScore: 123, indexerFlags: 123, mediaInfo: MediaInfoResource(id: 123, audioBitrate: 123, audioChannels: 123, audioCodec: "audioCodec_example", audioLanguages: "audioLanguages_example", audioStreamCount: 123, videoBitDepth: 123, videoBitrate: 123, videoCodec: "videoCodec_example", videoFps: 123, videoDynamicRange: "videoDynamicRange_example", videoDynamicRangeType: "videoDynamicRangeType_example", resolution: "resolution_example", runTime: "runTime_example", scanType: "scanType_example", subtitles: "subtitles_example"), originalFilePath: "originalFilePath_example", qualityCutoffNotMet: false), collection: MovieCollectionResource(title: "title_example", tmdbId: 123), popularity: 123, lastSearchTime: Date(), statistics: MovieStatisticsResource(movieFileCount: 123, sizeOnDisk: 123, releaseGroups: ["releaseGroups_example"])) // MovieResource |  (optional)

RadarrMovieAPI.apiV3MovieIdPut(id: id, moveFiles: moveFiles, movieResource: movieResource) { (response, error) in
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
 **moveFiles** | **Bool** |  | [optional] [default to false]
 **movieResource** | [**MovieResource**](MovieResource.md) |  | [optional] 

### Return type

[**MovieResource**](MovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV3MoviePost**
```swift
    open class func apiV3MoviePost(movieResource: MovieResource? = nil, completion: @escaping (_ data: MovieResource?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let movieResource = MovieResource(id: 123, title: "title_example", originalTitle: "originalTitle_example", originalLanguage: Language(id: 123, name: "name_example"), alternateTitles: [AlternativeTitleResource(id: 123, sourceType: SourceType(), movieMetadataId: 123, title: "title_example", cleanTitle: "cleanTitle_example")], secondaryYear: 123, secondaryYearSourceId: 123, sortTitle: "sortTitle_example", sizeOnDisk: 123, status: MovieStatusType(), overview: "overview_example", inCinemas: Date(), physicalRelease: Date(), digitalRelease: Date(), releaseDate: Date(), physicalReleaseNote: "physicalReleaseNote_example", images: [MediaCover(coverType: MediaCoverTypes(), url: "url_example", remoteUrl: "remoteUrl_example")], website: "website_example", remotePoster: "remotePoster_example", year: 123, youTubeTrailerId: "youTubeTrailerId_example", studio: "studio_example", path: "path_example", qualityProfileId: 123, hasFile: false, movieFileId: 123, monitored: false, minimumAvailability: nil, isAvailable: false, folderName: "folderName_example", runtime: 123, cleanTitle: "cleanTitle_example", imdbId: "imdbId_example", tmdbId: 123, titleSlug: "titleSlug_example", rootFolderPath: "rootFolderPath_example", folder: "folder_example", certification: "certification_example", genres: ["genres_example"], keywords: ["keywords_example"], tags: [123], added: Date(), addOptions: AddMovieOptions(ignoreEpisodesWithFiles: false, ignoreEpisodesWithoutFiles: false, monitor: MonitorTypes(), searchForMovie: false, addMethod: AddMovieMethod()), ratings: Ratings(imdb: RatingChild(votes: 123, value: 123, type: RatingType()), tmdb: nil, metacritic: nil, rottenTomatoes: nil, trakt: nil), movieFile: MovieFileResource(id: 123, movieId: 123, relativePath: "relativePath_example", path: "path_example", size: 123, dateAdded: Date(), sceneName: "sceneName_example", releaseGroup: "releaseGroup_example", edition: "edition_example", languages: [nil], quality: QualityModel(quality: Quality(id: 123, name: "name_example", source: QualitySource(), resolution: 123, modifier: Modifier()), revision: Revision(version: 123, real: 123, isRepack: false)), customFormats: [CustomFormatResource(id: 123, name: "name_example", includeCustomFormatWhenRenaming: false, specifications: [CustomFormatSpecificationSchema(id: 123, name: "name_example", implementation: "implementation_example", implementationName: "implementationName_example", infoLink: "infoLink_example", negate: false, _required: false, fields: [Field(order: 123, name: "name_example", label: "label_example", unit: "unit_example", helpText: "helpText_example", helpTextWarning: "helpTextWarning_example", helpLink: "helpLink_example", value: 123, type: "type_example", advanced: false, selectOptions: [SelectOption(value: 123, name: "name_example", order: 123, hint: "hint_example", dividerAfter: false)], selectOptionsProviderAction: "selectOptionsProviderAction_example", section: "section_example", hidden: "hidden_example", privacy: PrivacyLevel(), placeholder: "placeholder_example", isFloat: false)], presets: [nil])])], customFormatScore: 123, indexerFlags: 123, mediaInfo: MediaInfoResource(id: 123, audioBitrate: 123, audioChannels: 123, audioCodec: "audioCodec_example", audioLanguages: "audioLanguages_example", audioStreamCount: 123, videoBitDepth: 123, videoBitrate: 123, videoCodec: "videoCodec_example", videoFps: 123, videoDynamicRange: "videoDynamicRange_example", videoDynamicRangeType: "videoDynamicRangeType_example", resolution: "resolution_example", runTime: "runTime_example", scanType: "scanType_example", subtitles: "subtitles_example"), originalFilePath: "originalFilePath_example", qualityCutoffNotMet: false), collection: MovieCollectionResource(title: "title_example", tmdbId: 123), popularity: 123, lastSearchTime: Date(), statistics: MovieStatisticsResource(movieFileCount: 123, sizeOnDisk: 123, releaseGroups: ["releaseGroups_example"])) // MovieResource |  (optional)

RadarrMovieAPI.apiV3MoviePost(movieResource: movieResource) { (response, error) in
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
 **movieResource** | [**MovieResource**](MovieResource.md) |  | [optional] 

### Return type

[**MovieResource**](MovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

