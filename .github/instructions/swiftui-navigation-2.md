<!--
Downloaded via https://llm.codes by @steipete on October 7, 2025 at 11:57 AM
Source URL: https://developer.apple.com/documentation/swiftui/navigation
Total pages processed: 164
URLs filtered: Yes
Content de-duplicated: Yes
Availability strings filtered: Yes
Code blocks only: No
-->

# https://developer.apple.com/documentation/swiftui/navigation

Collection

- SwiftUI
- Navigation

API Collection

# Navigation

Enable people to move between different parts of your app’s view hierarchy within a scene.

## Overview

Use navigation containers to provide structure to your app’s user interface, enabling people to easily move among the parts of your app.

For example, people can move forward and backward through a stack of views using a `NavigationStack`, or choose which view to display from a tab bar using a `TabView`.

Configure navigation containers by adding view modifiers like `navigationSplitViewStyle(_:)` to the container. Use other modifiers on the views inside the container to affect the container’s behavior when showing that view. For example, you can use `navigationTitle(_:)` on a view to provide a toolbar title to display when showing that view.

## Topics

### Essentials

Understanding the navigation stack

Learn about the navigation stack, links, and how to manage navigation types in your app’s structure.

### Presenting views in columns

Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

Migrating to new navigation types

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

`struct NavigationSplitView`

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

Sets the style for navigation split views within this view.

Sets a fixed, preferred width for the column containing this view.

Sets a flexible, preferred width for the column containing this view.

`struct NavigationSplitViewVisibility`

The visibility of the leading columns in a navigation split view.

`struct NavigationLink`

A view that controls a navigation presentation.

### Stacking views in one column

`struct NavigationStack`

A view that displays a root view and enables you to present additional views over the root view.

`struct NavigationPath`

A type-erased list of data representing the content of a navigation stack.

Associates a destination view with a presented data type for use within a navigation stack.

Associates a destination view with a binding that can be used to push the view onto a `NavigationStack`.

`func navigationDestination<D, C>(item: Binding<Optional<D>>, destination: (D) -> C) -> some View`

Associates a destination view with a bound value for use within a navigation stack or navigation split view

### Managing column collapse

`struct NavigationSplitViewColumn`

A view that represents a column in a navigation split view.

### Setting titles for navigation content

`func navigationTitle(_:)`

Configures the view’s title for purposes of navigation, using a string binding.

`func navigationSubtitle(_:)`

Configures the view’s subtitle for purposes of navigation.

`func navigationDocument(_:)`

Configures the view’s document for purposes of navigation.

`func navigationDocument(_:preview:)`

### Configuring the navigation bar

Hides the navigation bar back button for the view.

Configures the title display mode for this view.

`struct NavigationBarItem`

A configuration for a navigation bar that represents a view at the top of a navigation stack.

### Configuring the sidebar

`var sidebarRowSize: SidebarRowSize`

The current size of sidebar rows.

`enum SidebarRowSize`

The standard sizes of sidebar rows.

### Presenting views in tabs

Enhancing your app’s content with tab navigation

Keep your app content front and center while providing quick access to navigation using the tab bar.

`struct TabView`

A view that switches between multiple child views using interactive user interface elements.

`struct Tab`

The content for a tab and the tab’s associated tab item in a tab view.

`struct TabRole`

A value that defines the purpose of the tab.

`struct TabSection`

A container that you can use to add hierarchy within a tab view.

Sets the style for the tab view within the current environment.

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom footer to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`struct TabBarMinimizeBehavior`

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

### Configuring a tab

Adds custom actions to a section.

`struct TabPlacement`

A place that a tab can appear.

`struct TabContentBuilder`

A result builder that constructs tabs for a tab view that supports programmatic selection. This builder requires that all tabs in the tab view have the same selection type.

`protocol TabContent`

A type that provides content for programmatically selectable tabs in a tab view.

`struct AnyTabContent`

Type erased tab content.

### Enabling tab customization

Specifies the customizations to apply to the sidebar representation of the tab view.

`struct TabViewCustomization`

The customizations a person makes to an adaptable sidebar tab view.

`struct TabCustomizationBehavior`

The customization behavior of customizable tab view content.

### Displaying views in multiple panes

`struct HSplitView`

A layout container that arranges its children in a horizontal line and allows the user to resize them using dividers placed between them.

`struct VSplitView`

A layout container that arranges its children in a vertical line and allows the user to resize them using dividers placed between them.

### Deprecated Types

`struct NavigationView`

A view for presenting a stack of views that represents a visible path in a navigation hierarchy.

Deprecated

Sets the tab bar item associated with this view.

## See Also

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui

Framework

# SwiftUI

Declare the user interface and behavior for your app on every platform.

## Overview

SwiftUI provides views, controls, and layout structures for declaring your app’s user interface. The framework provides event handlers for delivering taps, gestures, and other types of input to your app, and tools to manage the flow of data from your app’s models down to the views and controls that users see and interact with.

Define your app structure using the `App` protocol, and populate it with scenes that contain the views that make up your app’s user interface. Create your own custom views that conform to the `View` protocol, and compose them with SwiftUI views for displaying text, images, and custom shapes using stacks, lists, and more. Apply powerful modifiers to built-in views and your own views to customize their rendering and interactivity. Share code between apps on multiple platforms with views and controls that adapt to their context and presentation.

You can integrate SwiftUI views with objects from the UIKit, AppKit, and WatchKit frameworks to take further advantage of platform-specific functionality. You can also customize accessibility support in SwiftUI, and localize your app’s interface for different languages, countries, or cultural regions.

### Featured samples

![An image with a background of Mount Fuji, and in the foreground screenshots of the landmark detail view for Mount Fuji in the Landmarks app, in an iPad and iPhone.\\
\\
Landmarks: Building an app with Liquid Glass \\
\\
Enhance your app experience with system-provided and custom Liquid Glass.\\
\\
](https://developer.apple.com/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)

![\\
\\
Destination Video \\
\\
Leverage SwiftUI to build an immersive media experience in a multiplatform app.\\
\\
](https://developer.apple.com/documentation/visionOS/destination-video)

![\\
\\
BOT-anist \\
\\
Build a multiplatform app that uses windows, volumes, and animations to create a robot botanist’s greenhouse.\\
\\
](https://developer.apple.com/documentation/visionOS/BOT-anist)

![A screenshot displaying the document launch experience on iPad with a robot and plant accessory to the left and right of the title view, respectively.\\
\\
Building a document-based app with SwiftUI \\
\\
Create, save, and open documents in a multiplatform app.\\
\\
](https://developer.apple.com/documentation/swiftui/building-a-document-based-app-with-swiftui)

## Topics

### Essentials

Adopting Liquid Glass

Find out how to bring the new material to your app.

Learning SwiftUI

Discover tips and techniques for building multiplatform apps with this set of conceptual articles and sample code.

Exploring SwiftUI Sample Apps

Explore these SwiftUI samples using Swift Playgrounds on iPad or in Xcode to learn about defining user interfaces, responding to user interactions, and managing data flow.

SwiftUI updates

Learn about important changes to SwiftUI.

Landmarks: Building an app with Liquid Glass

Enhance your app experience with system-provided and custom Liquid Glass.

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

### Data and storage

Manage the data that your app uses to drive its interface.

Share data throughout a view hierarchy using the environment.

Indicate configuration preferences from views to their container views.

Store data for use across sessions of your app.

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

### View layout

Arrange views inside built-in layout containers like stacks and grids.

Make fine adjustments to alignment, spacing, padding, and other layout parameters.

Place views in custom arrangements and create animated transitions between layout types.

Display a structured, scrollable column of information.

Display selectable, sortable data arranged in rows and columns.

Present views in different kinds of purpose-driven containers, like forms or control groups.

Enable people to scroll to content that doesn’t fit in the current display.

### Event handling

Define interactions from taps, clicks, and swipes to fine-grained gestures.

Respond to input from a hardware device, like a keyboard or a Touch Bar.

Enable people to move or duplicate items by issuing Copy and Paste commands.

Enable people to move or duplicate items by dragging them from one location to another.

Identify and control which visible object responds to user interaction.

React to system events, like opening a URL.

### Accessibility

Make your SwiftUI apps accessible to everyone, including people with disabilities.

Enhance the legibility of content in your app’s interface.

Improve access to actions that your app can undertake.

Describe interface elements to help people understand what they represent.

Enable users to navigate to specific user interface elements using rotors.

### Framework integration

Add AppKit views to your SwiftUI app, or use SwiftUI views in your AppKit app.

Add UIKit views to your SwiftUI app, or use SwiftUI views in your UIKit app.

Add WatchKit views to your SwiftUI app, or use SwiftUI views in your WatchKit app.

Use SwiftUI views that other Apple frameworks provide.

### Tool support

Generate dynamic, interactive previews of your custom views.

Expose custom views and modifiers in the Xcode library.

Measure and improve your app’s responsiveness.

---

# https://developer.apple.com/documentation/swiftui/navigationstack

- SwiftUI
- NavigationStack

Structure

# NavigationStack

A view that displays a root view and enables you to present additional views over the root view.

@ `MainActor` @preconcurrency

## Mentioned in

Migrating to new navigation types

Adding a search interface to your app

Understanding the navigation stack

## Overview

Use a navigation stack to present a stack of views over a root view. People can add views to the top of the stack by clicking or tapping a `NavigationLink`, and remove views using built-in, platform-appropriate controls, like a Back button or a swipe gesture. The stack always displays the most recently added view that hasn’t been removed, and doesn’t allow the root view to be removed.

To create navigation links, associate a view with a data type by adding a `navigationDestination(for:destination:)` modifier inside the stack’s view hierarchy. Then initialize a `NavigationLink` that presents an instance of the same kind of data. The following stack displays a `ParkDetails` view for navigation links that present data of type `Park`:

NavigationStack {
List(parks) { park in
NavigationLink(park.name, value: park)
}
.navigationDestination(for: Park.self) { park in
ParkDetails(park: park)
}
}

In this example, the `List` acts as the root view and is always present. Selecting a navigation link from the list adds a `ParkDetails` view to the stack, so that it covers the list. Navigating back removes the detail view and reveals the list again. The system disables backward navigation controls when the stack is empty and the root view, namely the list, is visible.

### Manage navigation state

By default, a navigation stack manages state to keep track of the views on the stack. However, your code can share control of the state by initializing the stack with a binding to a collection of data values that you create. The stack adds items to the collection as it adds views to the stack and removes items when it removes views. For example, you can create a `State` property to manage the navigation for the park detail view:

@State private var presentedParks: [Park] = []

Initializing the state as an empty array indicates a stack with no views. Provide a `Binding` to this state property using the dollar sign ( `$`) prefix when you create a stack using the `init(path:root:)` initializer:

NavigationStack(path: $presentedParks) {
List(parks) { park in
NavigationLink(park.name, value: park)
}
.navigationDestination(for: Park.self) { park in
ParkDetails(park: park)
}
}

Like before, when someone taps or clicks the navigation link for a park, the stack displays the `ParkDetails` view using the associated park data. However, now the stack also puts the park data in the `presentedParks` array. Your code can observe this array to read the current stack state. It can also modify the array to change the views on the stack. For example, you can create a method that configures the stack with a specific set of parks:

func showParks() {
presentedParks = [Park("Yosemite"), Park("Sequoia")]
}

The `showParks` method replaces the stack’s display with a view that shows details for Sequoia, the last item in the new `presentedParks` array. Navigating back from that view removes Sequoia from the array, which reveals a view that shows details for Yosemite. Use a path to support deep links, state restoration, or other kinds of programmatic navigation.

### Navigate to different view types

To create a stack that can present more than one kind of view, you can add multiple `navigationDestination(for:destination:)` modifiers inside the stack’s view hierarchy, with each modifier presenting a different data type. The stack matches navigation links with navigation destinations based on their respective data types.

To create a path for programmatic navigation that contains more than one kind of data, you can use a `NavigationPath` instance as the path.

## Topics

### Creating a navigation stack

Creates a navigation stack that manages its own navigation state.

### Creating a navigation stack with a path

`init(path:root:)`

Creates a navigation stack with homogeneous navigation state that you can control.

## Relationships

### Conforms To

- `View`

## See Also

### Stacking views in one column

`struct NavigationPath`

A type-erased list of data representing the content of a navigation stack.

Associates a destination view with a presented data type for use within a navigation stack.

Associates a destination view with a binding that can be used to push the view onto a `NavigationStack`.

`func navigationDestination<D, C>(item: Binding<Optional<D>>, destination: (D) -> C) -> some View`

Associates a destination view with a bound value for use within a navigation stack or navigation split view

---

# https://developer.apple.com/documentation/swiftui/tabview

- SwiftUI
- TabView

Structure

# TabView

A view that switches between multiple child views using interactive user interface elements.

## Overview

To create a user interface with tabs, place `Tab` s in a `TabView`. On iOS, you can also use one of the badge modifiers, like `badge(_:)`, to assign a badge to each of the tabs.

The following example creates a tab view with three tabs, each presenting a custom child view. The first tab has a numeric badge and the third has a string badge.

TabView {
Tab("Received", systemImage: "tray.and.arrow.down.fill") {
ReceivedView()
}
.badge(2)

Tab("Sent", systemImage: "tray.and.arrow.up.fill") {
SentView()
}

Tab("Account", systemImage: "person.crop.circle.fill") {
AccountView()
}
.badge("!")
}

To programatically select different tabs, use the `init(selection:content:)` initializer. You can assign a selection value to each tab using a `Tab` initializer that takes a value. Each tab should have a unique selection value and all tabs should have the same selection value type. When people select a tab in the tab view, the tab view updates the selection binding to the value of the currently selected tab.

The following example creates a tab view that supports programatic selection and has 3 tabs.

TabView(selection: $selection) {
Tab("Received", systemImage: "tray.and.arrow.down.fill", value: 0) {
ReceivedView()
}

Tab("Sent", systemImage: "tray.and.arrow.up.fill", value: 1) {
SentView()
}

Tab("Account", systemImage: "person.crop.circle.fill", value: 2) {
AccountView()
}
}

You can use the `page` style to display a tab view with multiple scrolling pages of content.

The following example uses a `ForEach` to create a scrolling tab view that shows the temperatures of various cities.

TabView {
ForEach(cities) { city in
TemperatureView(city)
}
}
.tabViewStyle(.page)

### Using tab sections

The `sidebarAdaptable` style supports declaring a secondary tab hierarchy by grouping tabs with a `TabSection`.

On iPadOS, tab sections appear in both the sidebar and the tab bar. On iOS and the horizontally compact size class on iPadOS, secondary tabs appear in the tab bar. When secondary tabs appear in the tab bar, the section header doesn’t appear in the tab bar. Consider limiting the number of tabs on iOS and the iPadOS horizontal compact size class so all tabs fit in the tab bar.

The following example has 5 tabs, three of which are grouped within a `TabSection`.

TabView {
Tab("Requests", systemImage: "paperplane") {
RequestsView()
}

Tab("Account", systemImage: "person.crop.circle.fill") {
AccountView()
}

TabSection("Messages") {
Tab("Received", systemImage: "tray.and.arrow.down.fill") {
ReceivedView()
}

Tab("Drafts", systemImage: "pencil") {
DraftsView()
}
}
}
.tabViewStyle(.sidebarAdaptable)

### Changing tab structure between horizontal and regular size classes

The following example shows a `TabView` with 4 tabs in compact and 5 tabs in regular. In compact, one of the tabs is a ‘Browse’ tab that displays a custom list view. This list view allows navigating to the destinations that are contained within the ‘Library’ and ‘Playlists’ sections in the horizontally regular size class. The navigation path and the selection state are updated when the number of tabs changes.

struct BrowseTabExample: View {
@Environment(\.horizontalSizeClass) var sizeClass

@State var selection: MusicTab = .listenNow
@State var browseTabPath: [MusicTab] = []
@State var playlists = [Playlist("All Playlists"), Playlist("Running")]

var body: some View {
TabView(selection: $selection) {
Tab("Listen Now", systemImage: "play.circle", value: .listenNow) {
ListenNowView()
}

Tab("Radio", systemImage: "dot.radiowaves.left.and.right", value: .radio) {
RadioView()
}

Tab("Search", systemImage: "magnifyingglass", value: .search) {
SearchDetailView()
}

Tab("Browse", systemImage: "list.bullet", value: .browse) {
LibraryView(path: $browseTabPath)
}
.hidden(sizeClass != .compact)

TabSection("Library") {
Tab("Recently Added", systemImage: "clock", value: MusicTab.library(.recentlyAdded)) {
RecentlyAddedView()
}

Tab("Artists", systemImage: "music.mic", value: MusicTab.library(.artists)) {
ArtistsView()
}
}
.hidden(sizeClass == .compact)

TabSection("Playlists") {
ForEach(playlists) { playlist in
Tab(playlist.name, image: playlist.imafe, value: MusicTab.playlists(playlist)) {
playlist.detailView()
}
}
}
.hidden(sizeClass == .compact)
}
.tabViewStyle(.sidebarAdaptable)
.onChange(of: sizeClass, initial: true) { _, sizeClass in
if sizeClass == .compact && selection.showInBrowseTab {
browseTabPath = [selection]
selection = .browse
} else if sizeClass == .regular && selection == .browse {
selection = browseTabPath.last ?? .library(.recentlyAdded)
}
}
}
}
}

struct LibraryView: View {
@Binding var path: [MusicTab]

var body: some View {
NavigationStack(path: $path) {
List {
ForEach(MusicLibraryTab.allCases, id: \.self) { tab in
NavigationLink(tab.rawValue, value: MusicTab.library(tab))
}
// Code to add playlists here
}
.navigationDestination(for: MusicTab.self) { tab in
tab.detail()
}
}
}
}

### Adding support for customization

You can allow people to customize the tabs in a `TabView` by using `sidebarAdaptable` style with the `tabViewCustomization(_:)` modifier. Customization allows people to drag tabs from the sidebar to the tab bar, hide tabs, and rearrange tabs in the sidebar.

All tabs and tab sections that support customization need to have a customization ID. You can mark a tab as being non-customizable by specifying a `disabled` behavior in all adaptable tab bar placements using `customizationBehavior(_:for:)`.

On macOS, a default interaction is provided for reordering sections but not for controlling the visibility of individual tabs. A custom experience should be provided if desired by setting the visibility of the tab on the customization.

You can use `@AppStorage` or `@SceneStorage` to automatically persist any visibility or section order customizations a person makes.

The following example supports customizing all 4 tabs in the tab view and uses `@AppStorage` to persist the customizations a person makes.

@AppStorage
private var customization: TabViewCustomization

TabView {
Tab("Home", systemImage: "house") {
MyHomeView()
}
.customizationID("com.myApp.home")

Tab("Reports", systemImage: "chart.bar") {
MyReportsView()
}
.customizationID("com.myApp.reports")

TabSection("Categories") {
Tab("Climate", systemImage: "fan") {
ClimateView()
}
.customizationID("com.myApp.climate")

Tab("Lights", systemImage: "lightbulb") {
LightsView()
}
.customizationID("com.myApp.lights")
}
.customizationID("com.myApp.browse")
}
.tabViewStyle(.sidebarAdaptable)
.tabViewCustomization($customization)

## Topics

### Creating a tab view

`init(content:)`

Creates a tab view that uses a builder to create its tabs.

`init(selection:content:)`

Creates a tab view that uses a builder to create and specify selection values for its tabs.

### Configuring search activation

`struct TabSearchActivation`

Configures the activation behavior of search in the search tab.

## Relationships

### Conforms To

- `View`

## See Also

### Presenting views in tabs

Enhancing your app’s content with tab navigation

Keep your app content front and center while providing quick access to navigation using the tab bar.

`struct Tab`

The content for a tab and the tab’s associated tab item in a tab view.

`struct TabRole`

A value that defines the purpose of the tab.

`struct TabSection`

A container that you can use to add hierarchy within a tab view.

Sets the style for the tab view within the current environment.

---

# https://developer.apple.com/documentation/swiftui/view/navigationsplitviewstyle(_:)

#app-main)

- SwiftUI
- View
- navigationSplitViewStyle(\_:)

Instance Method

# navigationSplitViewStyle(\_:)

Sets the style for navigation split views within this view.

nonisolated

## Parameters

`style`

The style to set.

## Return Value

A view that uses the specified navigation split view style.

## Mentioned in

Migrating to new navigation types

## See Also

### Presenting views in columns

Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

`struct NavigationSplitView`

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

Sets a fixed, preferred width for the column containing this view.

Sets a flexible, preferred width for the column containing this view.

`struct NavigationSplitViewVisibility`

The visibility of the leading columns in a navigation split view.

`struct NavigationLink`

A view that controls a navigation presentation.

---

# https://developer.apple.com/documentation/swiftui/view/navigationtitle(_:)

#app-main)

- SwiftUI
- View
- navigationTitle(\_:)

Instance Method

# navigationTitle(\_:)

Configures the view’s title for purposes of navigation, using a string binding.

nonisolated

Show all declarations

## Parameters

`title`

The text of the title.

## Discussion

In iOS, iPadOS, and macOS, this allows editing the navigation title when the title is displayed in the toolbar.

Refer to the Configure your apps navigation titles article for more information on navigation title modifiers.

## See Also

### Setting titles for navigation content

`func navigationSubtitle(_:)`

Configures the view’s subtitle for purposes of navigation.

`func navigationDocument(_:)`

Configures the view’s document for purposes of navigation.

`func navigationDocument(_:preview:)`

---

# https://developer.apple.com/documentation/swiftui/understanding-the-composition-of-navigation-stack

- SwiftUI
- Navigation
- Understanding the navigation stack

Article

# Understanding the navigation stack

Learn about the navigation stack, links, and how to manage navigation types in your app’s structure.

## Overview

A `NavigationStack` is a container for your app’s navigation structure. Use a navigation stack to present a stack of views over a root view.

A `NavigationStack` exposes its state to your app with the path parameter of its initializer. To create a navigation stack with a path that you can control or track views on the navigation stack, use a `NavigationPath` or a `Binding` to a `RandomAccessCollection` and `RangeReplaceableCollection` that contains `Hashable` elements.

A `NavigationPath` is a type-erased collection on which you can store a heterogenous list of data. For homogenous data, use an `Array` instead. Because `NavigationPath` is type-erased, it can represent different types of data that correspond to a view in the navigation stack.

Another element of the navigation stack is the _navigation destination_, which encapsulates the views people can navigate to within your app.

You can present destinations on a `NavigationStack` using:

View-destination

Use the `init(destination:label:)` initializer to push a view directly onto the navigation stack. A view-destination link is fire-and-forget: SwiftUI tracks the navigation state, but from your app’s perspective, there are no stateful hooks indicating you pushed a view.

Value–destination

A value-destination indicates that you are pushing a value onto the path. SwiftUI uses the value you pushed to the path to determine the corresponding view using the `navigationDestination(for:destination:)` modifier. You use `init(value:label:)` initializer to append a value onto the navigation path and `navigationDestination(for:destination:)` modifier to map the data type of the path appended to a specific destination view. You can also programmatically push views onto a navigation stack using a `navigationDestination(isPresented:destination:)` modifier. The destination is stateful—the state is explicitly available to your app via the Boolean binding. In cases where the presentation state is better modeled by the absence or presence of a value rather than a Boolean, use `navigationDestination(item:destination:)`. This modifier takes a binding to a nullable data model.

### Present view–destination links

You can push a view onto a `NavigationStack` using `NavigationLink(destination:label:)`. With this initializer, you specify both a label—displayed on the link itself—and a destination—displayed when someone taps the link.

Enclose a `NavigationLink` in a navigation structure higher up in the view-hierarchy—an ancestor view, for example. If this condition isn’t met, the link typically appears as disabled.

Below is an example with two links inside a `NavigationStack`:

struct DestinationView: View {
var body: some View {
NavigationStack {
NavigationLink {
ColorDetail(color: .mint, text: "Mint")
} label: {
Text("Mint")
}

NavigationLink {
ColorDetail(color: .red, text: "Red")
} label: {
Text("Red")
}
}
}
}

struct ColorDetail: View {
var color: Color
var text: String

var body: some View {
VStack {
Text(text)
color
}
}
}

In this example, tapping the label titled “Mint” pushes a `ColorDetail(color: .mint, text: "Mint")` view onto the navigation stack. The navigation stack contents are the root view (the `NavigationLink` itself) at depth `0`, and `ColorDetail(color: .mint, text: "Mint")` at depth `1`.

When you use `init(destination:label:)`, note that:

- SwiftUI tracks the navigation state and the content of the navigation path; however, there are no stateful hooks for your app that indicate when a view has been pushed.

- Its state can’t be restored programmatically.

Use the stateful navigation techniques described in Manage navigation state and compose links to track when a navigation link triggers, instead of `onAppear(perform:)` or `task(priority:_:)`.

Use a `navigationDestination(isPresented:destination:)` modifier to navigate programmatically by providing a binding to a `Boolean` value. For example, you can programmatically push `ColorDetail` view onto the stack:

struct DestinationView: View {
@State private var showDetails = false
var favoriteColor: Color

NavigationStack {
VStack {
Circle()
.fill(favoriteColor)
Button("Show details") {
showDetails = true
}
}
.navigationDestination(isPresented: $showDetails) {
ColorDetail(color: favoriteColor, text: color.description)
}
}
}

Use this approach when you want to navigate based on toggling state rather than by people’s interaction, or when your app presents a one-off destination with a different data type than the homogenous path of the navigation stack.

### Present value-destination links

When you add data to the navigation path, SwiftUI maps the data type to a view, then pushes it onto the navigation stack when someone taps the link. To describe the view the stack displays, use the `navigationDestination(for:destination:)` view modifier inside a `NavigationStack`.

The following example implements `DestinationView` as a series of navigation links:

NavigationStack {
List {
NavigationLink("Mint", value: Color.mint)
NavigationLink("Red", value: Color.red)
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color, text: color.description)
}
}

In the example above, SwiftUI uses the value type—in this case, `Color`—to determine the appropriate navigation destination. With value-based navigation, you can define a variety of possible destinations for a single stack When someone taps “Mint”, SwiftUI pushes `ColorDetail` view with a value `.mint` onto the stack.

Value-based navigation shines in scenarios with mixed destination types. You can extend your app to handle recipe-related content in addition to colors:

struct ValueView: View {
private var recipes: [Recipe] = [.applePie, .chocolateCake]

var body: some View {
NavigationStack {
List {
NavigationLink("Mint", value: Color.mint)
NavigationLink("Red", value: Color.red)
ForEach(recipes) { recipe in
NavigationLink(recipe.description, value: recipe)
}
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color, text: color.description)
}
.navigationDestination(for: Recipe.self) { recipe in
RecipeDetailView(recipe: recipe)
}
}
}
}

struct RecipeDetailView: View {
var recipe: Recipe

var body: some View {
Text(recipe.description)
}
}

enum Recipe: Identifiable, Hashable, Codable {
case applePie
case chocolateCake

var id: Self { self }

var description: String {
switch self {
case .applePie:
return "Apple Pie"
case .chocolateCake:
return "Chocolate Cake"
}
}
}

In this example, the `NavigationStack` supports two destination types: `Color` for colors, and `Recipe` for recipes. SwiftUI determines the correct destination view based on the data type of the value from the navigation link.

Use `navigationDestination(item:destination:)` when you need to navigate to a view based on the presence of an item. When the item binding is non-nil, SwiftUI passes the value into the destination closure and pushes the view onto the stack. For example:

struct ContentView: View {
private var recipes: [Recipe] = [.applePie, .chocolateCake]
@State private var selectedRecipe: Recipe?

var body: some View {
NavigationStack {
List(recipes, selection: $selectedRecipe) { recipe in
NavigationLink(recipe.description, value: recipe)
}
.navigationDestination(item: $selectedRecipe) { recipe in
RecipeDetailView(recipe: recipe)
}
}
}
}

When a person taps a recipe, `selectedRecipe` value updates and SwiftUI pushes `RecipeDetailView(recipe: recipe)` onto the navigation stack. You can pop the view off the stack by setting `selectedRecipe`

By default, a navigation stack manages state to keep track of the views on the stack. However, your app can share control of the state by initializing the stack with a binding to a collection of data values that you create.

Use `init(path:root:)`, which takes a binding to a `NavigationPath` argument, when you want to observe the navigation state for this stack.

The `NavigationPath` data type is a heterogeneous collection type that accepts any `Hashable` values. You can add to the path by calling `append(_:)` or when people tap value-destination links such as `init(value:label:)`.

When you push a value onto the stack using `init(_:value:)`, you append the value to the path, as shown below:

struct ContentView: View {
@State private var path = NavigationPath()

var body: some View {
NavigationStack(path: $path) {
List {
NavigationLink("Mint", value: Color.mint)
NavigationLink("Red", value: Color.red)
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color)
}
}
}
}

In this example, when someone activates a link, SwiftUI adds the corresponding value, such as `Color.mint`, to `path`. SwiftUI uses the `State` property called `path` to mange the state of the navigation stack.

`init(path:root:)` also provides an initializer in which the path parameter takes a `Binding` to a `RandomAccessCollection` and a `RangeReplaceableCollection` argument. You can store the path as a property in an object that leverages the `Observable` macro data type, and use property observers such as `willSet` and `didSet` or the `onChange(of:initial:_:)` modifier to respond to changes when the value-destination link triggers.

In this case, the navigation path is a homogenous collection type that accepts a standard type, such as `Array`, or a custom data type as shown below:

@Observable
class NavigationManager {
var path: [Color] = [] {
willSet {
print("will set to \(newValue)")
}

didSet {
print("didSet to \(path)")
}
}
}

struct ContentView: View {
@State private var navigationManager = NavigationManager()

var body: some View {
NavigationStack(path: $navigationManager.path) {
List {
NavigationLink("Mint", value: Color.mint)
NavigationLink("Red", value: Color.red)
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color, text: color.description)
}
}
}
}

In the example above, the `willSet` and `didSet` property observers track when a navigation link triggers.

You can also use the reference to `path` variable to perform programmatic navigation. For example, you can pop a view off the stack:

didSet {
print("didSet to \(path)")
}
}

@discardableResult

path.popLast()
}
}

Use a standard type when your stack displays views that rely on a single type of data, and `NavigationPath` when you need to present multiple data types in a single stack, as in the following example:

struct ValueView: View {
@State private var path = NavigationPath()

var body: some View {
NavigationStack(path: $path) {
List {
NavigationLink("Mint", value: Color.mint)
NavigationLink("Red", value: Color.red)
NavigationLink("Apple Pie", value: Recipe.applePie)
NavigationLink("Chocolate Cake", value: Recipe.chocolateCake)
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color)
}
.navigationDestination(for: Recipe.self) { recipe in
RecipeDetailView(recipe: recipe)
}
}
}
}

When composed together, the navigation APIs allow you to use both styles of links, depending on what works best.

Here, when someone taps on the link “View Mint Color”, SwiftUI pushes the value-based destination link onto the stack, followed by a view-destination link:

var body: some View {
NavigationStack(path: $navigationManager.path) {
NavigationLink("View Mint Color", value: Color.mint)
.navigationDestination(for: Color.self) { color in
NavigationLink("Push Recipe View") {
RecipeDetailView(recipe: .applePie)
}
}
}
}
}

After the code in this example runs, and someone clicks each `NavigationLink`, the navigation stack builds up with three views:

Root

The starting view of the `NavigationStack`.

Collection of values

A sequence of zero or more values, such as `Color.mint`, pushed onto the path. The values serve as identifiers or keys that SwiftUI uses to determine which views to present.

Collection of views

A sequence of views such as `RecipeDetailView`, added to the path. This view is enclosed in the navigation destination and displayed when someone taps the link.

SwiftUI keeps track of the entire navigation path. The underlying data structure looks like the following example:

Root → [Color.mint] → [RecipeDetailView]

Conceptually, SwiftUI stacks view-based destinations on top of the value-based destinations in the stack’s navigation path. For example, the code below replaces `RecipeDetailView` from the above example with a `NavigationLink`:

var body: some View {
NavigationStack(path: $navigationManager.path) {
NavigationLink("View Mint Color", value: Color.mint)
.navigationDestination(for: Color.self) { color in
NavigationLink("Push Recipe View") {
NavigationLink("Push another view", value: Color.pink)
}
}
}
}
}

When you run the revised example, the view-destination link is still on the top of the stack.

If you use a heterogenous or homogeneous path on the stack, you may observe changes to the navigation path over time, as shown below:

@Observable
class NavigationManager {
var path: [Color] = [] {
didSet {
print("didSet to \(path)")
}
}
}

When someone navigates through the app, it prints the following logs:

New path: []
New Path: [Color.mint]

The logs print because view-destination navigation links don’t cause any state changes that your app can observe. If you attempt to push a value while a view-destination link is on the stack, SwiftUI pops all view destinations and pushes the value’s destination onto the stack.

### Restore state for navigation paths

State restoration for a navigation path enables you restore your interface to the previous interaction point during a subsequent launch, providing continuity for people using your app.

In iOS, state restoration is especially important at the window or scene level, because windows come and go frequently. For this reason, it’s important to think about state restoration for navigation path in the same way you handle restoring your app’s state at the window or scene level. See Restoring Your App’s State with SwiftUI to learn about storing scene data.

Using `Codable`, you can manually persist and load the navigation stack path in one of two ways, depending on whether the path data type is homogeneous or heterogeneous. Store a homogenous path as in the following example:

@Observable
class NavigationManager {
var path: [Recipe] = [] {
didSet {
save()
}
}

/// The URL for the JSON file that stores the navigation path.
private static var dataURL: URL {
.documentsDirectory.appending(path: "NavigationPath.json")
}

init() {
do {
// Load the data model from the 'NavigationPath' data file found in the Documents directory.
let path = try load(url: NavigationManager.dataURL)
self.path = path
} catch {
// Handle error.
}
}

func save() {
let encoder = JSONEncoder()
do {
let data = try encoder.encode(path)
try data.write(to: NavigationManager.dataURL)
} catch {
// Handle error.
}
}

/// Load the navigation path from a previously saved state.

let data = try Data(contentsOf: url, options: .mappedIfSafe)
let decoder = JSONDecoder()
return try decoder.decode([Recipe].self, from: data)
}
}

