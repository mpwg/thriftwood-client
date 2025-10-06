<!--
Downloaded via https://llm.codes by @steipete on October 6, 2025 at 05:19 PM
Source URL: https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog/
Total pages processed: 90
URLs filtered: Yes
Content de-duplicated: Yes
Availability strings filtered: Yes
Code blocks only: No
-->

# https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog/

- Xcode
- Localization
- Localizing and varying text with a string catalog

Article

# Localizing and varying text with a string catalog

Use a string catalog to translate text, handle plurals, and vary the text your app displays on specific devices.

## Overview

Your app delivers the best experience when it runs well in a person’s locale and displays content in their native language. Supporting multiple languages is more than translating text. It includes handling plurals for nouns and units, as well as displaying the right form of text on specific devices.

Use a string catalog to localize and translate all your app’s text in a visual editor right in Xcode. A string catalog automatically tracks all the localizable strings from your code, and keeps your translations in one place.

Use string catalogs to host translations, configure pluralization messages for different regions and locales, and change how text appears on different devices.

### Localize your app’s text

Before you can translate text, you need to make it localizable. This involves wrapping the user-facing strings in your app in constructs that make them translatable.

In SwiftUI, all string literals within a view are automatically localizable.

// SwiftUI localizable text.
Text("Welcome")

Make general text localizable using the `String(localized:)` initializer. For apps targeting older platforms, use the `NSLocalizedString` macro.

// General localizable text.
String(localized: "Buy a book"))

Add comments to give context and assist localizers when translating your text.

// Localizable text with comments.
Text("Explore", comment: "The title of the tab bar item that navigates to the Explore screen.")
String(localized: "Get Started", comment: "The label on the Get Started button that appears after they sign in.")

### Add a string catalog to your project

In the sheet that appears, select the platform, enter `string` into the filter field, select String Catalog, and click Next. In the dialog that appears, accept the default name `Localizable`, choose a location, and click Create.

If your string catalog gets too big, you can create multiple string catalog files within a single Xcode project, and give each a unique name. Then choose which string catalog to use for each translation by passing the string catalog name to the `tableName` or `table` parameter to the respective localization API as follows:

// A SwiftUI localization example pointing to a specific string catalog.
Text("Explore", tableName: "Navigation")

// A general text localization example pointing to a specific string catalog.
String(localized: "Get Started", table: "MainScreen")

### Add a language to your project

To support multiple languages in your app, add additional languages to your project. For each language, select the string catalog in the Project navigator, click the Add button (+) near the bottom of the string catalog editor, and select a language to add.

### Add your localizable text to the string catalog

Use the percent symbol beside each language to track your string catalog’s percentage of translation.

### Add your translations using the string catalog editor

After identifying your localizable strings and adding them to a string catalog, you can either manually translate them, or you can export them, send them to a third-party for translation, and then import them.

To enter your app’s translations manually, select the string catalog and click the language you want to add translations for. Then click the text field of the Language column for each key in the table and enter the translation for that key.

Newly added strings that require translation appear with a New icon in the State column. When you add a translation, the New icon changes to a green checkmark. As you add translations, the percent symbol beside the language updates, displaying the translation percentage for that language. When a string catalog language reaches full translation, the percent symbol changes to a green checkmark.

For information about exporting and importing translations in Xcode, see Exporting localizations and Importing localizations.

### Add pluralizations

Languages have different grammatical rules for handling plurals of nouns and units. For example, in English, you can return `1 Book` when the value of `%lld` is `1`. And you can return `%lld Books` for all other cases. Other languages can have fewer or more plural variants, depending on their region and locale.

| Plural | Text |
| --- | --- |
| One | `%lld Book` |
| Other | `%lld Books` |

To add a plural variant, first localize the text using the value the string is dependent on, using string interpolation.

@State private var itemCount = 0
Text("\(itemCount) Books")

Then, in the string catalog editor, select the language you want to add pluralization for, Control-click the variant key, and select the Vary by Plural option.

When you add a plural variant, the system does the following:

- Adds all the plural forms for that language into the string catalog editor.

- Determines which specifier to use for the interpolated string ( `%lld` representing a 64-bit integer in this case).

- Prepopulates the variant fields with the value of that key.

Click the text field in the Language column for each variation of that string key, and enter the text for the system to use when that plural displays.

When you run the app, the pluralized variants update based on the value of the interpolated string.

### Vary strings by device

When you need to alter the text that displays on a device due to the available space, or because it has a different interaction, use the Vary by Device option in the string catalog editor.

For example, suppose you want to display two different messages depending on whether your app is running on iPhone or a Mac.

| Operating system | Message |
| --- | --- |
| iOS | Tap to learn more |
| macOS | Click to learn more |

To vary the text string based on device, select the string catalog file, along with the language and key representing the message you want to vary. Control-click the key, select Vary by Device, and then select the device you want to add a specific message for.

Enter the text you want to display for that selected device, while retaining the existing text for all other devices. Add more devices if you need more variations.

When the app runs on the selected device, the system displays the new message for that device.

### Test your translations

To test your translations in the simulator:

2. In the dialog that appears, select the Run action on the left and click the Options tab.

3. Click the App Language drop-down, select the language you want to test, and click Close.

You can also navigate to Settings on the simulated device and change the deviceʼs language there. When your app runs, the translations for the selected language appear in the simulator.

## See Also

### Essentials

Supporting multiple languages in your app

Internationalize your app’s strings, images, and other resource types to prepare for the translation process.

Localizing Landmarks

Add localizations to the Landmarks sample code project.

---

# https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog

- Xcode
- Localization
- Localizing and varying text with a string catalog

Article

# Localizing and varying text with a string catalog

Use a string catalog to translate text, handle plurals, and vary the text your app displays on specific devices.

## Overview

Your app delivers the best experience when it runs well in a person’s locale and displays content in their native language. Supporting multiple languages is more than translating text. It includes handling plurals for nouns and units, as well as displaying the right form of text on specific devices.

Use a string catalog to localize and translate all your app’s text in a visual editor right in Xcode. A string catalog automatically tracks all the localizable strings from your code, and keeps your translations in one place.

Use string catalogs to host translations, configure pluralization messages for different regions and locales, and change how text appears on different devices.

### Localize your app’s text

Before you can translate text, you need to make it localizable. This involves wrapping the user-facing strings in your app in constructs that make them translatable.

In SwiftUI, all string literals within a view are automatically localizable.

// SwiftUI localizable text.
Text("Welcome")

Make general text localizable using the `String(localized:)` initializer. For apps targeting older platforms, use the `NSLocalizedString` macro.

// General localizable text.
String(localized: "Buy a book"))

Add comments to give context and assist localizers when translating your text.

// Localizable text with comments.
Text("Explore", comment: "The title of the tab bar item that navigates to the Explore screen.")
String(localized: "Get Started", comment: "The label on the Get Started button that appears after they sign in.")

### Add a string catalog to your project

In the sheet that appears, select the platform, enter `string` into the filter field, select String Catalog, and click Next. In the dialog that appears, accept the default name `Localizable`, choose a location, and click Create.

If your string catalog gets too big, you can create multiple string catalog files within a single Xcode project, and give each a unique name. Then choose which string catalog to use for each translation by passing the string catalog name to the `tableName` or `table` parameter to the respective localization API as follows:

// A SwiftUI localization example pointing to a specific string catalog.
Text("Explore", tableName: "Navigation")

// A general text localization example pointing to a specific string catalog.
String(localized: "Get Started", table: "MainScreen")

### Add a language to your project

To support multiple languages in your app, add additional languages to your project. For each language, select the string catalog in the Project navigator, click the Add button (+) near the bottom of the string catalog editor, and select a language to add.

### Add your localizable text to the string catalog

Use the percent symbol beside each language to track your string catalog’s percentage of translation.

### Add your translations using the string catalog editor

After identifying your localizable strings and adding them to a string catalog, you can either manually translate them, or you can export them, send them to a third-party for translation, and then import them.

To enter your app’s translations manually, select the string catalog and click the language you want to add translations for. Then click the text field of the Language column for each key in the table and enter the translation for that key.

Newly added strings that require translation appear with a New icon in the State column. When you add a translation, the New icon changes to a green checkmark. As you add translations, the percent symbol beside the language updates, displaying the translation percentage for that language. When a string catalog language reaches full translation, the percent symbol changes to a green checkmark.

For information about exporting and importing translations in Xcode, see Exporting localizations and Importing localizations.

### Add pluralizations

Languages have different grammatical rules for handling plurals of nouns and units. For example, in English, you can return `1 Book` when the value of `%lld` is `1`. And you can return `%lld Books` for all other cases. Other languages can have fewer or more plural variants, depending on their region and locale.

| Plural | Text |
| --- | --- |
| One | `%lld Book` |
| Other | `%lld Books` |

To add a plural variant, first localize the text using the value the string is dependent on, using string interpolation.

@State private var itemCount = 0
Text("\(itemCount) Books")

Then, in the string catalog editor, select the language you want to add pluralization for, Control-click the variant key, and select the Vary by Plural option.

When you add a plural variant, the system does the following:

- Adds all the plural forms for that language into the string catalog editor.

- Determines which specifier to use for the interpolated string ( `%lld` representing a 64-bit integer in this case).

- Prepopulates the variant fields with the value of that key.

Click the text field in the Language column for each variation of that string key, and enter the text for the system to use when that plural displays.

When you run the app, the pluralized variants update based on the value of the interpolated string.

### Vary strings by device

When you need to alter the text that displays on a device due to the available space, or because it has a different interaction, use the Vary by Device option in the string catalog editor.

For example, suppose you want to display two different messages depending on whether your app is running on iPhone or a Mac.

| Operating system | Message |
| --- | --- |
| iOS | Tap to learn more |
| macOS | Click to learn more |

To vary the text string based on device, select the string catalog file, along with the language and key representing the message you want to vary. Control-click the key, select Vary by Device, and then select the device you want to add a specific message for.

Enter the text you want to display for that selected device, while retaining the existing text for all other devices. Add more devices if you need more variations.

When the app runs on the selected device, the system displays the new message for that device.

### Test your translations

To test your translations in the simulator:

2. In the dialog that appears, select the Run action on the left and click the Options tab.

3. Click the App Language drop-down, select the language you want to test, and click Close.

You can also navigate to Settings on the simulated device and change the deviceʼs language there. When your app runs, the translations for the selected language appear in the simulator.

## See Also

### Essentials

Supporting multiple languages in your app

Internationalize your app’s strings, images, and other resource types to prepare for the translation process.

Localizing Landmarks

Add localizations to the Landmarks sample code project.

---

# https://developer.apple.com/documentation/xcode

# Xcode

Build, test, and submit your app with Apple’s integrated development environment.

## Overview

Xcode is the suite of tools you use to build apps for Apple platforms. Use Xcode to manage your entire development workflow — from creating your app to testing, optimizing, and submitting it to the App Store.

Xcode includes a world-class source editor with code completion, source control, and a powerful debugger. Use coding intelligence to explain and write code, analyze bugs, and generate fixes. Add playground macros to run code snippets, and add SwiftUI previews to see your UI as you build it.

Xcode also includes several tools to help you rapidly develop and test your app:

- Run your entire app in Simulator without using a real device.

- Create a single, multilayer icon for your app using the Icon Composer app.

- Use Instruments to profile and analyze your app, improve performance, and investigate system resource usage.

- Construct 3D content with Reality Composer.

- Train custom machine learning models with Create ML.

- Identify areas of your app that aren’t accessible with Accessibility Inspector.

## Topics

### Essentials

Creating an Xcode project for an app

Start developing your app by creating an Xcode project from a template.

Creating your app’s interface with SwiftUI

Develop apps in SwiftUI with an interactive preview that keeps the code and layout in sync.

Previewing your app’s interface in Xcode

Iterate designs quickly and preview your apps’ displays across different Apple devices.

Building and running an app

Compile your source files and assemble an app bundle to run on a device or simulator.

Xcode updates

Learn about important changes to Xcode.

### Xcode IDE

Manage the code and resources you use to build apps, libraries, and other software for Apple platforms.

Back up your files, collaborate with others, and tag your releases with source control support in Xcode.

Enable services that Apple provides, such as In-App Purchase, Push Notifications, Apple Pay, iCloud, and many others.

