# RadarrCalendarFeedAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**feedV3CalendarRadarrIcsGet**](RadarrCalendarFeedAPI.md#feedv3calendarradarricsget) | **GET** /feed/v3/calendar/radarr.ics | 


# **feedV3CalendarRadarrIcsGet**
```swift
    open class func feedV3CalendarRadarrIcsGet(pastDays: Int? = nil, futureDays: Int? = nil, tags: String? = nil, unmonitored: Bool? = nil, releaseTypes: [CalendarReleaseType]? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let pastDays = 987 // Int |  (optional) (default to 7)
let futureDays = 987 // Int |  (optional) (default to 28)
let tags = "tags_example" // String |  (optional) (default to "")
let unmonitored = true // Bool |  (optional) (default to false)
let releaseTypes = [CalendarReleaseType()] // [CalendarReleaseType] |  (optional)

RadarrCalendarFeedAPI.feedV3CalendarRadarrIcsGet(pastDays: pastDays, futureDays: futureDays, tags: tags, unmonitored: unmonitored, releaseTypes: releaseTypes) { (response, error) in
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
 **pastDays** | **Int** |  | [optional] [default to 7]
 **futureDays** | **Int** |  | [optional] [default to 28]
 **tags** | **String** |  | [optional] [default to &quot;&quot;]
 **unmonitored** | **Bool** |  | [optional] [default to false]
 **releaseTypes** | [**[CalendarReleaseType]**](CalendarReleaseType.md) |  | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