var body: some View {
NavigationStack(path: $navigationManager.path) {
List {
NavigationLink("Mint", value: Color.mint)
NavigationLink("Red", value: Color.red)
NavigationLink("Apple Pie", value: Recipe.applePie)
NavigationLink("Chocolate Cake", value: Recipe.chocolateCake)
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color, text: color.description)
}
.navigationDestination(for: Recipe.self) { recipe in
RecipeDetailView(recipe: recipe)
}
}
}
}

In the above example, when the `path` changes, `didSet` property observer triggers and the `save` function is called. The function saves the new path to disk so it can be restored when the app initializes `NavigationManager`.

Store a heterogeneous path using `NavigationPath`, as shown in the following example:

@Observable
class NavigationManager {
var path = NavigationPath() {
didSet {
save()
}
}

init() {
do {
// Load the data model from the 'NavigationPath' data file found in the Documents directory.
let path = try load(url: NavigationManager.dataURL)
self.path = path
} catch {
// Handle error
}
}

func save() {
guard let codableRepresentation = path.codable else { return }
let encoder = JSONEncoder()
do {
let data = try encoder.encode(codableRepresentation)
try data.write(to: NavigationManager.dataURL)
} catch {
//Handle error.
}
}

/// Load the navigation path from a previously saved data.

let data = try Data(contentsOf: url, options: .mappedIfSafe)
let decoder = JSONDecoder()
let path = try decoder.decode(NavigationPath.CodableRepresentation.self, from: data)
return NavigationPath(path)
}
}

In the example above, the `save` method checks `path.codable` for nullability. This value describes the contents of the path in a serializable format. It returns `nil` if any of the type-erased elements of the path don’t conform to the `codable`.

It’s important to perform this check because `NavigationPath` doesn’t require the data types to conform to `Codable`. `NavigationPath` only needs the types to conform to `Hashable`, and as a result, you can’t verify that the navigation path is a valid representation of `Codable` at compile time.

To learn more about navigation stacks, links and paths, see Bringing robust navigation structure to your SwiftUI app.

---

# https://developer.apple.com/documentation/swiftui/bringing-robust-navigation-structure-to-your-swiftui-app

- SwiftUI
- Navigation
- Bringing robust navigation structure to your SwiftUI app

Sample Code

# Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

Download

Xcode 16.0+

## Overview

## See Also

### Presenting views in columns

Migrating to new navigation types

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

`struct NavigationSplitView`

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

Sets the style for navigation split views within this view.

Sets a fixed, preferred width for the column containing this view.

Sets a flexible, preferred width for the column containing this view.

`struct NavigationSplitViewVisibility`

The visibility of the leading columns in a navigation split view.

`struct NavigationLink`

A view that controls a navigation presentation.

---

# https://developer.apple.com/documentation/swiftui/migrating-to-new-navigation-types

- SwiftUI
- Navigation
- Migrating to new navigation types

Article

# Migrating to new navigation types

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

## Overview

If your app has a minimum deployment target of iOS 16, iPadOS 16, macOS 13, tvOS 16, watchOS 9, or visionOS 1, or later, transition away from using `NavigationView`. In its place, use `NavigationStack` and `NavigationSplitView` instances. How you use these depends on whether you perform navigation in one column or across multiple columns. With these newer containers, you get better control over view presentation, container configuration, and programmatic navigation.

### Update single column navigation

If your app uses a `NavigationView` that you style using the `stack` navigation view style, where people navigate by pushing a new view onto a stack, switch to `NavigationStack`.

In particular, stop doing this:

NavigationView { // This is deprecated.
/* content */
}
.navigationViewStyle(.stack)

Instead, create a navigation stack:

NavigationStack {
/* content */
}

### Update multicolumn navigation

If your app uses a two- or three-column `NavigationView`, or for apps that have multiple columns in some cases and a single column in others — which is typical for apps that run on iPhone and iPad — switch to `NavigationSplitView`.

Instead of using a two-column navigation view:

NavigationView { // This is deprecated.
/* column 1 */
/* column 2 */
}

Create a navigation split view that has explicit sidebar and detail content using the `init(sidebar:detail:)` initializer:

NavigationSplitView {
/* column 1 */
} detail: {
/* column 2 */
}

Similarly, instead of using a three-column navigation view:

NavigationView { // This is deprecated.
/* column 1 */
/* column 2 */
/* column 3 */
}

Create a navigation split view that has explicit sidebar, content, and detail components using the `init(sidebar:content:detail:)` initializer:

NavigationSplitView {
/* column 1 */
} content: {
/* column 2 */
} detail: {
/* column 3 */
}

If you need navigation within a column, embed a navigation stack in that column. This arrangement provides finer control over what each column displays. `NavigationSplitView` also enables you to customize column visibility and width.

### Update programmatic navigation

If you perform programmatic navigation using one of the `NavigationLink` initializers that has an `isActive` input parameter, move the automation to the enclosing stack. Do this by changing your navigation links to use the `init(value:label:)` initializer, then use one of the navigation stack initializers that takes a path input, like `init(path:root:)`.

For example, if you have a navigation view with links that activate in response to individual state variables:

@State private var isShowingPurple = false
@State private var isShowingPink = false
@State private var isShowingOrange = false

var body: some View {
NavigationView { // This is deprecated.
List {
NavigationLink("Purple", isActive: $isShowingPurple) {
ColorDetail(color: .purple)
}
NavigationLink("Pink", isActive: $isShowingPink) {
ColorDetail(color: .pink)
}
NavigationLink("Orange", isActive: $isShowingOrange) {
ColorDetail(color: .orange)
}
}
}
.navigationViewStyle(.stack)
}

When some other part of your code sets one of the state variables to true, the navigation link that has the matching tag activates in response.

Rewrite this as a navigation stack that takes a path input:

@State private var path: [Color] = [] // Nothing on the stack by default.

var body: some View {
NavigationStack(path: $path) {
List {
NavigationLink("Purple", value: .purple)
NavigationLink("Pink", value: .pink)
NavigationLink("Orange", value: .orange)
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color)
}
}
}

This version uses the `navigationDestination(for:destination:)` view modifier to detach the presented data from the corresponding view. That makes it possible for the `path` array to represent every view on the stack. Changes that you make to the array affect what the container displays right now, as well as what people encounter as they navigate through the stack. You can support even more sophisticated programmatic navigation if you use a `NavigationPath` to store the path information, rather than a plain collection of data. For more information, see `NavigationStack`.

### Update selection-based navigation

If you perform programmatic navigation on `List` elements that use one of the `NavigationLink` initializers with a `selection` input parameter, you can move the selection to the list. For example, suppose you have a navigation view with links that activate in response to a `selection` state variable:

let colors: [Color] = [.purple, .pink, .orange]
@State private var selection: Color? = nil // Nothing selected by default.

var body: some View {
NavigationView { // This is deprecated.
List {
ForEach(colors, id: \.self) { color in
NavigationLink(color.description, tag: color, selection: $selection) {
ColorDetail(color: color)
}
}
}
Text("Pick a color")
}
}

Using the same properties, you can rewrite the body as:

var body: some View {
NavigationSplitView {
List(colors, id: \.self, selection: $selection) { color in
NavigationLink(color.description, value: color)
}
} detail: {
if let color = selection {
ColorDetail(color: color)
} else {
Text("Pick a color")
}
}
}

The list coordinates with the navigation logic so that changing the selection state variable in another part of your code activates the navigation link with the corresponding color. Similarly, if someone chooses the navigation link associated with a particular color, the list updates the selection value that other parts of your code can read.

### Provide backward compatibility with an availability check

If your app needs to run on platform versions earlier than iOS 16, iPadOS 16, macOS 13, tvOS 16, watchOS 9, or visionOS 1, you can start migration while continuing to support older clients by using an availability condition. For example, you can create a custom wrapper view that conditionally uses either `NavigationSplitView` or `NavigationView`:

where Sidebar: View, Content: View, Detail: View
{
private var sidebar: Sidebar
private var content: Content
private var detail: Detail

init(

) {
self.sidebar = sidebar()
self.content = content()
self.detail = detail()
}

var body: some View {
if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, visionOS 1, *) {
// Use the latest API.
NavigationSplitView {
sidebar
} content: {
content
} detail: {
detail
}
} else {
// Support previous platform versions.
NavigationView {
sidebar
content
detail
}
.navigationViewStyle(.columns)
}
}
}

Customize the wrapper to meet your app’s needs. For example, you can add a navigation split view style modifier like `navigationSplitViewStyle(_:)` to the `NavigationSplitView` in the appropriate branch of the availability check.

## See Also

### Presenting views in columns

Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

`struct NavigationSplitView`

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

Sets the style for navigation split views within this view.

Sets a fixed, preferred width for the column containing this view.

Sets a flexible, preferred width for the column containing this view.

`struct NavigationSplitViewVisibility`

The visibility of the leading columns in a navigation split view.

`struct NavigationLink`

A view that controls a navigation presentation.

---

# https://developer.apple.com/documentation/swiftui/navigationsplitview

- SwiftUI
- NavigationSplitView

Structure

# NavigationSplitView

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

## Mentioned in

Migrating to new navigation types

Adding a search interface to your app

## Overview

You create a navigation split view with two or three columns, and typically use it as the root view in a `Scene`. People choose one or more items in a leading column to display details about those items in subsequent columns.

To create a two-column navigation split view, use the `init(sidebar:detail:)` initializer:

var body: some View {
NavigationSplitView {
List(model.employees, selection: $employeeIds) { employee in
Text(employee.name)
}
} detail: {
EmployeeDetails(for: employeeIds)
}
}

In the above example, the navigation split view coordinates with the `List` in its first column, so that when people make a selection, the detail view updates accordingly. Programmatic changes that you make to the selection property also affect both the list appearance and the presented detail view.

To create a three-column view, use the `init(sidebar:content:detail:)` initializer. The selection in the first column affects the second, and the selection in the second column affects the third. For example, you can show a list of departments, the list of employees in the selected department, and the details about all of the selected employees:

@State private var departmentId: Department.ID? // Single selection.

var body: some View {
NavigationSplitView {
List(model.departments, selection: $departmentId) { department in
Text(department.name)
}
} content: {
if let department = model.department(id: departmentId) {
List(department.employees, selection: $employeeIds) { employee in
Text(employee.name)
}
} else {
Text("Select a department")
}
} detail: {
EmployeeDetails(for: employeeIds)
}
}

You can also embed a `NavigationStack` in a column. Tapping or clicking a `NavigationLink` that appears in an earlier column sets the view that the stack displays over its root view. Activating a link in the same column adds a view to the stack. Either way, the link must present a data type for which the stack has a corresponding `navigationDestination(for:destination:)` modifier.

On watchOS and tvOS, and with narrow sizes like on iPhone or on iPad in Slide Over, the navigation split view collapses all of its columns into a stack, and shows the last column that displays useful information. For example, the three-column example above shows the list of departments to start, the employees in the department after someone selects a department, and the employee details when someone selects an employee. For rows in a list that have `NavigationLink` instances, the list draws disclosure chevrons while in the collapsed state.

### Control column visibility

You can programmatically control the visibility of navigation split view columns by creating a `State` value of type `NavigationSplitViewVisibility`. Then pass a `Binding` to that state to the appropriate initializer — such as `init(columnVisibility:sidebar:detail:)` for two columns, or the `init(columnVisibility:sidebar:content:detail:)` for three columns.

The following code updates the first example above to always hide the first column when the view appears:

@State private var columnVisibility =
NavigationSplitViewVisibility.detailOnly

var body: some View {
NavigationSplitView(columnVisibility: $columnVisibility) {
List(model.employees, selection: $employeeIds) { employee in
Text(employee.name)
}
} detail: {
EmployeeDetails(for: employeeIds)
}
}

The split view ignores the visibility control when it collapses its columns into a stack.

### Collapsed split views

At narrow size classes, such as on iPhone or Apple Watch, a navigation split view collapses into a single stack. Typically SwiftUI automatically chooses the view to show on top of this single stack, based on the content of the split view’s columns.

For custom navigation experiences, you can provide more information to help SwiftUI choose the right column. Create a `State` value of type `NavigationSplitViewColumn`. Then pass a `Binding` to that state to the appropriate initializer, such as `init(preferredCompactColumn:sidebar:detail:)` or `init(preferredCompactColumn:sidebar:content:detail:)`.

The following code shows the blue detail view when run on iPhone. When the person using the app taps the back button, they’ll see the yellow view. The value of `preferredPreferredCompactColumn` will change from `.detail` to `.sidebar`:

@State private var preferredColumn =
NavigationSplitViewColumn.detail

var body: some View {
NavigationSplitView(preferredCompactColumn: $preferredColumn) {
Color.yellow
} detail: {
Color.blue
}
}

### Customize a split view

To specify a preferred column width in a navigation split view, use the `navigationSplitViewColumnWidth(_:)` modifier. To set minimum, maximum, and ideal sizes for a column, use `navigationSplitViewColumnWidth(min:ideal:max:)`. You can specify a different modifier in each column. The navigation split view does its best to accommodate the preferences that you specify, but might make adjustments based on other constraints.

To specify how columns in a navigation split view interact, use the `navigationSplitViewStyle(_:)` modifier with a `NavigationSplitViewStyle` value. For example, you can specify whether to emphasize the detail column or to give all of the columns equal prominence.

On some platforms, `NavigationSplitView` adds a `sidebarToggle` toolbar item. Use the `toolbar(removing:)` modifier to remove the default item.

## Topics

### Creating a navigation split view

Creates a two-column navigation split view.

Creates a three-column navigation split view.

### Hiding columns in a navigation split view

Creates a two-column navigation split view that enables programmatic control of the sidebar’s visibility.

Creates a three-column navigation split view that enables programmatic control of leading columns’ visibility.

### Specifying a preferred compact column

Creates a two-column navigation split view that enables programmatic control over which column appears on top when the view collapses into a single column in narrow sizes.

Creates a three-column navigation split view that enables programmatic control over which column appears on top when the view collapses into a single column in narrow sizes.

### Specifying a preferred compact column and column visibility

Creates a two-column navigation split view that enables programmatic control of the sidebar’s visibility in regular sizes and which column appears on top when the view collapses into a single column in narrow sizes.

Creates a three-column navigation split view that enables programmatic control of leading columns’ visibility in regular sizes and which column appears on top when the view collapses into a single column in narrow sizes.

## Relationships

### Conforms To

- `View`

## See Also

### Presenting views in columns

Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

Sets the style for navigation split views within this view.

Sets a fixed, preferred width for the column containing this view.

Sets a flexible, preferred width for the column containing this view.

`struct NavigationSplitViewVisibility`

The visibility of the leading columns in a navigation split view.

`struct NavigationLink`

A view that controls a navigation presentation.

---

# https://developer.apple.com/documentation/swiftui/view/navigationsplitviewcolumnwidth(_:)

#app-main)

- SwiftUI
- View
- navigationSplitViewColumnWidth(\_:)

Instance Method

# navigationSplitViewColumnWidth(\_:)

Sets a fixed, preferred width for the column containing this view.

nonisolated

## Discussion

Apply this modifier to the content of a column in a `NavigationSplitView` to specify a fixed preferred width for the column. Use `navigationSplitViewColumnWidth(min:ideal:max:)` if you need to specify a flexible width.

The following example shows a three-column navigation split view where the first column has a preferred width of 150 points, and the second column has a flexible, preferred width between 150 and 400 points:

NavigationSplitView {
MySidebar()
.navigationSplitViewColumnWidth(150)
} contents: {
MyContents()
.navigationSplitViewColumnWidth(
min: 150, ideal: 200, max: 400)
} detail: {
MyDetail()
}

Only some platforms enable resizing columns. If you specify a width that the current presentation environment doesn’t support, SwiftUI may use a different width for your column.

## See Also

### Presenting views in columns

Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

Migrating to new navigation types

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

`struct NavigationSplitView`

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

Sets the style for navigation split views within this view.

Sets a flexible, preferred width for the column containing this view.

`struct NavigationSplitViewVisibility`

The visibility of the leading columns in a navigation split view.

`struct NavigationLink`

A view that controls a navigation presentation.

---

# https://developer.apple.com/documentation/swiftui/view/navigationsplitviewcolumnwidth(min:ideal:max:)

#app-main)

- SwiftUI
- View
- navigationSplitViewColumnWidth(min:ideal:max:)

Instance Method

# navigationSplitViewColumnWidth(min:ideal:max:)

Sets a flexible, preferred width for the column containing this view.

nonisolated
func navigationSplitViewColumnWidth(
min: `CGFloat`? = nil,
ideal: `CGFloat`,
max: `CGFloat`? = nil

## Discussion

Apply this modifier to the content of a column in a `NavigationSplitView` to specify a preferred flexible width for the column. Use `navigationSplitViewColumnWidth(_:)` if you need to specify a fixed width.

The following example shows a three-column navigation split view where the first column has a preferred width of 150 points, and the second column has a flexible, preferred width between 150 and 400 points:

NavigationSplitView {
MySidebar()
.navigationSplitViewColumnWidth(150)
} contents: {
MyContents()
.navigationSplitViewColumnWidth(
min: 150, ideal: 200, max: 400)
} detail: {
MyDetail()
}

Only some platforms enable resizing columns. If you specify a width that the current presentation environment doesn’t support, SwiftUI may use a different width for your column.

## See Also

### Presenting views in columns

Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

Migrating to new navigation types

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

`struct NavigationSplitView`

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

Sets the style for navigation split views within this view.

Sets a fixed, preferred width for the column containing this view.

`struct NavigationSplitViewVisibility`

The visibility of the leading columns in a navigation split view.

`struct NavigationLink`

A view that controls a navigation presentation.

---

# https://developer.apple.com/documentation/swiftui/navigationsplitviewvisibility

- SwiftUI
- NavigationSplitViewVisibility

Structure

# NavigationSplitViewVisibility

The visibility of the leading columns in a navigation split view.

struct NavigationSplitViewVisibility

## Overview

Use a value of this type to control the visibility of the columns of a `NavigationSplitView`. Create a `State` property with a value of this type, and pass a `Binding` to that state to the `init(columnVisibility:sidebar:detail:)` or `init(columnVisibility:sidebar:content:detail:)` initializer when you create the navigation split view. You can then modify the value elsewhere in your code to:

- Hide all but the trailing column with `detailOnly`.

- Hide the leading column of a three-column navigation split view with `doubleColumn`.

- Show all the columns with `all`.

- Rely on the automatic behavior for the current context with `automatic`.

## Topics

### Getting visibilities

`static var automatic: NavigationSplitViewVisibility`

Use the default leading column visibility for the current device.

`static var all: NavigationSplitViewVisibility`

Show all the columns of a three-column navigation split view.

`static var doubleColumn: NavigationSplitViewVisibility`

Show the content column and detail area of a three-column navigation split view, or the sidebar column and detail area of a two-column navigation split view.

`static var detailOnly: NavigationSplitViewVisibility`

Hide the leading two columns of a three-column navigation split view, so that just the detail area shows.

## Relationships

### Conforms To

- `Decodable`
- `Encodable`
- `Equatable`
- `Sendable`
- `SendableMetatype`

## See Also

### Presenting views in columns

Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

Migrating to new navigation types

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

`struct NavigationSplitView`

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

Sets the style for navigation split views within this view.

Sets a fixed, preferred width for the column containing this view.

Sets a flexible, preferred width for the column containing this view.

`struct NavigationLink`

A view that controls a navigation presentation.

---

# https://developer.apple.com/documentation/swiftui/navigationlink

- SwiftUI
- NavigationLink

Structure

# NavigationLink

A view that controls a navigation presentation.

## Mentioned in

Migrating to new navigation types

Displaying data in lists

Understanding the navigation stack

## Overview

People click or tap a navigation link to present a view inside a `NavigationStack` or `NavigationSplitView`. You control the visual appearance of the link by providing view content in the link’s `label` closure. For example, you can use a `Label` to display a link:

NavigationLink {
FolderDetail(id: workFolder.id)
} label: {
Label("Work Folder", systemImage: "folder")
}

For a link composed only of text, you can use one of the convenience initializers that takes a string and creates a `Text` view for you:

NavigationLink("Work Folder") {
FolderDetail(id: workFolder.id)
}

### Link to a destination view

You can perform navigation by initializing a link with a destination view that you provide in the `destination` closure. For example, consider a `ColorDetail` view that fills itself with a color:

struct ColorDetail: View {
var color: Color

var body: some View {
color.navigationTitle(color.description)
}
}

The following `NavigationStack` presents three links to color detail views:

NavigationStack {
List {
NavigationLink("Mint") { ColorDetail(color: .mint) }
NavigationLink("Pink") { ColorDetail(color: .pink) }
NavigationLink("Teal") { ColorDetail(color: .teal) }
}
.navigationTitle("Colors")
}

### Create a presentation link

Alternatively, you can use a navigation link to perform navigation based on a presented data value. To support this, use the `navigationDestination(for:destination:)` view modifier inside a navigation stack to associate a view with a kind of data, and then present a value of that data type from a navigation link. The following example reimplements the previous example as a series of presentation links:

NavigationStack {
List {
NavigationLink("Mint", value: Color.mint)
NavigationLink("Pink", value: Color.pink)
NavigationLink("Teal", value: Color.teal)
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color)
}
.navigationTitle("Colors")
}

Separating the view from the data facilitates programmatic navigation because you can manage navigation state by recording the presented data.

### Control a presentation link programmatically

To navigate programmatically, introduce a state variable that tracks the items on a stack. For example, you can create an array of colors to store the stack state from the previous example, and initialize it as an empty array to start with an empty stack:

@State private var colors: [Color] = []

Then pass a `Binding` to the state to the navigation stack:

NavigationStack(path: $colors) {
// ...
}

You can use the array to observe the current state of the stack. You can also modify the array to change the contents of the stack. For example, you can programmatically add `blue` to the array, and navigation to a new color detail view using the following method:

func showBlue() {
colors.append(.blue)
}

### Coordinate with a list

You can also use a navigation link to control `List` selection in a `NavigationSplitView`:

let colors: [Color] = [.mint, .pink, .teal]
@State private var selection: Color? // Nothing selected by default.

var body: some View {
NavigationSplitView {
List(colors, id: \.self, selection: $selection) { color in
NavigationLink(color.description, value: color)
}
} detail: {
if let color = selection {
ColorDetail(color: color)
} else {
Text("Pick a color")
}
}
}

The list coordinates with the navigation logic so that changing the selection state variable in another part of your code activates the navigation link with the corresponding color. Similarly, if someone chooses the navigation link associated with a particular color, the list updates the selection value that other parts of your code can read.

## Topics

### Presenting a destination view

`init(_:destination:)`

Creates a navigation link that presents a destination view, with a text label that the link generates from a localized string key.

`init(destination:label:)`

Creates a navigation link that presents the destination view.

### Presenting a value

`init(_:value:)`

Creates a navigation link that presents the view corresponding to a codable value, with a text label that the link generates from a localized string key.

`init(value:label:)`

Creates a navigation link that presents the view corresponding to a codable value.

### Configuring the link

Sets the navigation link to present its destination as the detail component of the containing navigation view.

### Deprecated symbols

Review deprecated navigation link initializers.

## Relationships

### Conforms To

- `View`

## See Also

### Presenting views in columns

Bringing robust navigation structure to your SwiftUI app

Use navigation links, stacks, destinations, and paths to provide a streamlined experience for all platforms, as well as behaviors such as deep linking and state restoration.

Improve navigation behavior in your app by replacing navigation views with navigation stacks and navigation split views.

`struct NavigationSplitView`

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.

Sets the style for navigation split views within this view.

Sets a fixed, preferred width for the column containing this view.

Sets a flexible, preferred width for the column containing this view.

`struct NavigationSplitViewVisibility`

The visibility of the leading columns in a navigation split view.

---

# https://developer.apple.com/documentation/swiftui/navigationpath

- SwiftUI
- NavigationPath

Structure

# NavigationPath

A type-erased list of data representing the content of a navigation stack.

struct NavigationPath

## Mentioned in

Migrating to new navigation types

Understanding the navigation stack

## Overview

You can manage the state of a `NavigationStack` by initializing the stack with a binding to a collection of data. The stack stores data items in the collection for each view on the stack. You also can read and write the collection to observe and alter the stack’s state.

When a stack displays views that rely on only one kind of data, you can use a standard collection, like an array, to hold the data. If you need to present different kinds of data in a single stack, use a navigation path instead. The path uses type erasure so you can manage a collection of heterogeneous elements. The path also provides the usual collection controls for adding, counting, and removing data elements.

### Serialize the path

When the values you present on the navigation stack conform to the `Codable` protocol, you can use the path’s `codable` property to get a serializable representation of the path. Use that representation to save and restore the contents of the stack. For example, you can define an `ObservableObject` that handles serializing and deserializing the path:

class MyModelObject: ObservableObject {
@Published var path: NavigationPath

// Read data representing the path from app's persistent storage.
}

static func writeSerializedData(_ data: Data) {
// Write data representing the path to app's persistent storage.
}

init() {
if let data = Self.readSerializedData() {
do {
let representation = try JSONDecoder().decode(
NavigationPath.CodableRepresentation.self,
from: data)
self.path = NavigationPath(representation)
} catch {
self.path = NavigationPath()
}
} else {
self.path = NavigationPath()
}
}

func save() {
guard let representation = path.codable else { return }
do {
let encoder = JSONEncoder()
let data = try encoder.encode(representation)
Self.writeSerializedData(data)
} catch {
// Handle error.
}
}
}

Then, using that object in your view, you can save the state of the navigation path when the `Scene` enters the `ScenePhase.background` state:

@StateObject private var pathState = MyModelObject()
@Environment(\.scenePhase) private var scenePhase

var body: some View {
NavigationStack(path: $pathState.path) {
// Add a root view here.
}
.onChange(of: scenePhase) { phase in
if phase == .background {
pathState.save()
}
}
}

## Topics

### Creating a navigation path

`init()`

Creates a new, empty navigation path.

`init(_:)`

Creates a new navigation path from a serializable version.

### Managing path contents

`var isEmpty: Bool`

A Boolean that indicates whether this path is empty.

`var count: Int`

The number of elements in this path.

`func append(_:)`

Appends a new codable value to the end of this path.

`func removeLast(Int)`

Removes values from the end of this path.

### Encoding a path

`var codable: NavigationPath.CodableRepresentation?`

A value that describes the contents of this path in a serializable format.

`struct CodableRepresentation`

A serializable representation of a navigation path.

## Relationships

### Conforms To

- `Copyable`
- `Equatable`

## See Also

### Stacking views in one column

`struct NavigationStack`

A view that displays a root view and enables you to present additional views over the root view.

Associates a destination view with a presented data type for use within a navigation stack.

Associates a destination view with a binding that can be used to push the view onto a `NavigationStack`.

`func navigationDestination<D, C>(item: Binding<Optional<D>>, destination: (D) -> C) -> some View`

Associates a destination view with a bound value for use within a navigation stack or navigation split view

---

# https://developer.apple.com/documentation/swiftui/view/navigationdestination(for:destination:)

#app-main)

- SwiftUI
- View
- navigationDestination(for:destination:)

Instance Method

# navigationDestination(for:destination:)

Associates a destination view with a presented data type for use within a navigation stack.

nonisolated

for data: D.Type,

## Parameters

`data`

The type of data that this destination matches.

`destination`

A view builder that defines a view to display when the stack’s navigation state contains a value of type `data`. The closure takes one argument, which is the value of the data to present.

## Mentioned in

Understanding the navigation stack

Migrating to new navigation types

## Discussion

Add this view modifier to a view inside a `NavigationStack` to describe the view that the stack displays when presenting a particular kind of data. Use a `NavigationLink` to present the data. For example, you can present a `ColorDetail` view for each presentation of a `Color` instance:

NavigationStack {
List {
NavigationLink("Mint", value: Color.mint)
NavigationLink("Pink", value: Color.pink)
NavigationLink("Teal", value: Color.teal)
}
.navigationDestination(for: Color.self) { color in
ColorDetail(color: color)
}
.navigationTitle("Colors")
}

You can add more than one navigation destination modifier to the stack if it needs to present more than one kind of data.

Do not put a navigation destination modifier inside a “lazy” container, like `List` or `LazyVStack`. These containers create child views only when needed to render on screen. Add the navigation destination modifier outside these containers so that the navigation stack can always see the destination.

## See Also

### Stacking views in one column

`struct NavigationStack`

A view that displays a root view and enables you to present additional views over the root view.

`struct NavigationPath`

A type-erased list of data representing the content of a navigation stack.

Associates a destination view with a binding that can be used to push the view onto a `NavigationStack`.

`func navigationDestination<D, C>(item: Binding<Optional<D>>, destination: (D) -> C) -> some View`

Associates a destination view with a bound value for use within a navigation stack or navigation split view

---

# https://developer.apple.com/documentation/swiftui/view/navigationdestination(ispresented:destination:)

#app-main)

- SwiftUI
- View
- navigationDestination(isPresented:destination:)

Instance Method

# navigationDestination(isPresented:destination:)

Associates a destination view with a binding that can be used to push the view onto a `NavigationStack`.

nonisolated

## Parameters

`isPresented`

A binding to a Boolean value that indicates whether `destination` is currently presented.

`destination`

A view to present.

## Mentioned in

Understanding the navigation stack

## Discussion

In general, favor binding a path to a navigation stack for programmatic navigation. Add this view modifier to a view inside a `NavigationStack` to programmatically push a single view onto the stack. This is useful for building components that can push an associated view. For example, you can present a `ColorDetail` view for a particular color:

@State private var showDetails = false
var favoriteColor: Color

NavigationStack {
VStack {
Circle()
.fill(favoriteColor)
Button("Show details") {
showDetails = true
}
}
.navigationDestination(isPresented: $showDetails) {
ColorDetail(color: favoriteColor)
}
.navigationTitle("My Favorite Color")
}

Do not put a navigation destination modifier inside a “lazy” container, like `List` or `LazyVStack`. These containers create child views only when needed to render on screen. Add the navigation destination modifier outside these containers so that the navigation stack can always see the destination.

## See Also

### Stacking views in one column

`struct NavigationStack`

A view that displays a root view and enables you to present additional views over the root view.

`struct NavigationPath`

A type-erased list of data representing the content of a navigation stack.

Associates a destination view with a presented data type for use within a navigation stack.

`func navigationDestination<D, C>(item: Binding<Optional<D>>, destination: (D) -> C) -> some View`

Associates a destination view with a bound value for use within a navigation stack or navigation split view

---

# https://developer.apple.com/documentation/swiftui/view/navigationdestination(item:destination:)

#app-main)

- SwiftUI
- View
- navigationDestination(item:destination:)

Instance Method

# navigationDestination(item:destination:)

Associates a destination view with a bound value for use within a navigation stack or navigation split view

nonisolated

item: `Binding` < `Optional` <D>>,

## Parameters

`item`

A binding to the data presented, or `nil` if nothing is currently presented.

`destination`

A view builder that defines a view to display when `item` is not `nil`.

## Mentioned in

Understanding the navigation stack

## Discussion

Add this view modifier to a view inside a `NavigationStack` or `NavigationSplitView` to describe the view that the stack displays when presenting a particular kind of data. Programmatically update the binding to display or remove the view. For example, you can replace the view showing in the detail column of a navigation split view:

@State private var colorShown: Color?

NavigationSplitView {
List {
Button("Mint") { colorShown = .mint }
Button("Pink") { colorShown = .pink }
Button("Teal") { colorShown = .teal }
}
.navigationDestination(item: $colorShown) { color in
ColorDetail(color: color)
}
} detail: {
Text("Select a color")
}

When the person using the app taps on the Mint button, the mint color shows in the detail and `colorShown` gets the value `Color.mint`. You can reset the navigation split view to show the message “Select a color” by setting `colorShown` or `LazyVStack`. These containers create child views only when needed to render on screen. Add the navigation destination modifier outside these containers so that the navigation split view can always see the destination.

## See Also

### Stacking views in one column

`struct NavigationStack`

A view that displays a root view and enables you to present additional views over the root view.

`struct NavigationPath`

A type-erased list of data representing the content of a navigation stack.

Associates a destination view with a presented data type for use within a navigation stack.

Associates a destination view with a binding that can be used to push the view onto a `NavigationStack`.

---

# https://developer.apple.com/documentation/swiftui/navigationsplitviewcolumn

- SwiftUI
- NavigationSplitViewColumn

Structure

# NavigationSplitViewColumn

A view that represents a column in a navigation split view.

struct NavigationSplitViewColumn

## Overview

A `NavigationSplitView` collapses into a single stack in some contexts, like on iPhone or Apple Watch. Use this type with the `preferredCompactColumn` parameter to control which column of the navigation split view appears on top of the collapsed stack.

## Topics

### Getting a column

`static var sidebar: NavigationSplitViewColumn`

`static var content: NavigationSplitViewColumn`

`static var detail: NavigationSplitViewColumn`

## Relationships

### Conforms To

- `Equatable`
- `Hashable`
- `Sendable`
- `SendableMetatype`

---

# https://developer.apple.com/documentation/swiftui/view/navigationsubtitle(_:)

#app-main)

- SwiftUI
- View
- navigationSubtitle(\_:)

Instance Method

# navigationSubtitle(\_:)

Configures the view’s subtitle for purposes of navigation.

nonisolated

Show all declarations

## Parameters

`subtitle`

The subtitle to display.

## Discussion

A view’s navigation subtitle is used to provide additional contextual information alongside the navigation title. On macOS, the primary destination’s subtitle is displayed with the navigation title in the titlebar. On iOS and iPadOS, the subtitle is displayed with the navigation title in the navigation bar.

## See Also

### Setting titles for navigation content

`func navigationTitle(_:)`

Configures the view’s title for purposes of navigation, using a string binding.

`func navigationDocument(_:)`

Configures the view’s document for purposes of navigation.

`func navigationDocument(_:preview:)`

---

# https://developer.apple.com/documentation/swiftui/view/navigationdocument(_:)

#app-main)

- SwiftUI
- View
- navigationDocument(\_:)

Instance Method

# navigationDocument(\_:)

Configures the view’s document for purposes of navigation.

nonisolated

Show all declarations

## Discussion

In iOS, iPadOS, this populates the title menu with a header previewing the document. In macOS, this populates a proxy icon.

Refer to the Configure your apps navigation titles article for more information on navigation document modifiers.

## See Also

### Setting titles for navigation content

`func navigationTitle(_:)`

Configures the view’s title for purposes of navigation, using a string binding.