Compile your code into a binary format, and customize your project settings to build your code.

### Code

Edit your source files, locate issues, and make necessary changes using the Source Editor.

Organize code and resources in bundles and frameworks.

Create reusable code, organize it in a lightweight way, and share it across Xcode projects and with other developers.

### Interface

Add app icons, images, strings, data files, machine learning models, and other resources to your projects, and manage how you load them at runtime.

Expand the market for your app by supporting multiple languages and regions.

Accessibility Inspector

Reveal how your app represents itself to people using accessibility features.

### Documentation

Produce rich and engaging developer documentation for your apps, frameworks, and packages.

### Tuning and debugging

Configure and manage devices connected to your Mac or devices in Simulator and use them to run your app.

Identify and address issues in your app using the Xcode debugger, Xcode Organizer, Metal debugger, and Instruments.

Measure, investigate, and address the use of system resources and issues impacting performance using Instruments and Xcode Organizer.

Develop and run tests to detect logic failures, UI problems, and performance regressions.

### Distribution and continuous integration

Prepare your app and share it with your team, beta testers, and customers.

Automatically build, test, and distribute your apps with Xcode Cloud to verify changes and create high-quality apps.

### Hardware considerations

Apple silicon

Get the resources you need to create software for Macs with Apple silicon.

Write assembly instructions that adhere to the application binary interfaces of Apple platforms.

---

# https://developer.apple.com/documentation/xcode/localization

Collection

- Xcode
- Localization

# Localization

Expand the market for your app by supporting multiple languages and regions.

## Overview

Localization is the process of translating and adapting your app into multiple languages and regions. Localize your app to provide access for users who speak a variety of languages, and who download from different App Store territories.

First, _internationalize_ your code with APIs that automatically format and translate strings correctly for the language and region. Then add support for content that includes plural nouns and verbs by following language plural rules to increase the accuracy of your translations.

### Translate and adapt your app

In Xcode, localization refers specifically to the set of resources for a specific language and region that you support.

You add a localization to your project and select the resources you want to include for that language and region. Export the localization and send the files to _localizers_, who translate the user-facing text and adapt resources for particular cultures and regions. Finally, you import the localized files and test the app in that language and region directly in Xcode.

When you release a localized version of your app, you can also localize the App Store information in App Store Connect for the specific territories where you offer your app.

For other localization tips, tools, and resources, see Expanding Your App to New Markets.

## Topics

### Essentials

Supporting multiple languages in your app

Internationalize your app’s strings, images, and other resource types to prepare for the translation process.

Localizing and varying text with a string catalog

Use a string catalog to translate text, handle plurals, and vary the text your app displays on specific devices.

Localizing Landmarks

Add localizations to the Landmarks sample code project.

### Strings and text

Preparing your interface for localization

Find text in your app that needs translation and verify that your interface adapts to translated text.

Preparing your app’s text for translation

Make your app’s text translatable by leveraging the localization APIs in the Foundation framework.

Preparing dates, currencies, and numbers for translation

Ensure that dates, currencies, and numbers display correctly across multiple languages and locales by using formatters.

### Layouts and views

Preparing views for localization

Specify hints and add strings to localize your SwiftUI views.

Autosizing Views for Localization in iOS

Add auto layout constraints to your app to achieve localizable views.

Localization-Friendly Layouts in macOS

This project demonstrates localization-friendly auto layout constraints. It uses \`NSGridView\` as a container view to achieve localized layouts.

### Languages and regions

Adding support for languages and regions

Select the resources that you want to localize for each language and region you support.

Choosing localization regions and scripts

Add a language-only localization or localizations specific to regional variants and scripts.

### Resources and assets

Adding resources to localizations

Include more resources in the localizations you add to your project.

Localizing assets in a catalog

Use asset catalogs to localize colors, images, symbols, watch complications, and more.

### Translation and adaptation

Creating screenshots of your app for localizers

Share screenshots of your app with localizers to provide context for translation.

Exporting localizations

Provide the localizable files from your project to localizers.

Editing XLIFF and string catalog files

Translate or adapt the localizable files for a language and region that you export from your project.

Importing localizations

Import the files that you translate or adapt for a language and region into your project.

Locking views in storyboard and XIB files

Prevent changes to your Interface Builder files while localizing human-facing strings.

### Testing

Previewing localizations

Test localizations in the SwiftUI preview or the Interface Builder preview.

Testing localizations when running your app

Run your app in each language and region you support to thoroughly test your app.

### Legacy localization techniques

Localizing strings that contain plurals

Use a strings dictionary file to ensure correct localization of strings that contain language plurals.

Creating width and device variants of strings

Change a localized string for different interface widths and devices.

## See Also

### Interface

Add app icons, images, strings, data files, machine learning models, and other resources to your projects, and manage how you load them at runtime.

Accessibility Inspector

Reveal how your app represents itself to people using accessibility features.

---

# https://developer.apple.com/documentation/xcode/exporting-localizations

- Xcode
- Localization
- Exporting localizations

Article

# Exporting localizations

Provide the localizable files from your project to localizers.

## Overview

Export localizations for the languages and regions you’re ready to support. You can export all the files that you need to localize from your Xcode project, or export the files for specific localizations. Optionally, add files to the exported folders to provide context, and then give the files to localizers.

### Export localizations using Xcode

If you generate screenshots when testing your localizations, provide context for localizers by clicking “Include screenshots” to include the localization-specific screenshots in the `Notes` folder of the exported files. To filter the screenshots, click Customize, deselect the screenshots you don’t want to include, and click Done.

Xcode creates an Xcode Localization Catalog (a folder with a `.xcloc` file extension) containing the localizable resources for each language and region. You can open and edit this file in Xcode, or use any third-party tool that supports this file type. Xcode manages the localizable strings in your app for you as follows:

- Extracts strings from the following file types: source code, storyboard, XIB, `.strings`, `.stringsdict`, and Siri intent definition. Adds the extracted strings to a standard XML Localization Interchange File Format (XLIFF) that’s familiar to localizers.

- Adds the correct `.stringsdict` plural variants for each exported language to the XLIFF file.

- Creates a strings file for the localizable properties in the information property list file.

- Copies all localizable resources into the `Source Contents` folder to provide context for localizers.

Xcode extracts strings that you pass to `Text` structures, the `NSLocalizedString` macro, and similar APIs in your code. For example, if you pass a string with a comment to the `NSLocalizedString` macro, Xcode includes the comment in the XLIFF file.

In addition, each localization folder in the catalog contains only the resources and assets that you mark as localizable. Prior to localization, the file is a copy of the development language file—a placeholder to provide context for the localizers.

### Add files to the Xcode Localization Catalog

Before you give the catalog to localizers, you can add additional files to the `Notes` folders to provide more context. An Xcode Localization Catalog folder contains:

| Item | Description |
| --- | --- |
| `contents.json` | A JSON file containing metadata about the catalog, such as the development region, the locale, the tool (Xcode) and its version number, and the catalog version number. |
| `Localized Contents` | A folder containing the localizable resources, including an XLIFF file containing the localizable strings. |
| `Notes` | A folder containing additional information for localizers, such as screenshots, movies, or text files. |
| `Source Contents` | A folder containing the assets to produce the content that provides context for localizers, such as user interface files and other resources. |

### Export localizations using commands

You can also export localization files with the `xcodebuild` command using the - `exportLocalizations` argument:

To include the screenshots you generate while testing localizations, add the `-includeScreenshots` argument to the above command.

## See Also

### Translation and adaptation

Creating screenshots of your app for localizers

Share screenshots of your app with localizers to provide context for translation.

Editing XLIFF and string catalog files

Translate or adapt the localizable files for a language and region that you export from your project.

Importing localizations

Import the files that you translate or adapt for a language and region into your project.

Locking views in storyboard and XIB files

Prevent changes to your Interface Builder files while localizing human-facing strings.

---

# https://developer.apple.com/documentation/xcode/importing-localizations

- Xcode
- Localization
- Importing localizations

Article

# Importing localizations

Import the files that you translate or adapt for a language and region into your project.

## Overview

After you localize the contents of a catalog, import the localizations back into your project. When you import localizations, Xcode updates the strings files in your project from the localized versions in the XLIFF file in the catalog.

### Import localizations using Xcode

In the sheet that appears, review the warnings and errors. In the left column, click the Issues View button in the toolbar, then select a message that appears below. In the comparison editor on the right, the imported catalog version of the file appears on the left and the current project file appears on the right.

To review all the changes, click the File View button in the toolbar, and select a file in the navigator below. When you’re ready to import the files, click Import. Xcode updates the strings and `.stringsdict` files from the localized versions in the catalog. Xcode also updates any localizable resources and assets in an asset catalog.

### Import localizations using commands

You can also import the catalog with the `xcodebuild` command using the `-importLocalizations` argument:

Be sure to test your app for the languages and regions in your project.

## See Also

### Translation and adaptation

Creating screenshots of your app for localizers

Share screenshots of your app with localizers to provide context for translation.

Exporting localizations

Provide the localizable files from your project to localizers.

Editing XLIFF and string catalog files

Translate or adapt the localizable files for a language and region that you export from your project.

Locking views in storyboard and XIB files

Prevent changes to your Interface Builder files while localizing human-facing strings.

---

# https://developer.apple.com/documentation/xcode/supporting-multiple-languages-in-your-app

- Xcode
- Localization
- Supporting multiple languages in your app

Article

# Supporting multiple languages in your app

Internationalize your app’s strings, images, and other resource types to prepare for the translation process.

## Overview

Multilingual apps are apps that can run in more than one language and region. Making your app multilingual doesn’t only enable your app to run natively in more regions of the world, it gives your customers a better overall experience, while bringing your app to a wider audience.

To make your app multilingual, you first need to _internationalize_ it. This process involves preparing assets in your app so that a localizer can translate them into different languages and regional conventions. For example, dates in some countries appear in a day-month-year format, while in others, the month comes first.

After you internationalize your app, you need to _localize_ it. Localization is the process of translating your assets into other languages for various regions. During this process, you export the relevant strings and other resources from your app, and give them to a localizer for translation. The localizer gives you back translated versions of your assets, which you import into your app. You then test the translations in your app to make sure everything works.

## Internationalize your code

The first step to making your app multilingual is to internationalize your code to handle different languages and regional conventions.

This process involves writing your code in such a way that your app can automatically extract the language resources it needs based on the current language settings of your user’s device. The Foundation framework, along with other Apple frameworks, supports this internationalization process.

When writing code for internationalization, consider the following:

- **User-facing text**. People are more comfortable using apps when the text appears in the language and region of their device. Use localized versions of the string formatters to prepare your app’s text for localization. For more information about user-facing text, see Discover String Catalogs.

- **Dates, currencies, and numbers**. Different regions have different formats for dates, currencies, and numbers. Use `DateFormatter` and `NumberFormatter` in the Foundation framework to translate these strings correctly.

- **Pluralization**. Languages have different grammatical rules for handling plurals of nouns and units. Use a string catalog to localize formatted strings that contain variable amounts. For more information about pluralization, see Localizing and varying text with a string catalog.

- **Device type**. The device your app runs on affects the text it displays. The display on an Apple Watch differs from that on a Mac. Vary the text you present depending upon the device your app is running on. For more information about localizing text for a device type, see Localizing and varying text with a string catalog.

- **Grammatical agreement**. Many languages rely on gender for their grammar. Without knowing the subject’s gender or pronoun preferences, some localized strings may have grammatical errors, resulting in a poor user experience. Use the automatic grammar agreement APIs in Foundation, such as `TermOfAddress`, to represent grammatical gender in localized text. For more information about grammatical agreement, see Unlock the power of grammatical agreement.

- **Text direction**. European languages read left to right, and languages like Arabic and Hebrew read right to left. Use the layout tools in SwiftUI and Xcode to control text and UI element orientation, and to flip image direction when necessary. For more information about text direction, see Get it right (to left).

- **Tall languages**. Languages like Arabic, Hindi, and Thai require significantly more vertical space for their characters than Latin languages do. Additionally, Chinese, German, Japanese, and Korean have language-specific conventions for wrapping and hyphenation. To prevent clipping of words and letters, and to ensure proper spacing of text, use Dynamic Type. For more information about Dynamic Type, see Scaling fonts automatically and What’s new with text and text interactions.

- **Sounds, images and assets**. App assets like sounds, images, and colors can vary across language and region. Use an asset catalog to localize colors, images, and sounds in your app. For more information about adding resources to asset catalogs, see Adding resources to localizations and Localizing assets in a catalog.

## Localize your assets

After you internationalize your app, it’s ready for localization. To localize your assets, export localizable text from Xcode using standard file formats and submit them to a localization team for translation into your app’s supported languages.

To localize your app, do the following:

- Export your app assets.

- Translate those assets into other languages and regional conventions.

- Import the translated assets into your project.

For more information about exporting and importing app assets, see Discover String Catalogs.

## Test your translations

After you localize your app’s assets, you need to test the translations. Run your app in each language, and for each region you support, to thoroughly test the localized assets. For more information about testing, see Testing localizations when running your app.

## See Also

### Essentials

Localizing and varying text with a string catalog

Use a string catalog to translate text, handle plurals, and vary the text your app displays on specific devices.

Localizing Landmarks

Add localizations to the Landmarks sample code project.

---

# https://developer.apple.com/documentation/xcode/localizing-landmarks

- Xcode
- Localization
- Localizing Landmarks

Sample Code

# Localizing Landmarks

Add localizations to the Landmarks sample code project.

Download

Xcode 26.0+

## Overview

This is an unlocalized version of Landmarks. Prepare it for localization by adding a String Catalog and import translations ( `de.xcloc`) to complete the localization process.

## See Also

### Essentials

Supporting multiple languages in your app

Internationalize your app’s strings, images, and other resource types to prepare for the translation process.

Localizing and varying text with a string catalog

Use a string catalog to translate text, handle plurals, and vary the text your app displays on specific devices.

---

# https://developer.apple.com/documentation/xcode/localization)



---

# https://developer.apple.com/documentation/xcode/exporting-localizations)



---

# https://developer.apple.com/documentation/xcode/importing-localizations).



---

# https://developer.apple.com/documentation/xcode/supporting-multiple-languages-in-your-app)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/localizing-landmarks)



---

# https://developer.apple.com/documentation/xcode/creating-an-xcode-project-for-an-app

- Xcode
- Creating an Xcode project for an app

Article

# Creating an Xcode project for an app

Start developing your app by creating an Xcode project from a template.

## Overview

To create an Xcode project for your app, choose a template for the platform on which your app will run, and select the type of app you wish to develop, such as a single view, game, or document-based for iOS. Xcode templates include essential project configuration and files that help you start developing your app quickly.

### Prepare configuration information

Before you create a project, collect the information that Xcode needs to identify your app and you as a developer:

- **Product name.** The name of your app as it will appear in the App Store and appear on a device when installed. The product name must be at least 2 characters and no more than 255 bytes, and should be similar to the app name that you enter later in App Store Connect.

- **Organization identifier.** A reverse DNS string that uniquely identifies your organization. If you don’t have a company identifier, use `com.example.` followed by your organization name, and replace it before you distribute your app.

- **Organization name.** The name that appears in boilerplate text throughout your project folder. For example, the source and header file copyright strings contain the organization name. The organization name in your project isn’t the same as the organization name that appears in the App Store.

### Create a project

If you see a banner that says you don’t have support for the platform, you can create the project, but you can’t build and run it on a device. To install the platform now, click the Get button on the right of the banner. Otherwise, you can manage downloads in the Components settings later (see Downloading and installing additional Xcode components).

To continue creating your project, you need to provide a _product name_ and _organization identifier_ because they are used to create the _bundle identifier_ that identifies your app throughout the system. Also enter an _organization name_. If you don’t belong to an organization, enter your name.

To develop for all platforms and see an interactive preview of your layout, choose SwiftUI as the user interface before you click Next on this sheet.

### Manage files in the main window

When you create a project or open an existing project, the _main window_ appears, showing the necessary files and resources for developing your app.

You can access different parts of your project from the _navigator area_ in the main window. Use the _project navigator_ to select files you want to edit in the _editor area_. For example, when you select a Swift file in the project navigator, the file opens in the _source editor,_ where you can modify the code and set breakpoints.

Details about the selected file also appear in the _inspector area_ on the right. In the inspector area, you can select the Attributes inspector to edit properties of a file or user interface element. If you want to hide the inspector to make more room for the editor, click the “Hide or show the Inspectors” button in the upper-right corner of the toolbar.

You use the _toolbar_ to build and run your app on a simulated or real device. For iOS apps, choose the app target and a simulator or device from the run destination menu in the toolbar, then click the Run button.

For macOS apps, just click the Run button. When your app launches, the _debug area_ opens, where you can control the execution of your app and inspect variables. When the app stops at the breakpoint, use the controls in the debug area to step through the code or continue execution. When you are done running the app, click the Stop button in the toolbar.

If you use SwiftUI, you can see an interactive preview of the user interface while you create your app. Xcode keeps the changes you make in the source file, the canvas on the right, and the inspector in sync. You can use the controls in the preview to run the app with the debugger, too. For details, see Creating your app’s interface with SwiftUI.

To change properties you entered when creating your project, select the project name in the project navigator that appears at the top, then the _project editor_ opens in the editor area. Most of the properties you entered appear on the _General pane_ of the project editor.

## See Also

### Essentials

Creating your app’s interface with SwiftUI

Develop apps in SwiftUI with an interactive preview that keeps the code and layout in sync.

Previewing your app’s interface in Xcode

Iterate designs quickly and preview your apps’ displays across different Apple devices.

Building and running an app

Compile your source files and assemble an app bundle to run on a device or simulator.

Xcode updates

Learn about important changes to Xcode.

---

# https://developer.apple.com/documentation/xcode/creating-your-app-s-interface-with-swiftui

- Xcode
- Creating your app’s interface with SwiftUI

Article

# Creating your app’s interface with SwiftUI

Develop apps in SwiftUI with an interactive preview that keeps the code and layout in sync.

## Overview

If you choose the SwiftUI framework to develop your app, you can see an interactive preview as you lay out your user interface. Xcode keeps the changes you make to the source code, the user interface layout, and the inspector in sync. For example, when you edit attributes in the inspector, Xcode adds the corresponding code to the source file.

### Display the SwiftUI preview

Use the controls at the bottom of the preview to run the app on a simulated device in the canvas, with or without a debug session, or run the app on a connected device.

### Add views and modifiers

To add views and modifiers to your app, click the Library button (+) in the toolbar to open the library, then drag user interface elements from the library to either the canvas or source code. Regardless of where you drop the elements, Xcode keeps the source code and the layout in sync.

### Embed user interface elements

Additionally, you can modify the user interface by embedding elements in other structures. Command-click an element in the source code or in the canvas, then choose an “Embed in \[Generic Structure\]” action from the pop-up menu. For example, choose “Embed in HStack” to embed an element that arranges a view’s children in a horizontal line.

To learn more about SwiftUI, go to Introducing SwiftUI.

## See Also

### Essentials

Creating an Xcode project for an app

Start developing your app by creating an Xcode project from a template.

Previewing your app’s interface in Xcode

Iterate designs quickly and preview your apps’ displays across different Apple devices.

Building and running an app

Compile your source files and assemble an app bundle to run on a device or simulator.

Xcode updates

Learn about important changes to Xcode.

---

# https://developer.apple.com/documentation/xcode/previewing-your-apps-interface-in-xcode

- Xcode
- Previewing your app’s interface in Xcode

Article

# Previewing your app’s interface in Xcode

Iterate designs quickly and preview your apps’ displays across different Apple devices.

## Overview

With Xcode previews, you can make changes to your app’s views in code, and see the result of those changes quickly in the preview canvas. Add previews to your SwiftUI, UIKit, and AppKit views using the preview macro. Then configure how you want your previews to display using Xcode’s preview canvas, or programmatically in code.

### Add a preview to your view using the preview macro

When you create a view in Xcode, you can display it in the preview canvas. The preview canvas shows how your view appears on different devices in a variety of configurations.

// A SwiftUI preview.
#Preview {
// The view to preview.
}

// A UIKIt preview.
#Preview {
// The view or view controller to preview.
}

// An AppKit preview.
#Preview {

To add a preview macro to your view:

1. Open the source file of the view you want to display.

2. Add the `#Preview` macro to the view.

