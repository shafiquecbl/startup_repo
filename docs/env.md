# Application Configuration

The starter does not use a root `.env` file. Public application identity, release signing, and Dart runtime
configuration have separate owners.

## Android application identity

Tracked file: `android/app/app_config.properties`

```properties
app_name=Startup Repo
application_id=com.example.startupRepo
```

This file contains public build metadata only. Android version code/name come from `pubspec.yaml` through Flutter's
Gradle values.

## Android release signing

Template: `android/app/signing.properties.example`

Copy the template to `android/app/signing.properties` and replace the placeholders for a real release build:

```properties
keystore_path=upload-keystore.jks
keystore_password=replace-in-local-or-ci-secret-store
keystore_alias=upload
key_password=replace-in-local-or-ci-secret-store
```

`signing.properties`, `.jks`, and `.keystore` files are ignored by Git. CI must create the signing file from its
encrypted secret store. When no signing file exists, the reusable starter follows Flutter's generated-template
behavior and uses debug signing so local release-mode verification remains possible.

## iOS application identity

Tracked file: `ios/Flutter/Environment.xcconfig`

It may contain public values such as display name, marketing version, build number, and bundle identifier. Apple
signing certificates, provisioning profiles, and private keys belong in Xcode or CI secret storage, never xcconfig.

## API base URL

The fixed API base URL lives in `lib/core/utils/app_constants.dart` as `AppConstants.baseUrl`.
