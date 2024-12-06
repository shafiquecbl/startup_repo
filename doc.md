# Project Documentation

## Problem Statement

Setting up configurations for Android and iOS projects can be time-consuming and error-prone. Developers often need to manually configure various settings, which can lead to inconsistencies and mistakes. Our goal is to provide a streamlined solution where developers can manage basic/default configurations through a single file, reducing setup time and ensuring consistency.

## Solution

We have created a repository that allows developers to manage Android configurations through a [`.env`](.env) file and iOS configurations through an [`ios/Flutter/Environment.xcconfig`](ios/Flutter/Environment.xcconfig) file. Developers only need to update the values in these files, and the configurations will be applied automatically.

## Android Configuration

### Step-by-Step Guide

1. **Define Variables in [`.env`](.env) File**

   The [`.env`](.env) file is located at the root of the project. It contains the following variables:

   ```properties
   # App name
   APP_NAME=Startup Repo

   # Android Configuration
   BUNDLE_ID_ANDROID=com.example.startupRepo
   ANDROID_VERSION_CODE=1
   ANDROID_VERSION_NAME=1.0
   MIN_SDK_VERSION=24
   TARGET_SDK_VERSION=34

   # Keystore details for Android
   KEYSTORE_PATH=keystore.jks
   KEYSTORE_ALIAS=upload
   KEYSTORE_PASSWORD=upload
   KEY_PASSWORD=upload

   # Primary color
   PRIMARY_COLOR=#3498db
   ```

2. **Use Variables in [`android/app/build.gradle`](android/app/build.gradle)**

   The [`android/app/build.gradle`](android/app/build.gradle) file is located at [`android/app/build.gradle`](android/app/build.gradle). The variables from the [`.env`](.env) file are loaded and used in this file:

   ```gradle
   def loadEnv() {
       Properties properties = new Properties()
       def envFile = new File(rootProject.projectDir.parentFile, '.env')
       if (envFile.exists()) {
           envFile.withInputStream { stream ->
               properties.load(stream)
           }
       } else {
           throw new FileNotFoundException(".env file not found in project root directory")
       }
       return properties
   }

   project.ext.env = loadEnv()

   android {
       namespace "com.example.startup_repo"
       compileSdk flutter.compileSdkVersion
       ndkVersion flutter.ndkVersion

       defaultConfig {
           applicationId project.env.BUNDLE_ID_ANDROID
           minSdkVersion project.env.MIN_SDK_VERSION
           targetSdkVersion project.env.TARGET_SDK_VERSION
           versionCode project.env.ANDROID_VERSION_CODE.toInteger()
           versionName project.env.ANDROID_VERSION_NAME.toString()
           multiDexEnabled true
           resValue "string", "app_name", project.env.APP_NAME
       }

       signingConfigs {
           debug {
               storeFile file(project.env.KEYSTORE_PATH.toString())
               storePassword project.env.KEYSTORE_PASSWORD
               keyAlias project.env.KEYSTORE_ALIAS
               keyPassword project.env.KEY_PASSWORD
           }
           release {
               storeFile file(project.env.KEYSTORE_PATH.toString())
               storePassword project.env.KEYSTORE_PASSWORD
               keyAlias project.env.KEYSTORE_ALIAS
               keyPassword project.env.KEY_PASSWORD
           }
       }

       buildTypes {
           debug {
               signingConfig signingConfigs.debug
           }
           release {
               signingConfig signingConfigs.release
               minifyEnabled true
               shrinkResources true
           }
       }
   }
   ```

3. **Use Variables in [`android/app/src/debug/AndroidManifest.xml`](android/app/src/debug/AndroidManifest.xml)**

   The [`android/app/src/debug/AndroidManifest.xml`](android/app/src/debug/AndroidManifest.xml) file is located at [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml). The `APP_NAME` variable is used in this file:

   ```xml
   <manifest xmlns:android="http://schemas.android.com/apk/res/android">
       <application android:label="@string/app_name" android:name="${applicationName}" android:icon="@mipmap/ic_launcher">
           <activity android:name=".MainActivity" android:exported="true" android:launchMode="singleTop" android:taskAffinity="" android:theme="@style/LaunchTheme" android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode" android:hardwareAccelerated="true" android:windowSoftInputMode="adjustResize">
               <meta-data android:name="io.flutter.embedding.android.NormalTheme" android:resource="@style/NormalTheme" />
               <intent-filter>
                   <action android:name="android.intent.action.MAIN"/>
                   <category android:name="android.intent.category.LAUNCHER"/>
               </intent-filter>
           </activity>
           <meta-data android:name="flutterEmbedding" android:value="2" />
       </application>
   </manifest>
   ```

### Important Note