3. Create and return an instance of the view configuration you want to display in the body of the trailing closure of the macro.

struct ContentView: View {
var body: some View {
// ...
}
}

#Preview {
// A SwiftUI preview.
ContentView()
}

class WeatherViewController: UIViewController {
// ...
}

// A UIKit UIViewController preview.
#Preview {
let viewController = WeatherViewController()
viewController.title = "Current Weather"
return viewController
}

class WeatherView: UIView {
var icon: UIImage?
}

// A UIKit UIView preview.
#Preview {
let view = WeatherView()
if let image = UIImage(systemName: "sun.max.fill") {
view.icon = image
}
return view
}

class WeatherViewController: NSViewController {
// ...
}

// An AppKit NSViewController preview.
#Preview {

class WeatherView: NSView {
var icon: NSImage?
}

// An AppKit NSView preview.
#Preview {
let view = WeatherView()
view.icon = NSImage(symbolName: "sun.max.fill", variableValue: 0.0)
return view
}

### Interact with your view in live mode

When you select the live or interactive preview option, your view appears and interacts just like it would on a device or simulator. Use this mode of preview to test control logic, animations, and text entry as well as responses to asynchronous code. When you select this mode, a single device preview appears in the canvas. This is the default mode for new previews you display.

Play

### Try out new designs quickly with select mode

In select mode, the preview displays a snapshot of your view so you can interact with your view’s UI elements in the canvas. Selecting a control in the preview highlights the corresponding line of code in the source editor. Double-clicking certain text views, such as `Label`, moves focus to the source editor so you can make changes quickly.

### Control how your previews display with device settings

Use Device settings to control how a preview displays for a specific device. For example, to see how your view looks in Dark Mode, in a landscape right orientation, with extra large text:

1. Select the Device settings option at the bottom of the preview canvas.

2. Click the Color Scheme toggle to on, and select the Dark Appearance option under Color Scheme.

3. Click the Orientation toggle to on, and select the Landscape Right option under the Orientation header.

4. Click the Dynamic Type toggle to on, and drag the Dynamic Type slider to the X Large text setting.

### Test different view configurations

Use variant mode to see how your view appears in different variations for a given configuration. For example, to test how well your view supports accessibility, select Variant mode from the bottom of the preview canvas, and select the Dynamic Type Variants option. Xcode displays your view with different sizes of text.

Preview canvas supports the following variations:

Color Scheme Variants

Displays a light and dark preview of your view.

Orientation Variants

Displays your view in all the different portrait and landscape orientations.

Dynamic Type Variants

Displays your view in all the accessibility text sizes for your app.

### Preview on a specific device

To see how your view displays on a specific device, select the Preview destination picker option, and then select the device you want your preview to display. When you do, Xcode displays a preview of your view on that device.

### Capture specific previews in code

In addition to the preview options Xcode provides, you can also customize and configure previews you want to reuse programmatically in code.

For example, you can add a name to more easily track what each preview displays. When you pass the name of your preview as a string into the preview macro, the name appears in the title of the preview in the preview canvas.

// A preview with an assigned name.
#Preview("2x2 Grid Portrait") {
Content()
}

You can also control how your preview displays by passing one or more configuration traits as a variadic argument list into the preview macro. For example, to display your view in the landscape left orientation, pass the `landscapeLeft` type property into the `init(_:traits:body:)` preview initializer to tell Xcode which orientation to display.

// A SwiftUI preview with name and orientation.
#Preview("2x2 grid", traits: .landscapeLeft) {
CollageView(layout: .twoByTwoGrid)
}

// A UIKit preview with name and orientation.
#Preview("Camera setting sunning day", traits: .landscapeLeft) {
let viewController = CameraViewController()
if let image = UIImage(systemName: "sun.max.fill") {
viewController.lastImage = image
}
return viewController
}

// An AppKit preview with name and orientation.
#Preview("Camera setting sunning day", traits: .landscapeLeft) {
let viewController = CameraViewController()
viewController.lastImage = NSImage(symbolName: "sun.max.fill", variableValue: 0.0)
return viewController
}