`func navigationSubtitle(_:)`

Configures the view’s subtitle for purposes of navigation.

`func navigationDocument(_:preview:)`

---

# https://developer.apple.com/documentation/swiftui/view/navigationdocument(_:preview:)

#app-main)

- SwiftUI
- View
- navigationDocument(\_:preview:)

Instance Method

# navigationDocument(\_:preview:)

Configures the view’s document for purposes of navigation.

nonisolated

_ document: D,

Show all declarations

## Parameters

`document`

The transferable content associated to the navigation title.

`preview`

The preview of the document to use when sharing.

## Discussion

In iOS, iPadOS, this populates the title menu with a header previewing the document. In macOS, this populates a proxy icon.

Refer to the Configure your apps navigation titles article for more information on navigation document modifiers.

## See Also

### Setting titles for navigation content

`func navigationTitle(_:)`

Configures the view’s title for purposes of navigation, using a string binding.

`func navigationSubtitle(_:)`

Configures the view’s subtitle for purposes of navigation.

`func navigationDocument(_:)`

---

# https://developer.apple.com/documentation/swiftui/view/navigationbarbackbuttonhidden(_:)

#app-main)

- SwiftUI
- View
- navigationBarBackButtonHidden(\_:)

Instance Method

# navigationBarBackButtonHidden(\_:)

Hides the navigation bar back button for the view.

nonisolated

## Parameters

`hidesBackButton`

A Boolean value that indicates whether to hide the back button. The default value is `true`.

## Discussion

Use `navigationBarBackButtonHidden(_:)` to hide the back button for this view.

This modifier only takes effect when this view is inside of and visible within a `NavigationView`.

## See Also

### Configuring the navigation bar

Configures the title display mode for this view.

`struct NavigationBarItem`

A configuration for a navigation bar that represents a view at the top of a navigation stack.

---

# https://developer.apple.com/documentation/swiftui/view/navigationbartitledisplaymode(_:)

#app-main)

- SwiftUI
- View
- navigationBarTitleDisplayMode(\_:)

Instance Method

# navigationBarTitleDisplayMode(\_:)

Configures the title display mode for this view.

nonisolated

## Parameters

`displayMode`

The style to use for displaying the title.

## See Also

### Configuring the navigation bar

Hides the navigation bar back button for the view.

`struct NavigationBarItem`

A configuration for a navigation bar that represents a view at the top of a navigation stack.

---

# https://developer.apple.com/documentation/swiftui/navigationbaritem

- SwiftUI
- NavigationBarItem

Structure

# NavigationBarItem

A configuration for a navigation bar that represents a view at the top of a navigation stack.

struct NavigationBarItem

## Overview

Use one of the `NavigationBarItem.TitleDisplayMode` values to configure a navigation bar title’s display mode with the `navigationBarTitleDisplayMode(_:)` view modifier.

## Topics

### Setting a title display mode

`enum TitleDisplayMode`

A style for displaying the title of a navigation bar.

## Relationships

### Conforms To

- `Sendable`
- `SendableMetatype`

## See Also

### Configuring the navigation bar

Hides the navigation bar back button for the view.

Configures the title display mode for this view.

---

# https://developer.apple.com/documentation/swiftui/environmentvalues/sidebarrowsize

- SwiftUI
- EnvironmentValues
- sidebarRowSize

Instance Property

# sidebarRowSize

The current size of sidebar rows.

var sidebarRowSize: `SidebarRowSize` { get set }

## Discussion

On macOS, reflects the value of the “Sidebar icon size” in System Settings’ Appearance settings.

This can be used to update the content shown in the sidebar in response to this size. And it can be overridden to force a sidebar to a particularly size, regardless of the user preference.

On other platforms, the value is always `.medium` and setting a different value has no effect.

SwiftUI views like `Label` automatically adapt to the sidebar row size.

## See Also

### Configuring the sidebar

`enum SidebarRowSize`

The standard sizes of sidebar rows.

---

# https://developer.apple.com/documentation/swiftui/sidebarrowsize

- SwiftUI
- SidebarRowSize

Enumeration

# SidebarRowSize

The standard sizes of sidebar rows.

enum SidebarRowSize

## Overview

On macOS, sidebar rows have three different sizes: small, medium, and large. The size is primarily controlled by the current users’ “Sidebar Icon Size” in Appearance settings, and applies to all applications.

On all other platforms, the only supported sidebar size is `.medium`.

This size can be read or written in the environment using `EnvironmentValues.sidebarRowSize`.

## Topics

### Getting row sizes

`case small`

The standard “small” row size

`case medium`

The standard “medium” row size

`case large`

The standard “large” row size

## Relationships

### Conforms To

- `Copyable`
- `Equatable`
- `Hashable`
- `Sendable`
- `SendableMetatype`

## See Also

### Configuring the sidebar

`var sidebarRowSize: SidebarRowSize`

The current size of sidebar rows.

---

# https://developer.apple.com/documentation/swiftui/enhancing-your-app-content-with-tab-navigation

- SwiftUI
- Navigation
- Enhancing your app’s content with tab navigation

Sample Code

# Enhancing your app’s content with tab navigation

Keep your app content front and center while providing quick access to navigation using the tab bar.

Download (1.2 GB)

## Overview

Destination Video adopts the `sidebarAdaptable` tab view style, which optimizes the content browsing experience for each platform.

Starting in iPadOS 18, the tab bar appears on the top of the screen floating over your content instead of appearing at the bottom of the screen. This appearance creates an immersive full-screen browsing experience. Tab bars provide people with access to the top-level navigation in your app. However, too many tabs can make it hard for people to locate content. Implementing a sidebar makes it easier to navigate a detailed information hierarchy.

Play

### Create a tab bar

You can create a `TabView` with an explicit selection binding using the `init(selection:content:)` initializer. To add a tab within a `TabView` initialize a `Tab`. Destination Video uses the `init(_:systemImage:value:content:)` initializer to create each tab:

@State private var selectedTab: Tabs = .watchNow

var body: some View {
TabView(selection: $selectedTab) {
Tab("Watch Now", systemImage: "play", value: .watchNow) {
WatchNowView()
}
// More tabs...
}
}

The selection value type of the `TabView` matches the value type of the tabs it contains. In this case, the value of each `Tab` is of type `Tabs`, which this sample defines the following enumeration:

enum Tabs: Equatable, Hashable, Identifiable {
case watchNow
case library
case new
case favorites
case search
}

Additionally, this sample uses the `search` role with the `init(value:role:content:)` initializer. Setting the tab role to `search` makes the system applies a few default customizations to the `Tab`. The search tab gets:

- The default title for search, “search”

- The default system symbol for search, a magnifying glass

- The default pinned behavior for search, the system automatically pins it in the tab bar

Tab(value: .search, role: .search) {
// ...
}

Pinned tabs appear at the trailing edge of the tab bar, depending on the preferred language of your app. When the language is a left-to-right language, they appear on the right side. When the language is a right-to-left language, they’re on the left side.

### Build hierarchy in tab view

You can use a `TabSection` to declare a secondary tab hierarchy within a `TabView`. For example Destination Video uses the `init(content:header:)` initializer to create tab sections.

TabView(selection: $selectedTab) {
Tab("Watch Now", systemImage: "play", value: .watchNow) {
WatchNowView()
}

// More tabs...

TabSection {
Tab("Cinematic Shots", systemImage: "list.and.film", value: .collections(.cinematic)) {
// ...
}
} header: {
Label("Collections", systemImage: "folder")
}
}

Then it extends the `Tabs` enumeration to account for secondary tabs:

enum Tabs: Equatable, Hashable, Identifiable {
case watchNow
// ..
case search
case collections(Category)
case animations(Category)
}

enum Category: Equatable, Hashable, Identifiable, CaseIterable {
case cinematic
case forest
case sea
// ...
}

This sample uses a `ForEach` loop to iterate and initialize a new `Tab` for each tab value.

TabSection {
ForEach(Category.collectionsList) { collection in
Tab(collection.name, systemImage: collection.icon, value: Tabs.collections(collection)) {
// ..
}
}
} header: {
Label("Collections", systemImage: "folder")
}

### Make the tab bar adaptable

Tab bars with the `sidebarAdaptable` style allow people to toggle between the sidebar and tab bar. This lets your app leverage the convenience of being able to quickly navigate to top-level destinations within a compact tab bar while providing rich navigation hierarchy and destination options in the sidebar.

To create an adaptable tab bar, Destination Video adds the `tabViewStyle(_:)` modifier to its `TabView` and passes in the value `sidebarAdaptable`.

TabView(selection: $selectedTab) {
// Tabs
// ..
}
.tabViewStyle(.sidebarAdaptable)

A `TabView` with the `sidebarAdaptable` style appears differently depending on the platform, as shown in the following images.

A `TabView` appears as top tab bar that becomes a sidebar in iPadOS. Tab sections appear in both the sidebar and the tab bar. In compact view, a `TabView` appears as a bottom tab bar.

A `TabView` appears as a bottom tab bar in iOS. Secondary tabs appear in the tab bar. Unlike iPadOS, the section header doesn’t appear in the tab bar.

A `TabView` appears as a sidebar in macOS. Tab sections also appear in the sidebar.

A `TabView` appears as a sidebar that collapses into a floating pill after a person selects a tab in tvOS. Tab sections appear in the sidebar.

A `TabView` appears as an ornament in visionOS. Tab section headers appear in the ornament. If you select a tab section header in the ornament, the sidebar displays the tabs in that section.

### Enable customization

Tab view customization allows people to enter edit mode and personalize the tab bar. The customization in Destination Video allows people to:

- Drag and drop tabs to remove and add tabs to the tab bar

- Hide non-essential tabs

- Reorder tabs in tab sections in the sidebar

- Reorder tabs in the tab bar

To enable customizations, this sample defines a `TabViewCustomization` and attaches it to the `TabView` using the `tabViewCustomization(_:)` modifier. To persist the customization, this sample adds `AppStorage` with an identifier for a `TabViewCustomization` variable. Finally, it adds the `customizationID(_:)` modifier to each tab.

@AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization
@State private var selectedTab: Tabs = .watchNow

var body: some View {
TabView(selection: $selectedTab) {
Tab("Watch Now", systemImage: "play", value: .watchNow) {
WatchNowView()
}
.customizationID(Tabs.watchNow.customizationID)

}
.tabViewCustomization($tabViewCustomization)
}

To keep the most important tabs visible and in a fixed position, turn off customization behavior for those tabs using the `customizationBehavior(_:for:)` modifier.

Tab("Watch Now", systemImage: "play", value: .watchNow) {
WatchNowView()
}
.customizationBehavior(.disabled, for: .sidebar, .tabBar)

### Set the default visibility for tabs

In iPadOS, if there are too many tabs to fit in the screen, the system collapses the tabs that don’t fit and enables scrolling. However, having too many tabs can make it harder for people to locate the tab they’re looking for and navigate your app. Consider limiting the number of tabs so they all fit in the tab bar. The `defaultVisibility(_:for:)` modifier sets the default visibility of a `Tab` or `TabSection`.

Destination Video contains five tabs and two tab sections, each tab section contains multiple secondary tabs, but only seven tabs appear in the tab bar. In order to limit the tab bar to the most important tabs, all tabs within a `TabSection` are hidden from the tab bar by default.

TabSection {
// Tabs
} header {
// Section header
}
.defaultVisibility(.hidden, for: .tabBar)

If you enable customization, the `defaultVisibility(_:for:)` modifier still allows people to drag a tab from the sidebar into the tab bar. If you want to restrict tabs to only appear in the sidebar use `sidebarOnly` instead of setting the default visibility.

## See Also

#### Related samples

