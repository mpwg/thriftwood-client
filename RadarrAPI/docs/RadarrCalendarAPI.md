# RadarrCalendarAPI

All URIs are relative to *http://http://localhost:7878*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV3CalendarGet**](RadarrCalendarAPI.md#apiv3calendarget) | **GET** /api/v3/calendar | 


# **apiV3CalendarGet**
```swift
    open class func apiV3CalendarGet(start: Date? = nil, end: Date? = nil, unmonitored: Bool? = nil, tags: String? = nil, completion: @escaping (_ data: [MovieResource]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import RadarrAPI

let start = Date() // Date |  (optional)
let end = Date() // Date |  (optional)
let unmonitored = true // Bool |  (optional) (default to false)
let tags = "tags_example" // String |  (optional) (default to "")

RadarrCalendarAPI.apiV3CalendarGet(start: start, end: end, unmonitored: unmonitored, tags: tags) { (response, error) in
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
 **start** | **Date** |  | [optional] 
 **end** | **Date** |  | [optional] 
 **unmonitored** | **Bool** |  | [optional] [default to false]
 **tags** | **String** |  | [optional] [default to &quot;&quot;]

### Return type

[**[MovieResource]**](MovieResource.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