### Use inline dynamic properties with Previewable

When a view depends on a `Binding` property wrapper, you can create a functional binding for that property and pass it into your preview using the `Previewable()` macro. This macro works on any variable conforming to the `DynamicProperty` protocol.

struct PlayButton: View {
@Binding var isPlaying: Bool

var body: some View {
Button(action: {
self.isPlaying.toggle()
}) {
Image(systemName: isPlaying ? "pause.circle" : "play.circle")
.resizable()
.scaledToFit()
.frame(maxWidth: 80)
}
}
}

#Preview {
// Tag the dynamic property with `Previewable`.
@Previewable @State var isPlaying = true

// Pass it into your view.
PlayButton(isPlaying: $isPlaying)
}

Tagging a dynamic property with the `Previewable` macro gets rid of the need to create wrapper views in previews.

### Make complex objects reusable with a preview modifier

To avoid recreating expensive objects for every preview that needs them, in SwiftUI you can create these objects once with the `PreviewModifier` and then pass the preview modifier into your preview using the `Preview(_:traits:_:body:)` macro.

Expensive objects — such as objects that make network calls, perform disk access, or just take considerable time and effort to setup — can make your previews take longer to load. By creating these expensive objects once, and sharing them across all your previews, you make your previews more efficient.

For example, if you have an app with an expensive `Observable()` object:

@Observable
class AppState {
// An expensive, complex, bulky object.
var expensiveObject = "Some expensive object"
}

@main
struct MyApp: App {
@State private var appState = AppState()

var body: some Scene {
WindowGroup {
ComplexView()
.environment(appState)
}
}
}

You reuse that expensive object across multiple views in your app:

struct ComplexView: View {
@Environment(AppState.self) var appState

var body: some View {
Text("\(appState.expensiveObject)")
}
}

For every view you want to preview, you recreate and pass in that expensive object:

#Preview {
ComplexView()
// Potentially expensive if `AppState` is large or complex.
.environment(AppState())
}

Instead, define the expensive object once and share it across multiple previews using the `PreviewModifier` protocol.

1. Define a structure conforming to the `PreviewModifier` protocol.

2. Implement the static `makeSharedContext()` function returning the object with the expensive state.

3. Inject that shared context into the view you want to preview using the `body(content:context:)` function.

4. Add the modifier to the preview using the `Preview(_:traits:_:body:)` macro.

// Create a struct conforming to the PreviewModifier protocol.
struct SampleData: PreviewModifier {

// Define the object to share and return it as a shared context.

let appState = AppState()
appState.expensiveObject = "An expensive object to reuse in previews"
return appState
}

// Inject the object into the view to preview.
content
.environment(context)
}
}

// Add the modifier to the preview.
#Preview(traits: .modifier(SampleData())) {
ComplexView()
}

### Pass views only the data they need

When creating views, pass in only the data the view needs to display. Avoid passing in objects that fetch data; objects make setting up a view’s preview more complicated and less performant.

Instead, create views with the minimal amount of data they need, favoring simpler, immutable data types. Creating views this way makes testing and previewing your views easier and helps them perform better.

The following example shows how simple data types, like `String` and `enum`, can be used to preview a view in various ways using the preview macro.

struct CollaboratorCell: View {
// Construct your view with only the data it needs.
let name: String
let image: Image?
let connectionStatus: ConnectionStatus

enum ConnectionStatus {
case online
case offline
}

// ...
}

#Preview("Supported cell combinations", traits: .sizeThatFitsLayout) {
let image = Image(systemName: "person.circle")
return VStack {
// Then test each scenario in your preview macro.
CollaboratorCell(name: "Tom Clark", image: nil, connectionStatus: .offline)
CollaboratorCell(name: "Tom Clark", image: image, connectionStatus: .offline)
CollaboratorCell(name: "Tom Clark", image: nil, connectionStatus: .online)
CollaboratorCell(name: "Tom Clark", image: image, connectionStatus: .online)
CollaboratorCell(name: "Tom Long Middle Clark", image: nil, connectionStatus: .offline)
CollaboratorCell(name: "Tom Long Middle Clark", image: image, connectionStatus: .online)
}
}

class CollaboratorCell: UIView {
// Construct your view with only the data it needs.
let name: String
let image: UIImage?
let connectionStatus: ConnectionStatus

#Preview("Supported cell combinations", traits: .sizeThatFitsLayout) {
let image = UIImage(systemName: "person.circle")

// Then test each scenario in your preview macro.
let cell1 = CollaboratorCell(name: "Tom Clark", image: nil, connectionStatus: .offline)
let cell2 = CollaboratorCell(name: "Tom Clark", image: image, connectionStatus: .offline)
let cell3 = CollaboratorCell(name: "Tom Clark", image: nil, connectionStatus: .online)
let cell4 = CollaboratorCell(name: "Tom Clark", image: image, connectionStatus: .online)
let cell5 = CollaboratorCell(name: "Tom Long Middle Clark", image: nil, connectionStatus: .offline)
let cell6 = CollaboratorCell(name: "Tom Long Middle Clark", image: image, connectionStatus: .online)

// Create a test harness to display.
let stackView = UIStackView()
stackView.axis = .vertical
stackView.spacing = 8.0

stackView.addArrangedSubview(cell1)
stackView.addArrangedSubview(cell2)
stackView.addArrangedSubview(cell3)
stackView.addArrangedSubview(cell4)
stackView.addArrangedSubview(cell5)
stackView.addArrangedSubview(cell6)

return stackView
}

