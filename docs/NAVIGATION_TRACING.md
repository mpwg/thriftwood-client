# Navigation Tracing Guide

## Overview

Thriftwood includes comprehensive navigation tracing to help debug and understand the app's navigation flows. All navigation events are logged with detailed context including source, destination, initiator, and metadata.

## Log Categories

All navigation logs use the `AppLogger.navigation` category with the subsystem `com.thriftwood.app`.

### Log Levels

- **`trace`**: Detailed tracing for debugging (verbose)
- **`info`**: General informational messages
- **`debug`**: Debug-level messages with context
- **`warning`**: Potential issues or unexpected behavior
- **`error`**: Errors in navigation flow

## Tracing Features

### 1. Coordinator Lifecycle Tracing

Every coordinator logs its lifecycle events:

```swift
// Initialization
AppLogger.navigation.trace("CoordinatorName.init()", ...)

// Start
AppLogger.navigation.coordinatorStart(
    coordinator: "CoordinatorName",
    initialRoute: "routeName",
    ...
)

// Finish
AppLogger.navigation.coordinatorFinish(
    coordinator: "CoordinatorName",
    finalRoute: "routeName",
    ...
)
```

### 2. Navigation Event Tracing

All navigation events are logged with source and destination:

```swift
AppLogger.navigation.navigateFrom(
    from: "currentRoute",
    to: "destinationRoute",
    coordinator: "CoordinatorName",
    reason: "User tapped button X",
    metadata: ["key": "value"],
    file: #fileID,
    line: #line
)
```

**Logged Information:**

- Source route (where navigation started)
- Destination route (where navigating to)
- Coordinator responsible
- Reason for navigation
- Custom metadata
- Source file and line number
- Call stack depth

### 3. Tab Switching Tracing

Tab changes are logged separately:

```swift
AppLogger.navigation.tabSwitch(
    from: "Dashboard",
    to: "Services",
    coordinator: "TabCoordinator",
    reason: "User tapped tab",
    ...
)
```

### 4. Deep Link Tracing

Deep link handling is fully traced:

```swift
AppLogger.navigation.deepLink(
    url: "thriftwood://radarr/movies/123",
    coordinator: "AppCoordinator",
    action: "Navigating to movie detail",
    ...
)
```

### 5. View Lifecycle Tracing

Views can opt-in to lifecycle logging using the `.logViewLifecycle()` modifier:

```swift
struct MyView: View {
    var body: some View {
        VStack {
            // content
        }
        .logViewLifecycle(
            view: "MyView",
            metadata: [
                "user_id": currentUser.id,
                "context": "dashboard"
            ]
        )
    }
}
```

This logs:

- `onAppear` events with metadata
- `onDisappear` events with duration
- Source file and line number

### 6. Navigation Stack Tracing

All navigation stack operations are traced:

```swift
// Push to stack
coordinator.navigate(to: .someRoute)
// Logs: "Navigating from X to Y"

// Pop from stack
coordinator.pop()
// Logs: "Popping from X to Y"

// Pop to root
coordinator.popToRoot()
// Logs: "Popping to root from X"

// Child coordinator finished
coordinator.childDidFinish(childCoordinator)
// Logs: "Child coordinator finished: ChildCoordinatorName"
```

## Viewing Logs

### Console.app (macOS)

1. Open **Console.app** (in /Applications/Utilities/)
2. Connect your iOS device or select simulator
3. Filter by:
   - **Process**: Thriftwood
   - **Subsystem**: `com.thriftwood.app`
   - **Category**: `navigation`

### Xcode Console

1. Run the app in Xcode (⌘R)
2. Open the **Debug area** (⌘⇧Y)
3. View logs in the console pane

### Log Format

Logs follow this format:

```
[navigation] 🧭 NavigateFrom: from='moviesList' to='movieDetail(123)' coordinator='RadarrCoordinator' reason='User tapped movie row' [RadarrCoordinator.swift:45]
```

**Legend:**

- 🧭 = Navigation event
- 🎬 = Coordinator lifecycle
- 📱 = Tab switch
- 🔗 = Deep link
- 👁️ = View lifecycle
- ⚠️ = Warning
- ❌ = Error

## Example Log Flow

Here's what you'll see when navigating from Dashboard → Services → Radarr → Movie Detail:

```
[navigation] 🧭 TabSwitch: from='Dashboard' to='Services' coordinator='TabCoordinator' reason='User tapped Services tab' [TabCoordinator.swift:123]
[navigation] 👁️ ViewLifecycle: view='ServicesCoordinatorView' event='onAppear' [ServicesCoordinatorView.swift:35]
[navigation] 🧭 NavigateFrom: from='servicesList' to='radarr' coordinator='ServicesCoordinator' reason='User selected Radarr service' [ServicesCoordinator.swift:67]
[navigation] 🎬 CoordinatorStart: coordinator='RadarrCoordinator' initialRoute='moviesList' [RadarrCoordinator.swift:52]
[navigation] 👁️ ViewLifecycle: view='RadarrCoordinatorView' event='onAppear' [RadarrCoordinatorView.swift:28]
[navigation] 👁️ ViewLifecycle: view='MoviesListView' event='onAppear' [MoviesListView.swift:45]
[navigation] 🧭 NavigateFrom: from='moviesList' to='movieDetail(123)' coordinator='RadarrCoordinator' reason='User tapped movie row' [RadarrCoordinator.swift:98]
[navigation] 👁️ ViewLifecycle: view='MovieDetailView' event='onAppear' metadata={'movie_id': '123'} [MovieDetailView.swift:67]
```