![\\
\\
Destination Video](https://developer.apple.com/documentation/visionOS/destination-video)

#### Related articles

Elevating your iPad app with a tab bar and sidebar

Provide a compact, ergonomic tab bar for quick access to key parts of your app, and a sidebar for in-depth navigation.

#### Related videos

![\\
\\
Elevate your tab and sidebar experience in iPadOS](https://developer.apple.com/videos/play/wwdc2024/10147)

---

# https://developer.apple.com/documentation/swiftui/tab

- SwiftUI
- Tab

Structure

# Tab

The content for a tab and the tab’s associated tab item in a tab view.

## Topics

### Creating a tab

Creates a new tab that you can use in a tab view, with an empty label.

`init(value:content:)`

`init(value:role:content:)`

Creates a new tab with a label inferred from the role.

### Creating a tab with label

Creates a new tab with a label that you can use in a tab view.

### Creating a tab with system symbol

`init(_:systemImage:content:)`

Creates a new tab that you can use in a tab view using a system image for the tab item’s image, and a localized string key label.

`init(_:systemImage:value:content:)`

Creates a tab that the tab view presents when the tab view’s selection matches the tab’s value using a system image for the tab’s tab item image, with a localized string key label.

`init(_:systemImage:role:content:)`

`init(_:systemImage:value:role:content:)`

### Creating a tab with image

`init(_:image:content:)`

Creates a new tab that you can use in a tab view, with a localized string key label.

`init(_:image:value:content:)`

Creates a tab that the tab view presents when the tab view’s selection matches the tab’s value, with a localized string key label.

`init(_:image:role:content:)`

`init(_:image:value:role:content:)`

### Supporting types

`struct DefaultTabLabel`

The default label to use for a tab or tab section.

### Initializers

`init(value:content:label:)`

`init(value:role:content:label:)`

## Relationships

### Conforms To

- `Copyable`
- `TabContent`
Conforms when `Value` conforms to `Hashable`, `Content` conforms to `View`, and `Label` conforms to `View`.

## See Also

### Presenting views in tabs

Enhancing your app’s content with tab navigation

Keep your app content front and center while providing quick access to navigation using the tab bar.

`struct TabView`

A view that switches between multiple child views using interactive user interface elements.

`struct TabRole`

A value that defines the purpose of the tab.

`struct TabSection`

A container that you can use to add hierarchy within a tab view.

Sets the style for the tab view within the current environment.

---

# https://developer.apple.com/documentation/swiftui/tabrole

- SwiftUI
- TabRole

Structure

# TabRole

A value that defines the purpose of the tab.

struct TabRole

## Topics

### Type Properties

`static var search: TabRole`

The search role.

## Relationships

### Conforms To

- `Equatable`
- `Hashable`
- `Sendable`
- `SendableMetatype`

## See Also

### Presenting views in tabs

Enhancing your app’s content with tab navigation

Keep your app content front and center while providing quick access to navigation using the tab bar.

`struct TabView`

A view that switches between multiple child views using interactive user interface elements.

`struct Tab`

The content for a tab and the tab’s associated tab item in a tab view.

`struct TabSection`

A container that you can use to add hierarchy within a tab view.

Sets the style for the tab view within the current environment.

---

# https://developer.apple.com/documentation/swiftui/tabsection

- SwiftUI
- TabSection

Structure

# TabSection

A container that you can use to add hierarchy within a tab view.

## Overview

Use `TabSection` to organize tab content into separate sections. Each section has custom tab content that you provide on a per-instance basis. You can also provide a header for each section.

## Topics

### Creating a tab section

`init(content:)`

Creates a section with the provided section content.

`init(_:content:)`

Creates a section with the provided content.

`init(content:header:)`

Creates a section with a header and the provided section content.

### Supporting types

`struct DefaultTabLabel`

The default label to use for a tab or tab section.

## Relationships

### Conforms To

- `Copyable`
- `TabContent`
Conforms when `Header` conforms to `View`, `Content` conforms to `TabContent`, `Footer` conforms to `View`, and `SelectionValue` is `Content.TabValue`.

## See Also

### Presenting views in tabs

Enhancing your app’s content with tab navigation

Keep your app content front and center while providing quick access to navigation using the tab bar.

`struct TabView`

A view that switches between multiple child views using interactive user interface elements.

`struct Tab`

The content for a tab and the tab’s associated tab item in a tab view.

`struct TabRole`

A value that defines the purpose of the tab.

Sets the style for the tab view within the current environment.

---

# https://developer.apple.com/documentation/swiftui/view/tabviewstyle(_:)

#app-main)

- SwiftUI
- View
- tabViewStyle(\_:)

Instance Method

# tabViewStyle(\_:)

Sets the style for the tab view within the current environment.

nonisolated

## Parameters

`style`

The style to apply to this tab view.

## See Also

### Presenting views in tabs

Enhancing your app’s content with tab navigation

Keep your app content front and center while providing quick access to navigation using the tab bar.

`struct TabView`

A view that switches between multiple child views using interactive user interface elements.

`struct Tab`

The content for a tab and the tab’s associated tab item in a tab view.

`struct TabRole`

A value that defines the purpose of the tab.

`struct TabSection`

A container that you can use to add hierarchy within a tab view.

---

# https://developer.apple.com/documentation/swiftui/view/tabviewsidebarheader(content:)

#app-main)

- SwiftUI
- View
- tabViewSidebarHeader(content:)

Instance Method

# tabViewSidebarHeader(content:)

Adds a custom header to the sidebar of a tab view.

nonisolated

## Discussion

The header appears at the top of the sidebar before any tab labels and can scroll with the content. The header is only visible when the `TabView` is displaying the sidebar.

The following example adds a welcome message to the top of the sidebar:

TabView {
Tab("Home", systemImage: "house") {
HomeView()
}

Tab("Alerts", systemImage: "bell") {
AlertsView()
}

Tab("Browse", systemImage: "list.bullet") {
MyBrowseView()
}
}
.tabViewStyle(.sidebarAdaptable)
.tabViewSidebarHeader {
WelcomeHeaderView()
}

## See Also

### Configuring a tab bar

Adds a custom footer to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`struct TabBarMinimizeBehavior`

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

---

# https://developer.apple.com/documentation/swiftui/view/tabviewsidebarfooter(content:)

#app-main)

- SwiftUI
- View
- tabViewSidebarFooter(content:)

Instance Method

# tabViewSidebarFooter(content:)

Adds a custom footer to the sidebar of a tab view.

nonisolated

## Discussion

The footer appears at the bottom of the sidebar after any tab labels and can scroll with the content. The footer is only visible when the `TabView` is displaying the sidebar.

The following example adds a link to contact support to the bottom of the sidebar content:

TabView {
Tab("Home", systemImage: "house") {
HomeView()
}

Tab("Alerts", systemImage: "bell") {
AlertsView()
}

Tab("Browse", systemImage: "list.bullet") {
MyBrowseView()
}
}
.tabViewStyle(.sidebarAdaptable)
.tabViewSidebarFooter {
ContactSupportLink()
}

## See Also

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`struct TabBarMinimizeBehavior`

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

---

# https://developer.apple.com/documentation/swiftui/view/tabviewsidebarbottombar(content:)

#app-main)

- SwiftUI
- View
- tabViewSidebarBottomBar(content:)

Instance Method

# tabViewSidebarBottomBar(content:)

Adds a custom bottom bar to the sidebar of a tab view.

nonisolated

## Discussion

The content is pinned at the bottom of the sidebar, so it’s always visible when the sidebar is visible and doesn’t scroll with the content.

The following example adds an account button to the bottom of the sidebar:

TabView {
Tab("Home", systemImage: "house") {
HomeView()
}

Tab("Alerts", systemImage: "bell") {
AlertsView()
}

Tab("Browse", systemImage: "list.bullet") {
MyBrowseView()
}
}
.tabViewStyle(.sidebarAdaptable)
.tabViewSidebarBottomBar {
AccountButton()
}

## See Also

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom footer to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`struct TabBarMinimizeBehavior`

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

---

# https://developer.apple.com/documentation/swiftui/adaptabletabbarplacement

- SwiftUI
- AdaptableTabBarPlacement

Structure

# AdaptableTabBarPlacement

A placement for tabs in a tab view using the adaptable sidebar style.

struct AdaptableTabBarPlacement

## Topics

### Type Properties

`static let automatic: AdaptableTabBarPlacement`

The automatic placement.

`static let sidebar: AdaptableTabBarPlacement`

The sidebar of a tab view.

`static let tabBar: AdaptableTabBarPlacement`

The tab bar of a tab view.

## Relationships

### Conforms To

- `Equatable`
- `Hashable`

## See Also

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom footer to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`struct TabBarMinimizeBehavior`

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

---

# https://developer.apple.com/documentation/swiftui/environmentvalues/tabbarplacement

- SwiftUI
- EnvironmentValues
- tabBarPlacement

Instance Property

# tabBarPlacement

The current placement of the tab bar.

var tabBarPlacement: `TabBarPlacement`? { get }

## Discussion

Note that this value is only set within the content views of a `TabView`.

A `nil` value corresponds to an undefined placement.

## See Also

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom footer to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`struct TabBarMinimizeBehavior`

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

---

# https://developer.apple.com/documentation/swiftui/tabbarplacement

- SwiftUI
- TabBarPlacement

Structure

# TabBarPlacement

A placement for tabs in a tab view.

struct TabBarPlacement

## Topics

### Type Properties

`static let bottomBar: TabBarPlacement`

Bottom bar of a tab view.

`static let ornament: TabBarPlacement`

Tab view displaying as an ornament.

`static let pageIndicator: TabBarPlacement`

Tab view displaying as an indicator that shows the position within the pages.

`static let sidebar: TabBarPlacement`

The sidebar of a tab view.

`static let topBar: TabBarPlacement`

Top bar of a tab view.

## Relationships

### Conforms To

- `Equatable`
- `Hashable`

## See Also

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom footer to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`struct TabBarMinimizeBehavior`

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

---

# https://developer.apple.com/documentation/swiftui/environmentvalues/istabbarshowingsections

- SwiftUI
- EnvironmentValues
- isTabBarShowingSections

Instance Property

# isTabBarShowingSections

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

var isTabBarShowingSections: `Bool` { get }

## See Also

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom footer to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`struct TabBarMinimizeBehavior`

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

---

# https://developer.apple.com/documentation/swiftui/tabbarminimizebehavior

- SwiftUI
- TabBarMinimizeBehavior

Structure

# TabBarMinimizeBehavior

struct TabBarMinimizeBehavior

## Topics

### Type Properties

`static let automatic: TabBarMinimizeBehavior`

Determine the behavior automatically based on the surrounding context.

`static let never: TabBarMinimizeBehavior`

Never minimize the tab bar.

`static let onScrollDown: TabBarMinimizeBehavior`

Minimize the tab bar when downwards scrolling starts. Minimizing is supported for tab bars on only iPhone.

`static let onScrollUp: TabBarMinimizeBehavior`

Minimize the tab bar when upwards scrolling starts. Minimizing is supported for tab bars on only iPhone.

## Relationships

### Conforms To

- `Equatable`
- `Hashable`
- `Sendable`
- `SendableMetatype`

## See Also

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom footer to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`enum TabViewBottomAccessoryPlacement`

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

---

# https://developer.apple.com/documentation/swiftui/tabviewbottomaccessoryplacement

- SwiftUI
- TabViewBottomAccessoryPlacement

Enumeration

# TabViewBottomAccessoryPlacement

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.

enum TabViewBottomAccessoryPlacement

## Overview

The following example shows playback controls when the view is inline, and an expanded slider player view when the view is expanded.

struct MusicPlaybackView: View {
@Environment(\.tabViewBottomAccessoryPlacement) var placement

var body: some View {
switch placement {
case .inline:
ControlsPlaybackView()
case .expanded:
SliderPlaybackView()
}
}

You can set the `TabView` bottom accessory using `tabViewBottomAccessory(content:)`

TabView {
Tab("Home", systemImage: "house") {
HomeView()
}

Tab("Alerts", systemImage: "bell") {
AlertsView()
}

TabSection("Categories") {
Tab("Climate", systemImage: "fan") {
ClimateView()
}

Tab("Lights", systemImage: "lightbulb") {
LightsView()
}
}
}
.tabViewBottomAccessory {
HomeStatusView()
}

## Topics

### Enumeration Cases

`case expanded`

The bar is expanded on top of the bottom tab bar, if there is a bottom tab bar, or at the bottom of the tab’s content view.

`case inline`

The view is displayed in line with the bottom tab bar.

## Relationships

### Conforms To

- `Equatable`
- `Hashable`
- `Sendable`
- `SendableMetatype`

## See Also

### Configuring a tab bar

Adds a custom header to the sidebar of a tab view.

Adds a custom footer to the sidebar of a tab view.

Adds a custom bottom bar to the sidebar of a tab view.

`struct AdaptableTabBarPlacement`

A placement for tabs in a tab view using the adaptable sidebar style.

`var tabBarPlacement: TabBarPlacement?`

The current placement of the tab bar.

`struct TabBarPlacement`

A placement for tabs in a tab view.

`var isTabBarShowingSections: Bool`

A Boolean value that determines whether a tab view shows the expanded contents of a tab section.

`struct TabBarMinimizeBehavior`

---

# https://developer.apple.com/documentation/swiftui/view/sectionactions(content:)

#app-main)

- SwiftUI
- View
- sectionActions(content:)

Instance Method

# sectionActions(content:)

Adds custom actions to a section.

nonisolated

## Discussion

On iOS, the actions are displayed as items after the content of the section. On macOS, the actions are displayed when a user hovers over the section.

The following example adds an ‘Add’ button to the ‘Categories’ section.

List {
Label("Home", systemImage: "house")
Label("Alerts", systemImage: "bell")

Section("Categories") {
Label("Climate", systemImage: "fan")
Label("Lights", systemImage: "lightbulb")
}
.sectionActions {
Button("Add Category", systemImage: "plus") { }
}
}

## See Also

### Configuring a tab

`struct TabPlacement`

A place that a tab can appear.

`struct TabContentBuilder`

A result builder that constructs tabs for a tab view that supports programmatic selection. This builder requires that all tabs in the tab view have the same selection type.

`protocol TabContent`

A type that provides content for programmatically selectable tabs in a tab view.

`struct AnyTabContent`

Type erased tab content.

---

# https://developer.apple.com/documentation/swiftui/tabplacement

- SwiftUI
- TabPlacement

Structure

# TabPlacement

A place that a tab can appear.

struct TabPlacement

## Overview

Not all `TabView` styles support all placements.

## Topics

### Type Properties

`static let automatic: TabPlacement`

The default tab location.

`static let pinned: TabPlacement`

The pinned tab placement location.

`static let sidebarOnly: TabPlacement`

The sidebar tab placement location.

## Relationships

### Conforms To

- `Equatable`
- `Hashable`

## See Also

### Configuring a tab

Adds custom actions to a section.

`struct TabContentBuilder`

A result builder that constructs tabs for a tab view that supports programmatic selection. This builder requires that all tabs in the tab view have the same selection type.

`protocol TabContent`

A type that provides content for programmatically selectable tabs in a tab view.

`struct AnyTabContent`

Type erased tab content.

---

# https://developer.apple.com/documentation/swiftui/tabcontentbuilder

- SwiftUI
- TabContentBuilder

Structure

# TabContentBuilder

A result builder that constructs tabs for a tab view that supports programmatic selection. This builder requires that all tabs in the tab view have the same selection type.

@resultBuilder

## Topics

### Structures

`struct Content`

A view representation of the content of a builder-based tab view with selection.

### Type Methods

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:_:_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:_:_:_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:_:_:_:_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:_:_:_:_:_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:_:_:_:_:_:_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildblock(_:_:_:_:_:_:_:_:_:_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildexpression(_:))

`](https://developer.apple.com/documentation/swiftui/tabcontentbuilder/buildif(_:))

## See Also

### Configuring a tab

Adds custom actions to a section.

`struct TabPlacement`

A place that a tab can appear.

`protocol TabContent`

A type that provides content for programmatically selectable tabs in a tab view.

`struct AnyTabContent`

Type erased tab content.

---

# https://developer.apple.com/documentation/swiftui/tabcontent

- SwiftUI
- TabContent

Protocol

# TabContent

A type that provides content for programmatically selectable tabs in a tab view.

@ `MainActor` @preconcurrency

## Overview

A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type’s base declaration:

struct MyCustomType: Transition {
// `@preconcurrency @MainActor` isolation by default
}

Isolation to the main actor is the default, but it’s not required. Declare the conformance in an extension to opt out of main actor isolation:

extension MyCustomType: Transition {
// `nonisolated` by default
}

## Topics

### Associated Types

`associatedtype Body : TabContent`

The type of content representing the body of this content type.

**Required**

`associatedtype TabValue : Hashable`

The type used to drive selection for the containing tab view.

### Instance Properties

`var body: Self.Body`

The value of this type’s nested content.

### Instance Methods

`func accessibilityHint(_:isEnabled:)`

Communicates to the user what happens after selecting the tab.

`](https://developer.apple.com/documentation/swiftui/tabcontent/accessibilityidentifier(_:isenabled:))

Uses the string you specify to identify the view. Use this value for testing. It isn’t visible to the user.

`func accessibilityInputLabels(_:isEnabled:)`

Sets alternate input labels with which users identify a tab.

`func accessibilityLabel(_:isEnabled:)`

Adds a label to the tab that describes its contents.

`func accessibilityValue(_:isEnabled:)`

Adds a textual description of the value that the tab contains.

`func badge(_:)`

Generates a badge for a tab from an integer value.

`](https://developer.apple.com/documentation/swiftui/tabcontent/contextmenu(menuitems:))

Adds a context menu to a tab.

`](https://developer.apple.com/documentation/swiftui/tabcontent/customizationbehavior(_:for:))

Configures the customization behavior of customizable tab view content.

`](https://developer.apple.com/documentation/swiftui/tabcontent/customizationid(_:))

Sets the identifier for a tab to persist its state.

`](https://developer.apple.com/documentation/swiftui/tabcontent/defaultvisibility(_:for:))

Configures the default visibility of a tab in customizable contexts.

`](https://developer.apple.com/documentation/swiftui/tabcontent/disabled(_:))

Controls whether users can interact with this tab.

`](https://developer.apple.com/documentation/swiftui/tabcontent/draggable(_:))

Activates this tab as the source of a drag and drop operation. This tab can only be dragged when in the sidebar.

`](https://developer.apple.com/documentation/swiftui/tabcontent/dropdestination(for:action:))

Defines the destination of a drag and drop operation that handles the dropped content with a closure that you specify.

`](https://developer.apple.com/documentation/swiftui/tabcontent/hidden(_:))

Hides the tab from the user.

`](https://developer.apple.com/documentation/swiftui/tabcontent/popover(ispresented:attachmentanchor:arrowedge:content:))

Presents a popover when a given condition is true.

`](https://developer.apple.com/documentation/swiftui/tabcontent/popover(item:attachmentanchor:arrowedge:content:))

Presents a popover using the given item as a data source for the popover’s content.

`](https://developer.apple.com/documentation/swiftui/tabcontent/sectionactions(content:))

Adds custom actions to a tab section.

`](https://developer.apple.com/documentation/swiftui/tabcontent/springloadingbehavior(_:))

Sets the spring loading behavior for the tab.

`](https://developer.apple.com/documentation/swiftui/tabcontent/swipeactions(edge:allowsfullswipe:content:))

Adds custom swipe actions to a tab in a tab view.

`](https://developer.apple.com/documentation/swiftui/tabcontent/tabplacement(_:))

Specifies the placement of a tab.

## Relationships

### Conforming Types

- `AnyTabContent`
- `ForEach`
Conforms when `Data` conforms to `RandomAccessCollection`, `ID` conforms to `Hashable`, and `Content` conforms to `TabContent`.

- `Group`
Conforms when `Content` conforms to `TabContent`.

- `Tab`
Conforms when `Value` conforms to `Hashable`, `Content` conforms to `View`, and `Label` conforms to `View`.

- `TabSection`
Conforms when `Header` conforms to `View`, `Content` conforms to `TabContent`, `Footer` conforms to `View`, and `SelectionValue` is `Content.TabValue`.

## See Also

### Configuring a tab

Adds custom actions to a section.

`struct TabPlacement`

A place that a tab can appear.

`struct TabContentBuilder`

A result builder that constructs tabs for a tab view that supports programmatic selection. This builder requires that all tabs in the tab view have the same selection type.

`struct AnyTabContent`

Type erased tab content.

---

# https://developer.apple.com/documentation/swiftui/anytabcontent

- SwiftUI
- AnyTabContent

Structure

# AnyTabContent

Type erased tab content.

## Topics

### Initializers

Create an instance that type-erases `tabContent`.

## Relationships

### Conforms To

- `TabContent`

## See Also

### Configuring a tab

Adds custom actions to a section.

`struct TabPlacement`

A place that a tab can appear.

`struct TabContentBuilder`

A result builder that constructs tabs for a tab view that supports programmatic selection. This builder requires that all tabs in the tab view have the same selection type.

`protocol TabContent`

A type that provides content for programmatically selectable tabs in a tab view.

---

# https://developer.apple.com/documentation/swiftui/view/tabviewcustomization(_:)

#app-main)

- SwiftUI
- View
- tabViewCustomization(\_:)

Instance Method

# tabViewCustomization(\_:)

Specifies the customizations to apply to the sidebar representation of the tab view.

nonisolated

## Parameters

`customization`

The customization object to store user customization in.

## Discussion

Only the `sidebarAdaptable` style supports supports customization. Specifying a non-nil `TabViewCustomization` object using this modifier enables customization.

By default, if a person hasn’t made customizations, tabs appear according to the default builder visibilities and sections appear in the order you declare in the tab view’s tab builder.

You can change the default visibility by using the `defaultVisibility(_:for:)` with a `sidebar` placement.

You can change the default section order by changing the order in the builder. If there’s an existing persisted customization, reset the order by calling `resetTabOrder()` when you change the order.

All tabs and tab sections that support customization need to have a customization ID. You can mark a tab as being non-customizable by specifying a `disabled` behavior in all adaptable tab bar placements using `customizationBehavior(_:for:)`.

On macOS, a default interaction is provided for reordering sections but not for controlling the visibility of individual tabs. A custom experience should be provided if desired by setting the visibility of the tab on the customization.

The following code example uses `@AppStorage` to automatically persist any visibility or section order customizations a person makes.

@AppStorage
private var customization: TabViewCustomization

TabView {
Tab("Home", systemImage: "house") {
MyHomeView()
}
.customizationID("com.myApp.home")

Tab("Reports", systemImage: "chart.bar") {
MyReportsView()
}
.customizationID("com.myApp.reports")

TabSection("Categories") {
Tab("Climate", systemImage: "fan") {
ClimateView()
}
.customizationID("com.myApp.climate")

Tab("Lights", systemImage: "lightbulb") {
LightsView()
}
.customizationID("com.myApp.lights")
}
.customizationID("com.myApp.browse")
}
.tabViewStyle(.sidebarAdaptable)
.tabViewCustomization($customization)

## See Also

### Enabling tab customization

`struct TabViewCustomization`

The customizations a person makes to an adaptable sidebar tab view.

`struct TabCustomizationBehavior`

The customization behavior of customizable tab view content.

---

# https://developer.apple.com/documentation/swiftui/tabviewcustomization

- SwiftUI
- TabViewCustomization

Structure

# TabViewCustomization

The customizations a person makes to an adaptable sidebar tab view.

struct TabViewCustomization

## Overview

By default, if a person hasn’t made customizations, tabs appear according to the default builder visibilities and sections appear in the order you declare in the tab view’s tab builder.

You can change the default visibility by using the `defaultVisibility(_:for:)` with a `sidebar` placement.

You can change the default section order by changing the order in the builder. If there’s an existing persisted customization, reset the order by calling `resetTabOrder()` when you change the order.

All tabs and tab sections that support customization need to have a customization ID. You can mark a tab as being non-customizable by specifying a `disabled` behavior in all adaptable tab bar placements using `customizationBehavior(_:for:)`.

On macOS, a default interaction is provided for reordering sections but not for controlling the visibility of individual tabs. A custom experience should be provided if desired by setting the visibility of the tab on the customization.

The following code example uses `@AppStorage` to automatically persist any visibility or section order customizations a person makes.

@AppStorage
private var customization: TabViewCustomization

TabView {
Tab("Home", systemImage: "house") {
MyHomeView()
}
.customizationID("com.myApp.home")

Tab("Reports", systemImage: "chart.bar") {
MyReportsView()
}
.customizationID("com.myApp.reports")

TabSection("Categories") {
Tab("Climate", systemImage: "fan") {
ClimateView()
}
.customizationID("com.myApp.climate")

Tab("Lights", systemImage: "lightbulb") {
LightsView()
}
.customizationID("com.myApp.lights")
}
.customizationID("com.myApp.browse")
}
.tabViewStyle(.sidebarAdaptable)
.tabViewCustomization($customization)

## Topics

### Structures

`struct SectionCustomization`

The customizations a user has made to a `TabSection`.

`struct TabCustomization`

The customizations a user has made to a `Tab`.

### Initializers

`init()`

Creates an empty tab sidebar customization.

### Instance Methods

`func resetSectionOrder()`

Resets ordering )

Resets all tab sidebar visibilities

The customization of the section, identified by its customization identifier.

The customization for a section’s children, identified by the section’s customization identifier.

Deprecated

The visibility of the tab identified by its customization identifier.

The customization of the tab, identified by its customization identifier.

## Relationships

### Conforms To

- `Decodable`
- `Encodable`
- `Equatable`
- `Sendable`
- `SendableMetatype`

## See Also

### Enabling tab customization

Specifies the customizations to apply to the sidebar representation of the tab view.

`struct TabCustomizationBehavior`

The customization behavior of customizable tab view content.

---

# https://developer.apple.com/documentation/swiftui/tabcustomizationbehavior

- SwiftUI
- TabCustomizationBehavior

Structure

# TabCustomizationBehavior

The customization behavior of customizable tab view content.

struct TabCustomizationBehavior

## Overview

Use this type in conjunction with the `customizationBehavior(_:for:)` modifier.

## Topics

### Type Properties

`static var automatic: TabCustomizationBehavior`

The automatic customization behavior.

`static var disabled: TabCustomizationBehavior`

The customization behavior isn’t available.

`static var reorderable: TabCustomizationBehavior`

The reorderable customization behavior.

## Relationships

### Conforms To

- `Equatable`

## See Also

### Enabling tab customization

Specifies the customizations to apply to the sidebar representation of the tab view.

`struct TabViewCustomization`

The customizations a person makes to an adaptable sidebar tab view.

---

# https://developer.apple.com/documentation/swiftui/hsplitview

- SwiftUI
- HSplitView

Structure

# HSplitView

A layout container that arranges its children in a horizontal line and allows the user to resize them using dividers placed between them.

## Topics

## Relationships

### Conforms To

- `View`

## See Also

### Displaying views in multiple panes

`struct VSplitView`

A layout container that arranges its children in a vertical line and allows the user to resize them using dividers placed between them.

---

# https://developer.apple.com/documentation/swiftui/vsplitview

- SwiftUI
- VSplitView

Structure

# VSplitView

A layout container that arranges its children in a vertical line and allows the user to resize them using dividers placed between them.

## Topics

## Relationships

### Conforms To

- `View`

## See Also

### Displaying views in multiple panes

`struct HSplitView`

A layout container that arranges its children in a horizontal line and allows the user to resize them using dividers placed between them.

---

# https://developer.apple.com/documentation/swiftui/navigationview

- SwiftUI
- NavigationView Deprecated

Structure

# NavigationView

A view for presenting a stack of views that represents a visible path in a navigation hierarchy.

iOS 13.0–26.1DeprecatediPadOS 13.0–26.1DeprecatedMac Catalyst 13.0–26.1DeprecatedmacOS 10.15–26.1DeprecatedtvOS 13.0–26.1DeprecatedvisionOS 1.0–26.1DeprecatedwatchOS 7.0–26.1Deprecated

## Mentioned in

Migrating to new navigation types

Displaying data in lists

Picking container views for your content

## Overview

Use a `NavigationView` to create a navigation-based app in which the user can traverse a collection of views. Users navigate to a destination view by selecting a `NavigationLink` that you provide. On iPadOS and macOS, the destination content appears in the next column. Other platforms push a new view onto the stack, and enable removing items from the stack with platform-specific controls, like a Back button or a swipe gesture.

Use the `init(content:)` initializer to create a navigation view that directly associates navigation links and their destination views:

NavigationView {
List(model.notes) { note in
NavigationLink(note.title, destination: NoteEditor(id: note.id))
}
Text("Select a Note")
}

Style a navigation view by modifying it with the `navigationViewStyle(_:)` view modifier. Use other modifiers, like `navigationTitle(_:)`, on views presented by the navigation view to customize the navigation interface for the presented view.

## Topics

### Creating a navigation view

Creates a destination-based navigation view.

### Styling navigation views

Sets the style for navigation views within this view.

`protocol NavigationViewStyle`

A specification for the appearance and interaction of a navigation view.

## Relationships

### Conforms To

- `View`

## See Also

### Deprecated Types

Sets the tab bar item associated with this view.

Deprecated

---

# https://developer.apple.com/documentation/swiftui/view/tabitem(_:)

#app-main)

- SwiftUI
- View
- tabItem(\_:) Deprecated

Instance Method

# tabItem(\_:)

Sets the tab bar item associated with this view.

iOS 13.0–26.1DeprecatediPadOS 13.0–26.1DeprecatedMac Catalyst 13.0–26.1DeprecatedmacOS 10.15–26.1DeprecatedtvOS 13.0–26.1DeprecatedwatchOS 7.0–26.1Deprecated

nonisolated

## Parameters

`label`

The tab bar item to associate with this view.

## Discussion

Use `tabItem(_:)` to configure a view as a tab bar item in a `TabView`. The example below adds two views as tabs in a `TabView`:

struct View1: View {
var body: some View {
Text("View 1")
}
}

struct View2: View {
var body: some View {
Text("View 2")
}
}

struct TabItem: View {
var body: some View {
TabView {
View1()
.tabItem {
Label("Menu", systemImage: "list.dash")
}

View2()
.tabItem {
Label("Order", systemImage: "square.and.pencil")
}
}
}
}

## See Also

### Deprecated Types

`struct NavigationView`

A view for presenting a stack of views that represents a visible path in a navigation hierarchy.

Deprecated

---

# https://developer.apple.com/documentation/swiftui/app-organization

Collection

- SwiftUI
- App organization

API Collection

# App organization

Define the entry point and top-level structure of your app.

## Overview

Describe your app’s structure declaratively, much like you declare a view’s appearance. Create a type that conforms to the `App` protocol and use it to enumerate the Scenes that represent aspects of your app’s user interface.

SwiftUI enables you to write code that works across all of Apple’s platforms. However, it also enables you to tailor your app to the specific capabilities of each platform. For example, if you need to respond to the callbacks that the system traditionally makes on a UIKit, AppKit, or WatchKit app’s delegate, define a delegate object and instantiate it in your app structure using an appropriate delegate adaptor property wrapper, like `UIApplicationDelegateAdaptor`.

For platform-specific design guidance, see Getting started in the Human Interface Guidelines.

## Topics

### Creating an app

Destination Video

Leverage SwiftUI to build an immersive media experience in a multiplatform app.

Hello World

Use windows, volumes, and immersive spaces to teach people about the Earth.

Backyard Birds: Building an app with SwiftData and widgets

Create an app with persistent data, interactive widgets, and an all new in-app purchase experience.

Food Truck: Building a SwiftUI multiplatform app

Create a single codebase and app target for Mac, iPad, and iPhone.

Fruta: Building a Feature-Rich App with SwiftUI

Create a shared codebase to build a multiplatform app that offers widgets and an App Clip.

Migrating to the SwiftUI life cycle

Use a scene-based life cycle in SwiftUI while keeping your existing codebase.

`protocol App`

A type that represents the structure and behavior of an app.

### Targeting iOS and iPadOS

`UILaunchScreen`

The user interface to show while an app launches.

`UILaunchScreens`

The user interfaces to show while an app launches in response to different URL schemes.

`struct UIApplicationDelegateAdaptor`

A property wrapper type that you use to create a UIKit app delegate.

### Targeting macOS

`struct NSApplicationDelegateAdaptor`

A property wrapper type that you use to create an AppKit app delegate.

### Targeting watchOS

`struct WKApplicationDelegateAdaptor`

A property wrapper that is used in `App` to provide a delegate from WatchKit.

`struct WKExtensionDelegateAdaptor`

A property wrapper type that you use to create a WatchKit extension delegate.

### Targeting tvOS

Creating a tvOS media catalog app in SwiftUI

Build standard content lockups and rows of content shelves for your tvOS app.

### Handling system recenter events

`enum WorldRecenterPhase`

A type that represents information associated with a phase of a system recenter event. Values of this type are passed to the closure specified in View.onWorldRecenter(action:).

## See Also

### App structure

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui/scenes

Collection

- SwiftUI
- Scenes

API Collection

# Scenes

Declare the user interface groupings that make up the parts of your app.

## Overview

A scene represents a part of your app’s user interface that has a life cycle that the system manages. An `App` instance presents the scenes it contains, while each `Scene` acts as the root element of a `View` hierarchy.

The system presents scenes in different ways depending on the type of scene, the platform, and the context. A scene might fill the entire display, part of the display, a window, a tab in a window, or something else. In some cases, your app might also be able to display more than one instance of the scene at a time, like when a user simultaneously opens multiple windows based on a single `WindowGroup` declaration in your app. For more information about the primary built-in scene types, see Windows and Documents.

You configure scenes using modifiers, similar to how you configure views. For example, you can adjust the appearance of the window that contains a scene — if the scene happens to appear in a window — using the `windowStyle(_:)` modifier. Similarly, you can add menu commands that become available when the scene is in the foreground on certain platforms using the `commands(content:)` modifier.

## Topics

### Creating scenes

`protocol Scene`

A part of an app’s user interface with a life cycle managed by the system.

`struct SceneBuilder`

A result builder for composing a collection of scenes into a single composite scene.

### Monitoring scene life cycle

`var scenePhase: ScenePhase`

The current phase of the scene.

`enum ScenePhase`

An indication of a scene’s operational state.

### Managing a settings window

`struct Settings`

A scene that presents an interface for viewing and modifying an app’s settings.

`struct SettingsLink`

A view that opens the Settings scene defined by an app.

`struct OpenSettingsAction`

An action that presents the settings scene for an app.

`var openSettings: OpenSettingsAction`

A Settings presentation action stored in a view’s environment.

### Building a menu bar

Building and customizing the menu bar with SwiftUI

Provide a seamless, cross-platform user experience by building a native menu bar for iPadOS and macOS.

### Creating a menu bar extra

`struct MenuBarExtra`

A scene that renders itself as a persistent control in the system menu bar.

Sets the style for menu bar extra created by this scene.

`protocol MenuBarExtraStyle`

A specification for the appearance and behavior of a menu bar extra scene.

### Creating watch notifications

`struct WKNotificationScene`

A scene which appears in response to receiving the specified category of remote or local notifications.

## See Also

### App structure

Define the entry point and top-level structure of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui/windows

Collection

- SwiftUI
- Windows

API Collection

# Windows

Display user interface content in a window or a collection of windows.

## Overview

The most common way to present a view hierarchy in your app’s interface is with a `WindowGroup`, which produces a platform-specific behavior and appearance.

On platforms that support it, people can open multiple windows from the group simultaneously. Each window relies on the same root view definition, but retains its own view state. On some platforms, you can also supplement your app’s user interface with a single-instance window using the `Window` scene type.

Configure windows using scene modifiers that you add to the window declaration, like `windowStyle(_:)` or `defaultPosition(_:)`. You can also indicate how to configure new windows that you present from a view hierarchy by adding the `presentedWindowStyle(_:)` view modifier to a view in the hierarchy.

For design guidance, see Windows in the Human Interface Guidelines.

## Topics

### Essentials

Customizing window styles and state-restoration behavior in macOS

Configure how your app’s windows look and function in macOS to provide an engaging and more coherent experience.

Bringing multiple windows to your SwiftUI app

Compose rich views by reacting to state changes and customize your app’s scene presentation and behavior on iPadOS and macOS.

### Creating windows

`struct WindowGroup`

A scene that presents a group of identically structured windows.

`struct Window`

A scene that presents its content in a single, unique window.

`struct UtilityWindow`

A specialized window scene that provides secondary utility to the content of the main scenes of an application.

`protocol WindowStyle`

A specification for the appearance and interaction of a window.

Sets the style for windows created by this scene.

### Styling the associated toolbar

Sets the style for the toolbar defined within this scene.

Sets the label style of items in a toolbar and enables user customization.

Sets the label style of items in a toolbar.

`protocol WindowToolbarStyle`

A specification for the appearance and behavior of a window’s toolbar.

### Opening windows

Presenting windows and spaces

Open and close the scenes that make up your app’s interface.

`var supportsMultipleWindows: Bool`

A Boolean value that indicates whether the current platform supports opening multiple windows.

`var openWindow: OpenWindowAction`

A window presentation action stored in a view’s environment.

`struct OpenWindowAction`

An action that presents a window.

`struct PushWindowAction`

An action that opens the requested window in place of the window the action is called from.

### Closing windows

`var dismissWindow: DismissWindowAction`

A window dismissal action stored in a view’s environment.

`struct DismissWindowAction`

An action that dismisses a window associated to a particular scene.

`var dismiss: DismissAction`

An action that dismisses the current presentation.

`struct DismissAction`

An action that dismisses a presentation.

`struct DismissBehavior`

Programmatic window dismissal behaviors.

### Sizing a window

Positioning and sizing windows

Influence the initial geometry of windows that your app presents.

`func defaultSize(_:)`

Sets a default size for a window.

Sets a default width and height for a window.

Sets a default size for a volumetric window.

Sets the kind of resizability to use for a window.

`struct WindowResizability`

The resizability of a window.

Specifies how windows derived form this scene should determine their size when zooming.

`struct WindowIdealSize`

A type which defines the size a window should use when zooming.

### Positioning a window

Sets a default position for a window.

`struct WindowLevel`

The level of a window.

Sets the window level of this scene.

`struct WindowLayoutRoot`

A proxy which represents the root contents of a window.

`struct WindowPlacement`

A type which represents a preferred size and position for a window.

Defines a function used for determining the default placement of windows.

Provides a function which determines a placement to use when windows of a scene zoom.

`struct WindowPlacementContext`

A type which represents contextual information used for sizing and positioning windows.

`struct WindowProxy`

The proxy for an open window in the app.

`struct DisplayProxy`

A type which provides information about display hardware.

### Configuring window visibility

`struct WindowVisibilityToggle`

A specialized button for toggling the visibility of a window.

Sets the default launch behavior for this scene.

Sets the restoration behavior for this scene.

`struct SceneLaunchBehavior`

The launch behavior for a scene.

`struct SceneRestorationBehavior`

The restoration behavior for a scene.

Sets the preferred visibility of the non-transient system views overlaying the app.

Configures the visibility of the window toolbar when the window enters full screen mode.

`struct WindowToolbarFullScreenVisibility`

The visibility of the window toolbar with respect to full screen mode.

### Managing window behavior

`struct WindowManagerRole`

Options for defining how a scene’s windows behave when used within a managed window context, such as full screen mode and Stage Manager.

Configures the role for windows derived from `self` when participating in a managed window context, such as full screen or Stage Manager.

`struct WindowInteractionBehavior`

Options for enabling and disabling window interaction behaviors.

Configures the dismiss functionality for the window enclosing `self`.

Configures the full screen functionality for the window enclosing `self`.

Configures the minimize functionality for the window enclosing `self`.

Configures the resize functionality for the window enclosing `self`.

Configures the behavior of dragging a window by its background.

### Interacting with volumes

Adds an action to perform when the viewpoint of the volume changes.

Specifies which viewpoints are supported for the window bar and ornaments in a volume.

`struct VolumeViewpointUpdateStrategy`

A type describing when the action provided to `onVolumeViewpointChange(updateStrategy:initial:_:)` should be called.

`struct Viewpoint3D`

A type describing what direction something is being viewed from.

`enum SquareAzimuth`

A type describing what direction something is being viewed from along the horizontal plane and snapped to 4 directions.

`struct WorldAlignmentBehavior`

A type representing the world alignment behavior for a scene.

Specifies how a volume should be aligned when moved in the world.

`struct WorldScalingBehavior`

Specifies the scaling behavior a window should have within the world.

Specify the world scaling behavior for the window.

`struct WorldScalingCompensation`

Indicates whether returned metrics will take dynamic scaling into account.

The current limitations of the device tracking the user’s surroundings.

`struct WorldTrackingLimitation`

A structure to represent limitations of tracking the user’s surroundings.

`struct SurfaceSnappingInfo`

A type representing information about the window scenes snap state.

### Deprecated Types

`enum ControlActiveState`

The active appearance expected of controls in a window.

Deprecated

## See Also

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui/immersive-spaces

Collection

- SwiftUI
- Immersive spaces

API Collection

# Immersive spaces

Display unbounded content in a person’s surroundings.

## Overview

Use an immersive space in visionOS to present SwiftUI views outside of any containers. You can include any views in a space, although you typically use a `RealityView` to present RealityKit content.

You can request one of three styles of spaces with the `immersionStyle(selection:in:)` scene modifier:

- The `mixed` style blends your content with passthrough. This enables you to place virtual objects in a person’s surroundings.

- The `full` style displays only your content, with passthrough turned off. This enables you to completely control the visual experience, like when you want to transport people to a new world.

- The `progressive` style completely replaces passthrough in a portion of the display. You might use this style to keep people grounded in the real world while displaying a view into another world.

When you open an immersive space, the system continues to display all of your app’s windows, but hides windows from other apps. The system supports displaying only one space at a time across all apps, so your app can only open a space if one isn’t already open.

## Topics

### Creating an immersive space

`struct ImmersiveSpace`

A scene that presents its content in an unbounded space.

`struct ImmersiveSpaceContentBuilder`

A result builder for composing a collection of immersive space elements.

Sets the style for an immersive space.

`protocol ImmersionStyle`

The styles that an immersive space can have.

`var immersiveSpaceDisplacement: Pose3D`

The displacement that the system applies to the immersive space when moving the space away from its default position, in meters.

`struct ImmersiveEnvironmentBehavior`

The behavior of the system-provided immersive environments when a scene is opened by your app.

`struct ProgressiveImmersionAspectRatio`

### Opening an immersive space

`var openImmersiveSpace: OpenImmersiveSpaceAction`

An action that presents an immersive space.

`struct OpenImmersiveSpaceAction`

### Closing the immersive space

`var dismissImmersiveSpace: DismissImmersiveSpaceAction`

An immersive space dismissal action stored in a view’s environment.

`struct DismissImmersiveSpaceAction`

An action that dismisses an immersive space.

### Hiding upper limbs during immersion

Sets the preferred visibility of the user’s upper limbs, while an `ImmersiveSpace` scene is presented.

### Adjusting content brightness

Sets the content brightness of an immersive space.

`struct ImmersiveContentBrightness`

The content brightness of an immersive space.

### Responding to immersion changes

Performs an action when the immersion state of your app changes.

`struct ImmersionChangeContext`

A structure that represents a state of immersion of your app.

### Adding menu items to an immersive space

Add menu items to open immersive spaces from a media player’s environment picker.

### Handling remote immersive spaces

`struct RemoteImmersiveSpace`

A scene that presents its content in an unbounded space on a remote device.

`struct RemoteDeviceIdentifier`

An opaque type that identifies a remote device displaying scene content in a `RemoteImmersiveSpace`.

## See Also

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui/documents

Collection

- SwiftUI
- Documents

API Collection

# Documents

Enable people to open and manage documents.

## Overview

Create a user interface for opening and editing documents using the `DocumentGroup` scene type.

You initialize the scene with a model that describes the organization of the document’s data, and a view hierarchy that SwiftUI uses to display the document’s contents to the user. You can use either a value type model, which you typically store as a structure, that conforms to the `FileDocument` protocol, or a reference type model you store in a class instance that conforms to the `ReferenceFileDocument` protocol. You can also use SwiftData-backed documents using an initializer like `init(editing:contentType:editor:prepareDocument:)`.

SwiftUI supports standard behaviors that users expect from a document-based app, appropriate for each platform, like multiwindow support, open and save panels, drag and drop, and so on. For related design guidance, see Patterns in the Human Interface Guidelines.

## Topics

### Creating a document

Building a document-based app with SwiftUI

Create, save, and open documents in a multiplatform app.

Building a document-based app using SwiftData

Code along with the WWDC presenter to transform an app with SwiftData.

`struct DocumentGroup`

A scene that enables support for opening, creating, and saving documents.

### Storing document data in a structure instance

`protocol FileDocument`

A type that you use to serialize documents to and from file.

`struct FileDocumentConfiguration`

The properties of an open file document.

### Storing document data in a class instance

`protocol ReferenceFileDocument`

A type that you use to serialize reference type documents to and from file.

`struct ReferenceFileDocumentConfiguration`

The properties of an open reference file document.

`var undoManager: UndoManager?`

The undo manager used to register a view’s undo operations.

### Accessing document configuration

`var documentConfiguration: DocumentConfiguration?`

The configuration of a document in a `DocumentGroup`.

`struct DocumentConfiguration`

### Reading and writing documents

`struct FileDocumentReadConfiguration`

The configuration for reading file contents.

`struct FileDocumentWriteConfiguration`

The configuration for serializing file contents.

### Opening a document programmatically

`var newDocument: NewDocumentAction`

An action in the environment that presents a new document.

`struct NewDocumentAction`

An action that presents a new document.

`var openDocument: OpenDocumentAction`

An action in the environment that presents an existing document.

`struct OpenDocumentAction`

An action that presents an existing document.

### Configuring the document launch experience

`struct DocumentGroupLaunchScene`

A launch scene for document-based applications.

`struct DocumentLaunchView`

A view to present when launching document-related user experience.

`struct DocumentLaunchGeometryProxy`

A proxy for access to the frame of the scene and its title view.

`struct DefaultDocumentGroupLaunchActions`

The default actions for the document group launch scene and the document launch view.

`struct NewDocumentButton`

A button that creates and opens new documents.

`protocol DocumentBaseBox`

A Box that allows setting its Document base not requiring the caller to know the exact types of the box and its base.

### Renaming a document

`struct RenameButton`

A button that triggers a standard rename action.

`func renameAction(_:)`

Sets a closure to run for the rename action.

`var rename: RenameAction?`

An action that activates the standard rename interaction.

`struct RenameAction`

An action that activates a standard rename interaction.

## See Also

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui/modal-presentations

Collection

- SwiftUI
- Modal presentations

API Collection

# Modal presentations

Present content in a separate view that offers focused interaction.

## Overview

To draw attention to an important, narrowly scoped task, you display a modal presentation, like an alert, popover, sheet, or confirmation dialog.

In SwiftUI, you create a modal presentation using a view modifier that defines how the presentation looks and the condition under which SwiftUI presents it. SwiftUI detects when the condition changes and makes the presentation for you. Because you provide a `Binding` to the condition that initiates the presentation, SwiftUI can reset the underlying value when the user dismisses the presentation.

For design guidance, see Modality in the Human Interface Guidelines.

## Topics

### Configuring a dialog

`struct DialogSeverity`

The severity of an alert or confirmation dialog.

### Showing a sheet, cover, or popover

Presents a sheet when a binding to a Boolean value that you provide is true.

Presents a sheet using the given item as a data source for the sheet’s content.

Presents a modal view that covers as much of the screen as possible when binding to a Boolean value you provide is true.

Presents a modal view that covers as much of the screen as possible using the binding you provide as a data source for the sheet’s content.

Presents a popover using the given item as a data source for the popover’s content.

Presents a popover when a given condition is true.

`enum PopoverAttachmentAnchor`

An attachment anchor for a popover.

### Adapting a presentation size

Specifies how to adapt a presentation to horizontally and vertically compact size classes.

Specifies how to adapt a presentation to compact size classes.

`struct PresentationAdaptation`

Strategies for adapting a presentation to a different size class.

Sets the sizing of the containing presentation.

`protocol PresentationSizing`

A type that defines the size of the presentation content and how the presentation size adjusts to its content’s size changing.

`struct PresentationSizingRoot`

A proxy to a view provided to the presentation with a defined presentation size.

`struct PresentationSizingContext`

Contextual information about a presentation.

### Configuring a sheet’s height

Sets the available detents for the enclosing sheet.

Sets the available detents for the enclosing sheet, giving you programmatic control of the currently selected detent.

Configures the behavior of swipe gestures on a presentation.

Sets the visibility of the drag indicator on top of a sheet.

`struct PresentationDetent`

A type that represents a height where a sheet naturally rests.

`protocol CustomPresentationDetent`

The definition of a custom detent with a calculated height.

`struct PresentationContentInteraction`

A behavior that you can use to influence how a presentation responds to swipe gestures.

### Styling a sheet and its background

Requests that the presentation have a specific corner radius.

Sets the presentation background of the enclosing sheet using a shape style.

Sets the presentation background of the enclosing sheet to a custom view.

Controls whether people can interact with the view behind a presentation.

`struct PresentationBackgroundInteraction`

The kinds of interaction available to views behind a presentation.

### Presenting an alert

`struct AlertScene`

A scene that renders itself as a standalone alert dialog.

`func alert(_:isPresented:actions:)`

Presents an alert when a given condition is true, using a text view for the title.

`func alert(_:isPresented:presenting:actions:)`

Presents an alert using the given data to produce the alert’s content and a text view as a title.

Presents an alert when an error is present.

`func alert(_:isPresented:actions:message:)`

Presents an alert with a message when a given condition is true using a text view as a title.

`func alert(_:isPresented:presenting:actions:message:)`

Presents an alert with a message using the given data to produce the alert’s content and a text view for a title.

Presents an alert with a message when an error is present.

### Getting confirmation for an action

`func confirmationDialog(_:isPresented:titleVisibility:actions:)`

Presents a confirmation dialog when a given condition is true, using a text view for the title.

`func confirmationDialog(_:isPresented:titleVisibility:presenting:actions:)`

Presents a confirmation dialog using data to produce the dialog’s content and a text view for the title.

`func dismissalConfirmationDialog(_:shouldPresent:actions:)`

Presents a confirmation dialog when a dismiss action has been triggered.

### Showing a confirmation dialog with a message

`func confirmationDialog(_:isPresented:titleVisibility:actions:message:)`

Presents a confirmation dialog with a message when a given condition is true, using a text view for the title.

`func confirmationDialog(_:isPresented:titleVisibility:presenting:actions:message:)`

Presents a confirmation dialog with a message using data to produce the dialog’s content and a text view for the message.

`func dismissalConfirmationDialog(_:shouldPresent:actions:message:)`

### Configuring a dialog

Configures the icon used by dialogs within this view.

Configures the icon used by alerts.

Sets the severity for alerts.

Enables user suppression of dialogs and alerts presented within `self`, with a default suppression message on macOS. Unused on other platforms.

Enables user suppression of an alert with a custom suppression message.

`func dialogSuppressionToggle(_:isSuppressed:)`

Enables user suppression of dialogs and alerts presented within `self`, with a custom suppression message on macOS. Unused on other platforms.

### Exporting to file

`func fileExporter(isPresented:document:contentType:defaultFilename:onCompletion:)`

Presents a system interface for exporting a document that’s stored in a value type, like a structure, to a file on disk.

`func fileExporter(isPresented:documents:contentType:onCompletion:)`

Presents a system interface for exporting a collection of value type documents to files on disk.

`func fileExporter(isPresented:document:contentTypes:defaultFilename:onCompletion:onCancellation:)`

Presents a system interface for allowing the user to export a `FileDocument` to a file on disk.

`func fileExporter(isPresented:documents:contentTypes:onCompletion:onCancellation:)`

Presents a system dialog for allowing the user to export a collection of documents that conform to `FileDocument` to files on disk.

Presents a system interface allowing the user to export a `Transferable` item to file on disk.

Presents a system interface allowing the user to export a collection of items to files on disk.

`func fileExporterFilenameLabel(_:)`

On macOS, configures the `fileExporter` with a label for the file name field.

### Importing from file

Presents a system interface for allowing the user to import multiple files.

Presents a system interface for allowing the user to import an existing file.

Presents a system dialog for allowing the user to import multiple files.

### Moving a file

Presents a system interface for allowing the user to move an existing file to a new location.

Presents a system interface for allowing the user to move a collection of existing files to a new location.

Presents a system dialog for allowing the user to move an existing file to a new location.

Presents a system dialog for allowing the user to move a collection of existing files to a new location.

### Configuring a file dialog

On macOS, configures the `fileExporter`, `fileImporter`, or `fileMover` to provide a refined URL search experience: include or exclude hidden files, allow searching by tag, etc.

`func fileDialogConfirmationLabel(_:)`

On macOS, configures the the `fileExporter`, `fileImporter`, or `fileMover` with a custom confirmation button label.

On macOS, configures the `fileExporter`, `fileImporter`, or `fileMover` to persist and restore the file dialog configuration.

Configures the `fileExporter`, `fileImporter`, or `fileMover` to open with the specified default directory.

On macOS, configures the `fileExporter`, `fileImporter`, or `fileMover` behavior when a user chooses an alias.

`func fileDialogMessage(_:)`

On macOS, configures the the `fileExporter`, `fileImporter`, or `fileMover` with a custom text that is presented to the user, similar to a title.

On macOS, configures the the `fileImporter` or `fileMover` to conditionally disable presented URLs.

`struct FileDialogBrowserOptions`

The way that file dialogs present the file system.

### Presenting an inspector

Inserts an inspector at the applied position in the view hierarchy.

Sets a fixed, preferred width for the inspector containing this view when presented as a trailing column.

Sets a flexible, preferred width for the inspector in a trailing-column presentation.

### Dismissing a presentation

`var isPresented: Bool`

A Boolean value that indicates whether the view associated with this environment is currently presented.

`var dismiss: DismissAction`

An action that dismisses the current presentation.

`struct DismissAction`

An action that dismisses a presentation.

Conditionally prevents interactive dismissal of presentations like popovers, sheets, and inspectors.

### Deprecated modal presentations

`struct Alert`

A representation of an alert presentation.

Deprecated

`struct ActionSheet`

A representation of an action sheet presentation.

## See Also

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui/toolbars

Collection

- SwiftUI
- Toolbars

API Collection

# Toolbars

Provide immediate access to frequently used commands and controls.

## Overview

The system might present toolbars above or below your app’s content, depending on the platform and the context.

Add items to a toolbar by applying the `toolbar(content:)` view modifier to a view in your app. You can also configure the toolbar using view modifiers. For example, you can set the visibility of a toolbar with the `toolbar(_:for:)` modifier.

For design guidance, see Toolbars in the Human Interface Guidelines.

## Topics

### Populating a toolbar

`func toolbar(content:)`

Populates the toolbar or navigation bar with the specified items.

`struct ToolbarItem`

A model that represents an item which can be placed in the toolbar or navigation bar.

`struct ToolbarItemGroup`

A model that represents a group of `ToolbarItem` s which can be placed in the toolbar or navigation bar.

`struct ToolbarItemPlacement`

A structure that defines the placement of a toolbar item.

`protocol ToolbarContent`

Conforming types represent items that can be placed in various locations in a toolbar.

`struct ToolbarContentBuilder`

Constructs a toolbar item set from multi-expression closures.

`struct ToolbarSpacer`

A standard space item in toolbars.

`struct DefaultToolbarItem`

A toolbar item that represents a system component.

### Populating a customizable toolbar

Populates the toolbar or navigation bar with the specified items, allowing for user customization.

`protocol CustomizableToolbarContent`

Conforming types represent items that can be placed in various locations in a customizable toolbar.

`struct ToolbarCustomizationBehavior`

The customization behavior of customizable toolbar content.

`struct ToolbarCustomizationOptions`

Options that influence the default customization behavior of customizable toolbar content.

`struct SearchToolbarBehavior`

The behavior of a search field in a toolbar.

### Removing default items

Remove a toolbar item present by default

`struct ToolbarDefaultItemKind`

A kind of toolbar item a `View` adds by default.

### Setting toolbar visibility

Specifies the visibility of a bar managed by SwiftUI.

Specifies the preferred visibility of backgrounds on a bar managed by SwiftUI.

`struct ToolbarPlacement`

The placement of a toolbar.

`struct ContentToolbarPlacement`

### Specifying the role of toolbar content

Configures the semantic role for the content populating the toolbar.

`struct ToolbarRole`

The purpose of content that populates the toolbar.

### Styling a toolbar

`func toolbarBackground(_:for:)`

Specifies the preferred shape style of the background of a bar managed by SwiftUI.

Specifies the preferred color scheme of a bar managed by SwiftUI.

Specifies the preferred foreground style of bars managed by SwiftUI.

Sets the style for the toolbar defined within this scene.

`protocol WindowToolbarStyle`

A specification for the appearance and behavior of a window’s toolbar.

`var toolbarLabelStyle: ToolbarLabelStyle?`

The label style to apply to controls within a toolbar.

`struct ToolbarLabelStyle`

The label style of a toolbar.

`struct SpacerSizing`

A type which defines how spacers should size themselves.

### Configuring the toolbar title display mode

Configures the toolbar title display mode for this view.

`struct ToolbarTitleDisplayMode`

A type that defines the behavior of title of a toolbar.

### Setting the toolbar title menu

Configure the title menu of a toolbar.

`struct ToolbarTitleMenu`

The title menu of a toolbar.

### Creating an ornament

`func ornament(visibility:attachmentAnchor:contentAlignment:ornament:)`

Presents an ornament.

`struct OrnamentAttachmentAnchor`

An attachment anchor for an ornament.

## See Also

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Enable people to search for text or other content within your app.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui/search

Collection

- SwiftUI
- Search

API Collection

# Search

Enable people to search for text or other content within your app.

## Overview

To present a search field in your app, create and manage storage for search text and optionally for discrete search terms known as _tokens_. Then bind the storage to the search field by applying the searchable view modifier to a view in your app.

As people interact with the field, they implicitly modify the underlying storage and, thereby, the search parameters. Your app correspondingly updates other parts of its interface. To enhance the search interaction, you can also:

- Offer suggestions during search, for both text and tokens.

- Implement search scopes that help people to narrow the search space.

- Detect when people activate the search field, and programmatically dismiss the search field using environment values.

For design guidance, see Searching in the Human Interface Guidelines.

## Topics

### Searching your app’s data model

Adding a search interface to your app

Present an interface that people can use to search for content in your app.

Performing a search operation

Update search results based on search text and optional tokens that you store.

`func searchable(text:placement:prompt:)`

Marks this view as searchable, which configures the display of a search field.

`func searchable(text:tokens:placement:prompt:token:)`

Marks this view as searchable with text and tokens.

`func searchable(text:editableTokens:placement:prompt:token:)`

`struct SearchFieldPlacement`

The placement of a search field in a view hierarchy.

### Making search suggestions

Suggesting search terms

Provide suggestions to people searching for content in your app.

Configures the search suggestions for this view.

Configures how to display search suggestions within this view.

`func searchCompletion(_:)`

Associates a fully formed string with the value of this view when used as a search suggestion.

`func searchable(text:tokens:suggestedTokens:placement:prompt:token:)`

Marks this view as searchable with text, tokens, and suggestions.

`struct SearchSuggestionsPlacement`

The ways that SwiftUI displays search suggestions.

### Limiting search scope

Scoping a search operation

Divide the search space into a few broad categories.

Configures the search scopes for this view.

Configures the search scopes for this view with the specified activation strategy.

`struct SearchScopeActivation`

The ways that searchable modifiers can show or hide search scopes.

### Detecting, activating, and dismissing search

Managing search interface activation

Programmatically detect and dismiss a search field.

`var isSearching: Bool`

A Boolean value that indicates when the user is searching.

`var dismissSearch: DismissSearchAction`

An action that ends the current search interaction.

`struct DismissSearchAction`

An action that can end a search interaction.

`func searchable(text:isPresented:placement:prompt:)`

Marks this view as searchable with programmatic presentation of the search field.

`func searchable(text:tokens:isPresented:placement:prompt:token:)`

Marks this view as searchable with text and tokens, as well as programmatic presentation.

`func searchable(text:editableTokens:isPresented:placement:prompt:token:)`

`func searchable(text:tokens:suggestedTokens:isPresented:placement:prompt:token:)`

Marks this view as searchable with text, tokens, and suggestions, as well as programmatic presentation.

### Displaying toolbar content during search

Configures the search toolbar presentation behavior for any searchable modifiers within this view.

`struct SearchPresentationToolbarBehavior`

A type that defines how the toolbar behaves when presenting search.

### Searching for text in a view

Programmatically presents the find and replace interface for text editor views.

Prevents find and replace operations in a text editor.

Prevents replace operations in a text editor.

`struct FindContext`

The status of the find navigator for views which support text editing.

## See Also

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

---

# https://developer.apple.com/documentation/swiftui/app-extensions

Collection

- SwiftUI
- App extensions

API Collection

# App extensions

Extend your app’s basic functionality to other parts of the system, like by adding a Widget.

## Overview

Use SwiftUI along with WidgetKit to add widgets to your app.

Widgets provide quick access to relevant content from your app. Define a structure that conforms to the `Widget` protocol, and declare a view hierarchy for the widget. Configure the views inside the widget as you do other SwiftUI views, using view modifiers, including a few widget-specific modifiers.

For design guidance, see Widgets in the Human Interface Guidelines.

## Topics

### Creating widgets

Building Widgets Using WidgetKit and SwiftUI

Create widgets to show your app’s content on the Home screen, with custom intents for user-customizable settings.

Creating a widget extension

Display your app’s content in a convenient, informative widget on various devices.

Keeping a widget up to date

Plan your widget’s timeline to show timely, relevant information using dynamic views, and update the timeline when things change.

Making a configurable widget

Give people the option to customize their widgets by adding a custom app intent to your project.

`protocol Widget`

The configuration and content of a widget to display on the Home screen or in Notification Center.

`protocol WidgetBundle`

A container used to expose multiple widgets from a single widget extension.

`struct LimitedAvailabilityConfiguration`

A type-erased widget configuration.

`protocol WidgetConfiguration`

A type that describes a widget’s content.

`struct EmptyWidgetConfiguration`

An empty widget configuration.

### Composing control widgets

`protocol ControlWidget`

The configuration and content of a control widget to display in system spaces such as Control Center, the Lock Screen, and the Action Button.

`protocol ControlWidgetConfiguration`

A type that describes a control widget’s content.

`struct EmptyControlWidgetConfiguration`

An empty control widget configuration.

`struct ControlWidgetConfigurationBuilder`

A custom attribute that constructs a control widget’s body.

`protocol ControlWidgetTemplate`

`struct EmptyControlWidgetTemplate`

An empty control widget template.

`struct ControlWidgetTemplateBuilder`

A custom attribute that constructs a control widget template’s body.

`func controlWidgetActionHint(_:)`

The action hint of the control described by the modified label.

`func controlWidgetStatus(_:)`

The status of the control described by the modified label.

### Labeling a widget

`func widgetLabel(_:)`

Returns a localized text label that displays additional content outside the accessory family widget’s main SwiftUI view.

Creates a label for displaying additional content outside an accessory family widget’s main SwiftUI view.

### Styling a widget group

The view modifier that can be applied to `AccessoryWidgetGroup` to specify the shape the three content views will be masked with. The value of `style` is set to `.automatic`, which is `.circular` by default.

### Controlling the accented group

Adds the view and all of its subviews to the accented group.

### Managing placement in the Dynamic Island

Specifies the vertical placement for a view of an expanded Live Activity that appears in the Dynamic Island.

## See Also

### App structure

Define the entry point and top-level structure of your app.

Declare the user interface groupings that make up the parts of your app.

Display user interface content in a window or a collection of windows.

Display unbounded content in a person’s surroundings.

Enable people to open and manage documents.

Enable people to move between different parts of your app’s view hierarchy within a scene.

Present content in a separate view that offers focused interaction.

Provide immediate access to frequently used commands and controls.

Enable people to search for text or other content within your app.

---

# https://developer.apple.com/documentation/swiftui/navigationstack),



---

# https://developer.apple.com/documentation/swiftui/tabview).



---

# https://developer.apple.com/documentation/swiftui/view/navigationsplitviewstyle(_:))



---

# https://developer.apple.com/documentation/swiftui/view/navigationtitle(_:))



---

# https://developer.apple.com/documentation/swiftui/understanding-the-composition-of-navigation-stack)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/bringing-robust-navigation-structure-to-your-swiftui-app)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/migrating-to-new-navigation-types)



---

# https://developer.apple.com/documentation/swiftui/navigationsplitview)



---

# https://developer.apple.com/documentation/swiftui/view/navigationsplitviewcolumnwidth(_:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/view/navigationsplitviewcolumnwidth(min:ideal:max:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/navigationsplitviewvisibility)



---

# https://developer.apple.com/documentation/swiftui/navigationlink)



---

# https://developer.apple.com/documentation/swiftui/navigationstack)



---

# https://developer.apple.com/documentation/swiftui/navigationpath)



---

# https://developer.apple.com/documentation/swiftui/view/navigationdestination(for:destination:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/view/navigationdestination(ispresented:destination:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/navigationstack).



---

# https://developer.apple.com/documentation/swiftui/view/navigationdestination(item:destination:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/navigationsplitviewcolumn)



---

# https://developer.apple.com/documentation/swiftui/view/navigationsubtitle(_:))



---

# https://developer.apple.com/documentation/swiftui/view/navigationdocument(_:))



---

# https://developer.apple.com/documentation/swiftui/view/navigationdocument(_:preview:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/view/navigationbarbackbuttonhidden(_:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/view/navigationbartitledisplaymode(_:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/navigationbaritem)



---

# https://developer.apple.com/documentation/swiftui/environmentvalues/sidebarrowsize)



---

# https://developer.apple.com/documentation/swiftui/sidebarrowsize)



---

# https://developer.apple.com/documentation/swiftui/enhancing-your-app-content-with-tab-navigation)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/tabview)



---

# https://developer.apple.com/documentation/swiftui/tab)



---

# https://developer.apple.com/documentation/swiftui/tabrole)



---

# https://developer.apple.com/documentation/swiftui/tabsection)



---

# https://developer.apple.com/documentation/swiftui/view/tabviewstyle(_:))



---

# https://developer.apple.com/documentation/swiftui/view/tabviewsidebarheader(content:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/view/tabviewsidebarfooter(content:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/view/tabviewsidebarbottombar(content:))

)#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/adaptabletabbarplacement)



---

# https://developer.apple.com/documentation/swiftui/environmentvalues/tabbarplacement)



---

# https://developer.apple.com/documentation/swiftui/tabbarplacement)



---

# https://developer.apple.com/documentation/swiftui/environmentvalues/istabbarshowingsections)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/tabbarminimizebehavior)



---

# https://developer.apple.com/documentation/swiftui/tabviewbottomaccessoryplacement)



---

# https://developer.apple.com/documentation/swiftui/view/sectionactions(content:))



---

# https://developer.apple.com/documentation/swiftui/tabplacement)



---

# https://developer.apple.com/documentation/swiftui/tabcontentbuilder)



---

# https://developer.apple.com/documentation/swiftui/tabcontent)



---

# https://developer.apple.com/documentation/swiftui/anytabcontent)



---

# https://developer.apple.com/documentation/swiftui/view/tabviewcustomization(_:))



---

# https://developer.apple.com/documentation/swiftui/tabviewcustomization)



---

# https://developer.apple.com/documentation/swiftui/tabcustomizationbehavior)



---

# https://developer.apple.com/documentation/swiftui/hsplitview)



---

# https://developer.apple.com/documentation/swiftui/vsplitview)



---

# https://developer.apple.com/documentation/swiftui/navigationview)



---

# https://developer.apple.com/documentation/swiftui/view/tabitem(_:))



---

# https://developer.apple.com/documentation/swiftui/app-organization)



---

# https://developer.apple.com/documentation/swiftui/scenes)



---

# https://developer.apple.com/documentation/swiftui/windows)



---

# https://developer.apple.com/documentation/swiftui/immersive-spaces)



---

# https://developer.apple.com/documentation/swiftui/documents)



---

# https://developer.apple.com/documentation/swiftui/modal-presentations)



---

# https://developer.apple.com/documentation/swiftui/toolbars)



---

# https://developer.apple.com/documentation/swiftui/search)



---

# https://developer.apple.com/documentation/swiftui/app-extensions)



---

# https://developer.apple.com/documentation/swiftui/view

- SwiftUI
- View

Protocol

# View

A type that represents part of your app’s user interface and provides modifiers that you use to configure views.

@MainActor @preconcurrency
protocol View

## Mentioned in

Declaring a custom view

Configuring views

Reducing view modifier maintenance

Displaying data in lists

Migrating to the SwiftUI life cycle

## Overview

You create custom views by declaring types that conform to the `View` protocol. Implement the required `body` computed property to provide the content for your custom view.

struct MyView: View {
var body: some View {
Text("Hello, World!")
}
}

Assemble the view’s body by combining one or more of the built-in views provided by SwiftUI, like the `Text` instance in the example above, plus other custom views that you define, into a hierarchy of views. For more information about creating custom views, see Declaring a custom view.

The `View` protocol provides a set of modifiers — protocol methods with default implementations — that you use to configure views in the layout of your app. Modifiers work by wrapping the view instance on which you call them in another view with the specified characteristics, as described in Configuring views. For example, adding the `opacity(_:)` modifier to a text view returns a new view with some amount of transparency:

Text("Hello, World!")
.opacity(0.5) // Display partially transparent text.

The complete list of default modifiers provides a large set of controls for managing views. For example, you can fine tune Layout modifiers, add Accessibility modifiers information, and respond to Input and event modifiers. You can also collect groups of default modifiers into new, custom view modifiers for easy reuse.

A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is declared in its original declaration. Isolation to the main actor is the default, but it’s not required. Declare the conformance in an extension to opt-out the isolation.

## Topics

### Implementing a custom view

`var body: Self.Body`

The content and behavior of the view.

**Required** Default implementations provided.

`associatedtype Body : View`

The type of view representing the body of this view.

**Required**

Applies a modifier to a view and returns a new view.

Generate dynamic, interactive previews of your custom views.

### Configuring view elements

Make your SwiftUI apps accessible to everyone, including people with disabilities.

Configure a view’s foreground and background styles, controls, and visibility.

Manage the rendering, selection, and entry of text in your view.

Add and configure supporting views, like toolbars and context menus.

Configure charts that you declare with Swift Charts.

### Drawing views

Apply built-in styles to different types of views.

Tell a view how to arrange itself within a view hierarchy by adjusting its size, position, alignment, padding, and so on.

Affect the way the system draws a view, for example by scaling or masking a view, or by applying graphical effects.

### Providing interactivity

Supply actions for a view to perform in response to user input and system events.

Enable people to search for content in your app.

Define additional views for the view to present under specified conditions.

Access storage and provide child views with configuration data.

### Deprecated modifiers

Review unsupported modifiers and their replacements.

### Instance Methods

Adds multiple accessibility actions to the view with a specific category. Actions allow assistive technologies, such as VoiceOver, to interact with the view by invoking the action and are grouped by their category. When multiple action modifiers with an equal category are applied to the view, the actions are combined together.

Defines a region in which default accessibility focus is evaluated by assigning a value to a given accessibility focus state binding.

`func accessibilityScrollStatus(_:isEnabled:)`

Changes the announcement provided by accessibility technologies when a user scrolls a scroll view within this view.

The view modifier that can be applied to `AccessoryWidgetGroup` to specify the shape the three content views will be masked with. The value of `style` is set to `.automatic`, which is `.circular` by default.

Sets the button’s style.

Sets the style to be used by the button. (see `PKAddPassButtonStyle`).

Configures gestures in this view hierarchy to handle events that activate the containing window.

Constrains this view’s dimensions to the specified 3D aspect ratio.

Configures the view’s icon for purposes of navigation.

`func attributedTextFormattingDefinition(_:)`

Apply a text formatting definition to nested views.

Presents a modal view that enables users to add devices to their organization.

Adds the background extension effect to the view. The view will be duplicated into mirrored copies which will be placed around the view on any edge with available safe area. Additionally, a blur effect will be applied on top to blur out the copies.

Ensures that the view is always visible to the user, even when other content is occluding it, like 3D models.

The preferred sizing behavior of buttons in the view hierarchy.

Displays a certificate sheet using the provided certificate trust.

`func chart3DPose(_:)`

Associates a binding to be updated when the 3D chart’s pose is changed by an interaction.

Sets the visibility of the z axis.

Configures the z-axis for 3D charts in the view.

`func chartZAxisLabel(_:position:alignment:spacing:)`

Adds z axis label for charts in the view. It effects 3D charts only.

Configures the z scale for 3D charts.

Modally present UI which allows the user to select which contacts your app has access to.

Adjusts the view’s layout to avoid the container view’s corner insets for the specified edges.

Sets a particular container value of a view.

`func contentToolbar(for:content:)`

Populates the toolbar of the specified content view type with the views you provide.

A `continuityDevicePicker` should be used to discover and connect nearby continuity device through a button interface or other form of activation. On tvOS, this presents a fullscreen continuity device picker experience when selected. The modal view covers as much the screen of `self` as possible when a given condition is true.

`func controlWidgetActionHint(_:)`

The action hint of the control described by the modified label.

`func controlWidgetStatus(_:)`

The status of the control described by the modified label.

Declares the view as dependent on the entitlement of an In-App Purchase product, and returns a modified view.

Whether the alert or confirmation dialog prevents the app from being quit/terminated by the system or app termination menu item.

Adds to a `DocumentLaunchView` actions that accept a list of selected files as their parameter.

Configures a drag session.

`func dragContainer(for:in:_:)`

A container with draggable views where the drag payload is based on multiple identifiers of dragged items.

`func dragContainer(for:itemID:in:_:)`

A container with draggable views.

Provides multiple item selection support for drag containers.

Describes the way dragged previews are visually composed.

Activates this view as the source of a drag and drop operation, allowing to provide optional identifiable payload and specify the namespace of the drag container this view belongs to.

Activates this view as the source of a drag and drop operation, allowing to provide optional payload and specify the namespace of the drag container this view belongs to.

Inside a drag container, activates this view as the source of a drag and drop operation. Supports lazy drag containers.

Configures a drop session.

Defines the destination of a drag and drop operation that provides a drop operation proposal and handles the dropped content with a closure that you specify.

Describes the way previews for a drop are composed.

Sets the style for forms in a view hierarchy.

Presents a modal view while the game synced directory loads.

Fills the view’s background with a custom glass background effect and container-relative rounded rectangle shape.

Fills the view’s background with a custom glass background effect and a shape that you specify.

Applies the Liquid Glass effect to a view.

Associates an identity value to Liquid Glass effects defined within this view.

Associates a glass effect transition with any glass effects defined within this view.

Associates any Liquid Glass effects defined within this view to a union with the provided identifier.

Specifies how a view should be associated with the current SharePlay group activity.

Assigns a hand gesture shortcut to the modified control.

Sets the behavior of the hand pointer while the user is interacting with the view.

Specifies the game controllers events which should be delivered through the GameController framework when the view, or one of its descendants has focus.

Specifies the game controllers events which should be delivered through the GameController framework when the view or one of its descendants has focus.

Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

Requests permission to read the specified HealthKit data types.

Requests permission to save and read the specified HealthKit data types.

Sets the generation style for an image playground.

Policy determining whether to support the usage of people in the playground or not.

Presents the system sheet to create images from the specified input.

Add menu items to open immersive spaces from a media player’s environment picker.

Add a function to call before initiating a purchase from StoreKit view within this view, providing a set of options for the purchase.

Presents a visual picker interface that contains events and images that a person can select to retrieve more information.

Set the spacing between the icon and title in labels.

Set the width reserved for icons in labels.

Sets a style for labeled content.

Controls the visibility of labels of any controls contained within this view.

A modifier for the default line height in the view hierarchy.

Sets the insets of rows in a list on the specified edges.

Changes the visibility of the list section index.

Set the section margins for the specific edges.

Applies a managed content style to the view.

Allows this view to be manipulated using common hand gestures.

Applies the given 3D affine transform to the view and allows it to be manipulated using common hand gestures.

Allows the view to be manipulated using a manipulation gesture attached to a different view.

Adds a manipulation gesture to this view without allowing this view to be manipulable itself.

Uses the given keyframes to animate the camera of a `Map` when the given trigger value changes.

Configures all Map controls in the environment to have the specified visibility

Configures all `Map` views in the associated environment to have standard size and position controls

Specifies the selection accessory to display for a `MapFeature`

Specifies a custom presentation for the currently selected feature.

Specifies which map features should have selection disabled.

Presents a map item detail popover.

Presents a map item detail sheet.

Creates a mapScope that SwiftUI uses to connect map controls to an associated map.

Specifies the map style to be used.

Identifies this view as the source of a navigation transition, such as a zoom transition.

Sets an explicit active appearance for materials in this view.

A modifier for the default text alignment strategy in the view hierarchy.

Configures whether navigation links show a disclosure indicator.

Sets the navigation transition style for this view.

Registers a handler to invoke in response to the specified app intent that your app receives.

Called when a user has entered or updated a coupon code. This is required if the user is being asked to provide a coupon code.

Called when a payment method has changed and asks for an update payment request. If this modifier isn’t provided Wallet will assume the payment method is valid.

Called when a user selected a shipping address. This is required if the user is being asked to provide a shipping contact.

Called when a user selected a shipping method. This is required if the user is being asked to provide a shipping method.

`func onCameraCaptureEvent(isEnabled:defaultSoundDisabled:action:)`

Used to register an action triggered by system capture events.

`func onCameraCaptureEvent(isEnabled:defaultSoundDisabled:primaryAction:secondaryAction:)`

Used to register actions triggered by system capture events.

Specifies an action to perform on each update of an ongoing dragging operation activated by `draggable(_:)` or anther drag modifiers.

Specifies an action to perform on each update of an ongoing drop operation activated by `dropDestination(_:)` or other drop modifiers.

`func onGeometryChange3D(for:of:action:)`

Returns a new view that arranges to call `action(value)` whenever the value computed by `transform(proxy)` changes, where `proxy` provides access to the view’s 3D geometry properties.

Add an action to perform when a purchase initiated from a StoreKit view within this view completes.

Add an action to perform when a user triggers the purchase button on a StoreKit view within this view.

Adds an action to perform when the enclosing window is being interactively resized.

`func onMapCameraChange(frequency:_:)`

Performs an action when Map camera framing changes

Sets an `OpenURLAction` that prefers opening URL with an in-app browser. It’s equivalent to calling `.onOpenURL(_:)`

`func onWorldRecenter(action:)`

Adds an action to perform when recentering the view with the digital crown.

Sets the action on the PayLaterView. See `PKPayLaterAction`.

Sets the display style on the PayLaterView. See `PKPayLaterDisplayStyle`.

Sets the features that should be allowed to show on the payment buttons.

Sets the style to be used by the button. (see `PayWithApplePayButtonStyle`).

Presents a popover tip on the modified view.

`func postToPhotosSharedAlbumSheet(isPresented:items:photoLibrary:defaultAlbumIdentifier:completion:)`

Presents an “Add to Shared Album” sheet that allows the user to post the given items to a shared album.

Selects a subscription offer to apply to a purchase that a customer makes from a subscription store view, a store view, or a product view.

`func preferredWindowClippingMargins(_:_:)`

Requests additional margins for drawing beyond the bounds of the window.

Changes the way the enclosing presentation breaks through content occluding it.

Whether a presentation prevents the app from being terminated/quit by the system or app termination menu item.

Configure the visibility of labels displaying an in-app purchase product description within the view.

Adds a standard border to an in-app purchase product’s icon .

Sets the style for In-App Purchase product views within a view.

Adds gestures that control the position and direction of a virtual camera.

A view modifier that controls the frame sizing and content alignment behavior for `RealityView`

Rotates a view with impacts to its frame in a containing layout

`func rotation3DLayout(_:axis:)`

`func safeAreaBar(edge:alignment:spacing:content:)`

Shows the specified content as a custom bar beside the modified view.

Scales this view to fill its parent.

Scales this view to fit its parent.

Hides any scroll edge effects for scroll views within this hierarchy.

Configures the scroll edge effect style for scroll views within this hierarchy.

Enables or disables scrolling in scrollable views when using particular inputs.

Binds the selection of the search field associated with the nearest searchable modifier to the given `TextSelection` value.

Configures the behavior for search in the toolbar.

`func sectionIndexLabel(_:)`

Sets the label that is used in a section index to point to this section, typically only a single character long.

Sets the style used for displaying the control (see `SignInWithAppleButton.Style`).

Sets the thumb visibility for `Slider` s within this view.

Adds secondary views within the 3D bounds of this view.

Uses the specified preference value from the view to produce another view occupying the same 3D space of the first view.

Specifies the visibility of auxiliary buttons that store view and subscription store view instances may use.

Declares the view as dependent on an In-App Purchase product and returns a modified view.

Declares the view as dependent on a collection of In-App Purchase products and returns a modified view.

Selects the introductory offer eligibility preference to apply to a purchase a customer makes from a subscription store view.

Selects a promotional offer to apply to a purchase a customer makes from a subscription store view.

Deprecated

Declares the view as dependent on the status of an auto-renewable subscription group, and returns a modified view.

Configures subscription store view instances within a view to use the provided button label.

`func subscriptionStoreControlBackground(_:)`

Set a standard effect to use for the background of subscription store view controls within the view.

Sets a view to use to decorate individual subscription options within a subscription store view.

Sets the control style for subscription store views within a view.

Sets the control style and control placement for subscription store views within a view.

Sets the style subscription store views within this view use to display groups of subscription options.

Sets the background style for picker items of the subscription store view instances within a view.

Sets the background shape and style for subscription store view picker items within a view.

Configures a view as the destination for a policy button action in subscription store views.

Configures a URL as the destination for a policy button action in subscription store views.

Sets the style for the and buttons within a subscription store view.

Sets the primary and secondary style for the and buttons within a subscription store view.

Adds an action to perform when a person uses the sign-in button on a subscription store view within a view.

Sets the color rendering mode for symbol images.

Sets the variable value mode mode for symbol images within this view.

Sets the behavior for tab bar minimization.

Configures the activation and deactivation behavior of search in the search tab.

Adds a tabletop game to a view.

Supplies a closure which returns a new interaction whenever needed.

`func textContentType(_:)`

Sets the text content type for this view, which the system uses to offer suggestions while the user enters text on macOS.

Define which system text formatting controls are available.

Returns a new view such that any text views within it will use `renderer` to draw themselves.

Sets the direction of a selection or cursor relative to a text character.

Sets a value for the specified tip anchor to be used to anchor a tip view to the `.bounds` of the view.

Sets the tip’s view background to a style. Currently this only applies to inline tips, not popover tips.

Controls whether people can interact with the view behind a presented tip.

Sets the corner radius for an inline tip view.

Sets the size for a tip’s image.

Sets the style for a tip’s image.

Sets the given style for TipView within the view hierarchy.

Hides an individual view within a control group toolbar item.

Presents a picker that selects a collection of transactions.

Provides a task to perform before this view appears

Presents a translation popover when a given condition is true.

Adds a task to perform before this view appears or when the translation configuration changes.

Adds a task to perform before this view appears or when the specified source or target languages change.

Sets the style to be used by the button. (see `PKIdentityButtonStyle`).

Determines whether horizontal swipe gestures trigger backward and forward page navigation.

Specifies the visibility of the webpage’s natural background color within this view.

Adds an item-based context menu to a WebView, replacing the default set of context menu items.

Determines whether a web view can display content full screen.

Determines whether pressing a link displays a preview of the destination for the link.

Determines whether magnify gestures change the view’s magnification.

Adds an action to be performed when a value, created from a scroll geometry, changes.

Enables or disables scrolling in web views when using particular inputs.

Associates a binding to a scroll position with the web view.

Determines whether to allow people to select or otherwise interact with text.

Sets the window anchor point used when the size of the view changes such that the window must resize.

Configures the visibility of the window toolbar when the window enters full screen mode.

Presents a preview of the workout contents as a modal sheet

A modifier for the default text writing direction strategy in the view hierarchy.

Specifies whether the system should show the Writing Tools affordance for text input views affected by the environment.

Specifies the Writing Tools behavior for text and text input in the environment.

## Relationships

### Inherited By

- `DynamicViewContent`
- `InsettableShape`
- `NSViewControllerRepresentable`
- `NSViewRepresentable`
- `RoundedRectangularShape`
- `Shape`
- `ShapeView`
- `UIViewControllerRepresentable`
- `UIViewRepresentable`
- `WKInterfaceObjectRepresentable`

### Conforming Types

- `AngularGradient`
- `AnyShape`
- `AnyView`
- `AsyncImage`
- `Button`
- `ButtonBorderShape`
- `ButtonStyleConfiguration.Label`
- `Canvas`
Conforms when `Symbols` conforms to `View`.

- `Capsule`
- `Circle`
- `Color`
- `ColorPicker`
- `ConcentricRectangle`
- `ContainerRelativeShape`
- `ContentUnavailableView`
- `ControlGroup`
- `ControlGroupStyleConfiguration.Content`
- `ControlGroupStyleConfiguration.Label`
- `DatePicker`
- `DatePickerStyleConfiguration.Label`
- `DebugReplaceableView`
- `DefaultButtonLabel`
- `DefaultDateProgressLabel`
- `DefaultDocumentGroupLaunchActions`
- `DefaultGlassEffectShape`
- `DefaultSettingsLinkLabel`
- `DefaultShareLinkLabel`
- `DefaultTabLabel`
- `DefaultWindowVisibilityToggleLabel`
- `DisclosureGroup`
- `DisclosureGroupStyleConfiguration.Content`
- `DisclosureGroupStyleConfiguration.Label`
- `Divider`
- `DocumentLaunchView`
- `EditButton`
- `EditableCollectionContent`
Conforms when `Content` conforms to `View`, `Data` conforms to `Copyable`, and `Data` conforms to `Escapable`.

- `Ellipse`
- `EllipticalGradient`
- `EmptyView`
- `EquatableView`
- `FillShapeView`
- `ForEach`
Conforms when `Data` conforms to `RandomAccessCollection`, `ID` conforms to `Hashable`, and `Content` conforms to `View`.

- `Form`
- `FormStyleConfiguration.Content`
- `Gauge`
- `GaugeStyleConfiguration.CurrentValueLabel`
- `GaugeStyleConfiguration.Label`
- `GaugeStyleConfiguration.MarkedValueLabel`
- `GaugeStyleConfiguration.MaximumValueLabel`
- `GaugeStyleConfiguration.MinimumValueLabel`
- `GeometryReader`
- `GeometryReader3D`
- `GlassBackgroundEffectConfiguration.Content`
- `GlassEffectContainer`
- `Grid`
Conforms when `Content` conforms to `View`.

- `GridRow`
Conforms when `Content` conforms to `View`.

- `Group`
Conforms when `Content` conforms to `View`.

- `GroupBox`
- `GroupBoxStyleConfiguration.Content`
- `GroupBoxStyleConfiguration.Label`
- `GroupElementsOfContent`
- `GroupSectionsOfContent`
- `HSplitView`
- `HStack`
- `HelpLink`
- `Image`
- `KeyframeAnimator`
- `Label`
- `LabelStyleConfiguration.Icon`
- `LabelStyleConfiguration.Title`
- `LabeledContent`
Conforms when `Label` conforms to `View` and `Content` conforms to `View`.

- `LabeledContentStyleConfiguration.Content`
- `LabeledContentStyleConfiguration.Label`
- `LabeledControlGroupContent`
- `LabeledToolbarItemGroupContent`
- `LazyHGrid`
- `LazyHStack`
- `LazyVGrid`
- `LazyVStack`
- `LinearGradient`
- `Link`
- `List`
- `Menu`
- `MenuButton`
- `MenuStyleConfiguration.Content`
- `MenuStyleConfiguration.Label`
- `MeshGradient`
- `ModifiedContent`
Conforms when `Content` conforms to `View` and `Modifier` conforms to `ViewModifier`.

- `MultiDatePicker`
- `NavigationLink`
- `NavigationSplitView`
- `NavigationStack`
- `NavigationView`
- `NewDocumentButton`
- `OffsetShape`
- `OutlineGroup`
Conforms when `Data` conforms to `RandomAccessCollection`, `ID` conforms to `Hashable`, `Parent` conforms to `View`, `Leaf` conforms to `View`, and `Subgroup` conforms to `View`.

- `OutlineSubgroupChildren`
- `PasteButton`
- `Path`
- `PhaseAnimator`
- `Picker`
- `PlaceholderContentView`
- `PresentedWindowContent`
- `PreviewModifierContent`
- `PrimitiveButtonStyleConfiguration.Label`
- `ProgressView`
- `ProgressViewStyleConfiguration.CurrentValueLabel`
- `ProgressViewStyleConfiguration.Label`
- `RadialGradient`
- `Rectangle`
- `RenameButton`
- `RotatedShape`
- `RoundedRectangle`
- `ScaledShape`
- `ScrollView`
- `ScrollViewReader`
- `SearchUnavailableContent.Actions`
- `SearchUnavailableContent.Description`
- `SearchUnavailableContent.Label`
- `Section`
Conforms when `Parent` conforms to `View`, `Content` conforms to `View`, and `Footer` conforms to `View`.

- `SectionConfiguration.Actions`
- `SecureField`
- `SettingsLink`
- `ShareLink`
- `Slider`
- `Spacer`
- `Stepper`
- `StrokeBorderShapeView`
- `StrokeShapeView`
- `SubscriptionView`
- `Subview`
- `SubviewsCollection`
- `SubviewsCollectionSlice`
- `TabContentBuilder.Content`
- `TabView`
- `Table`
- `Text`
- `TextEditor`
- `TextField`
- `TextFieldLink`
- `TimelineView`
Conforms when `Schedule` conforms to `TimelineSchedule` and `Content` conforms to `View`.

- `Toggle`
- `ToggleStyleConfiguration.Label`
- `TransformedShape`
- `TupleView`
- `UnevenRoundedRectangle`
- `VSplitView`
- `VStack`
- `ViewThatFits`
- `WindowVisibilityToggle`
- `ZStack`
- `ZStackContent3D`
Conforms when `Content` conforms to `View`.

## See Also

### Creating a view

Define views and assemble them into a view hierarchy.

`struct ViewBuilder`

A custom parameter attribute that constructs views from closures.

---

# https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app

- SwiftUI
- Search
- Adding a search interface to your app

Article

# Adding a search interface to your app

Present an interface that people can use to search for content in your app.

## Overview

Add a search interface to your app by applying one of the searchable view modifiers — like `searchable(text:placement:prompt:)` — to a `NavigationSplitView` or `NavigationStack`, or to a view inside one of these. A search field then appears in the toolbar. The precise placement and appearance of the search field depends on the platform, where you put the modifier in code, and its configuration.

The searchable modifier that creates the field takes a `Binding` to a string that represents the search field’s text. You provide the storage for the string — and optionally for an array of discrete search tokens — that you use to conduct the search. To learn about managing the search field’s data, see Performing a search operation.

### Place the search field automatically

You can automatically place the search field by adding the `searchable(text:placement:prompt:)` modifier to a navigation element like a navigation split view:

struct ContentView: View {
@State private var departmentId: Department.ID?
@State private var productId: Product.ID?
@State private var searchText: String = ""

var body: some View {
NavigationSplitView {
DepartmentList(departmentId: $departmentId)
} content: {
ProductList(departmentId: departmentId, productId: $productId)
} detail: {
ProductDetails(productId: productId)
}
.searchable(text: $searchText) // Adds a search field.
}
}

With this configuration, the search field appears on the trailing edge of the toolbar in macOS. In iOS and iPadOS, the first or second column displays the search field in a double or triple column navigation view, respectively. The above three-column example puts the search field at the top of the middle column on iPad.

### Control the placement structurally

To add a search field to a specific column in iOS and iPadOS, add the searchable modifier to a view in that column. For example, to indicate that the search covers departments in the previous example, you could place the search field in the first column by adding the modifier to that column’s `DepartmentList` view instead of to the navigation split view:

NavigationSplitView {
DepartmentList(departmentId: $departmentId)
.searchable(text: $searchText)
} content: {
ProductList(departmentId: departmentId, productId: $productId)
} detail: {
ProductDetails(productId: productId)
}

### Control the placement programmatically

You can alternatively use the `placement` input parameter to suggest a `SearchFieldPlacement` value for the search interface. For example, you can achieve the same results as the previous example in macOS using the `sidebar` placement:

NavigationSplitView {
DepartmentList(departmentId: $departmentId)
} content: {
ProductList(departmentId: departmentId, productId: $productId)
} detail: {
ProductDetails(productId: productId)
}
.searchable(text: $searchText, placement: .sidebar)

If SwiftUI can’t satisfy the placement request, like when you ask for sidebar placement in a searchable modifier that isn’t applied to a navigation split view, SwiftUI relies instead on its automatic placement rules.

### Set a prompt for the search field

By default, the search field contains Search as the placeholder text, to prompt people on how to use the field. You can customize the prompt by setting either a string, a `Text` view, or a `LocalizedStringKey` for the searchable modifier’s `prompt` input parameter. For example, you might use this to clarify that the search field in the Department column searches among both departments and the products in each department:

DepartmentList(departmentId: $departmentId)
.searchable(text: $searchText, prompt: "Departments and products")

## See Also

### Searching your app’s data model

Performing a search operation

Update search results based on search text and optional tokens that you store.

`func searchable(text:placement:prompt:)`

Marks this view as searchable, which configures the display of a search field.

`func searchable(text:tokens:placement:prompt:token:)`

Marks this view as searchable with text and tokens.

`func searchable(text:editableTokens:placement:prompt:token:)`

`struct SearchFieldPlacement`

The placement of a search field in a view hierarchy.

---

# https://developer.apple.com/documentation/swiftui/list

- SwiftUI
- List

Structure

# List

A container that presents rows of data arranged in a single column, optionally providing the ability to select one or more members.

@MainActor @preconcurrency

## Mentioned in

Picking container views for your content

Displaying data in lists

Grouping data with lazy stack views

Making a view into a drag source

Migrating to new navigation types

## Overview

In its simplest form, a `List` creates its contents statically, as shown in the following example:

var body: some View {
List {
Text("A List Item")
Text("A Second List Item")
Text("A Third List Item")
}
}

More commonly, you create lists dynamically from an underlying collection of data. The following example shows how to create a simple list from an array of an `Ocean` type which conforms to `Identifiable`:

struct Ocean: Identifiable {
let name: String
let id = UUID()
}

private var oceans = [\
Ocean(name: "Pacific"),\
Ocean(name: "Atlantic"),\
Ocean(name: "Indian"),\
Ocean(name: "Southern"),\
Ocean(name: "Arctic")\
]

var body: some View {
List(oceans) {
Text($0.name)
}
}

### Supporting selection in lists

To make members of a list selectable, provide a binding to a selection variable. Binding to a single instance of the list data’s `Identifiable.ID` type creates a single-selection list. Binding to a `Set` creates a list that supports multiple selections. The following example shows how to add multiselect to the previous example:

struct Ocean: Identifiable, Hashable {
let name: String
let id = UUID()
}

var body: some View {
NavigationView {
List(oceans, selection: $multiSelection) {
Text($0.name)
}
.navigationTitle("Oceans")
.toolbar { EditButton() }
}
Text("\(multiSelection.count) selections")
}

When people make a single selection by tapping or clicking, the selected cell changes its appearance to indicate the selection. To enable multiple selections with tap gestures, put the list into edit mode by either modifying the `editMode` value, or adding an `EditButton` to your app’s interface. When you put the list into edit mode, the list shows a circle next to each list item. The circle contains a checkmark when the user selects the associated item. The example above uses an Edit button, which changes its title to Done while in edit mode:

People can make multiple selections without needing to enter edit mode on devices that have a keyboard and mouse or trackpad, like Mac and iPad.

### Refreshing the list content

To make the content of the list refreshable using the standard refresh control, use the `refreshable(action:)` modifier.

The following example shows how to add a standard refresh control to a list. When the user drags the top of the list downward, SwiftUI reveals the refresh control and executes the specified action. Use an `await` expression inside the `action` closure to refresh your data. The refresh indicator remains visible for the duration of the awaited operation.

struct Ocean: Identifiable, Hashable {
let name: String
let id = UUID()
let stats: [String: String]
}

class OceanStore: ObservableObject {
@Published var oceans = Ocean
func loadStats() async {}
}

@EnvironmentObject var store: OceanStore

var body: some View {
NavigationView {
List(store.oceans) { ocean in
HStack {
Text(ocean.name)
StatsSummary(stats: ocean.stats) // A custom view for showing statistics.
}
}
.refreshable {
await store.loadStats()
}
.navigationTitle("Oceans")
}
}

### Supporting multidimensional lists

To create two-dimensional lists, group items inside `Section` instances. The following example creates sections named after the world’s oceans, each of which has `Text` views named for major seas attached to those oceans. The example also allows for selection of a single list item, identified by the `id` of the example’s `Sea` type.

struct ContentView: View {
struct Sea: Hashable, Identifiable {
let name: String
let id = UUID()
}

struct OceanRegion: Identifiable {
let name: String
let seas: [Sea]
let id = UUID()
}

private let oceanRegions: [OceanRegion] = [\
OceanRegion(name: "Pacific",\
seas: [Sea(name: "Australasian Mediterranean"),\
Sea(name: "Philippine"),\
Sea(name: "Coral"),\
Sea(name: "South China")]),\
OceanRegion(name: "Atlantic",\
seas: [Sea(name: "American Mediterranean"),\
Sea(name: "Sargasso"),\
Sea(name: "Caribbean")]),\
OceanRegion(name: "Indian",\
seas: [Sea(name: "Bay of Bengal")]),\
OceanRegion(name: "Southern",\
seas: [Sea(name: "Weddell")]),\
OceanRegion(name: "Arctic",\
seas: [Sea(name: "Greenland")])\
]

@State private var singleSelection: UUID?

var body: some View {
NavigationView {
List(selection: $singleSelection) {
ForEach(oceanRegions) { region in
Section(header: Text("Major \(region.name) Ocean Seas")) {
ForEach(region.seas) { sea in
Text(sea.name)
}
}
}
}
.navigationTitle("Oceans and Seas")
}
}
}

Because this example uses single selection, people can make selections outside of edit mode on all platforms.

### Creating hierarchical lists

You can also create a hierarchical list of arbitrary depth by providing tree-structured data and a `children` parameter that provides a key path to get the child nodes at any level. The following example uses a deeply-nested collection of a custom `FileItem` type to simulate the contents of a file system. The list created from this data uses collapsing cells to allow the user to navigate the tree structure.

struct ContentView: View {
struct FileItem: Hashable, Identifiable, CustomStringConvertible {
var id: Self { self }
var name: String
var children: [FileItem]? = nil
var description: String {
switch children {
case nil:
return "📄 \(name)"
case .some(let children):
return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
}
}
}
let fileHierarchyData: [FileItem] = [\
FileItem(name: "users", children:\
[FileItem(name: "user1234", children:\
[FileItem(name: "Photos", children:\
[FileItem(name: "photo001.jpg"),\
FileItem(name: "photo002.jpg")]),\
FileItem(name: "Movies", children:\
[FileItem(name: "movie001.mp4")]),\
FileItem(name: "Documents", children: [])\
]),\
FileItem(name: "newuser", children:\
[FileItem(name: "Documents", children: [])\
])\
]),\
FileItem(name: "private", children: nil)\
]
var body: some View {
List(fileHierarchyData, children: \.children) { item in
Text(item.description)
}
}
}

### Styling lists

SwiftUI chooses a display style for a list based on the platform and the view type in which it appears. Use the `listStyle(_:)` modifier to apply a different `ListStyle` to all lists within a view. For example, adding `.listStyle(.plain)` to the example shown in the “Creating Multidimensional Lists” topic applies the `plain` style, the following screenshot shows:

## Topics

### Creating a list from a set of views

Creates a list with the given content.

`init(selection:content:)`

Creates a list with the given content that supports selecting a single row that cannot be deselcted.

### Creating a list from enumerated data

`init(_:rowContent:)`

Creates a list that computes its rows on demand from an underlying collection of identifiable data.

`init(_:selection:rowContent:)`

Creates a list that computes its rows on demand from an underlying collection of identifiable data, optionally allowing users to select a single row.

`init(_:id:rowContent:)`

Creates a list that identifies its rows based on a key path to the identifier of the underlying data.

`init(_:id:selection:rowContent:)`

Creates a list that identifies its rows based on a key path to the identifier of the underlying data, optionally allowing users to select a single row.

### Creating a list from hierarchical data

`init(_:children:rowContent:)`

Creates a hierarchical list that computes its rows on demand from a binding to an underlying collection of identifiable data.

`init(_:children:selection:rowContent:)`

Creates a hierarchical list that computes its rows on demand from a binding to an underlying collection of identifiable data and allowing users to have exactly one row always selected.

`init(_:id:children:rowContent:)`

Creates a hierarchical list that identifies its rows based on a key path to the identifier of the underlying data.

`init(_:id:children:selection:rowContent:)`

Creates a hierarchical list that identifies its rows based on a key path to the identifier of the underlying data and allowing users to have exactly one row always selected.

### Creating a list from editable data

Creates a list that computes its rows on demand from an underlying collection of identifiable data and allows to edit the collection.

`init(_:editActions:selection:rowContent:)`

Creates a list that computes its rows on demand from an underlying collection of identifiable data, allows to edit the collection, and requires a selection of a single row.

`init(_:id:editActions:selection:rowContent:)`

Creates a list that computes its rows on demand from an underlying collection of identifiable, allows to edit the collection, and requires a selection of a single row.

### Supporting types

`var body: some View`

The content of the list.

## Relationships

### Conforms To

- `View`

## See Also

### Creating a list

Visualize collections of data with platform-appropriate appearance.

Sets the style for lists within this view.

---

# https://developer.apple.com/documentation/swiftui/state

- SwiftUI
- State

Structure

# State

A property wrapper type that can read and write a value managed by SwiftUI.

@frozen @propertyWrapper

## Mentioned in

Managing user interface state

Performing a search operation

Understanding the navigation stack

## Overview

Use state as the single source of truth for a given value type that you store in a view hierarchy. Create a state value in an `App`, `Scene`, or `View` by applying the `@State` attribute to a property declaration and providing an initial value. Declare state as private to prevent setting it in a memberwise initializer, which can conflict with the storage management that SwiftUI provides:

struct PlayButton: View {
@State private var isPlaying: Bool = false // Create the state.

var body: some View {
Button(isPlaying ? "Pause" : "Play") { // Read the state.
isPlaying.toggle() // Write the state.
}
}
}

SwiftUI manages the property’s storage. When the value changes, SwiftUI updates the parts of the view hierarchy that depend on the value. To access a state’s underlying value, you use its `wrappedValue` property. However, as a shortcut Swift enables you to access the wrapped value by referring directly to the state instance. The above example reads and writes the `isPlaying` state property’s wrapped value by referring to the property directly.

Declare state as private in the highest view in the view hierarchy that needs access to the value. Then share the state with any subviews that also need access, either directly for read-only access, or as a binding for read-write access. You can safely mutate state properties from any thread.

### Share state with subviews

If you pass a state property to a subview, SwiftUI updates the subview any time the value changes in the container view, but the subview can’t modify the value. To enable the subview to modify the state’s stored value, pass a `Binding` instead.

For example, you can remove the `isPlaying` state from the play button in the above example, and instead make the button take a binding:

struct PlayButton: View {
@Binding var isPlaying: Bool // Play button now receives a binding.

var body: some View {
Button(isPlaying ? "Pause" : "Play") {
isPlaying.toggle()
}
}
}

Then you can define a player view that declares the state and creates a binding to the state. Get the binding to the state value by accessing the state’s `projectedValue`, which you get by prefixing the property name with a dollar sign ( `$`):

struct PlayerView: View {
@State private var isPlaying: Bool = false // Create the state here now.

var body: some View {
VStack {
PlayButton(isPlaying: $isPlaying) // Pass a binding.

// ...
}
}
}

Like you do for a `StateObject`, declare `State` as private to prevent setting it in a memberwise initializer, which can conflict with the storage management that SwiftUI provides. Unlike a state object, always initialize state by providing a default value in the state’s declaration, as in the above examples. Use state only for storage that’s local to a view and its subviews.

### Store observable objects

You can also store observable objects that you create with the `Observable()` macro in `State`; for example:

@Observable
class Library {
var name = "My library of books"
// ...
}

struct ContentView: View {
@State private var library = Library()

var body: some View {
LibraryView(library: library)
}
}

A `State` property always instantiates its default value when SwiftUI instantiates the view. For this reason, avoid side effects and performance-intensive work when initializing the default value. For example, if a view updates frequently, allocating a new default object each time the view initializes can become expensive. Instead, you can defer the creation of the object using the `task(priority:_:)` modifier, which is called only once when the view first appears:

struct ContentView: View {
@State private var library: Library?

var body: some View {
LibraryView(library: library)
.task {
library = Library()
}
}
}

Delaying the creation of the observable state object ensures that unnecessary allocations of the object doesn’t happen each time SwiftUI initializes the view. Using the `task(priority:_:)` modifier is also an effective way to defer any other kind of work required to create the initial state of the view, such as network calls or file access.

### Share observable state objects with subviews

To share an `Observable` object stored in `State` with a subview, pass the object reference to the subview. SwiftUI updates the subview anytime an observable property of the object changes, but only when the subview’s `body` reads the property. For example, in the following code `BookView` updates each time `title` changes but not when `isAvailable` changes:

@Observable
class Book {
var title = "A sample book"
var isAvailable = true
}

struct ContentView: View {
@State private var book = Book()

var body: some View {
BookView(book: book)
}
}

struct BookView: View {
var book: Book

var body: some View {
Text(book.title)
}
}

`State` properties provide bindings to their value. When storing an object, you can get a `Binding` to that object, specifically the reference to the object. This is useful when you need to change the reference stored in state in some other subview, such as setting the reference to `nil`:

struct ContentView: View {
@State private var book: Book?

var body: some View {
DeleteBookView(book: $book)
.task {
book = Book()
}
}
}

struct DeleteBookView: View {
@Binding var book: Book?

var body: some View {
Button("Delete book") {
book = nil
}
}
}

However, passing a `Binding` to an object stored in `State` isn’t necessary when you need to change properties of that object. For example, you can set the properties of the object to new values in a subview by passing the object reference instead of a binding to the reference:

var body: some View {
BookCheckoutView(book: book)
}
}