class CollaboratorCell: NSView {
// Construct your view with only the data it needs.
let name: String
let image: NSImage?
let connectionStatus: ConnectionStatus

#Preview("Supported cell combinations", traits: .sizeThatFitsLayout) {
let image = NSImage(systemSymbolName: "person.circle", accessibilityDescription: "A person symbol inside the outline of a circle.")

// Create a test harness to display.
let stackView = NSStackView()
stackView.orientation = .vertical
stackView.spacing = 8.0

### Reduce your app size with development assets

To access resources in your previews, without shipping them in the final version of your app, use development assets. Development assets give you access to resources such as images, video, JSON data, and code files in your previews and Simulator, without increasing the overall size of your app.

Add items to the Development Assets of a project target as follows:

1. Select the project folder in the Project navigator.

2. Select the target you want to add the development assets to.

3. In the General tab, scroll down to Development Assets.

4. In the lower-left corner, click the Add items button (+).

5. In the dialog that appears, select the items that you want to add and click Add.

## See Also

### Essentials

Creating an Xcode project for an app

Start developing your app by creating an Xcode project from a template.

Creating your app’s interface with SwiftUI

Develop apps in SwiftUI with an interactive preview that keeps the code and layout in sync.

Building and running an app

Compile your source files and assemble an app bundle to run on a device or simulator.

Xcode updates

Learn about important changes to Xcode.

---

# https://developer.apple.com/documentation/xcode/building-and-running-an-app

- Xcode
- Building and running an app

Article

# Building and running an app

Compile your source files and assemble an app bundle to run on a device or simulator.

## Overview

During development, you build and run an app many times to test new features and eliminate bugs. Each time you build, Xcode analyzes your app’s source files to determine which ones it must recompile. Xcode also identifies any other tasks that it must perform, such as running custom scripts. Depending on the state of your project, Xcode performs either a complete rebuild of everything, or an incremental build of only the changed items.

When you run an app after a successful build, Xcode launches the app on the selected device. Mac apps run on the same device as your Xcode installation. iOS, iPadOS, tvOS, visionOS, and watchOS apps run either on a connected device or in a simulated environment on your Mac.

### Configure a target for your app

Xcode determines how to build apps and other products from your project’s target information. A _target_ contains the tasks required to create an executable, and the settings to use to build it. For example, an app target might contain the list of files to compile, the resources to copy into the app’s bundle, and other steps needed to configure the app.

When you create a new project, the template you choose includes a default target, which Xcode configures using the information you provide. You can add new targets to your project at any time to create additional products. For information about how to configure new targets, see Configuring a new target in your project.

### Select a scheme for your target

A _build scheme_ is a collection of settings that specify which targets to build, the build configuration to use, and the executable environment for the running product. Xcode creates schemes for most targets automatically, and you can create additional schemes to customize the build and execution options. For example, you might create a new scheme to pass additional launch arguments to your app.

To build an app, or any other target, select a scheme that contains the target. Xcode displays the selected scheme in the toolbar of your project window. To change the selected scheme, click the scheme name and choose a new one from the pop-up menu.

For information about how to configure your project’s schemes, see Customizing the build schemes for a project.

### Tell Xcode where to run your app

When you select a scheme to build, you also select a destination where you run the built products. Each scheme contains a list of real or simulated devices that represent the available destinations. To select a destination, click the destination name, which is next to the scheme name in the toolbar. Select an appropriate device from the pop-up menu.

Choose a destination that gives you the capabilities you need. For Mac products, select My Mac. For other platforms, if the app doesn’t require actual hardware, you can choose a simulator to test features quickly on your Mac. If your app requires actual hardware, or you’re ready to see how your app behaves in real conditions, select a real device. For information on configuring new simulated devices or connecting to a real device, see Running your app in Simulator or on a device.

### Build, run, and debug your app

A scheme’s build configuration determines how Xcode launches the product. For a scheme that builds an app, Xcode launches the app itself. For other products, you specify the app to launch using the scheme editor. You can also use the scheme editor to specify launch arguments, runtime data, and debugging parameters.

## See Also

### Essentials

Creating an Xcode project for an app

Start developing your app by creating an Xcode project from a template.

Creating your app’s interface with SwiftUI

Develop apps in SwiftUI with an interactive preview that keeps the code and layout in sync.

Previewing your app’s interface in Xcode

Iterate designs quickly and preview your apps’ displays across different Apple devices.

Xcode updates

Learn about important changes to Xcode.

---

# https://developer.apple.com/documentation/xcode/projects-and-workspaces

Collection

- Xcode
- Projects and workspaces

# Projects and workspaces

Manage the code and resources you use to build apps, libraries, and other software for Apple platforms.

## Topics

### Files and workspaces

Managing files and folders in your Xcode project

Add new or existing files to your project, and use groups to organize the files and folders in the Project navigator.

Managing multiple projects and their dependencies

Manage related projects in one place using a workspace, or configure build-time dependencies between different Xcode projects using cross-project references.

### Navigation

Configuring the Xcode project window

Configure the appearance of Xcode project windows by showing and hiding editors, inspectors, and navigation content.

Finding and replacing content in a project

Search some or all of your project for text strings or symbol names, and perform advanced searches using regular expressions.

### Project configuration

Managing your app’s information property list values

Customize the information property list values for your app using Xcode.

Adding package dependencies to your app

Integrate package dependencies to share code between projects, or leverage code from other developers.

Creating a Mac version of your iPad app

Bring your iPad app to macOS with Mac Catalyst.

Setting up a watchOS project

Create a new watchOS project or add a watch target to an existing iOS project.

Embedding a command-line tool in a sandboxed app

Add a command-line tool to a sandboxed app’s Xcode project so the resulting app can run it as a helper tool.

### Associated domains and universal links

Use universal links to link directly to content within your app and share data securely.

## See Also

### Xcode IDE

Back up your files, collaborate with others, and tag your releases with source control support in Xcode.

Enable services that Apple provides, such as In-App Purchase, Push Notifications, Apple Pay, iCloud, and many others.

Compile your code into a binary format, and customize your project settings to build your code.

---

# https://developer.apple.com/documentation/xcode/source-control-management

Collection

- Xcode
- Source control management

# Source control management

Back up your files, collaborate with others, and tag your releases with source control support in Xcode.

## Overview

_Source control_ is the practice of tracking and managing changes to your code. Manage your Xcode project with source control to keep a rich history of the changes you make, and collaborate on code faster and more effectively.

Xcode simplifies source control management with its built-in support for Git. You create a Git _source control repository_ that represents your project, and track the changes you make to your project through _commits_. When your code is

ready, your collaborators can review your changes, suggest alternative approaches, and accept your changes by approving and merging your new code into the main codebase.

## Topics

### Essentials

Configuring your Xcode project to use source control

Sync code changes between team members and development computers by setting up your Xcode project to use Git source control.

Tracking code changes in a source control repository

Create a history of incremental code changes to your Xcode project’s source control repository with Git commits.

### Git

Organizing your code changes with source control

Streamline your collaboration workflow by managing your Xcode project’s features and releases with Git branches and tags.

Combining code changes in a source control repository

Integrate code changes from multiple sources and resolve conflicts between different versions of code using source control tools in Xcode.

Configuring source control preferences in Xcode

Customize the default Xcode Settings for connecting to Git repositories, applying code changes, and more options for configuring source control.

## See Also

### Xcode IDE

Manage the code and resources you use to build apps, libraries, and other software for Apple platforms.

Enable services that Apple provides, such as In-App Purchase, Push Notifications, Apple Pay, iCloud, and many others.

Compile your code into a binary format, and customize your project settings to build your code.

---

# https://developer.apple.com/documentation/xcode/capabilities

Collection

- Xcode
- Capabilities

# Capabilities

Enable services that Apple provides, such as In-App Purchase, Push Notifications, Apple Pay, iCloud, and many others.

## Overview

Capabilities simplify the configuration process for many of Apple’s services, some of which require you to configure specific `Entitlements` or change your app’s provisioning profile. When you add a capability to an app or other target in your project, Xcode automatically configures that target to use the corresponding service. For example, Xcode might add a required entitlement to a new entitlements file and configure the project to use those entitlements. When Xcode needs you to provide additional information, it presents a simplified UI for you to specify that information.

Xcode automatically manages your target’s entitlements file based on the capabilities you add to that target. If you need to edit the file manually, see Editing property list files.

## Topics

### Essentials

Adding capabilities to your app

Configure your target to include and customize capabilities that provide access to Apple’s app services.

### App execution

Configuring background execution modes

Indicate the background services your app requires to continue executing in the background in iOS, iPadOS, tvOS, visionOS, and watchOS.

Configuring custom fonts

Register your app as a provider or consumer of systemwide custom fonts.

Configuring game controllers

Enhance gameplay input by enabling the discovery, configuration, and use of physical game controllers.

Configuring Maps support

Register your iOS routing app to provide point-to-point directions to Maps and other apps.

Configuring Siri support

Enable your app and its Intents extension to resolve, confirm, and handle user-driven Siri requests for your app’s services.

### Commerce

Configuring Apple Pay support

Process payments in your app using the payment information the user stores on their device.

Configuring Sign in with Apple support

Allow users to create an account and sign in to your app with their Apple Account.

Configuring Wallet support

Access the user’s Wallet to add, update, and display your app’s passes.

### Data management

Configuring an associated domain

Create a two-way association between your app and your website to enable universal links, Handoff, App Clips, and shared web credentials.

Configuring app groups

Enable communication and data sharing between multiple installed apps created by the same developer.

Configuring iCloud services

Share user or app data among multiple instances of your app running on different devices.

### Network

Configuring network extensions

Customize the various capabilities of your app’s networking stack, such as proxying DNS queries or creating packet tunnels.

Registering your app with APNs

Communicate with Apple Push Notification service (APNs) and receive a unique device token that identifies your app.

Configuring Group Activities

Leverage FaceTime infrastructure to create coordinated experiences users can share.

Configuring media device discovery

Add a third-party media device or protocol as a streaming option in the same system menu as AirPlay.

### Security

Configuring the hardened runtime

Protect the runtime integrity of your macOS app by restricting access to sensitive resources and preventing common exploits.

Configuring the macOS App Sandbox

Protect system resources and user data from compromised apps by restricting access to the file system, network connections, and more.

Configuring keychain sharing

Share keychain items between multiple apps belonging to the same developer.

Protecting local app data using containers on macOS

Secure your app’s local storage data from unauthorized access and modification.

Accessing app group containers in your existing macOS app

Ensure your app has app group container entitlements and macOS can authorize them.

### User data

Configuring HealthKit access

Read and write health and activity data in the Health app.

Configuring HomeKit access

Discover compatible accessories and communicate with configured accessories and services to perform actions.

## See Also

### Xcode IDE

Manage the code and resources you use to build apps, libraries, and other software for Apple platforms.

Back up your files, collaborate with others, and tag your releases with source control support in Xcode.

Compile your code into a binary format, and customize your project settings to build your code.

---

# https://developer.apple.com/documentation/xcode/build-system

Collection

- Xcode
- Build system

# Build system

Compile your code into a binary format, and customize your project settings to build your code.

## Overview

The Xcode build system manages the tools that transform your code and resource files into a finished app. When you tell Xcode to build your project, the build system analyzes your files and uses your project settings to assemble the set of tasks to perform. Use your project settings to modify the build process and add tasks that you need to complete your builds.

## Topics

### Essentials

Configuring a new target in your project

Configure your project to build a new product, and add the code and resources the product requires.

Configuring a multiplatform app

Share project settings and code across platforms in a single app target.

### Build settings

Configuring the build settings of a target

Specify the options you use to compile, link, and produce a product from a target, and identify settings inherited from your project or the system.

Adding a build configuration file to your project

Specify your project’s build settings in plain-text files, and supply different settings for debug and release builds.

Build settings reference

A detailed list of individual Xcode build settings that control or change the way a target is built.

Identifying and addressing framework module issues

Detect and fix common problems found in framework modules with the module verifier.

Understanding build product layout changes in Xcode

### Build customization

Customizing the build schemes for a project

Specify which targets to build, and customize the settings Xcode uses to build, run, test, and profile those targets.

Customizing the build phases of a target

Specify the tasks to perform during a build, including the source files to compile, the scripts to run, and the resources to include in the final product.

Creating build rules for custom file types

Tell Xcode how to build your project’s custom file types, and provide dependency information to optimize the build process for each file.

Running custom scripts during a build

Execute custom shell scripts during the build process, and run tools or other commands that your project requires.

Running code on a specific platform or OS version

Add conditional compilation markers around code that requires a particular family of devices or minimum operating system version to run.

### Performance

Configuring your project to use mergeable libraries

Use mergeable dynamic libraries to get app launch times similar to static linking in release builds, without losing dynamically linked build times in debug builds.

Improving the speed of incremental builds

Tell the Xcode build system about your project’s target-related dependencies, and reduce the compiler workload during each build cycle.

Improving build efficiency with good coding practices

Shorten compile times by reducing the number of symbols your code exports and by giving the compiler the explicit information it needs.

Building your project with explicit module dependencies

Reduce compile times by eliminating unnecessary module variants using the Xcode build system.

### Security and privacy

Verifying the origin of your XCFrameworks

Discover who signed a framework, and take action when that changes.

Enabling enhanced security for your app

Detect out-of-bounds memory access, use of freed memory, and other potential vulnerabilities.

Creating enhanced security helper extensions

Reduce opportunities for an attacker to target your app through its extensions.

Adopting type-aware memory allocation

Reduce the opportunities to treat pointers as data in your code.

Conforming to Mach IPC security restrictions

Avoid crashes and potentially insecure situations associated with Mach messages.

## See Also

### Xcode IDE

Manage the code and resources you use to build apps, libraries, and other software for Apple platforms.

Back up your files, collaborate with others, and tag your releases with source control support in Xcode.

Enable services that Apple provides, such as In-App Purchase, Push Notifications, Apple Pay, iCloud, and many others.

---

# https://developer.apple.com/documentation/xcode/source-editor

Collection

- Xcode
- Source Editor

# Source Editor

Edit your source files, locate issues, and make necessary changes using the Source Editor.

## Topics

### Source file creation, organization, and editing

Editing source files in Xcode

Edit source files in Xcode and add Quick Help comments to improve your project’s maintainability.

Running code snippets using the playground macro

Add playgrounds to your code that run and display results in the canvas.

### Writing code with intelligence in Xcode

Writing code with intelligence in Xcode

Generate code, fix bugs fast, and learn as you go with intelligence built directly into Xcode.

### Issue detection

Fixing issues in your code as you type

Minimize typing-related errors using code completion, and let Xcode fix common mistakes for you.

### Code search and refactoring

Finding and refactoring code

Search your code for text, patterns, and symbols that you can refactor quickly and easily.

## See Also

### Code

Organize code and resources in bundles and frameworks.

Create reusable code, organize it in a lightweight way, and share it across Xcode projects and with other developers.

---

# https://developer.apple.com/documentation/xcode/bundles-and-frameworks



---

# https://developer.apple.com/documentation/xcode/swift-packages

Collection

- Xcode
- Swift packages

# Swift packages

Create reusable code, organize it in a lightweight way, and share it across Xcode projects and with other developers.

## Overview

Swift packages are reusable components of Swift, Objective-C, Objective-C++, C, or C++ code that developers can use in their projects. They bundle source files, binaries, and resources in a way that’s easy to use in your app’s project.

Xcode supports creating and publishing Swift packages, as well as adding, removing, and managing package dependencies. Its support for Swift packages is built on top of the open source Swift Package Manager project.

To learn more about the API you use in your package manifest, see `Package`. To learn more about the Swift Package Manager, see Swift.org and the open source Swift Package Manager repository.

## Topics

### Package dependencies

Adding package dependencies to your app

Integrate package dependencies to share code between projects, or leverage code from other developers.

Identifying binary dependencies

Find out if a package dependency references a binary and verify the binary’s authenticity.

Editing a package dependency as a local package

Override a package dependency and edit its content by adding it as a local package.

### Package creation

Creating a standalone Swift package with Xcode

Bundle executable or shareable code into a standalone Swift package.

Bundling resources with a Swift package

Add resource files to your Swift package and access them in your code.

Localizing package resources

Ensure that your Swift package provides localized resources for many locales.

Distributing binary frameworks as Swift packages

Make binaries available to other developers by creating Swift packages that include one or more XCFrameworks.

Developing a Swift package in tandem with an app

Add your published Swift package as a local package to your app’s project and develop the package and the app in tandem.

Organizing your code with local packages

Simplify maintenance, promote modularity, and encourage reuse by organizing your app’s code into local Swift packages.

PackageDescription

Create reusable code, organize it in a lightweight way, and share it across your projects and with other developers.

### Package distribution

Publishing a Swift package with Xcode

Publish your Swift package privately, or share it globally with other developers.

### Continuous integration

Building Swift packages or apps that use them in continuous integration workflows

Build Swift packages with an existing continuous integration setup and prepare apps that consume package dependencies within an existing CI pipeline.

## See Also

### Code

Edit your source files, locate issues, and make necessary changes using the Source Editor.

Organize code and resources in bundles and frameworks.

---

# https://developer.apple.com/documentation/xcode/asset-management

Collection

- Xcode
- Asset management

# Asset management

Add app icons, images, strings, data files, machine learning models, and other resources to your projects, and manage how you load them at runtime.

## Overview

Apps rely on many types of assets to create a rich, dynamic, and visually engaging user experience. Xcode provides tools and settings to help you add, organize, and optimize the different asset types your app uses.

Xcode simplifies managing most types of assets with asset catalogs. Use _asset catalogs_ to organize and manage resources such as images, colors, app icons, textures, stickers, and data.

Xcode also provides interactive editors for certain types of assets, like particle effects, that let you experiment, make changes, and see the results immediately.

## Topics

### App icons and launch screen

Creating your app icon using Icon Composer

Use Icon Composer to stylize your app icon for different platforms and appearances.

Configuring your app to use alternate app icons

Add alternate app icons to your app, and let people choose which icon to display.

Configuring your app icon using an asset catalog

Add app icon variations to an asset catalog that represents your app in places such as the App Store, the Home Screen, Settings, and search results.

Specifying your app’s launch screen

Make your iOS app launch experience faster and more responsive by customizing a launch screen.

### Asset catalogs

Managing assets with asset catalogs

Add, organize, and edit sets of assets in your Xcode project using asset catalogs.

### Images

Adding images to your Xcode project

Import images into your project, manage their appearances and variations, and load them at runtime.

Creating custom symbol images for your app

Create, organize, and annotate symbol images using SF Symbols.

### Colors

Specifying your app’s color scheme

Set a global accent color for your app by using asset catalogs.

Supporting Dark Mode in your interface

Update colors, images, and behaviors so that your app adapts automatically when Dark Mode is active.

### Augmented reality assets

Detecting Images in an AR Experience

React to known 2D images in the user’s environment, and use their positions to place AR content.

Scanning and Detecting 3D Objects

Record spatial features of real-world objects, then use the results to find those objects in the user’s environment and trigger AR content.

### Machine learning models

Create ML

Create machine learning models for use in your app.

### Particle effects

Creating a SpriteKit particle emitter in Xcode

Add particle effects to your app by creating repeatable particles.

## See Also

### Interface

Expand the market for your app by supporting multiple languages and regions.

Accessibility Inspector

Reveal how your app represents itself to people using accessibility features.

---

# https://developer.apple.com/documentation/xcode/writing-documentation

Collection

- Xcode
- Writing documentation

# Writing documentation

Produce rich and engaging developer documentation for your apps, frameworks, and packages.

## Overview

The DocC documentation compiler converts Markdown-based text into rich documentation for Swift and Objective-C frameworks, packages, and apps to display in Xcode’s documentation window or host on a website.

DocC syntax — called documentation markup — is a custom variant of Markdown that adds functionality for developer documentation-specific features, like cross-symbol linking, term-definition lists, code listings, and asides. You add documentation markup to your source code, use Xcode’s Build Documentation feature to compile it with DocC, and produce reference documentation for your APIs. You can also use documentation markup, along with a set of directives that instruct how DocC generates your content, to offer step-by-step tutorials that teach developers to use your APIs through interactive coding exercises.

For a deeper understanding of DocC and guidance on its usage, please consult the DocC documentation available at DocC Swift.org.

## Topics

### Essentials

Documenting apps, frameworks, and packages

Create developer documentation from in-source comments, add articles with code snippets, and add tutorials for a guided learning experience.

### Documentation content

Writing symbol documentation in your source files

Add reference documentation to your symbols that explains how to use them.

Adding supplemental content to a documentation catalog

Include articles and extension files to extend your source documentation comments or provide supporting conceptual content.

SlothCreator: Building DocC documentation in Xcode

Build DocC documentation for a Swift package that contains a DocC Catalog.

### Structure and formatting

Adding structure to your documentation pages

Make symbols easier to find by arranging them into groups and collections.

### Distribution

Distributing documentation to other developers

Share your documentation directly with Xcode users or host it on a web server.

---

# https://developer.apple.com/documentation/xcode/devices-and-simulator

Collection

- Xcode
- Devices and Simulator

# Devices and Simulator

Configure and manage devices connected to your Mac or devices in Simulator and use them to run your app.

## Overview

As you build your app, run it on real or simulated devices to test new features and evaluate your progress.

Run your app on a real device to confirm that you can interact with it as you intend, and that your app’s performance on a real device meets your expectations. To run your app on a real device, first enable Developer Mode on your iOS, iPadOS, visionOS, or watchOS device, then connect your device to your Mac and run your app from Xcode.

Run your app on Simulator to quickly evaluate new features and bug fixes, and to see how your user interface works on devices that you don’t have access to. Use Simulator’s features to streamline your testing, but be aware that there are some scenarios that require testing on hardware instead of Simulator.

## Topics

### Essentials

Enabling Developer Mode on a device

Grant or deny permission for locally installed apps to run on iOS, iPadOS, visionOS, and watchOS devices.

Running your app in Simulator or on a device

Launch your app in a simulated iOS, iPadOS, tvOS, visionOS, or watchOS device, or on a device connected to a Mac.

### Simulator management

Downloading and installing additional Xcode components

Add more Simulator runtimes, optional features, and support for additional platforms.

Installing your app in many Simulator platforms and versions

Set up your app in multiple Simulator platforms and versions without the build-and-run cycle.

### Simulator interactions

Interacting with your app in the iOS and iPadOS simulator

Use your Mac to control interactions with your iOS and iPadOS apps in Simulator.

Interacting with your app in the tvOS simulator

Use your Mac to control interactions with your tvOS apps in Simulator.

Interacting with your app in the watchOS simulator

Use your Mac to control interactions with your watchOS apps in Simulator.

Interacting with your app in the visionOS simulator

Use your Mac to navigate spaces and control interactions with your visionOS apps in Simulator.

Configuring Simulator for your working environment

Adjust Simulator settings for window or screen size, light or dark appearance, and audio settings, and restart or reset a simulated device.

Simulating an external display or CarPlay

Test how your app handles an external display or CarPlay from Simulator.

Capturing screenshots and videos from Simulator

Record and share test results, or prepare for App Store distribution with screenshots and videos of your app from Simulator.

### Simulator testing considerations

Testing in Simulator versus testing on hardware devices

Review the differences between Simulator and hardware devices to determine which you should choose to test a scenario.

Sharing data with Simulator

Enter text directly in Simulator, or share location data, images, web addresses, files, or data from the clipboard with Simulator.

Testing complex hardware device scenarios in Simulator

Test hardware device-specific scenarios, such as Face ID or Touch ID authentication, fall detection, getting a memory warning, or location changes.

Identifying graphics and animations issues in Simulator

Reveal performance and display issues in your views with color overlays, and slow down animations to debug and improve them.

### Simulator troubleshooting

Troubleshooting Simulator launch or animation issues

Diagnose and resolve issues launching a simulator, or with slow scrolling or animations in Simulator.

## See Also

### Tuning and debugging

Identify and address issues in your app using the Xcode debugger, Xcode Organizer, Metal debugger, and Instruments.

Measure, investigate, and address the use of system resources and issues impacting performance using Instruments and Xcode Organizer.

Develop and run tests to detect logic failures, UI problems, and performance regressions.

---

# https://developer.apple.com/documentation/xcode/debugging



---

# https://developer.apple.com/documentation/xcode/performance-and-metrics



---

# https://developer.apple.com/documentation/xcode/testing



---

# https://developer.apple.com/documentation/xcode/distribution

Collection

- Xcode
- Distribution

# Distribution

Prepare your app and share it with your team, beta testers, and customers.

## Topics

### Essentials

Preparing your app for distribution

Configure the information property list and add icons before you distribute your app.

### Distribution and release

Distributing your app for beta testing and releases

Release your app to beta testers and users.

Distributing your app to registered devices

Register devices in your developer account and deploy your app to them for testing.

Packaging Mac software for distribution

Build a zip archive, disk image, or installer package for distributing your Mac software.

### Code signing

Creating distribution-signed code for macOS

Sign Mac code for distribution using either Xcode or command-line tools.

Using the latest code signature format

Update legacy app code signatures so your app runs on current OS releases.

Notarizing macOS software before distribution

Give users even more confidence in your macOS software by submitting it to Apple for notarization.

Signing a daemon with a restricted entitlement

Wrap a daemon in an app-like structure to use an entitlement thatʼs authorized by a provisioning profile.

Synchronizing code signing identities with your developer account

Ensure you and other team members can sign your organization’s code and installer packages in Xcode.

TN3125: Inside Code Signing: Provisioning Profiles

Learn how provisioning profiles enable third-party code to run on Apple platforms.

### Testing

Testing a release build

Run your app in simulated user environments to discover and identify deployment errors.

Testing a beta OS

Manage unintended differences in your app by testing beta operating-system (OS) releases.

### Feedback

Viewing and responding to feedback from beta testers

Follow up on feedback from beta testers using the Feedback organizer.

## See Also

### Distribution and continuous integration

Automatically build, test, and distribute your apps with Xcode Cloud to verify changes and create high-quality apps.

---

# https://developer.apple.com/documentation/xcode/xcode-cloud



---

# https://developer.apple.com/documentation/xcode/application-binary-interfaces



---

# https://developer.apple.com/documentation/xcode/creating-an-xcode-project-for-an-app)



---

# https://developer.apple.com/documentation/xcode/creating-your-app-s-interface-with-swiftui)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/previewing-your-apps-interface-in-xcode)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/building-and-running-an-app)



---

# https://developer.apple.com/documentation/xcode/projects-and-workspaces)



---

# https://developer.apple.com/documentation/xcode/source-control-management)



---

# https://developer.apple.com/documentation/xcode/capabilities)



---

# https://developer.apple.com/documentation/xcode/build-system)



---

# https://developer.apple.com/documentation/xcode/source-editor)



---

# https://developer.apple.com/documentation/xcode/bundles-and-frameworks)



---

# https://developer.apple.com/documentation/xcode/swift-packages)



---

# https://developer.apple.com/documentation/xcode/asset-management)



---

# https://developer.apple.com/documentation/xcode/writing-documentation)



---

# https://developer.apple.com/documentation/xcode/devices-and-simulator)



---

# https://developer.apple.com/documentation/xcode/debugging)



---

# https://developer.apple.com/documentation/xcode/performance-and-metrics)



---

# https://developer.apple.com/documentation/xcode/testing)



---

# https://developer.apple.com/documentation/xcode/distribution)



---

# https://developer.apple.com/documentation/xcode/xcode-cloud)



---

# https://developer.apple.com/documentation/xcode/application-binary-interfaces)



---

# https://developer.apple.com/documentation/xcode/preparing-your-interface-for-localization

- Xcode
- Localization
- Preparing your interface for localization

Article

# Preparing your interface for localization

Find text in your app that needs translation and verify that your interface adapts to translated text.

## Overview

Before you localize your app, use Xcode to identify nonlocalized strings in your interface and to verify whether your interface adjusts to the characteristics of localized strings.

### Find nonlocalized strings

When you run your app, the nonlocalized strings appear in all caps.

### Run your app using pseudolanguages

| Pseudolanguage | Description |
| --- | --- |
| Double-Length Pseudolanguage | Doubles the length of localizable strings to test whether views adjust their size and position. |
| Right-to-Left Pseudolanguage | Simulates a right-to-left writing direction to test whether views flip accordingly. |
| Emotional Pseudolanguage | Simulates emojis in a string. |
| Accented Pseudolanguage | Adds accents to localizable strings to test whether views adjust to languages that have high and low ascenders. |
| Bounded String Pseudolanguage | Wraps strings to identify places where localized strings may appear truncated. |
| Right-to-Left Pseudolanguage With Right-to-Left Strings | Simulates a right-to-left writing direction, using right-to-left strings. |

## See Also

### Strings and text

Preparing your app’s text for translation

Make your app’s text translatable by leveraging the localization APIs in the Foundation framework.

Preparing dates, currencies, and numbers for translation

Ensure that dates, currencies, and numbers display correctly across multiple languages and locales by using formatters.

---

# https://developer.apple.com/documentation/xcode/preparing-your-apps-text-for-translation

- Xcode
- Localization
- Preparing your app’s text for translation

Article

# Preparing your app’s text for translation

Make your app’s text translatable by leveraging the localization APIs in the Foundation framework.

## Overview

Before the system can translate your app’s text, you need to prepare your app’s strings for translation by creating localizable versions of these strings using the `String(localized:)` and `AttributedString(localized:)` APIs found in the Foundation framework.

Localizable strings are user-facing strings you present to people at runtime. These strings signal to the system that they should be considered for translation, and thus added to your string catalog file. You then export those strings from your string catalog and send them to a localizer for translation or you edit the string catalog yourself and enter the translations directly there.

### Make your string literals localizable

String literals — strings created only with double quotes — aren’t localizable by themselves.

// An example of a nonlocalizable string literal.
let name = "Lightbulbs"

There’s no way for the system to know whether the string literal is a user-facing string in need of translation or simply a print statement there for debugging.

To make a string localizable, create a `String` object using the `init(localized:)` initializer.

// Localizable string with the same key and value.
String(localized: "Lightbulbs")

This initializer takes the string literal passed in as a `LocalizedStringResource` and assigns it to a key equal to the value of the string literal itself. Your string catalog uses this key to look up translations based on the language and locale of the user’s device, and then returns the translated value associated with that key. With this initializer, the key and underlying string value are the same. This means you can use the text of your development language as the keys for your translations.

To create localizable strings with different keys and values, use the `init(localized:defaultValue:options:table:bundle:locale:comment:)` initializer. This initializer assigns the first string literal as the string’s key and makes the second parameter the default string value.

// Localizable string with a different key and value.
String(localized: "LIGHTING_KEY", defaultValue: "Lightbulbs")

If someone else translates your strings, consider adding helpful comments to your string initializers to provide additional context about how and when the string displays.

// Localizable string with a comment providing additional context.
String(localized: "Lightbulbs", comment: "Label: The icon name displayed on the control screen")

If the number of translations in your string catalog grows too large, consider breaking the default catalog up into several smaller catalogs. Then specify which catalog a translation comes from using the `table` parameter in the `init(localized:defaultValue:options:table:bundle:locale:comment:)` initializer.

// Localizable string referenced from the Greetings.xcstrings string catalog file.
String(localized: "Welcome", table: "Greetings")

Use `String(localized:)` and `AttributedString(localized:)` initializers to initialize UIKit and AppKit controls as well as general Swift structures containing variables of type `String`.

struct Accessory {
// Nonlocalizable string literal.
let name: String
}
// Made localizable using the String(localized:) initializer.
Accessory(name: String(localized: "Welcome"))

// Localizable string passed into a UIKit control.
let label = UILabel()
label.text = String(localized: "Welcome")

// Localizable string passed into a AppKit UI control.
let textField = NSTextField()
textField.stringValue = String(localized: "Welcome")

### Localize text automatically in SwiftUI

SwiftUI views that accept string literals of type `LocalizedStringKey` are automatically considered localizable. For example, the following strings are all automatically considered localizable in SwiftUI:

// Text made localizable with LocalizedStringKey.

Label("Thanks for shopping with us!", systemImage: "bag")
.font(.title)
HStack {
Button("Clear Cart") {}
Button("Checkout") {}
}

To help translators better understand the context for a localized string, use the `init(_:tableName:bundle:comment:)` initializer of your `Text` view and provide a comment with additional details.

// Provide additional localizable data with a `TextView`.

Stepper {
Text("Increase or decrease the item quantity", comment: "Lets the shopper increase or decrease the quantity for an item in their shopping cart")
} onIncrement: {
// ...
} onDecrement: {
// ...
}

### Pass localizable strings with a localizable type

When defining or passing localizable text in your views, use the recommended type for passing strings in Swift `LocalizedStringResource`.

// Localizable strings in SwiftUI.

struct CardView: View {
let title: LocalizedStringResource
let subtitle: LocalizedStringResource

var body: some View {
ZStack {
Rectangle()
VStack {
Text(title)
Text(subtitle)
}
.padding()
}
}
}

CardView(title: "Recent Purchases", subtitle: "Items you've ordered in the past week")

This type not only supports initialization using string literals, it also supports adding a comment, table name, or default value that’s different from the string key.

`LocalizedStringResource` also works for strings defined in general Swift code. For example, here’s a structure that defines a title of type `LocalizedStringResource`, which is then instantiated using a string literal and an instance of `LocalizedStringResource`, both localizable.

struct UserAction {
let title: LocalizedStringResource
}

// Localizable text created with a string literal.
let action = UserAction(title: "Order items")

// Localizable text created with a `LocalizedStringResource`.
let actionWithComment = UserAction(title: LocalizedStringResource("Order items", comment: "Action title displayed in button"))

### Define and load localizable strings from within your framework

If you define the strings that you want to localize in another module, framework, or Swift Package, use the `bundle` argument in their definition. For example, say you want to modularize your project and you create a framework called `BirdFinderUtilities`. To look up a localizable string from within that framework:

1. Identify the name of a class within the framework (in this case, `BirdSongs`).

2. Pass that class into an instance of `Bundle` using the `init(for:)` initializer.

3. Use that `Bundle` to look up the localizable string.

// Localizable string within a framework.
String(localized: "Songs", bundle: Bundle(for: (BirdSongs.self)))

// Localizable string within a framework in SwiftUI.
Text("Songs", bundle: Bundle(for: (BirdSongs.self)))

// Localizable string within a framework for a `LocalizedStringResource`.
LocalizedStringResource("Songs", bundle: .forClass(BirdSongs.self), comment: "Headline above the name of the song currently playing.")

## See Also

### Strings and text

Preparing your interface for localization

Find text in your app that needs translation and verify that your interface adapts to translated text.

Preparing dates, currencies, and numbers for translation

Ensure that dates, currencies, and numbers display correctly across multiple languages and locales by using formatters.

---

# https://developer.apple.com/documentation/xcode/preparing-dates-numbers-with-formatters

- Xcode
- Localization
- Preparing dates, currencies, and numbers for translation

Article

# Preparing dates, currencies, and numbers for translation

Ensure that dates, currencies, and numbers display correctly across multiple languages and locales by using formatters.

## Overview

Languages and regions have different formats for presenting dates and numbers. Some languages use the period (.) as a decimal separator, and others use the comma (,). Some place the percent sign before the number when formatting percentages. And many regions display time and date differently, despite being part of the same language.

Instead of trying to account for all these variations yourself, use the formatters built into Foundation to create localizable versions of the dates and numbers you want to present.

### Format dates with predefined styles

To convert a date or number into a localizable string, use the Foundation formatters and styles. These APIs take instances of your date and number objects, and convert them into localizable formatted strings according to the locale of the device your app is running on.

For example, to create a localizable string from a date object, create an instance of the `Date` you want to format and then call the `formatted()` function on the date.

// The current time and date. Example output is for en_US locale.en_US locale.
let date = Date.now

// A default, formatted, localizable date string.
let defaultFormatted = date.formatted()
// "8/25/2023, 12:03 PM"

To vary the date components that display, or display only the time or the date, use the `formatted(date:time:)` method on the `Date` object passing in instances of `Date.FormatStyle.DateStyle` and `Date.FormatStyle.TimeStyle`.

// The date you want to format.
let meetingDate = Date.now

// A formatted date displaying only the date.
let formattedDate = meetingDate.formatted(date: .abbreviated, time: .omitted)
// "Aug 25, 2023"

// A formatted date displaying only the time.
let formattedTime = meetingDate.formatted(date: .omitted, time: .standard)
// "12:03:10 PM"

// A formatted date displaying both the date and time.
let formattedDateAndTime = meetingDate.formatted(date: .complete, time: .complete)
// "Friday, August 25, 2023 at 12:03:10 PM PDT"

### Create your own custom date styles

To format a date to a specific style, create your own custom date style including only the date properties you want to display.

For example, to create a date that includes only the month, day, and year:

1. Create an instance of the `Date` object you want to format.

2. Create a `Date.FormatStyle` structure or use the doc://com.apple.documentation/documentation/foundation/date/formatstyle/3798884-datetime factory variable, and chain together the properties you want to display in successive function calls.

3. Then pass that `Date.FormatStyle` structure as an input into the the `formatted(_:)` function on the date object.

// A date string with specific attributes.
let myDate = Date.now
let formatStyle = Date.FormatStyle.dateTime.year().day().month()
let formatted = date.formatted(formatStyle)
// "Sep 7, 2023"

You can also achieve the same result in one line.

// Same result in one line using the `dateTime` factory variable.
let formatted = Date.now.formatted(.dateTime.year().day().month())
// "Sep 7, 2023"

The order of the fields you pass into the `formatted(_:)` function doesn’t matter. For example, these lines of code produce the same result.

// Same result.
Date.now.formatted(.dateTime.year().month().day().hour().minute().second())
Date.now.formatted(.dateTime.second().minute().hour().day().month().year())
// "Sep 7, 2023 at 10:29:52 AM"

Customize the date styles you want to display by chaining together instances of `Date.FormatStyle.Symbol` structures along with their respective formatting properties.

// A date string for a wide month format.
let formattedWide = date.formatted(.dateTime.year().day().month(.wide))
// "September 7, 2023"

// A date string for a wide weekday.
let formattedWeekday = date.formatted(.dateTime.weekday(.wide))
// "Thursday"

// A date string for the ISO 8601 time and date standard.
let logFormat = date.formatted(.iso8601)
// "2023-09-07T17:25:39Z"

// A date string representing a file format.
let fileNameFormat = date.formatted(.iso8601.year().month().day().dateSeparator(.dash))
// "2023-09-07"

### Format percents and scientific numbers

If you want to create a localizable string for a number (such as `Int`, `Double`, `Decimal`, or `Float`), call `formatted()` or `formatted(_:)` on the number instance, along with the format style to display.

For example, to create a formatted version of an `Int`, call the doc://com.apple.documentation/documentation/swift/int32/formatted() function on the number.

let value = 12345
// A default, formatted, localizable date string.
var formatted = value.formatted()
// "12,345"

To format the number as a percent, call `formatted(_ format:)` on the number you want to display with the `NumberFormatter.Style.percent` number format style. Integers convert directly into percentages using the whole number.

let number = 25
let numberFormatted = number.formatted(.percent)
// "25%"

Fractions convert between the range of 0 and 1.

let fraction = 0.25
let fractionFormatted = fraction.formatted(.percent)
// "25%"

To display a number using scientific notation, call `formatted(_:)` on the number to display using the `scientific`, `notation(_:)`, and doc://com.apple.documentation/documentation/foundation/floatingpointformatstyle/3870086-number format styles.

let scientific = 42e9
let scientificFormatted = scientific.formatted(.number.notation(.scientific))
// "4.2E10"

### Format currencies

To present a number as a localizable currency:

1. Look up the code of the currency you want to display (such as `"CAD"` for Canada).

2. Pass that code as a parameter to the `Decimal.FormatStyle.Currency` format style initializer `init(code:locale:)`.

3. Then call `formatted(_:)` on the number passing in the currency format instance.

// A number formatted in different currencies.
let amount: Decimal = 12345.67
amount.formatted(.currency(code: "JPY"))
// "¥12,346"
amount.formatted(.currency(code: "EUR").presentation(.fullName))
// "12,345.67 euros"
amount.formatted(.currency(code: "USD").grouping(.automatic))
// "$12,345.67"

### Format times as intervals or durations

To display an interval of time as a localizable string:

1. Create two instances of the `Date` object — one representing the start of the time interval and the other the end.

2. Using these two dates, create a `Range` structure setting the upper and lower bounds of the interval.

3. Then call one of the range formatters — such as `formatted()` or `formatted(date:time:)` — passing in the time and date styles you want to display.

// An example of a time interval.

// The current time and date. Example output is for en_US locale.
let now = Date.now

// 5000 seconds from now.
let later = now + TimeInterval(5000)

// The default formatted display for a time interval.
let range = (now..<later).formatted()
// "9/8/2023, 10:44 AM – 12:07 PM"

// A time interval formatted using a predefined date format.
let noDate = (now..<later).formatted(date: .omitted, time: .complete)
// "10:44:39 AM PDT – 12:07:59 PM PDT"

To display time as a duration, you can similarly define a date range and convert that range into a duration.

// An example of a duration.

// Duration from a range of dates.
let timeDuration = (now..<later).formatted(.timeDuration)
// "1:23:20"

let components = (now..<later).formatted(.components(style: .wide))
// "1 hour, 23 minutes, 20 seconds"

let relative = later.formatted(.relative(presentation: .named, unitsStyle: .wide))
// "in 1 hour"

You can also use factory methods like `seconds(_:)` on the `Duration` structure to produce localizable durations from a single number.

For example, to display a given number of seconds as a duration of time:

1. Pass in the number of seconds you want to display to the `seconds(_:)` function of the `Duration` structure.

2. Then call `formatted(_:)`, passing in instances of `Duration.TimeFormatStyle` or `Duration.UnitsFormatStyle` to achieve the format and style you want.

// Duration formatted from a single unit of time.
Duration.seconds(2000).formatted(.time(pattern: .hourMinute))
// "0:33"
Duration.seconds(2000).formatted(.time(pattern: .hourMinuteSecond))
// "0:33:20"
Duration.seconds(2000).formatted(.time(pattern: .minuteSecond))
// "33:20"

### Format items as lists

To create a localizable string in the form of a list, use the `ListFormatStyle` structure along with either the `formatted()` or `formatted(_:)` function to create a string representation of a `Sequence` of items.

// An array of strings formatted into a list.
let sizes = ["small", "medium", "large"]
sizes.formatted(.list(type: .and, width: .narrow))
// "small, medium, large"
sizes.formatted(.list(type: .and, width: .standard))
// "small, medium, and large"
sizes.formatted(.list(type: .and, width: .short))
// "small, medium, & large"

You can also create lists using different formatting styles by calling the doc://com.apple.documentation/documentation/foundation/listformatstyle/3796585-list function along with specific list format styles.

// A list of numbers formatted as percentages.
[25, 50, 75].formatted(.list(memberStyle: .percent, type: .or))
// "25%, 50%, or 75%"

### Convert and display measurement units across different locales

Units of measure vary significantly depending on the locale the format style uses. For example, a distance in feet for the `en_US` locale appears as meters using the French locale `fr_FR`.

To ensure your units of measure convert and display properly across different languages and regions:

1. Use the `Measurement` structure to define a variable representing the unit of measure you want to display.

2. Then call `formatted(_:)` or `formatted(_:)` on the variable to get the display style you want.

For example, say you want to convert and display the following measurements.

// Measurements to display.
let speedLimit = Measurement(value: 110, unit: UnitSpeed.kilometersPerHour)
let distanceToMoon = Measurement(value: 384400, unit: UnitLength.kilometers)
let surfBoardLength = Measurement(value: 8, unit: UnitLength.feet)
let waterTemperature = Measurement(value: 61.2, unit: UnitTemperature.fahrenheit)

To convert them using the default format, call `formatted(_:)` on the measurement object.

// Example output is for en_US locale.

// Default display for a unit of measure.
speedLimit.formatted()
// "68 mph"
distanceToMoon.formatted()
// "238,855 mi"
surfBoardLength.formatted()
// "8 ft"
waterTemperature.formatted()
// "61.2°F"

To customize the output, call the `formatted(_:)` function on the measurement using the doc://com.apple.documentation/documentation/foundation/stringstyle/3870200-measurement factory method to create the format and style you want.

// Custom display options for a unit of measure.
distanceToMoon.formatted(.measurement(width: .wide))
// "238,855 miles"
distanceToMoon.formatted(.measurement(width: .abbreviated))
// "238,855 mi"
distanceToMoon.formatted(.measurement(width: .narrow))
// "238,855mi"

### Format dates and numbers in SwiftUI

To format dates and numbers in SwiftUI, use the `format` initializers on SwiftUI view controls to customize how those strings display.

For example, here is a SwiftUI view that displays three different localizable formats of `Date` using the doc://com.apple.documentation/documentation/swiftui/text/init(\_:format:)-2p5e7 initializer from the `Text` view.

@State private var myDate = Date.now

var body: some View {
VStack {
Text(myDate, format: Date.FormatStyle(date: .numeric, time: .omitted))
Text(myDate, format: Date.FormatStyle(date: .complete, time: .complete))
Text(myDate, format: Date.FormatStyle().hour(.defaultDigits(amPM: .omitted)).minute())
}
}

This example uses the `init(_:value:format:prompt:)` initializer of the `TextField` view to present a number as a percentage for a tip.

@State private var tip = 0.15

var body: some View {
HStack {
Text("Tip")
Spacer()
TextField("Amount", value: $tip, format: .percent)
}
}

## Test the formatters

To test and see how your formatters display in different languages and regions, create an instance of a `Locale` object, passing in the `identifier` of the region you want to test. Then set that locale on the output of your formatted string to see how that string displays in that language and region.

For example, you can see how your localizable strings display in French as follows.

// The locale for France French.
let frenchLocale = Locale(identifier: "fr_FR")

let stages = ["50", "75", "100"]
stages.formatted(.list(type: .and).locale(frenchLocale))
// "50, 75 et 100"
stages.formatted(.list(type: .or).locale(frenchLocale))
// "50, 75 ou 100"

To test your formatters in SwiftUI, set the locale in the environment variable in the `#Preview` section of your code.

struct ContentView: View {
@State private var myDate = Date.now
@Environment(\.locale) var locale

var body: some View {
VStack {
Text(myDate, format: .dateTime.second().minute().hour().day().month().year().locale(locale))
}
}
}

#Preview {
Group {
ContentView()
.environment(\.locale, Locale(identifier: "fr_FR"))
ContentView()
.environment(\.locale, Locale(identifier: "pt_BR"))
}
}