## Debugging Navigation Issues

### Issue: Navigation not working

1. **Check logs for navigation attempt:**

   ```
   Filter: "NavigateFrom"
   ```

   - Is the navigation event logged?
   - Check the `from` and `to` routes
   - Verify coordinator name is correct

2. **Check for errors:**

   ```
   Filter: "navigation" AND "error"
   ```

3. **Verify coordinator lifecycle:**
   ```
   Filter: "CoordinatorStart"
   ```
   - Is the coordinator initialized?
   - Is `start()` called?

### Issue: Tab switching not working

1. **Check tab switch logs:**

   ```
   Filter: "TabSwitch"
   ```

   - Is the tab switch event logged?
   - Check `from` and `to` tab names

2. **Check selected tab state:**
   ```
   Filter: "MainTabView" AND "onAppear"
   ```
   - Look at `selected_tab` metadata

### Issue: Deep link not working

1. **Check deep link logs:**
   ```
   Filter: "deepLink"
   ```
   - Is the URL being parsed?
   - Check the coordinator handling the link
   - Verify action being taken

### Issue: View not appearing

1. **Check view lifecycle logs:**
   ```
   Filter: "ViewLifecycle" AND "MyViewName"
   ```
   - Is `onAppear` being called?
   - Check metadata for context

## Performance Considerations

- Tracing adds minimal overhead (< 1ms per navigation event)
- Logs are only written in Debug builds by default
- Use `.trace()` level for verbose debugging (can be disabled in production)
- Metadata is lazy-evaluated to avoid performance impact

## Adding Tracing to New Code

### Adding to a Coordinator

```swift
final class MyCoordinator: CoordinatorProtocol {
    func start() {
        AppLogger.navigation.coordinatorStart(
            coordinator: "MyCoordinator",
            initialRoute: "home",
            file: #fileID,
            line: #line
        )
        // initialization code
    }

    func showDetail(id: String) {
        let fromRoute = navigationPath.last.map { "\($0)" } ?? "none"
        AppLogger.navigation.navigateFrom(
            from: fromRoute,
            to: "detail(\(id))",
            coordinator: "MyCoordinator",
            reason: "User requested detail view",
            metadata: ["id": id],
            file: #fileID,
            line: #line
        )
        navigate(to: .detail(id: id))
    }
}
```

### Adding to a View

```swift
struct MyView: View {
    var body: some View {
        VStack {
            // content
        }
        .logViewLifecycle(
            view: "MyView",
            metadata: ["context": "important_context"]
        )
    }
}
```

## Best Practices

1. **Always include reason:** Explain why navigation is happening
2. **Add relevant metadata:** Include IDs, context, user info
3. **Use consistent naming:** Use the same coordinator/view names across logs
4. **Don't log sensitive data:** Avoid logging API keys, tokens, passwords
5. **Keep metadata concise:** Don't log entire objects, just IDs
6. **Use #fileID and #line:** Always include source location for debugging

## Advanced: Custom Metadata

You can add any metadata to help debugging:

```swift
AppLogger.navigation.navigateFrom(
    from: currentRoute,
    to: targetRoute,
    coordinator: coordinatorName,
    reason: explanation,
    metadata: [
        "user_id": user.id,
        "session_id": session.id,
        "source_screen": "dashboard",
        "trigger": "button_tap",
        "animation_enabled": "\(animated)",
        "deep_link_source": deepLinkURL,
        // Add any key-value pairs helpful for debugging
    ],
    file: #fileID,
    line: #line
)
```

## Troubleshooting

### Logs not appearing

1. **Check log level:** Ensure Console.app is showing `Debug` level logs
2. **Check subsystem filter:** Make sure `com.thriftwood.app` is selected
3. **Check category filter:** Ensure `navigation` category is enabled
4. **Rebuild app:** Clean build folder (⌘⇧K) and rebuild

### Too many logs

1. **Filter by view:** Use view name in filter
2. **Filter by coordinator:** Use coordinator name in filter
3. **Filter by event type:** Use "NavigateFrom", "TabSwitch", etc.
4. **Use time range:** Narrow down to specific time period

### Missing context

1. **Check metadata:** Look for custom metadata in logs
2. **Check call stack:** Use `navigation_depth` to understand stack state
3. **Check parent/child relationships:** Follow coordinator lifecycle logs

## Related Documentation

- [Architecture Overview](architecture/README.md)
- [Coordinator Pattern](architecture/NAVIGATION_QUICK_REFERENCE.md)
- [Logging Guide](LOGGING.md)

## Future Enhancements

Planned improvements to navigation tracing:

- [ ] Visual navigation graph in Xcode console
- [ ] Navigation performance metrics
- [ ] Automatic navigation flow diagrams
- [ ] Integration with Instruments.app
- [ ] Remote logging for production debugging