struct BookCheckoutView: View {
var book: Book

var body: some View {
Button(book.isAvailable ? "Check out book" : "Return book") {
book.isAvailable.toggle()
}
}
}

If you need a binding to a specific property of the object, pass either the binding to the object and extract bindings to specific properties where needed, or pass the object reference and use the `Bindable` property wrapper to create bindings to specific properties. For example, in the following code `BookEditorView` wraps `book` with `@Bindable`. Then the view uses the `$` syntax to pass to a `TextField` a binding to `title`:

struct BookView: View {
let book: Book

var body: some View {
BookEditorView(book: book)
}
}

struct BookEditorView: View {
@Bindable var book: Book

var body: some View {
TextField("Title", text: $book.title)
}
}

## Topics

### Creating a state

`init(wrappedValue: Value)`

Creates a state property that stores an initial wrapped value.

`init(initialValue: Value)`

Creates a state property that stores an initial value.

`init()`

Creates a state property without an initial value.

### Getting the value

`var wrappedValue: Value`

The underlying value referenced by the state variable.

A binding to the state value.

## Relationships

### Conforms To

- `DynamicProperty`
- `Sendable`
- `SendableMetatype`

## See Also

### Creating and sharing view state

Encapsulate view-specific data within your app’s view hierarchy to make your views reusable.