## See Also

### Strings and text

Preparing your interface for localization

Find text in your app that needs translation and verify that your interface adapts to translated text.

Preparing your app’s text for translation

Make your app’s text translatable by leveraging the localization APIs in the Foundation framework.

---

# https://developer.apple.com/documentation/xcode/autosizing_views_for_localization_in_ios

- Xcode
- Autosizing Views for Localization in iOS

Sample Code

# Autosizing Views for Localization in iOS

Add auto layout constraints to your app to achieve localizable views.

Download

Xcode 12.0+

## Overview

## See Also

### Container views

Display nested views using a configurable and highly customizable layout.

Display data in a single column of customizable rows.

`class UIStackView`

A streamlined interface for laying out a collection of views in either a column or a row.

`class UIScrollView`

A view that allows the scrolling and zooming of its contained views.

---

# https://developer.apple.com/documentation/xcode/localization-friendly_layouts_in_macos

- Xcode
- Localization-Friendly Layouts in macOS

Sample Code

# Localization-Friendly Layouts in macOS

This project demonstrates localization-friendly auto layout constraints. It uses `NSGridView` as a container view to achieve localized layouts.

Download

Xcode 12.0+

## Overview

## See Also

### Container Views

Arrange views in a flexible grid, and handle the layout associated with those views.