Do not change the `namespace "com.example.startup_repo"` in [`android/app/build.gradle`](android/app/build.gradle) as it is used as an import in [`android/app/src/main/kotlin/com/example/startup_repo/MainActivity.kt`](android/app/src/main/kotlin/com/example/startup_repo/MainActivity.kt).

## iOS Configuration

### Step-by-Step Guide

1. **Define Variables in [`ios/Flutter/Environment.xcconfig`](ios/Flutter/Environment.xcconfig)**

   The [`ios/Flutter/Environment.xcconfig`](ios/Flutter/Environment.xcconfig) file is located at [`ios/Flutter/Environment.xcconfig`](ios/Flutter/Environment.xcconfig). It contains the following variables:

   ```plaintext
   APP_NAME = Startup Repo
   APP_VERSION = 1.0;
   BUILD_NUMBER = 1;
   BUNDLE_ID= com.example.startupRepo
   ```

2. **Import [`ios/Flutter/Environment.xcconfig`](ios/Flutter/Environment.xcconfig) in [`ios/Flutter/Debug.xcconfig`](ios/Flutter/Debug.xcconfig) and [`ios/Flutter/Release.xcconfig`](ios/Flutter/Release.xcconfig)**

   The [`ios/Flutter/Debug.xcconfig`](ios/Flutter/Debug.xcconfig) and [`ios/Flutter/Release.xcconfig`](ios/Flutter/Release.xcconfig) files are located at [`ios/Flutter/Debug.xcconfig`](ios/Flutter/Debug.xcconfig) and [`ios/Flutter/Release.xcconfig`](ios/Flutter/Release.xcconfig), respectively. These files import the [`ios/Flutter/Environment.xcconfig`](ios/Flutter/Environment.xcconfig) file:

   ```plaintext
   # Debug.xcconfig
   #include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
   #include "Generated.xcconfig"
   #include "Environment.xcconfig"

   MY_APP_NAME = ${APP_NAME}
   MY_MARKETING_VERSION = ${APP_VERSION}
   MY_CURRENT_PROJECT_VERSION = ${BUILD_NUMBER}
   MY_BUNDLE_ID= ${BUNDLE_ID}
   ```

   ```plaintext
   # Release.xcconfig
   #include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
   #include "Generated.xcconfig"
   #include "Environment.xcconfig"

   MY_APP_NAME = ${APP_NAME}
   MY_MARKETING_VERSION = ${APP_VERSION}
   MY_CURRENT_PROJECT_VERSION = ${BUILD_NUMBER}
   MY_BUNDLE_ID= ${BUNDLE_ID}
   ```

3. **Use Variables in [`ios/Runner/Info.plist`](ios/Runner/Info.plist)**

   The [`ios/Runner/Info.plist`](ios/Runner/Info.plist) file is located at [`ios/Runner/Info.plist`](ios/Runner/Info.plist). The variables are used in this file:

   ```xml
   <plist version="1.0">
       <dict>
           <key>CFBundleDisplayName</key>
           <string>${MY_APP_NAME}</string>
           <key>CFBundleIdentifier</key>
           <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
           <key>CFBundleName</key>
           <string>${MY_APP_NAME}</string>
           <key>CFBundleShortVersionString</key>
           <string>$(MARKETING_VERSION)</string>
           <key>CFBundleVersion</key>
           <string>$(CURRENT_PROJECT_VERSION)</string>
       </dict>
   </plist>
   ```

4. **Use Variables in [`ios/Runner.xcodeproj/project.pbxproj`](ios/Runner.xcodeproj/project.pbxproj)**

   The [`ios/Runner.xcodeproj/project.pbxproj`](ios/Runner.xcodeproj/project.pbxproj) file is located at [`ios/Runner.xcodeproj/project.pbxproj`](ios/Runner.xcodeproj/project.pbxproj). The variables are used in this file:

   ```pbxproj
   97C147071CF9000F007C117D /* Release */ = {
       isa = XCBuildConfiguration;
       baseConfigurationReference = 7AFA3C8E1D35360C0083082E /* Release.xcconfig */;
       buildSettings = {
           PRODUCT_BUNDLE_IDENTIFIER = "${MY_BUNDLE_ID}";
           PRODUCT_NAME = "$(TARGET_NAME)";
           MARKETING_VERSION = "${MY_MARKETING_VERSION}";
           CURRENT_PROJECT_VERSION = "${MY_CURRENT_PROJECT_VERSION}";
       };
       name = Release;
   };
   ```

## Future Plans

We plan to automate our development process using GitHub Actions. Having all configuration data in environment files will make it easy to set up the same products for different clients with their specific information.

## Conclusion

By managing configurations through [`.env`](.env) and [`ios/Flutter/Environment.xcconfig`](ios/Flutter/Environment.xcconfig) files, we have simplified the setup process for Android and iOS projects. Developers only need to update these files, and the configurations will be applied automatically, ensuring consistency and reducing setup time.