`struct Bindable`

A property wrapper type that supports creating bindings to the mutable properties of observable objects.

`struct Binding`

A property wrapper type that can read and write a value owned by a source of truth.

---

# https://developer.apple.com/documentation/swiftui/binding

- SwiftUI
- Binding

Structure

# Binding

A property wrapper type that can read and write a value owned by a source of truth.

@frozen @propertyWrapper @dynamicMemberLookup

## Mentioned in

Performing a search operation

Understanding the navigation stack

Adding a search interface to your app

Managing user interface state

Managing search interface activation

## Overview

Use a binding to create a two-way connection between a property that stores data, and a view that displays and changes the data. A binding connects a property to a source of truth stored elsewhere, instead of storing data directly. For example, a button that toggles between play and pause can create a binding to a property of its parent view using the `Binding` property wrapper.

struct PlayButton: View {
@Binding var isPlaying: Bool

var body: some View {
Button(isPlaying ? "Pause" : "Play") {
isPlaying.toggle()
}
}
}

The parent view declares a property to hold the playing state, using the `State` property wrapper to indicate that this property is the value’s source of truth.

struct PlayerView: View {
var episode: Episode
@State private var isPlaying: Bool = false

var body: some View {
VStack {
Text(episode.title)
.foregroundStyle(isPlaying ? .primary : .secondary)
PlayButton(isPlaying: $isPlaying) // Pass a binding.
}
}
}

When `PlayerView` initializes `PlayButton`, it passes a binding of its state property into the button’s binding property. Applying the `$` prefix to a property wrapped value returns its `projectedValue`, which for a state property wrapper returns a binding to the value.

Whenever the user taps the `PlayButton`, the `PlayerView` updates its `isPlaying` state.

A binding conforms to `Sendable` only if its wrapped value type also conforms to `Sendable`. It is always safe to pass a sendable binding between different concurrency domains. However, reading from or writing to a binding’s wrapped value from a different concurrency domain may or may not be safe, depending on how the binding was created. SwiftUI will issue a warning at runtime if it detects a binding being used in a way that may compromise data safety.

## Topics

### Creating a binding

`init(_:)`

Creates a binding by projecting the base value to a hashable value.

Creates a binding from the value of another binding.

`init(get:set:)`

Creates a binding with closures that read and write the binding value.

Creates a binding with an immutable value.

### Getting the value

`var wrappedValue: Value`

The underlying value referenced by the binding variable.

A projection of the binding value that returns a binding.

Returns a binding to the resulting value of a given key path.

### Managing changes

`var id: Value.ID`

The stable identity of the entity associated with this instance, corresponding to the `id` of the binding’s wrapped value.

Specifies an animation to perform when the binding value changes.

Specifies a transaction for the binding.

`var transaction: Transaction`

The binding’s transaction.

### Subscripts

`subscript(_:)`

## Relationships

### Conforms To

- `BidirectionalCollection`
- `Collection`
- `Copyable`
- `DynamicProperty`
Conforms when `Value` conforms to `Copyable` and `Escapable`.

- `Identifiable`
- `RandomAccessCollection`
- `Sendable`
- `SendableMetatype`
- `Sequence`

## See Also

### Creating and sharing view state

Encapsulate view-specific data within your app’s view hierarchy to make your views reusable.

`struct State`

A property wrapper type that can read and write a value managed by SwiftUI.

`struct Bindable`

A property wrapper type that supports creating bindings to the mutable properties of observable objects.

---

# https://developer.apple.com/documentation/swiftui/navigationstack/init(path:root:)

#app-main)

- SwiftUI
- NavigationStack
- init(path:root:)

Initializer

# init(path:root:)

Creates a navigation stack with homogeneous navigation state that you can control.

@MainActor @preconcurrency
init(

) where Data : MutableCollection, Data : RandomAccessCollection, Data : RangeReplaceableCollection, Data.Element : Hashable

Show all declarations

## Parameters

`path`

A `Binding` to the navigation state for this stack.

`root`

The view to display when the stack is empty.

## Mentioned in

Understanding the navigation stack

Migrating to new navigation types

## Discussion

If you don’t need access to the navigation state, use `init(root:)`.

---

# https://developer.apple.com/documentation/swiftui/navigationstack/init(root:)

#app-main)

- SwiftUI
- NavigationStack
- init(root:)

Initializer

# init(root:)

Creates a navigation stack that manages its own navigation state.

@ `MainActor` @preconcurrency

## Parameters

`root`

The view to display when the stack is empty.

---

# https://developer.apple.com/documentation/swiftui/view)



---

# https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/navigationlink),



---

# https://developer.apple.com/documentation/swiftui/list)



---

# https://developer.apple.com/documentation/swiftui/state)



---

# https://developer.apple.com/documentation/swiftui/binding)



---

# https://developer.apple.com/documentation/swiftui/navigationstack/init(path:root:))



---

# https://developer.apple.com/documentation/swiftui/navigationstack/init(root:))



---

# https://developer.apple.com/documentation/swiftui/navigationsplitviewstyle

- SwiftUI
- NavigationSplitViewStyle

Protocol

# NavigationSplitViewStyle

A type that specifies the appearance and interaction of navigation split views within a view hierarchy.

@MainActor @preconcurrency
protocol NavigationSplitViewStyle

## Overview

To configure the navigation split view style for a view hierarchy, use the `navigationSplitViewStyle(_:)` modifier.

A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type’s base declaration:

struct MyCustomType: Transition {
// `@preconcurrency @MainActor` isolation by default
}

Isolation to the main actor is the default, but it’s not required. Declare the conformance in an extension to opt out of main actor isolation:

extension MyCustomType: Transition {
// `nonisolated` by default
}

## Topics

### Creating built-in styles

`static var automatic: AutomaticNavigationSplitViewStyle`

A navigation split style that resolves its appearance automatically based on the current context.

`static var balanced: BalancedNavigationSplitViewStyle`

A navigation split style that reduces the size of the detail content to make room when showing the leading column or columns.

`static var prominentDetail: ProminentDetailNavigationSplitViewStyle`

A navigation split style that attempts to maintain the size of the detail content when hiding or showing the leading columns.

### Creating custom styles

Creates a view that represents the body of a navigation split view.

**Required**

`typealias Configuration`

The properties of a navigation split view instance.

`associatedtype Body : View`

A view that represents the body of a navigation split view.

### Supporting types

`struct AutomaticNavigationSplitViewStyle`

`struct BalancedNavigationSplitViewStyle`

`struct ProminentDetailNavigationSplitViewStyle`

`struct NavigationSplitViewStyleConfiguration`

## Relationships

### Conforming Types

- `AutomaticNavigationSplitViewStyle`
- `BalancedNavigationSplitViewStyle`
- `ProminentDetailNavigationSplitViewStyle`

## See Also

### Styling navigation views

Sets the style for navigation split views within this view.

Sets the style for the tab view within the current environment.

`protocol TabViewStyle`

A specification for the appearance and interaction of a tab view.

---

# https://developer.apple.com/documentation/swiftui/navigationsplitviewstyle)



---

# https://developer.apple.com/documentation/swiftui/configure-your-apps-navigation-titles

- SwiftUI
- View fundamentals
- View
- Auxiliary view modifiers
- Configure your apps navigation titles

Article

# Configure your apps navigation titles

Use a navigation title to display the current navigation state of an interface.

## Overview

On iOS and watchOS, when a view is navigated to inside of a navigation stack, that view’s title is displayed in the navigation bar. On iPadOS, the primary destination’s navigation title is reflected as the window’s title in the App Switcher. Similarly on macOS, the primary destination’s title is used as the window title in the titlebar, Windows menu and Mission Control.

In its simplest form, you can provide a string or a localized string key to a navigation title modifier directly.

ContentView()
.navigationTitle("My Title")

The title of your apps toolbar can be further customized using additional navigation related modifiers. For example, you can associate a `URL` or your own type conforming to `Transferable` to your view using the navigation document modifier.

ContentView()
.navigationTitle("My Title")
.navigationDocument(myURL)

In iOS and iPadOS, this will construct a title that can present a menu by tapping the navigation title in the app’s navigation bar. The menu contains content providing information related to the URL and a draggable icon for sharing.

In macOS, this item will construct a proxy icon for manipulating the file backing the document.

When providing a transferable type, you should typically provide a `SharePreview` which provides the appropriate content for rendering the preview in the header of the menu.

ContentView()
.navigationTitle("My Title")
.navigationDocument(
myDocument,
preview: SharePreview(
"My Preview Title", image: myDocument.image))

### Renaming

You can provide a text binding to the navigation title modifier and SwiftUI will automatically configure the toolbar to allow editing of the navigation title on iOS or macOS. SwiftUI automatically syncs the navigation title with the value of the string binding provided to the text field.

You can provide a string binding to the navigation title to configure the title’s text field. SwiftUI will automatically place a rename action in the title menu alongside the actions originating from your app’s commands.

ContentView()
.navigationTitle($contentTitle)

In iOS, when using a text field in a navigation title, SwiftUI creates a button in the toolbar title. When triggered, this button updates the navigation title to display an inline text field that will update the binding you provide as the user types.

## See Also

### Navigation titles

`func navigationTitle(_:)`

Configures the view’s title for purposes of navigation, using a string binding.

`func navigationSubtitle(_:)`

Configures the view’s subtitle for purposes of navigation.

---

# https://developer.apple.com/documentation/swiftui/configure-your-apps-navigation-titles)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/swiftui/app

- SwiftUI
- App

Protocol

# App

A type that represents the structure and behavior of an app.

@MainActor @preconcurrency
protocol App

## Mentioned in

Migrating to the SwiftUI life cycle

## Overview

Create an app by declaring a structure that conforms to the `App` protocol. Implement the required `body` computed property to define the app’s content:

@main
struct MyApp: App {
var body: some Scene {
WindowGroup {
Text("Hello, world!")
}
}
}

Precede the structure’s declaration with the @main attribute to indicate that your custom `App` protocol conformer provides the entry point into your app. The protocol provides a default implementation of the `main()` method that the system calls to launch your app. You can have exactly one entry point among all of your app’s files.

Compose the app’s body from instances that conform to the `Scene` protocol. Each scene contains the root view of a view hierarchy and has a life cycle managed by the system. SwiftUI provides some concrete scene types to handle common scenarios, like for displaying documents or settings. You can also create custom scenes.

@main
struct Mail: App {
var body: some Scene {
WindowGroup {
MailViewer()
}
Settings {
SettingsView()
}
}
}

You can declare state in your app to share across all of its scenes. For example, you can use the `StateObject` attribute to initialize a data model, and then provide that model on a view input as an `ObservedObject` or through the environment as an `EnvironmentObject` to scenes in the app:

@main
struct Mail: App {
@StateObject private var model = MailModel()

var body: some Scene {
WindowGroup {
MailViewer()
.environmentObject(model) // Passed through the environment.
}
Settings {
SettingsView(model: model) // Passed as an observed object.
}
}
}

A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type’s base declaration:

struct MyCustomType: Transition {
// `@preconcurrency @MainActor` isolation by default
}

Isolation to the main actor is the default, but it’s not required. Declare the conformance in an extension to opt out of main actor isolation:

extension MyCustomType: Transition {
// `nonisolated` by default
}

## Topics

### Implementing an app

`var body: Self.Body`

The content and behavior of the app.

**Required**

`associatedtype Body : Scene`

The type of scene representing the content of the app.

### Running an app

`init()`

Creates an instance of the app using the body that you define for its content.

`static func main()`

Initializes and runs the app.

## See Also

### Creating an app

Destination Video

Leverage SwiftUI to build an immersive media experience in a multiplatform app.

Hello World

Use windows, volumes, and immersive spaces to teach people about the Earth.

Backyard Birds: Building an app with SwiftData and widgets

Create an app with persistent data, interactive widgets, and an all new in-app purchase experience.

Food Truck: Building a SwiftUI multiplatform app

Create a single codebase and app target for Mac, iPad, and iPhone.

Fruta: Building a Feature-Rich App with SwiftUI

Create a shared codebase to build a multiplatform app that offers widgets and an App Clip.

Use a scene-based life cycle in SwiftUI while keeping your existing codebase.

---

# https://developer.apple.com/documentation/swiftui/landmarks-building-an-app-with-liquid-glass

- SwiftUI
- Landmarks: Building an app with Liquid Glass

Sample Code

# Landmarks: Building an app with Liquid Glass

Enhance your app experience with system-provided and custom Liquid Glass.

Download

Xcode 26.0+

## Overview

Landmarks is a SwifUI app that demonstrates how to use the new dynamic and expressive design feature, Liquid Glass. The Landmarks app lets people explore interesting sites around the world. Whether it’s a national park near their home or a far-flung location on a different continent, the app provides a way for people to organize and mark their adventures and receive custom activity badges along the way. Landmarks runs on iPad, iPhone, and Mac.

Landmarks uses a `NavigationSplitView` to organize and navigate to content in the app, and demonstrates several key concepts to optimize the use of Liquid Glass:

- Stretching content behind the sidebar and inspector with the background extension effect.

- Extending horizontal scroll views under a sidebar or inspector.

- Leveraging the system-provided glass effect in toolbars.

- Applying Liquid Glass effects to custom interface elements and animations.

- Building a new app icon with Icon Composer.

The sample also demonstrates several techniques to use when changing window sizes, and for adding global search.

## Apply a background extension effect

The sample applies a background extension effect to the featured landmark header in the top view, and the main image in the landmark detail view. This effect extends and blurs the image under the sidebar and inspector when they’re open, creating a full edge-to-edge experience.

To achieve this effect, the sample creates and configures an `Image` that extends to both the leading and trailing edges of the containing view, and applies the `backgroundExtensionEffect()` modifier to the image. For the featured image, the sample adds an overlay with a headline and button after the modifier, so that only the image extends under the sidebar and inspector.

For more information, see Landmarks: Applying a background extension effect.

## Extend horizontal scrolling under the sidebar

Within each continent section in `LandmarksView`, an instance of `LandmarkHorizontalListView` shows a horizontally scrolling list of landmark views. When open, the landmark views can scroll underneath the sidebar or inspector.

To achieve this effect, the app aligns the scroll views next to the leading and trailing edges of the containing view.

For more information, see Landmarks: Extending horizontal scrolling under a sidebar or inspector.

## Refine the Liquid Glass in the toolbar

In `LandmarkDetailView`, the sample adds toolbar items for:

- sharing a landmark

- adding or removing a landmark from a list of Favorites

- adding or removing a landmark from Collections

- showing or hiding the inspector

The system applies Liquid Glass to toolbar items automatically:

The sample also organizes the toolbar into related groups, instead of having all the buttons in one group. For more information, see Landmarks: Refining the system provided Liquid Glass effect in toolbars.

## Display badges with Liquid Glass

Badges provide people with a visual indicator of the activities they’ve recorded in the Landmarks app. When a person completes all four activities for a landmark, they earn that landmark’s badge. The sample uses custom Liquid Glass elements with badges, and shows how to coordinate animations with Liquid Glass.

To create a custom Liquid Glass badge, Landmarks uses a view with an `Image` to display a system symbol image for the badge. The badge has a background hexagon `Image` filled with a custom color. The badge view uses the `glassEffect(_:in:)` modifier to apply Liquid Glass to the badge.

To demonstrate the morphing effect that the system provides with Liquid Glass animations, the sample organizes the badges and the toggle button into a `GlassEffectContainer`, and assigns each badge a unique `glassEffectID(_:in:)`.

For more information, see Landmarks: Displaying custom activity badges. For information about building custom views with Liquid Glass, see Applying Liquid Glass to custom views.

## Create the app icon with Icon Composer

Landmarks includes a dynamic and expressive app icon composed in Icon Composer. You build app icons with four layers that the system uses to produce specular highlights when a person moves their device, so that the icon responds as if light was reflecting off the glass. The Settings app allows people to personalize the icon by selecting light, dark, clear, or tinted variants of your app icon as well.

For more information on creating a new app icon, see Creating your app icon using Icon Composer.

## Topics

### App features

Landmarks: Applying a background extension effect

Configure an image to blur and extend under a sidebar or inspector panel.

Landmarks: Extending horizontal scrolling under a sidebar or inspector

Improve your horizontal scrollbar’s appearance by extending it under a sidebar or inspector.

Landmarks: Refining the system provided Liquid Glass effect in toolbars

Organize toolbars into related groupings to improve their appearance and utility.

Landmarks: Displaying custom activity badges

Provide people with a way to mark their adventures by displaying animated custom activity badges.

## See Also

### Essentials

Adopting Liquid Glass

Find out how to bring the new material to your app.

Learning SwiftUI

Discover tips and techniques for building multiplatform apps with this set of conceptual articles and sample code.

Exploring SwiftUI Sample Apps

Explore these SwiftUI samples using Swift Playgrounds on iPad or in Xcode to learn about defining user interfaces, responding to user interactions, and managing data flow.

SwiftUI updates

Learn about important changes to SwiftUI.

---

# https://developer.apple.com/documentation/swiftui/model-data

Collection

- SwiftUI
- Model data

API Collection

# Model data

Manage the data that your app uses to drive its interface.

## Overview

SwiftUI offers a declarative approach to user interface design. As you compose a hierarchy of views, you also indicate data dependencies for the views. When the data changes, either due to an external event or because of an action that the user performs, SwiftUI automatically updates the affected parts of the interface. As a result, the framework automatically performs most of the work that view controllers traditionally do.

The framework provides tools, like state variables and bindings, for connecting your app’s data to the user interface. These tools help you maintain a single source of truth for every piece of data in your app, in part by reducing the amount of glue logic you write. Select the tool that best suits the task you need to perform:

- Manage transient UI state locally within a view by wrapping value types as `State` properties.

- Share a reference to a source of truth, like local state, using the `Binding` property wrapper.

- Connect to and observe reference model data in views by applying the `Observable()` macro to the model data type. Instantiate an observable model data type directly in a view using a `State` property. Share the observable model data with other views in the hierarchy without passing a reference using the `Environment` property wrapper.

### Leveraging property wrappers

SwiftUI implements many data management types, like `State` and `Binding`, as Swift property wrappers. Apply a property wrapper by adding an attribute with the wrapper’s name to a property’s declaration.

@State private var isVisible = true // Declares isVisible as a state variable.

The property gains the behavior that the wrapper specifies. The state and data flow property wrappers in SwiftUI watch for changes in your data, and automatically update affected views as necessary. When you refer directly to the property in your code, you access the wrapped value, which for the `isVisible` state property in the example above is the stored Boolean.

if isVisible == true {
Text("Hello") // Only renders when isVisible is true.
}

Alternatively, you can access a property wrapper’s projected value by prefixing the property name with the dollar sign ( `$`). SwiftUI state and data flow property wrappers project a `Binding`, which is a two-way connection to the wrapped value, allowing another view to access and mutate a single source of truth.

Toggle("Visible", isOn: $isVisible) // The toggle can update the stored value.

For more information about property wrappers, see Property Wrappers in The Swift Programming Language.

## Topics

### Creating and sharing view state

Managing user interface state

Encapsulate view-specific data within your app’s view hierarchy to make your views reusable.

`struct State`

A property wrapper type that can read and write a value managed by SwiftUI.

`struct Bindable`

A property wrapper type that supports creating bindings to the mutable properties of observable objects.

`struct Binding`

A property wrapper type that can read and write a value owned by a source of truth.

### Creating model data

Managing model data in your app

Create connections between your app’s data model and views.

Migrating from the Observable Object protocol to the Observable macro

Update your existing app to leverage the benefits of Observation in Swift.

`@attached(member, names: named(_$observationRegistrar), named(access), named(withMutation), named(shouldNotifyObservers)) @attached(memberAttribute) @attached(extension, conformances: Observable) macro Observable()`

Defines and implements conformance of the Observable protocol.

Monitoring data changes in your app

Show changes to data in your app’s user interface by using observable objects.

`struct StateObject`

A property wrapper type that instantiates an observable object.

`struct ObservedObject`

A property wrapper type that subscribes to an observable object and invalidates a view whenever the observable object changes.

`protocol ObservableObject : AnyObject`

A type of object with a publisher that emits before the object has changed.

### Responding to data changes

`func onChange(of:initial:_:)`

Adds a modifier for this view that fires an action when a specific value changes.

Adds an action to perform when this view detects data emitted by the given publisher.

### Distributing model data throughout your app

Supplies an observable object to a view’s hierarchy.

Supplies an `ObservableObject` to a view subhierarchy.

`struct EnvironmentObject`

A property wrapper type for an observable object that a parent or ancestor view supplies.

### Managing dynamic data

`protocol DynamicProperty`

An interface for a stored variable that updates an external property of a view.

## See Also

### Data and storage

Share data throughout a view hierarchy using the environment.

Indicate configuration preferences from views to their container views.

Store data for use across sessions of your app.

---

# https://developer.apple.com/documentation/swiftui/environment-values

Collection

- SwiftUI
- Environment values

API Collection

# Environment values

Share data throughout a view hierarchy using the environment.

## Overview

Views in SwiftUI can react to configuration information that they read from the environment using an `Environment` property wrapper.

A view inherits its environment from its container view, subject to explicit changes from an `environment(_:_:)` view modifier, or by implicit changes from one of the many modifiers that operate on environment values. As a result, you can configure a entire hierarchy of views by modifying the environment of the group’s container.

You can find many built-in environment values in the `EnvironmentValues` structure. You can also create a custom `EnvironmentValues` property by defining a new property in an extension to the environment values structure and applying the `Entry()` macro to the variable declaration.

## Topics

### Accessing environment values

`struct Environment`

A property wrapper that reads a value from a view’s environment.

`struct EnvironmentValues`

A collection of environment values propagated through a view hierarchy.

### Creating custom environment values

`macro Entry()`

Creates an environment values, transaction, container values, or focused values entry.

`protocol EnvironmentKey`

A key for accessing values in the environment.

### Modifying the environment of a view

Places an observable object in the view’s environment.

Sets the environment value of the specified key path to the given value.

Transforms the environment value of the specified key path with the given function.

### Modifying the environment of a scene

Places an observable object in the scene’s environment.

## See Also

### Data and storage

Manage the data that your app uses to drive its interface.

Indicate configuration preferences from views to their container views.

Store data for use across sessions of your app.

---

# https://developer.apple.com/documentation/swiftui/preferences

Collection

- SwiftUI
- Preferences

API Collection

# Preferences

Indicate configuration preferences from views to their container views.

## Overview

Whereas you use the environment to configure the subviews of a view, you use preferences to send configuration information from subviews toward their container. However, unlike configuration information that flows down a view hierarchy from one container to many subviews, a single container needs to reconcile potentially conflicting preferences flowing up from its many subviews.

When you use the `PreferenceKey` protocol to define a custom preference, you indicate how to merge preferences from multiple subviews. You can then set a value for the preference on a view using the `preference(key:value:)` view modifier. Many built-in modifiers, like `navigationTitle(_:)`, rely on preferences to send configuration information to their container.

## Topics

### Setting preferences

Sets a value for the given preference.

Applies a transformation to a preference value.

### Creating custom preferences

`protocol PreferenceKey`

A named value produced by a view.

### Setting preferences based on geometry

Sets a value for the specified preference key, the value is a function of a geometry value tied to the current coordinate space, allowing readers of the value to convert the geometry to their local coordinates.

Sets a value for the specified preference key, the value is a function of the key’s current value and a geometry value tied to the current coordinate space, allowing readers of the value to convert the geometry to their local coordinates.

### Responding to changes in preferences

Adds an action to perform when the specified preference key’s value changes.

### Generating backgrounds and overlays from preferences

Reads the specified preference value from the view, using it to produce a second view that is applied as the background of the original view.

Reads the specified preference value from the view, using it to produce a second view that is applied as an overlay to the original view.

## See Also

### Data and storage

Manage the data that your app uses to drive its interface.

Share data throughout a view hierarchy using the environment.

Store data for use across sessions of your app.

---

# https://developer.apple.com/documentation/swiftui/persistent-storage

Collection

- SwiftUI
- Persistent storage

API Collection

# Persistent storage

Store data for use across sessions of your app.

## Overview

The operating system provides ways to store data when your app closes, so that when people open your app again later, they can continue working without interruption. The mechanism that you use depends on factors like what and how much you need to store, whether you need serialized or random access to the data, and so on.

You use the same kinds of storage in a SwiftUI app that you use in any other app. For example, you can access files on disk using the `FileManager` interface. However, SwiftUI also provides conveniences that make it easier to use certain kinds of persistent storage in a declarative environment. For example, you can use `FetchRequest` and `FetchedResults` to interact with a Core Data model.

## Topics

### Saving state across app launches

Restoring Your App’s State with SwiftUI

Provide app continuity for users by preserving their current activities.

The default store used by `AppStorage` contained within the view.

`struct AppStorage`

A property wrapper type that reflects a value from `UserDefaults` and invalidates a view on a change in value in that user default.

`struct SceneStorage`

A property wrapper type that reads and writes to persisted, per-scene storage.

### Accessing Core Data

Loading and Displaying a Large Data Feed

Consume data in the background, and lower memory use by batching imports and preventing duplicate records.

`var managedObjectContext: NSManagedObjectContext`

`struct FetchRequest`

A property wrapper type that retrieves entities from a Core Data persistent store.

`struct FetchedResults`

A collection of results retrieved from a Core Data store.

`struct SectionedFetchRequest`

A property wrapper type that retrieves entities, grouped into sections, from a Core Data persistent store.

`struct SectionedFetchResults`

A collection of results retrieved from a Core Data persistent store, grouped into sections.

## See Also

### Data and storage

Manage the data that your app uses to drive its interface.

Share data throughout a view hierarchy using the environment.

Indicate configuration preferences from views to their container views.

---

# https://developer.apple.com/documentation/swiftui/view-fundamentals

Collection

- SwiftUI
- View fundamentals

API Collection

# View fundamentals

Define the visual elements of your app using a hierarchy of views.

## Overview

Views are the building blocks that you use to declare your app’s user interface. Each view contains a description of what to display for a given state. Every bit of your app that’s visible to the user derives from the description in a view, and any type that conforms to the `View` protocol can act as a view in your app.

Compose a custom view by combining built-in views that SwiftUI provides with other custom views that you create in your view’s `body` computed property. Configure views using the view modifiers that SwiftUI provides, or by defining your own view modifiers using the `ViewModifier` protocol and the `modifier(_:)` method.

## Topics

### Creating a view

Declaring a custom view

Define views and assemble them into a view hierarchy.

`protocol View`

A type that represents part of your app’s user interface and provides modifiers that you use to configure views.

`struct ViewBuilder`

A custom parameter attribute that constructs views from closures.

### Modifying a view

Configuring views

Adjust the characteristics of a view by applying view modifiers.

Reducing view modifier maintenance

Bundle view modifiers that you regularly reuse into a custom view modifier.

Applies a modifier to a view and returns a new view.

`protocol ViewModifier`

A modifier that you apply to a view or another view modifier, producing a different version of the original value.

`struct EmptyModifier`

An empty, or identity, modifier, used during development to switch modifiers at compile time.

`struct ModifiedContent`

A value with a modifier applied to it.

`protocol EnvironmentalModifier`

A modifier that must resolve to a concrete modifier in an environment before use.

`struct ManipulableModifier`

`struct ManipulableResponderModifier`

`struct ManipulableTransformBindingModifier`

`struct ManipulationGeometryModifier`

`struct ManipulationGestureModifier`

`struct ManipulationUsingGestureStateModifier`

`enum Manipulable`

A namespace for various manipulable related types.

### Responding to view life cycle updates

Adds an action to perform before this view appears.

Adds an action to perform after this view disappears.

Adds an asynchronous task to perform before this view appears.

Adds a task to perform before this view appears or when a specified value changes.

### Managing the view hierarchy

Binds a view’s identity to the given proxy value.

Sets the unique tag value of this view.

Prevents the view from updating its child view when its new value is the same as its old value.

### Supporting view types

`struct AnyView`

A type-erased view.

`struct EmptyView`

A view that doesn’t contain any content.

`struct EquatableView`

A view type that compares itself against its previous value and prevents its child updating if its new value is the same as its old value.

`struct SubscriptionView`

A view that subscribes to a publisher with an action.

`struct TupleView`

A View created from a swift tuple of View values.

## See Also

### Views

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/view-configuration

Collection

- SwiftUI
- View configuration

API Collection

# View configuration

Adjust the characteristics of views in a hierarchy.

## Overview

SwiftUI enables you to tune the appearance and behavior of views using view modifiers.

Many modifiers apply to specific kinds of views or behaviors, but some apply more generally. For example, you can conditionally hide any view by dynamically setting its opacity, display contextual help when people hover over a view, or request the light or dark appearance for a view.

## Topics

### Hiding views

Sets the transparency of this view.

Hides this view unconditionally.

### Hiding system elements

Hides the labels of any controls contained within this view.

Controls the visibility of labels of any controls contained within this view.

`var labelsVisibility: Visibility`

The labels visibility set by `labelsVisibility(_:)`.

Sets the menu indicator visibility for controls within this view.

Sets the visibility of the status bar.

Sets the preferred visibility of the non-transient system views overlaying the app.

`enum Visibility`

The visibility of a UI element, chosen automatically based on the platform, current context, and other factors.

### Managing view interaction

Adds a condition that controls whether users can interact with this view.

`var isEnabled: Bool`

A Boolean value that indicates whether the view associated with this environment allows user interaction.

Sets a tag that you use for tracking interactivity.

Mark the receiver as their content might be invalidated.

### Providing contextual help

`func help(_:)`

Adds help text to a view using a text view that you provide.

### Detecting and requesting the light or dark appearance

Sets the preferred color scheme for this presentation.

`var colorScheme: ColorScheme`

The color scheme of this environment.

`enum ColorScheme`

The possible color schemes, corresponding to the light and dark appearances.

### Getting the color scheme contrast

`var colorSchemeContrast: ColorSchemeContrast`

The contrast associated with the color scheme of this environment.

`enum ColorSchemeContrast`

The contrast between the app’s foreground and background colors.

### Configuring passthrough

Applies an effect to passthrough video.

`struct SurroundingsEffect`

Effects that the system can apply to passthrough video.

`struct BreakthroughEffect`

### Redacting private content

Designing your app for the Always On state

Customize your watchOS app’s user interface for continuous display.

Marks the view as containing sensitive, private user data.

Adds a reason to apply a redaction to this view hierarchy.

Removes any reason to apply a redaction to this view hierarchy.

`var redactionReasons: RedactionReasons`

The current redaction reasons applied to the view hierarchy.

`var isSceneCaptured: Bool`

The current capture state.

`struct RedactionReasons`

The reasons to apply a redaction to data displayed on screen.

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/view-styles

Collection

- SwiftUI
- View styles

API Collection

# View styles

Apply built-in and custom appearances and behaviors to different types of views.

## Overview

SwiftUI defines built-in styles for certain kinds of views and automatically selects the appropriate style for a particular presentation context. For example, a `Label` might appear as an icon, a string title, or both, depending on factors like the platform, whether the view appears in a toolbar, and so on.

You can override the automatic style by using one of the style view modifiers. These modifiers typically propagate throughout a container view, so that you can wrap a view hierarchy in a style modifier to affect all the views of the given type within the hierarchy.

Any of the style protocols that define a `makeBody(configuration:)` method, like `ToggleStyle`, also enable you to define custom styles. Create a type that conforms to the corresponding style protocol and implement its `makeBody(configuration:)` method. Then apply the new style using a style view modifier exactly like a built-in style.

## Topics

### Styling views with Liquid Glass

Applying Liquid Glass to custom views

Configure, combine, and morph views using Liquid Glass effects.

Landmarks: Building an app with Liquid Glass

Enhance your app experience with system-provided and custom Liquid Glass.

Applies the Liquid Glass effect to a view.

Returns a copy of the structure configured to be interactive.

`struct GlassEffectContainer`

A view that combines multiple Liquid Glass shapes into a single shape that can morph individual shapes into one another.

`struct GlassEffectTransition`

A structure that describes changes to apply when a glass effect is added or removed from the view hierarchy.

`struct GlassButtonStyle`

A button style that applies glass border artwork based on the button’s context.

`struct GlassProminentButtonStyle`

A button style that applies prominent glass border artwork based on the button’s context.

`struct DefaultGlassEffectShape`

The default shape applied by glass effects, a capsule.

### Styling buttons

`func buttonStyle(_:)`

Sets the style for buttons within this view to a button style with a custom appearance and standard interaction behavior.

`protocol ButtonStyle`

A type that applies standard interaction behavior and a custom appearance to all buttons within a view hierarchy.

`struct ButtonStyleConfiguration`

The properties of a button.

`protocol PrimitiveButtonStyle`

A type that applies custom interaction behavior and a custom appearance to all buttons within a view hierarchy.

`struct PrimitiveButtonStyleConfiguration`

Sets the style used for displaying the control (see `SignInWithAppleButton.Style`).

### Styling pickers

Sets the style for pickers within this view.

`protocol PickerStyle`

A type that specifies the appearance and interaction of all pickers within a view hierarchy.

Sets the style for date pickers within this view.

`protocol DatePickerStyle`

A type that specifies the appearance and interaction of all date pickers within a view hierarchy.

### Styling menus

Sets the style for menus within this view.

`protocol MenuStyle`

A type that applies standard interaction behavior and a custom appearance to all menus within a view hierarchy.

`struct MenuStyleConfiguration`

A configuration of a menu.

### Styling toggles

Sets the style for toggles in a view hierarchy.

`protocol ToggleStyle`

The appearance and behavior of a toggle.

`struct ToggleStyleConfiguration`

The properties of a toggle instance.

### Styling indicators

Sets the style for gauges within this view.

`protocol GaugeStyle`

Defines the implementation of all gauge instances within a view hierarchy.

`struct GaugeStyleConfiguration`

The properties of a gauge instance.

Sets the style for progress views in this view.

`protocol ProgressViewStyle`

A type that applies standard interaction behavior to all progress views within a view hierarchy.

`struct ProgressViewStyleConfiguration`

The properties of a progress view instance.

### Styling views that display text

Sets the style for labels within this view.

`protocol LabelStyle`

A type that applies a custom appearance to all labels within a view.

`struct LabelStyleConfiguration`

The properties of a label.

Sets the style for text fields within this view.

`protocol TextFieldStyle`

A specification for the appearance and interaction of a text field.

Sets the style for text editors within this view.

`protocol TextEditorStyle`

A specification for the appearance and interaction of a text editor.

`struct TextEditorStyleConfiguration`

The properties of a text editor.

### Styling collection views

Sets the style for lists within this view.

`protocol ListStyle`

A protocol that describes the behavior and appearance of a list.

Sets the style for tables within this view.

`protocol TableStyle`

A type that applies a custom appearance to all tables within a view.

`struct TableStyleConfiguration`

The properties of a table.

Sets the style for disclosure groups within this view.

`protocol DisclosureGroupStyle`

A type that specifies the appearance and interaction of disclosure groups within a view hierarchy.

### Styling navigation views

Sets the style for navigation split views within this view.

`protocol NavigationSplitViewStyle`

A type that specifies the appearance and interaction of navigation split views within a view hierarchy.

Sets the style for the tab view within the current environment.

`protocol TabViewStyle`

A specification for the appearance and interaction of a tab view.

### Styling groups

Sets the style for control groups within this view.

`protocol ControlGroupStyle`

Defines the implementation of all control groups within a view hierarchy.

`struct ControlGroupStyleConfiguration`

The properties of a control group.

Sets the style for forms in a view hierarchy.

`protocol FormStyle`

The appearance and behavior of a form.

`struct FormStyleConfiguration`

The properties of a form instance.

Sets the style for group boxes within this view.

`protocol GroupBoxStyle`

A type that specifies the appearance and interaction of all group boxes within a view hierarchy.

`struct GroupBoxStyleConfiguration`

The properties of a group box instance.

Sets the style for the index view within the current environment.

`protocol IndexViewStyle`

Defines the implementation of all `IndexView` instances within a view hierarchy.

Sets a style for labeled content.

`protocol LabeledContentStyle`

The appearance and behavior of a labeled content instance..

`struct LabeledContentStyleConfiguration`

The properties of a labeled content instance.

### Styling windows from a view inside the window

Sets the style for windows created by interacting with this view.

Sets the style for the toolbar in windows created by interacting with this view.

### Adding a glass background on views in visionOS

Fills the view’s background with an automatic glass background effect and container-relative rounded rectangle shape.

Fills the view’s background with an automatic glass background effect and a shape that you specify.

`enum GlassBackgroundDisplayMode`

The display mode of a glass background.

`protocol GlassBackgroundEffect`

A specification for the appearance of a glass background.

`struct AutomaticGlassBackgroundEffect`

The automatic glass background effect.

`struct GlassBackgroundEffectConfiguration`

A configuration used to build a custom effect.

`struct FeatheredGlassBackgroundEffect`

The feathered glass background effect.

`struct PlateGlassBackgroundEffect`

The plate glass background effect.

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/animations

Collection

- SwiftUI
- Animations

API Collection

# Animations

Create smooth visual updates in response to state changes.

## Overview

You tell SwiftUI how to draw your app’s user interface for different states, and then rely on SwiftUI to make interface updates when the state changes.

To avoid abrupt visual transitions when the state changes, add animation in one of the following ways:

- Animate all of the visual changes for a state change by changing the state inside a call to the `withAnimation(_:_:)` global function.

- Add animation to a particular view when a specific value changes by applying the `animation(_:value:)` view modifier to the view.

- Animate changes to a `Binding` by using the binding’s `animation(_:)` method.

SwiftUI animates the effects that many built-in view modifiers produce, like those that set a scale or opacity value. You can animate other values by making your custom views conform to the `Animatable` protocol, and telling SwiftUI about the value you want to animate.

When an animated state change results in adding or removing a view to or from the view hierarchy, you can tell SwiftUI how to transition the view into or out of place using built-in transitions that `AnyTransition` defines, like `slide` or `scale`. You can also create custom transitions.

For design guidance, see Motion in the Human Interface Guidelines.

## Topics

### Adding state-based animation to an action

Returns the result of recomputing the view’s body with the provided animation.

Returns the result of recomputing the view’s body with the provided animation, and runs the completion when all animations are complete.

`struct AnimationCompletionCriteria`

The criteria that determines when an animation is considered finished.

`struct Animation`

The way a view changes over time to create a smooth visual transition from one state to another.

### Adding state-based animation to a view

`func animation(_:)`

Applies the given animation to this view when this view changes.

Applies the given animation to this view when the specified value changes.

Applies the given animation to all animatable values within the `body` closure.

### Creating phase-based animation

Controlling the timing and movements of your animations

Build sophisticated animations that you control using phase and keyframe animators.

Animates effects that you apply to a view over a sequence of phases that change continuously.

Animates effects that you apply to a view over a sequence of phases that change based on a trigger.

`struct PhaseAnimator`

A container that animates its content by automatically cycling through a collection of phases that you provide, each defining a discrete step within an animation.

### Creating keyframe-based animation

Loops the given keyframes continuously, updating the view using the modifiers you apply in `body`.

Plays the given keyframes when the given trigger value changes, updating the view using the modifiers you apply in `body`.

`struct KeyframeAnimator`

A container that animates its content with keyframes.

`protocol Keyframes`

A type that defines changes to a value over time.

`struct KeyframeTimeline`

A description of how a value changes over time, modeled using keyframes.

`struct KeyframeTrack`

A sequence of keyframes animating a single property of a root type.

`struct KeyframeTrackContentBuilder`

The builder that creates keyframe track content from the keyframes that you define within a closure.

`struct KeyframesBuilder`

A builder that combines keyframe content values into a single value.

`protocol KeyframeTrackContent`

A group of keyframes that define an interpolation curve of an animatable value.

`struct CubicKeyframe`

A keyframe that uses a cubic curve to smoothly interpolate between values.

`struct LinearKeyframe`

A keyframe that uses simple linear interpolation.

`struct MoveKeyframe`

A keyframe that immediately moves to the given value without interpolating.

`struct SpringKeyframe`

A keyframe that uses a spring function to interpolate to the given value.

### Creating custom animations

`protocol CustomAnimation`

A type that defines how an animatable value changes over time.

`struct AnimationContext`

Contextual values that a custom animation can use to manage state and access a view’s environment.

`struct AnimationState`

A container that stores the state for a custom animation.

`protocol AnimationStateKey`

A key for accessing animation state values.

`struct UnitCurve`

A function defined by a two-dimensional curve that maps an input progress in the range \[0,1\] to an output progress that is also in the range \[0,1\]. By changing the shape of the curve, the effective speed of an animation or other interpolation can be changed.

`struct Spring`

A representation of a spring’s motion.

### Making data animatable

`protocol Animatable`

A type that describes how to animate a property of a view.

`struct AnimatableValues`

`struct AnimatablePair`

A pair of animatable values, which is itself animatable.

`protocol VectorArithmetic`

A type that can serve as the animatable data of an animatable type.

`struct EmptyAnimatableData`

An empty type for animatable data.

### Updating a view on a schedule

Updating watchOS apps with timelines

Seamlessly schedule updates to your user interface, even while it’s inactive.

`struct TimelineView`

A view that updates according to a schedule that you provide.

`protocol TimelineSchedule`

A type that provides a sequence of dates for use as a schedule.

`typealias TimelineViewDefaultContext`

Information passed to a timeline view’s content callback.

### Synchronizing geometries

Defines a group of views with synchronized geometry using an identifier and namespace that you provide.

`struct MatchedGeometryProperties`

A set of view properties that may be synchronized between views using the `View.matchedGeometryEffect()` function.

`protocol GeometryEffect`

An effect that changes the visual appearance of a view, largely without changing its ancestors or descendants.

`struct Namespace`

A dynamic property type that allows access to a namespace defined by the persistent identity of the object containing the property (e.g. a view).

Isolates the geometry (e.g. position and size) of the view from its parent view.

### Defining transitions

`func transition(_:)`

Associates a transition with the view.

`protocol Transition`

A description of view changes to apply when a view is added to and removed from the view hierarchy.

`struct TransitionProperties`

The properties a `Transition` can have.

`enum TransitionPhase`

An indication of which the current stage of a transition.

`struct AsymmetricTransition`

A composite `Transition` that uses a different transition for insertion versus removal.

`struct AnyTransition`

A type-erased transition.

Modifies the view to use a given transition as its method of animating changes to the contents of its views.

`var contentTransition: ContentTransition`

The current method of animating the contents of views.

`var contentTransitionAddsDrawingGroup: Bool`

A Boolean value that controls whether views that render content transitions use GPU-accelerated rendering.

`struct ContentTransition`

A kind of transition that applies to the content within a single view, rather than to the insertion or removal of a view.

`struct PlaceholderContentView`

A placeholder used to construct an inline modifier, transition, or other helper type.

Sets the navigation transition style for this view.

`protocol NavigationTransition`

A type that defines the transition to use when navigating to a view.

Identifies this view as the source of a navigation transition, such as a zoom transition.

`protocol MatchedTransitionSourceConfiguration`

A configuration that defines the appearance of a matched transition source.

`struct EmptyMatchedTransitionSourceConfiguration`

An unstyled matched transition source configuration.

### Moving an animation to another view

Executes a closure with the specified transaction and returns the result.

Executes a closure with the specified transaction key path and value and returns the result.

Applies the given transaction mutation function to all animations used within the view.

Applies the given transaction mutation function to all animations used within the `body` closure.

`struct Transaction`

The context of the current state-processing update.

`macro Entry()`

Creates an environment values, transaction, container values, or focused values entry.

`protocol TransactionKey`

A key for accessing values in a transaction.

### Deprecated types

`protocol AnimatableModifier`

A modifier that can create another modifier with animation.

Deprecated

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/text-input-and-output

Collection

- SwiftUI
- Text input and output

API Collection

# Text input and output

Display formatted text and get text input from the user.

## Overview

To display read-only text, or read-only text paired with an image, use the built-in `Text` or `Label` views, respectively. When you need to collect text input from the user, use an appropriate text input view, like `TextField` or `TextEditor`.

You add view modifiers to control the text’s font, selectability, alignment, layout direction, and so on. These modifiers also affect other views that display text, like the labels on controls, even if you don’t define an explicit `Text` view.

For design guidance, see Typography in the Human Interface Guidelines.

## Topics

### Displaying text

`struct Text`

A view that displays one or more lines of read-only text.

`struct Label`

A standard label for user interface items, consisting of an icon with a title.

Sets the style for labels within this view.

### Getting text input

Building rich SwiftUI text experiences

Build an editor for formatted text using SwiftUI text editor views and attributed strings.

`struct TextField`

A control that displays an editable text interface.

Sets the style for text fields within this view.

`struct SecureField`

A control into which people securely enter private text.

`struct TextEditor`

A view that can display and edit long-form text.

### Selecting text

Controls whether people can select text within this view.

`protocol TextSelectability`

A type that describes the ability to select text.

`struct TextSelection`

Represents a selection of text.

Sets the direction of a selection or cursor relative to a text character.

`var textSelectionAffinity: TextSelectionAffinity`

A representation of the direction or association of a selection or cursor relative to a text character. This concept becomes much more prominent when dealing with bidirectional text (text that contains both LTR and RTL scripts, like English and Arabic combined).

`enum TextSelectionAffinity`

`struct AttributedTextSelection`

Represents a selection of attributed text.

### Setting a font

Applying custom fonts to text

Add and use a font in your app that scales with Dynamic Type.

Sets the default font for text in this view.

Sets the font design of the text in this view.

Sets the font weight of the text in this view.

Sets the font width of the text in this view.

`var font: Font?`

The default font of this environment.

`struct Font`

An environment-dependent font.

### Adjusting text size

Applies a text scale to text in the view.

`func dynamicTypeSize(_:)`

Sets the Dynamic Type size within the view to the given value.

`var dynamicTypeSize: DynamicTypeSize`

The current Dynamic Type size.

`enum DynamicTypeSize`

A Dynamic Type size, which specifies how large scalable content should be.

`struct ScaledMetric`

A dynamic property that scales a numeric value.

`protocol TextVariantPreference`

A protocol for controlling the size variant of text views.

`struct FixedTextVariant`

The default text variant preference that chooses the largest available variant.

`struct SizeDependentTextVariant`

The size dependent variant preference allows the text to take the available space into account when choosing the variant to display.

### Controlling text style

Applies a bold font weight to the text in this view.

Applies italics to the text in this view.

Applies an underline to the text in this view.

Applies a strikethrough to the text in this view.

Sets a transform for the case of the text contained in this view when displayed.

`var textCase: Text.Case?`

A stylistic override to transform the case of `Text` when displayed, using the environment’s locale.

Modifies the fonts of all child views to use the fixed-width variant of the current font, if possible.

Modifies the fonts of all child views to use fixed-width digits, if possible, while leaving other characters proportionally spaced.

`protocol AttributedTextFormattingDefinition`

A protocol for defining how text can be styled in a view.

`protocol AttributedTextValueConstraint`

A protocol for defining a constraint on the value of a certain attribute.

`enum AttributedTextFormatting`

A namespace for types related to attributed text formatting definitions.

### Managing text layout

Sets the truncation mode for lines of text that are too long to fit in the available space.

`var truncationMode: Text.TruncationMode`

A value that indicates how the layout truncates the last line of text to fit into the available space.

Sets whether text in this view can compress the space between characters when necessary to fit text in a line.

`var allowsTightening: Bool`

A Boolean value that indicates whether inter-character spacing should tighten to fit the text into the available space.

Sets the minimum amount that text in this view scales down to fit in the available space.

`var minimumScaleFactor: CGFloat`

The minimum permissible proportion to shrink the font size to fit the text into the available space.

Sets the vertical offset for the text relative to its baseline in this view.

Sets the spacing, or kerning, between characters for the text in this view.

Sets the tracking for the text in this view.

Sets whether this view mirrors its contents horizontally when the layout direction is right-to-left.

`enum TextAlignment`

An alignment position for text along the horizontal axis.

### Rendering text

Creating visual effects with SwiftUI

Add scroll effects, rich color treatments, custom transitions, and advanced effects using shaders and a text renderer.

`protocol TextAttribute`

A value that you can attach to text views and that text renderers can query.

Returns a new view such that any text views within it will use `renderer` to draw themselves.

`protocol TextRenderer`

A value that can replace the default text view rendering behavior.

`struct TextProxy`

A proxy for a text view that custom text renderers use.

### Limiting line count for multiline text

`func lineLimit(_:)`

Sets to a closed range the number of lines that text can occupy in this view.

Sets a limit for the number of lines text can occupy in this view.

`var lineLimit: Int?`

The maximum number of lines that text can occupy in a view.

### Formatting multiline text

Sets the amount of space between lines of text in this view.

`var lineSpacing: CGFloat`

The distance in points between the bottom of one line fragment and the top of the next.

Sets the alignment of a text view that contains multiple lines of text.

`var multilineTextAlignment: TextAlignment`

An environment value that indicates how a text view aligns its lines when the content wraps or contains newlines.

### Formatting date and time

`enum SystemFormatStyle`

A namespace for format styles that implement designs used across Apple’s platformes.

`struct TimeDataSource`

A source of time related data.

### Managing text entry

Sets whether to disable autocorrection for this view.

`var autocorrectionDisabled: Bool`

A Boolean value that determines whether the view hierarchy has auto-correction enabled.

Sets the keyboard type for this view.

Configures the behavior in which scrollable content interacts with the software keyboard.

`func textContentType(_:)`

Sets the text content type for this view, which the system uses to offer suggestions while the user enters text on macOS.

Sets how often the shift key in the keyboard is automatically enabled.

`struct TextInputAutocapitalization`

The kind of autocapitalization behavior applied during text input.

Associates a fully formed string with the value of this view when used as a text input suggestion

Configures the text input suggestions for this view.

Sets the text content type for this view, which the system uses to offer suggestions while the user enters text on a watchOS device.

Sets the text content type for this view, which the system uses to offer suggestions while the user enters text on an iOS or tvOS device.

`struct TextInputFormattingControlPlacement`

A structure defining the system text formatting controls available on each platform.

### Dictating text

Configures the dictation behavior for any search fields configured by the searchable modifier.

`struct TextInputDictationActivation`

`struct TextInputDictationBehavior`

### Configuring the Writing Tools behavior

Specifies the Writing Tools behavior for text and text input in the environment.

`struct WritingToolsBehavior`

The Writing Tools editing experience for text and text input.

### Specifying text equivalents

`func typeSelectEquivalent(_:)`

Sets an explicit type select equivalent text in a collection, such as a list or table.

### Localizing text

Preparing views for localization

Specify hints and add strings to localize your SwiftUI views.

`struct LocalizedStringKey`

The key used to look up an entry in a strings file or strings dictionary file.

`var locale: Locale`

The current locale that views should use.

`func typesettingLanguage(_:isEnabled:)`

Specifies the language for typesetting.

`struct TypesettingLanguage`

Defines how typesetting language is determined for text.

### Deprecated types

`enum ContentSizeCategory`

The sizes that you can specify for content.

Deprecated

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/images

Collection

- SwiftUI
- Images

API Collection

# Images

Add images and symbols to your app’s user interface.

## Overview

Display images, including SF Symbols, images that you store in an asset catalog, and images that you store on disk, using an `Image` view.

For images that take time to retrieve — for example, when you load an image from a network endpoint — load the image asynchronously using `AsyncImage`. You can instruct that view to display a placeholder during the load operation.

For design guidance, see Images in the Human Interface Guidelines.

## Topics

### Creating an image

`struct Image`

A view that displays an image.

### Configuring an image

Fitting images into available space

Adjust the size and shape of images in your app’s user interface by applying view modifiers.

Scales images within the view according to one of the relative sizes available including small, medium, and large images sizes.

`var imageScale: Image.Scale`