`class NSSplitView`

A view that arranges two or more views in a linear stack running horizontally or vertically.

Organize Your User Interface with a Stack View

Group individual views in your app’s user interface into a scrollable stack view.

`class NSStackView`

A view that arranges an array of views horizontally or vertically and updates their placement and sizing when the window size changes.

`class NSTabView`

A multipage interface that displays one page at a time.

Provide an interface for navigating content that is too large to fit in the available space.

---

# https://developer.apple.com/documentation/xcode/adding-support-for-languages-and-regions



---

# https://developer.apple.com/documentation/xcode/choosing-localization-regions-and-scripts



---

# https://developer.apple.com/documentation/xcode/adding-resources-to-localizations



---

# https://developer.apple.com/documentation/xcode/localizing-assets-in-a-catalog



---

# https://developer.apple.com/documentation/xcode/creating-screenshots-of-your-app-for-localizers

- Xcode
- Localization
- Creating screenshots of your app for localizers

Article

# Creating screenshots of your app for localizers

Share screenshots of your app with localizers to provide context for translation.

## Overview

When running UI tests of your localizations, you can generate screenshots to include in the exported localization folders that you give to localizers. The screenshots provide context for the localizable strings and resources in the interface. You can generate screenshots from your project’s test plans or Test scheme.

