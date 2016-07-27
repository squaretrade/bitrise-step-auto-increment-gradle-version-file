# Auto-increment Android Gradle versionCode and versionName
* Auto-increments `versionCode` in a `version.gradle` file by 1 by default.
* If `versionName` ends with ".versionCode" (e.g. ".69") that portion of the `versionName` string will be incremented.
Otherwise ".versionCode" will be appended to `versionName`.

## How to use this Step
* Create a `version.gradle` file in the same directory as your `build.gradle` file with the following contents:
```
ext {
    versionCode = 69
    versionName = "1.2.15.69"
}
```
* Update build.gradle to as follows to import `versionCode` and `versionName`:
```
apply from: 'version.gradle'

android {
    defaultConfig {
        versionCode project.ext.versionCode
        versionName project.ext.versionName
        ...
    }
```
### Build Step Input
#### Required
* `version_gradle_file`: full path to `version.gradle` file.
#### Optional
* `version_code_offset`: amount to increment `versionCode`.  Default value is 1.

### Build Step Output
* `GRADLE_VERSION_CODE`: The new value of `versionCode` in the `version.gradle` file.
* `GRADLE_VERSION_NAME`: The new value of `versionName` in the `version.gradle` file.

## TODO
* Allow for `version_code` to be specified with default `$BITRISE_BUILD_NUMBER` instead of incrementing the pre-existing value.
The would mean the nature of the build step would change.
* Allow for replacing instead of appending `version_code` to `versionName` if `versionCode` is not found at the end of the string.
* fix bitrise.yml for testing and sharing.
* USE CASE: support/test updating gradle.property file (should work).
* USE CASE: support/test updating build.gradle file (should work).
* Output new_version_code and new_version_name from step.

## Credits
* based on [Set Android Manifest Version Code and Name](https://github.com/jamesmontemagno/steps-set-android-manifest-versions) build step.