The image scale for this environment.

`enum Scale`

A scale to apply to vector images relative to text.

`enum Orientation`

The orientation of an image.

`enum ResizingMode`

The modes that SwiftUI uses to resize an image to fit within its containing view.

### Loading images asynchronously

`struct AsyncImage`

A view that asynchronously loads and displays an image.

`enum AsyncImagePhase`

The current phase of the asynchronous image loading operation.

### Setting a symbol variant

Makes symbols within the view show a particular variant.

`var symbolVariants: SymbolVariants`

The symbol variant to use in this environment.

`struct SymbolVariants`

A variant of a symbol.

### Managing symbol effects

Returns a new view with a symbol effect added to it.

Returns a new view with its inherited symbol image effects either removed or left unchanged.

`struct SymbolEffectTransition`

Creates a transition that applies the Appear, Disappear, DrawOn or DrawOff symbol animation to symbol images within the inserted or removed view hierarchy.

### Setting symbol rendering modes

Sets the rendering mode for symbol images within this view.

`var symbolRenderingMode: SymbolRenderingMode?`

The current symbol rendering mode, or `nil` denoting that the mode is picked automatically using the current image and foreground style as parameters.

`struct SymbolRenderingMode`

A symbol rendering mode.

`struct SymbolColorRenderingMode`

A method of filling a layer in a symbol image.

`struct SymbolVariableValueMode`

A method of rendering the variable value of a symbol image.

### Rendering images from views

`class ImageRenderer`

An object that creates images from SwiftUI views.

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/controls-and-indicators

Collection

- SwiftUI
- Controls and indicators

API Collection

# Controls and indicators

Display values and get user selections.

## Overview

SwiftUI provides controls that enable user interaction specific to each platform and context. For example, people can initiate events with buttons and links, or choose among a set of discrete values with different kinds of pickers. You can also display information to the user with indicators like progress views and gauges.

Use these built-in controls and indicators when composing custom views, and style them to match the needs of your app’s user interface. For design guidance, see Menus and actions, Selection and input, and Status in the Human Interface Guidelines.

## Topics

### Creating buttons

`struct Button`

A control that initiates an action.

`func buttonStyle(_:)`

Sets the style for buttons within this view to a button style with a custom appearance and standard interaction behavior.

Sets the border shape for buttons in this view.

Sets whether buttons in this view should repeatedly trigger their actions on prolonged interactions.

`var buttonRepeatBehavior: ButtonRepeatBehavior`

Whether buttons with this associated environment should repeatedly trigger their actions on prolonged interactions.

`struct ButtonBorderShape`

A shape used to draw a button’s border.

`struct ButtonRole`

A value that describes the purpose of a button.

`struct ButtonRepeatBehavior`

The options for controlling the repeatability of button actions.

`struct ButtonSizing`

The sizing behavior of `Button` s and other button-like controls.

### Creating special-purpose buttons

`struct EditButton`

A button that toggles the edit mode environment value.

`struct PasteButton`

A system button that reads items from the pasteboard and delivers it to a closure.

`struct RenameButton`

A button that triggers a standard rename action.

### Linking to other content

`struct Link`

A control for navigating to a URL.

`struct ShareLink`

A view that controls a sharing presentation.

`struct SharePreview`

A representation of a type to display in a share preview.

`struct TextFieldLink`

A control that requests text input from the user when pressed.

`struct HelpLink`

A button with a standard appearance that opens app-specific help documentation.

### Getting numeric inputs

`struct Slider`

A control for selecting a value from a bounded linear range of values.

`struct Stepper`

A control that performs increment and decrement actions.

`struct Toggle`

A control that toggles between on and off states.

Sets the style for toggles in a view hierarchy.

### Choosing from a set of options

`struct Picker`

A control for selecting from a set of mutually exclusive values.

Sets the style for pickers within this view.

Sets the style for radio group style pickers within this view to be horizontally positioned with the radio buttons inside the layout.

Sets the default wheel-style picker item height.

`var defaultWheelPickerItemHeight: CGFloat`

The default height of an item in a wheel-style picker, such as a date picker.

Specifies the selection effect to apply to a palette item.

`struct PaletteSelectionEffect`

The selection effect to apply to a palette item.

### Choosing dates

`struct DatePicker`

A control for selecting an absolute date.

Sets the style for date pickers within this view.

`struct MultiDatePicker`

A control for picking multiple dates.

`var calendar: Calendar`

The current calendar that views should use when handling dates.

`var timeZone: TimeZone`

The current time zone that views should use when handling dates.

### Choosing a color

`struct ColorPicker`

A control used to select a color from the system color picker UI.

### Indicating a value

`struct Gauge`

A view that shows a value within a range.

Sets the style for gauges within this view.

`struct ProgressView`

A view that shows the progress toward completion of a task.

Sets the style for progress views in this view.

`struct DefaultDateProgressLabel`

The default type of the current value label when used by a date-relative progress view.

`struct DefaultButtonLabel`

The default label to use for a button.

### Indicating missing content

`struct ContentUnavailableView`

An interface, consisting of a label and additional content, that you display when the content of your app is unavailable to users.

### Providing haptic feedback

Plays the specified `feedback` when the provided `trigger` value changes.

`func sensoryFeedback(trigger:_:)`

Plays feedback when returned from the `feedback` closure after the provided `trigger` value changes.

Plays the specified `feedback` when the provided `trigger` value changes and the `condition` closure returns `true`.

`struct SensoryFeedback`

Represents a type of haptic and/or audio feedback that can be played.

### Sizing controls

`func controlSize(_:)`

Sets the size for controls within this view.

`var controlSize: ControlSize`

The size to apply to controls within a view.

`enum ControlSize`

The size classes, like regular or small, that you can apply to controls within a view.

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/menus-and-commands

Collection

- SwiftUI
- Menus and commands

API Collection

# Menus and commands

Provide space-efficient, context-dependent access to commands and controls.

## Overview

Use a menu to provide people with easy access to common commands. You can add items to a macOS or iPadOS app’s menu bar using the `commands(content:)` scene modifier, or create context menus that people reveal near their current task using the `contextMenu(menuItems:)` view modifier.

Create submenus by nesting `Menu` instances inside others. Use a `Divider` view to create a separator between menu elements.

For design guidance, see Menus in the Human Interface Guidelines.

## Topics

### Building a menu bar

Building and customizing the menu bar with SwiftUI

Provide a seamless, cross-platform user experience by building a native menu bar for iPadOS and macOS.

### Creating a menu

Populating SwiftUI menus with adaptive controls

Improve your app by populating menus with controls and organizing your content intuitively.

`struct Menu`

A control for presenting a menu of actions.

Sets the style for menus within this view.

### Creating context menus

Adds a context menu to a view.

Adds a context menu with a custom preview to a view.

Adds an item-based context menu to a view.

### Defining commands

Adds commands to the scene.

Removes all commands defined by the modified scene.

Replaces all commands defined by the modified scene with the commands from the builder.

`protocol Commands`

Conforming types represent a group of related commands that can be exposed to the user via the main menu on macOS and key commands on iOS.

`struct CommandMenu`

Command menus are stand-alone, top-level containers for controls that perform related, app-specific commands.

`struct CommandGroup`

Groups of controls that you can add to existing command menus.

`struct CommandsBuilder`

Constructs command sets from multi-expression closures. Like `ViewBuilder`, it supports up to ten expressions in the closure body.

`struct CommandGroupPlacement`

The standard locations that you can place new command groups relative to.

### Getting built-in command groups

`struct SidebarCommands`

A built-in set of commands for manipulating window sidebars.

`struct TextEditingCommands`

A built-in group of commands for searching, editing, and transforming selections of text.

`struct TextFormattingCommands`

A built-in set of commands for transforming the styles applied to selections of text.

`struct ToolbarCommands`

A built-in set of commands for manipulating window toolbars.

`struct ImportFromDevicesCommands`

A built-in set of commands that enables importing content from nearby devices.

`struct InspectorCommands`

A built-in set of commands for manipulating inspectors.

`struct EmptyCommands`

An empty group of commands.

### Showing a menu indicator

Sets the menu indicator visibility for controls within this view.

`var menuIndicatorVisibility: Visibility`

The menu indicator visibility to apply to controls within a view.

### Configuring menu dismissal

Tells a menu whether to dismiss after performing an action.

`struct MenuActionDismissBehavior`

The set of menu dismissal behavior options.

### Setting a preferred order

Sets the preferred order of items for menus presented from this view.

`var menuOrder: MenuOrder`

The preferred order of items for menus presented from this view.

`struct MenuOrder`

The order in which a menu presents its content.

### Deprecated types

`struct MenuButton`

A button that displays a menu containing a list of choices when pressed.

Deprecated

`typealias PullDownButton` Deprecated

`struct ContextMenu`

A container for views that you present as menu items in a context menu.

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/shapes

Collection

- SwiftUI
- Shapes

API Collection

# Shapes

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

## Overview

Draw shapes like circles and rectangles, as well as custom paths that define shapes of your own design. Apply styles that include environment-aware colors, rich gradients, and material effects to the foreground, background, and outline of your shapes.

If you need the efficiency or flexibility of immediate mode drawing — for example, to create particle effects — use a `Canvas` view instead.

## Topics

### Creating rectangular shapes

`struct Rectangle`

A rectangular shape aligned inside the frame of the view containing it.

`struct RoundedRectangle`

A rectangular shape with rounded corners, aligned inside the frame of the view containing it.

`enum RoundedCornerStyle`

Defines the shape of a rounded rectangle’s corners.

`protocol RoundedRectangularShape`

A protocol of `InsettableShape` that describes a rounded rectangular shape.

`struct RoundedRectangularShapeCorners`

A type describing the corner styles of a `RoundedRectangularShape`.

`struct UnevenRoundedRectangle`

A rectangular shape with rounded corners with different values, aligned inside the frame of the view containing it.

`struct RectangleCornerRadii`

Describes the corner radius values of a rounded rectangle with uneven corners.

`struct RectangleCornerInsets`

The inset sizes for the corners of a rectangle.

`struct ConcentricRectangle`

A shape that is replaced by a concentric version of the current container shape. If the container shape is a rectangle derived shape with four corners, this shape could choose to respect corners individually.

### Creating circular shapes

`struct Circle`

A circle centered on the frame of the view containing it.

`struct Ellipse`

An ellipse aligned inside the frame of the view containing it.

`struct Capsule`

A capsule shape aligned inside the frame of the view containing it.

### Drawing custom shapes

`struct Path`

The outline of a 2D shape.

### Defining shape behavior

`protocol ShapeView`

A view that provides a shape that you can use for drawing operations.

`protocol Shape`

A 2D shape that you can use when drawing a view.

`struct AnyShape`

A type-erased shape value.

`enum ShapeRole`

Ways of styling a shape.

`struct StrokeStyle`

The characteristics of a stroke that traces a path.

`struct StrokeShapeView`

A shape provider that strokes its shape.

`struct StrokeBorderShapeView`

A shape provider that strokes the border of its shape.

`struct FillStyle`

A style for rasterizing vector shapes.

`struct FillShapeView`

A shape provider that fills its shape.

### Transforming a shape

`struct ScaledShape`

A shape with a scale transform applied to it.

`struct RotatedShape`

A shape with a rotation transform applied to it.

`struct OffsetShape`

A shape with a translation offset transform applied to it.

`struct TransformedShape`

A shape with an affine transform applied to it.

### Setting a container shape

`func containerShape(_:)`

Sets the container shape to use for any container relative shape or concentric rectangle within this view.

`protocol InsettableShape`

A shape type that is able to inset itself to produce another shape.

`struct ContainerRelativeShape`

A shape that is replaced by an inset version of the current container shape. If no container shape was defined, is replaced by a rectangle.

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Enhance your views with graphical effects and customized drawings.

---

# https://developer.apple.com/documentation/swiftui/drawing-and-graphics

Collection

- SwiftUI
- Drawing and graphics

API Collection

# Drawing and graphics

Enhance your views with graphical effects and customized drawings.

## Overview

You create rich, dynamic user interfaces with the built-in views and Shapes that SwiftUI provides. To enhance any view, you can apply many of the graphical effects typically associated with a graphics context, like setting colors, adding masks, and creating composites.

When you need the flexibility of immediate mode drawing in a graphics context, use a `Canvas` view. This can be particularly helpful when you want to draw an extremely large number of dynamic shapes — for example, to create particle effects.

For design guidance, see Materials and Color in the Human Interface Guidelines.

## Topics

### Immediate mode drawing

Add Rich Graphics to Your SwiftUI App

Make your apps stand out by adding background materials, vibrancy, custom graphics, and animations.

`struct Canvas`

A view type that supports immediate mode drawing.

`struct GraphicsContext`

An immediate mode drawing destination, and its current state.

### Setting a color

`func tint(_:)`

Sets the tint color within this view.

`struct Color`

A representation of a color that adapts to a given context.

### Styling content

Adds a border to this view with the specified style and width.

Sets a view’s foreground elements to use a given style.

Sets the primary and secondary levels of the foreground style in the child view.

Sets the primary, secondary, and tertiary levels of the foreground style.

Sets the specified style to render backgrounds within the view.

`var backgroundStyle: AnyShapeStyle?`

An optional style that overrides the default system background style when set.

`protocol ShapeStyle`

A color or pattern to use when rendering a shape.

`struct AnyShapeStyle`

A type-erased ShapeStyle value.

`struct Gradient`

A color gradient represented as an array of color stops, each having a parametric location value.

`struct MeshGradient`

A two-dimensional gradient defined by a 2D grid of positioned colors.

`struct AnyGradient`

A color gradient.

`struct ShadowStyle`

A style to use when rendering shadows.

`struct Glass`

A structure that defines the configuration of the Liquid Glass material.

### Transforming colors

Brightens this view by the specified amount.

Sets the contrast and separation between similar colors in this view.

Inverts the colors in this view.

Adds a color multiplication effect to this view.

Adjusts the color saturation of this view.

Adds a grayscale effect to this view.

Applies a hue rotation effect to this view.

Adds a luminance to alpha effect to this view.

Sets an explicit active appearance for materials in this view.

`var materialActiveAppearance: MaterialActiveAppearance`

The behavior materials should use for their active state, defaulting to `automatic`.

`struct MaterialActiveAppearance`

The behavior for how materials appear active and inactive.

### Scaling, rotating, or transforming a view

Scales this view to fill its parent.

Scales this view to fit its parent.

`func scaleEffect(_:anchor:)`

Scales this view’s rendered output by the given amount in both the horizontal and vertical directions, relative to an anchor point.

Scales this view’s rendered output by the given horizontal and vertical amounts, relative to an anchor point.

Scales this view by the specified horizontal, vertical, and depth factors, relative to an anchor point.

`func aspectRatio(_:contentMode:)`

Constrains this view’s dimensions to the specified aspect ratio.

Rotates a view’s rendered output in two dimensions around the specified point.

Renders a view’s content as if it’s rotated in three dimensions around the specified axis.

Rotates the view’s content by the specified 3D rotation value.

`func rotation3DEffect(_:axis:anchor:)`

Rotates the view’s content by an angle about an axis that you specify as a tuple of elements.

Applies an affine transformation to this view’s rendered output.

Applies a 3D transformation to this view’s rendered output.

Applies a projection transformation to this view’s rendered output.

`struct ProjectionTransform`

`enum ContentMode`

Constants that define how a view’s content fills the available space.

### Masking and clipping

Masks this view using the alpha channel of the given view.

Clips this view to its bounding rectangular frame.

Sets a clipping shape for this view.

### Applying blur and shadows

Applies a Gaussian blur to this view.

Adds a shadow to this view.

`struct ColorMatrix`

A matrix to use in an RGBA color transformation.

### Applying effects based on geometry

Applies effects to this view, while providing access to layout information through a geometry proxy.

Applies effects to this view, while providing access to layout information through a 3D geometry proxy.

`protocol VisualEffect`

Visual Effects change the visual appearance of a view without changing its ancestors or descendents.

`struct EmptyVisualEffect`

The base visual effect that you apply additional effect to.

### Compositing views

Sets the blend mode for compositing this view with overlapping views.

Wraps this view in a compositing group.

Composites this view’s contents into an offscreen image before final display.

`enum BlendMode`

Modes for compositing a view with overlapping content.

`enum ColorRenderingMode`

The set of possible working color spaces for color-compositing operations.

`protocol CompositorContent`

`struct CompositorContentBuilder`

A result builder for composing a collection of `CompositorContent` elements.

`struct AnyCompositorContent`

Type erased compositor content.

### Measuring a view

`struct GeometryReader`

A container view that defines its content as a function of its own size and coordinate space.

`struct GeometryReader3D`

`struct GeometryProxy`

A proxy for access to the size and coordinate space (for anchor resolution) of the container view.

`struct GeometryProxy3D`

A proxy for access to the size and coordinate space of the container view.

Assigns a name to the view’s coordinate space, so other code can operate on dimensions like points and sizes relative to the named space.

`enum CoordinateSpace`

A resolved coordinate space created by the coordinate space protocol.

`protocol CoordinateSpaceProtocol`

A frame of reference within the layout system.

`struct PhysicalMetric`

Provides access to a value in points that corresponds to the specified physical measurement.

`struct PhysicalMetricsConverter`

A physical metrics converter provides conversion between point values and their extent in 3D space, in the form of physical length measurements.

### Responding to a geometry change

`func onGeometryChange(for:of:action:)`

Adds an action to be performed when a value, created from a geometry proxy, changes.

### Accessing Metal shaders

Returns a new view that applies `shader` to `self` as a filter effect on the color of each pixel.

Returns a new view that applies `shader` to `self` as a geometric distortion effect on the location of each pixel.

Returns a new view that applies `shader` to `self` as a filter on the raster layer created from `self`.

`struct Shader`

A reference to a function in a Metal shader library, along with its bound uniform argument values.

`struct ShaderFunction`

A reference to a function in a Metal shader library.

`struct ShaderLibrary`

A Metal shader library.

### Accessing geometric constructs

`enum Axis`

The horizontal or vertical dimension in a 2D coordinate system.

`struct Angle`

A geometric angle whose value you access in either radians or degrees.

`struct UnitPoint`

A normalized 2D point in a view’s coordinate space.

`struct UnitPoint3D`

A normalized 3D point in a view’s coordinate space.

`struct Anchor`

An opaque value derived from an anchor source and a particular view.

`protocol DepthAlignmentID`

`struct Alignment3D`

An alignment in all three axes.

`struct GeometryProxyCoordinateSpace3D`

A representation of a `GeometryProxy3D` which can be used for `CoordinateSpace3D` based conversions.

## See Also

### Views

Define the visual elements of your app using a hierarchy of views.

Adjust the characteristics of views in a hierarchy.

Apply built-in and custom appearances and behaviors to different types of views.

Create smooth visual updates in response to state changes.

Display formatted text and get text input from the user.

Add images and symbols to your app’s user interface.

Display values and get user selections.

Provide space-efficient, context-dependent access to commands and controls.

Trace and fill built-in and custom shapes with a color, gradient, or other pattern.

---

# https://developer.apple.com/documentation/swiftui/layout-fundamentals

Collection

- SwiftUI
- Layout fundamentals

API Collection

# Layout fundamentals

Arrange views inside built-in layout containers like stacks and grids.

## Overview

Use layout containers to arrange the elements of your user interface. Stacks and grids update and adjust the positions of the subviews they contain in response to changes in content or interface dimensions. You can nest layout containers inside other layout containers to any depth to achieve complex layout effects.

To finetune the position, alignment, and other elements of a layout that you build with layout container views, see Layout adjustments. To define custom layout containers, see Custom layout. For design guidance, see Layout in the Human Interface Guidelines.

## Topics

### Choosing a layout

Picking container views for your content

Build flexible user interfaces by using stacks, grids, lists, and forms.

### Statically arranging views in one dimension

Building layouts with stack views

Compose complex layouts from primitive container views.

`struct HStack`

A view that arranges its subviews in a horizontal line.

`struct VStack`

A view that arranges its subviews in a vertical line.

### Dynamically arranging views in one dimension

Grouping data with lazy stack views

Split content into logical sections inside lazy stack views.

Creating performant scrollable stacks

Display large numbers of repeated views efficiently with scroll views, stack views, and lazy stacks.

`struct LazyHStack`

A view that arranges its children in a line that grows horizontally, creating items only as needed.

`struct LazyVStack`

A view that arranges its children in a line that grows vertically, creating items only as needed.

`struct PinnedScrollableViews`

A set of view types that may be pinned to the bounds of a scroll view.

### Statically arranging views in two dimensions

`struct Grid`

A container view that arranges other views in a two dimensional layout.

`struct GridRow`

A horizontal row in a two dimensional grid container.

Tells a view that acts as a cell in a grid to span the specified number of columns.

Specifies a custom alignment anchor for a view that acts as a grid cell.

Asks grid layouts not to offer the view extra size in the specified axes.

Overrides the default horizontal alignment of the grid column that the view appears in.

### Dynamically arranging views in two dimensions

`struct LazyHGrid`

A container view that arranges its child views in a grid that grows horizontally, creating items only as needed.

`struct LazyVGrid`

A container view that arranges its child views in a grid that grows vertically, creating items only as needed.

`struct GridItem`

A description of a row or a column in a lazy grid.

### Layering views

Adding a background to your view

Compose a background behind your view and extend it beyond the safe area insets.

`struct ZStack`

A view that overlays its subviews, aligning them in both axes.

Controls the display order of overlapping views.

Layers the views that you specify behind this view.

Sets the view’s background to a style.

Sets the view’s background to the default background style.

`func background(_:in:fillStyle:)`

Sets the view’s background to an insettable shape filled with a style.

`func background(in:fillStyle:)`

Sets the view’s background to an insettable shape filled with the default background style.

Layers the views that you specify in front of this view.

Layers the specified style in front of this view.

Layers a shape that you specify in front of this view.

`var backgroundMaterial: Material?`

The material underneath the current view.

Sets the container background of the enclosing container using a view.

`struct ContainerBackgroundPlacement`

The placement of a container background.

### Automatically choosing the layout that fits

`struct ViewThatFits`

A view that adapts to the available space by providing the first child view that fits.

### Separators

`struct Spacer`

A flexible space that expands along the major axis of its containing stack layout, or on both axes if not contained in a stack.

`struct Divider`

A visual element that can be used to separate other content.

## See Also

### View layout

Make fine adjustments to alignment, spacing, padding, and other layout parameters.

Place views in custom arrangements and create animated transitions between layout types.

Display a structured, scrollable column of information.

Display selectable, sortable data arranged in rows and columns.

Present views in different kinds of purpose-driven containers, like forms or control groups.

Enable people to scroll to content that doesn’t fit in the current display.

---

# https://developer.apple.com/documentation/swiftui/layout-adjustments

Collection

- SwiftUI
- Layout adjustments

API Collection

# Layout adjustments

Make fine adjustments to alignment, spacing, padding, and other layout parameters.

## Overview

Layout containers like stacks and grids provide a great starting point for arranging views in your app’s user interface. When you need to make fine adjustments, use layout view modifiers. You can adjust or constrain the size, position, and alignment of a view. You can also add padding around a view, and indicate how the view interacts with system-defined safe areas.

To get started with a basic layout, see Layout fundamentals. For design guidance, see Layout in the Human Interface Guidelines.

## Topics

### Finetuning a layout

Laying out a simple view

Create a view layout by adjusting the size of views.

Inspecting view layout

Determine the position and extent of a view using Xcode previews or by adding temporary borders.

### Adding padding around a view

`func padding(_:)`

Adds a different padding amount to each edge of this view.

Adds an equal padding amount to specific edges of this view.

`func padding3D(_:)`

Pads this view using the edge insets you specify.

Adds padding to the specified edges of this view using an amount that’s appropriate for the current scene.

Adds a specified kind of padding to the specified edges of this view using an amount that’s appropriate for the current scene.

`struct ScenePadding`

The padding used to space a view from its containing scene.

### Influencing a view’s size

Positions this view within an invisible frame with the specified size.

Positions this view within an invisible frame with the specified depth.

Positions this view within an invisible frame having the specified size constraints.

Positions this view within an invisible frame having the specified depth constraints.

Positions this view within an invisible frame with a size relative to the nearest container.

Fixes this view at its ideal size.

Fixes this view at its ideal size in the specified dimensions.

Sets the priority by which a parent layout should apportion space to this child.

### Adjusting a view’s position

Making fine adjustments to a view’s position

Shift the position of a view by applying the offset or position modifier.

Positions the center of this view at the specified point in its parent’s coordinate space.

Positions the center of this view at the specified coordinates in its parent’s coordinate space.

Offset this view by the horizontal and vertical amount specified in the offset parameter.

Offset this view by the specified horizontal and vertical distances.

Brings a view forward in Z by the provided distance in points.

### Aligning views

Aligning views within a stack

Position views inside a stack using alignment guides.

Aligning views across stacks

Create a custom alignment and use it to align views across multiple stacks.

`func alignmentGuide(_:computeValue:)`

Sets the view’s horizontal alignment.

`struct Alignment`

An alignment in both axes.

`struct HorizontalAlignment`

An alignment position along the horizontal axis.

`struct VerticalAlignment`

An alignment position along the vertical axis.

`struct DepthAlignment`

An alignment position along the depth axis.

`protocol AlignmentID`

A type that you use to create custom alignment guides.

`struct ViewDimensions`

A view’s size and alignment guides in its own coordinate space.

`struct ViewDimensions3D`

A view’s 3D size and alignment guides in its own coordinate space.

`struct SpatialContainer`

A layout container that aligns overlapping content in 3D space.

### Setting margins

Configures the content margin for a provided placement.

`func contentMargins(_:_:for:)`

`struct ContentMarginPlacement`

The placement of margins.

### Staying in the safe areas

Expands the safe area of a view.

`func safeAreaInset(edge:alignment:spacing:content:)`

Shows the specified content beside the modified view.

`func safeAreaPadding(_:)`

Adds the provided insets into the safe area of this view.

`struct SafeAreaRegions`

A set of symbolic safe area regions.

### Setting a layout direction

Sets the behavior of this view for different layout directions.

`enum LayoutDirectionBehavior`

A description of what should happen when the layout direction changes.

`var layoutDirection: LayoutDirection`

The layout direction associated with the current environment.

`enum LayoutDirection`

A direction in which SwiftUI can lay out content.

`struct LayoutRotationUnaryLayout`

### Reacting to interface characteristics

`var isLuminanceReduced: Bool`

A Boolean value that indicates whether the display or environment currently requires reduced luminance.

`var displayScale: CGFloat`

The display scale of this environment.

`var pixelLength: CGFloat`

The size of a pixel on the screen.

`var horizontalSizeClass: UserInterfaceSizeClass?`

The horizontal size class of this environment.

`var verticalSizeClass: UserInterfaceSizeClass?`

The vertical size class of this environment.

`enum UserInterfaceSizeClass`

A set of values that indicate the visual size available to the view.

### Accessing edges, regions, and layouts

`enum Edge`

An enumeration to indicate one edge of a rectangle.

`enum Edge3D`

An edge or face of a 3D volume.

`enum HorizontalEdge`

An edge on the horizontal axis.

`enum VerticalEdge`

An edge on the vertical axis.

`struct EdgeInsets`

The inset distances for the sides of a rectangle.

`struct EdgeInsets3D`

The inset distances for the faces of a 3D volume.

## See Also

### View layout

Arrange views inside built-in layout containers like stacks and grids.

Place views in custom arrangements and create animated transitions between layout types.

Display a structured, scrollable column of information.

Display selectable, sortable data arranged in rows and columns.

Present views in different kinds of purpose-driven containers, like forms or control groups.

Enable people to scroll to content that doesn’t fit in the current display.

---

# https://developer.apple.com/documentation/swiftui/custom-layout

Collection

- SwiftUI
- Custom layout

API Collection

# Custom layout

Place views in custom arrangements and create animated transitions between layout types.

## Overview

You can create complex view layouts using the built-in layout containers and layout view modifiers that SwiftUI provides. However, if you need behavior that you can’t achieve with the built-in layout tools, create a custom layout container type using the `Layout` protocol. A container that you define asks for the sizes of all its subviews, and then indicates where to place the subviews within its own bounds.

You can also create animated transitions among layout types that conform to the `Layout` procotol, including both built-in and custom layouts.

For design guidance, see Layout in the Human Interface Guidelines.

## Topics

### Creating a custom layout container

Composing custom layouts with SwiftUI

Arrange views in your app’s interface using layout tools that SwiftUI provides.

`protocol Layout`

A type that defines the geometry of a collection of views.

`struct LayoutSubview`

A proxy that represents one subview of a layout.

`struct LayoutSubviews`

A collection of proxy values that represent the subviews of a layout view.

### Configuring a custom layout

`struct LayoutProperties`

Layout-specific properties of a layout container.

`struct ProposedViewSize`

A proposal for the size of a view.

`struct ViewSpacing`

A collection of the geometric spacing preferences of a view.

### Associating values with views in a custom layout

Associates a value with a custom layout property.

`protocol LayoutValueKey`

A key for accessing a layout value of a layout container’s subviews.

### Transitioning between layout types

`struct AnyLayout`

A type-erased instance of the layout protocol.

`struct HStackLayout`

A horizontal container that you can use in conditional layouts.

`struct VStackLayout`

A vertical container that you can use in conditional layouts.

`struct ZStackLayout`

An overlaying container that you can use in conditional layouts.

`struct GridLayout`

A grid that you can use in conditional layouts.

## See Also

### View layout

Arrange views inside built-in layout containers like stacks and grids.

Make fine adjustments to alignment, spacing, padding, and other layout parameters.

Display a structured, scrollable column of information.

Display selectable, sortable data arranged in rows and columns.

Present views in different kinds of purpose-driven containers, like forms or control groups.

Enable people to scroll to content that doesn’t fit in the current display.

---

# https://developer.apple.com/documentation/swiftui/lists

Collection

- SwiftUI
- Lists

API Collection

# Lists

Display a structured, scrollable column of information.

## Overview

Use a list to display a one-dimensional vertical collection of views.

The list is a complex container type that automatically provides scrolling when it grows too large for the current display. You build a list by providing it with individual views for the rows in the list, or by using a `ForEach` to enumerate a group of rows. You can also mix these strategies, blending any number of individual views and `ForEach` constructs.

Use view modifiers to configure the appearance and behavior of a list and its rows, headers, sections, and separators. For example, you can apply a style to the list, add swipe gestures to individual rows, or make the list refreshable with a pull-down gesture. You can also use the configuration associated with Scroll views to control the list’s implicit scrolling behavior.

For design guidance, see Lists and tables in the Human Interface Guidelines.

## Topics

### Creating a list

Displaying data in lists

Visualize collections of data with platform-appropriate appearance.

`struct List`

A container that presents rows of data arranged in a single column, optionally providing the ability to select one or more members.

Sets the style for lists within this view.

### Disclosing information progressively

`struct OutlineGroup`

A structure that computes views and disclosure groups on demand from an underlying collection of tree-structured, identified data.

`struct DisclosureGroup`

A view that shows or hides another content view, based on the state of a disclosure control.

Sets the style for disclosure groups within this view.

### Configuring a list’s layout

Applies an inset to the rows in a list.

`var defaultMinListRowHeight: CGFloat`

The default minimum height of rows in a list.

`var defaultMinListHeaderHeight: CGFloat?`

The default minimum height of a header in a list.

Sets the vertical spacing between two adjacent rows in a List.

`func listSectionSpacing(_:)`

Sets the spacing between adjacent sections in a `List` to a custom value.

`struct ListSectionSpacing`

The spacing options between two adjacent sections in a list.

Set the section margins for the specific edges.

### Configuring rows

`func listItemTint(_:)`

Sets a fixed tint color for content in a list.

`struct ListItemTint`

A tint effect configuration that you can apply to content in a list.

### Configuring headers

Sets the header prominence for this view.

`var headerProminence: Prominence`

The prominence to apply to section headers within a view.

`enum Prominence`

A type indicating the prominence of a view hierarchy.

### Configuring separators

Sets the tint color associated with a row.

Sets the tint color associated with a section.

Sets the display mode for the separator associated with this specific row.

Sets whether to hide the separator associated with a list section.

### Configuring backgrounds

Places a custom background view behind a list row item.

Overrides whether lists and tables in this view have alternating row backgrounds.

`struct AlternatingRowBackgroundBehavior`

The styling of views with respect to alternating row backgrounds.

`var backgroundProminence: BackgroundProminence`

The prominence of the background underneath views associated with this environment.

`struct BackgroundProminence`

The prominence of backgrounds underneath other views.

### Displaying a badge on a list item

`func badge(_:)`

Generates a badge for the view from an integer value.

Specifies the prominence of badges created by this view.

`var badgeProminence: BadgeProminence`

The prominence to apply to badges associated with this environment.

`struct BadgeProminence`

The visual prominence of a badge.

### Configuring interaction

Adds custom swipe actions to a row in a list.

Adds a condition that controls whether users can select this view.

Requests that the containing list row use the provided hover effect.

Requests that the containing list row have its hover effect disabled.

### Refreshing a list’s content

Marks this view as refreshable.

`var refresh: RefreshAction?`

A refresh action stored in a view’s environment.

`struct RefreshAction`

An action that initiates a refresh operation.

### Editing a list

Adds a condition for whether the view’s view hierarchy is movable.

Adds a condition for whether the view’s view hierarchy is deletable.

An indication of whether the user can edit the contents of a view associated with this environment.

`enum EditMode`

A mode that indicates whether the user can edit a view’s content.

`struct EditActions`

A set of edit actions on a collection of data that a view can offer to a user.

`struct EditableCollectionContent`

An opaque wrapper view that adds editing capabilities to a row in a list.

`struct IndexedIdentifierCollection`

A collection wrapper that iterates over the indices and identifiers of a collection together.

### Configuring a section index

Changes the visibility of the list section index.

`func sectionIndexLabel(_:)`

Sets the label that is used in a section index to point to this section, typically only a single character long.

## See Also

### View layout

Arrange views inside built-in layout containers like stacks and grids.

Make fine adjustments to alignment, spacing, padding, and other layout parameters.

Place views in custom arrangements and create animated transitions between layout types.

Display selectable, sortable data arranged in rows and columns.

Present views in different kinds of purpose-driven containers, like forms or control groups.

Enable people to scroll to content that doesn’t fit in the current display.

---