To include the screenshots in the Xcode Localization Catalog (a folder with a `.xcloc` file extension), see Exporting localizations.

### Create a test plan

If you add many localizations to your project, test plans are ideal for generating screenshots because you can create a configuration for each. A test plan (a file with a `.xctestplan` file extension) specifies which tests to run and how to run them one or more times.

### Add localization configurations

Add a configuration for each localization to your test plan. In the Project navigator, select the test plan, then click Configurations. On the left, click the Add button (+) at the bottom. Select the new configuration that appears and enter a name for the localization.

Edit the configuration file for the localization test. Under Localization, set the Application Language and Application Region settings to the corresponding language and region for the localization. Under UI Testing, switch Localization Screenshots from Off to On.

## See Also

### Translation and adaptation

Exporting localizations

Provide the localizable files from your project to localizers.

Editing XLIFF and string catalog files

Translate or adapt the localizable files for a language and region that you export from your project.

Importing localizations

Import the files that you translate or adapt for a language and region into your project.

Locking views in storyboard and XIB files

Prevent changes to your Interface Builder files while localizing human-facing strings.

---

# https://developer.apple.com/documentation/xcode/editing-xliff-and-string-catalog-files

- Xcode
- Localization
- Editing XLIFF and string catalog files

Article

# Editing XLIFF and string catalog files

Translate or adapt the localizable files for a language and region that you export from your project.

## Overview

After you export localizations, you can give the Xcode Localization Catalog to localizers for translation, or edit the XLIFF files located in the `Localized Contents` folder yourself.

### Add translations to XLIFF files

### Group related strings using tables

When you import the localizations, Xcode adds a version of the strings file for each localization to your project. In the following SwiftUI code listing, the first `Text` string appears in the default `Localized.strings` file while the Button label that specifies a table name appears in the `Buttons.strings` file:

VStack {
Text("Hello, world!", comment:"A friendly greeting.")
.font(.largeTitle)
.padding()
Button(action: pushMe){
Text("Push Me", tableName:"Buttons", comment:"Push Me button label.")
}
.font(.title)
}

### Edit string catalogs in Xcode

After you import localizations, you can edit the string catalog file in your project and the next time you export localizations, Xcode includes your changes in the XLIFF files.

For more information about editing string catalogs in Xcode, see Localizing and varying text with a string catalog.

## See Also

### Translation and adaptation

Creating screenshots of your app for localizers

Share screenshots of your app with localizers to provide context for translation.

Exporting localizations

Provide the localizable files from your project to localizers.

Importing localizations

Import the files that you translate or adapt for a language and region into your project.

Locking views in storyboard and XIB files

Prevent changes to your Interface Builder files while localizing human-facing strings.

---

# https://developer.apple.com/documentation/xcode/locking-views-in-storyboard-and-xib-files

- Xcode
- Localization
- Locking views in storyboard and XIB files

Article

# Locking views in storyboard and XIB files

Prevent changes to your Interface Builder files while localizing human-facing strings.

## Overview

Before you export localizations, optionally lock the views in your storyboard and XIB files so you don’t inadvertently change localizable properties while you’re waiting for translations. Use this feature if you want to continue developing your app and avoid conflicts when importing localizations later. You can choose a locking level that controls the set of editable properties for each view.

### Lock views

You can set the locking level for a single view or for the entire user interface file. By default, views inherit their lock attribute from their parent view, and top-level views inherit their lock attribute from the user interface file. If you set a view’s lock attribute, it sets the lock attribute for all its descendant views.

To lock a single view, select the user interface file (files with a `.storyboard` or `.xib` filename extension) in the Project navigator, then select the view in Interface Builder. In the Identity inspector, choose a locking level from the Lock pop-up menu under Document:

Inherited - (\[locking level\])

Use the parent view’s locking level.

Nothing

Don’t lock any properties (make all properties editable).

All Properties

Lock all properties.

Localizable Properties

Lock localizable properties, such as user-facing text and size.

Non-localizable Properties

Lock non-localizable properties (make user-facing text and size properties editable).

For example, choose Localizable Properties while waiting for translations from localizers. If you import localizations and don’t want to make other changes inadvertently, choose Non-localizable Properties.

## See Also

### Translation and adaptation

Creating screenshots of your app for localizers

Share screenshots of your app with localizers to provide context for translation.

Exporting localizations

Provide the localizable files from your project to localizers.

Editing XLIFF and string catalog files

Translate or adapt the localizable files for a language and region that you export from your project.

Importing localizations

Import the files that you translate or adapt for a language and region into your project.

---

# https://developer.apple.com/documentation/xcode/previewing-localizations



---

# https://developer.apple.com/documentation/xcode/testing-localizations-when-running-your-app



---

# https://developer.apple.com/documentation/xcode/localizing-strings-that-contain-plurals



---

# https://developer.apple.com/documentation/xcode/creating-width-and-device-variants-of-strings



---

# https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/preparing-your-interface-for-localization)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/preparing-your-apps-text-for-translation)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/preparing-dates-numbers-with-formatters)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/autosizing_views_for_localization_in_ios)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/localization-friendly_layouts_in_macos)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/adding-support-for-languages-and-regions)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/choosing-localization-regions-and-scripts)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/adding-resources-to-localizations)



---

# https://developer.apple.com/documentation/xcode/localizing-assets-in-a-catalog)



---

# https://developer.apple.com/documentation/xcode/creating-screenshots-of-your-app-for-localizers)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/editing-xliff-and-string-catalog-files)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/importing-localizations)



---

# https://developer.apple.com/documentation/xcode/locking-views-in-storyboard-and-xib-files)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/previewing-localizations)



---

# https://developer.apple.com/documentation/xcode/testing-localizations-when-running-your-app)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/localizing-strings-that-contain-plurals)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/creating-width-and-device-variants-of-strings)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

# https://developer.apple.com/documentation/xcode/localizing-assets-in-a-catalog).



---

# https://developer.apple.com/documentation/xcode/testing-localizations-when-running-your-app).

.#app-main)

# The page you're looking for can't be found.

Search developer.apple.comSearch Icon

---

