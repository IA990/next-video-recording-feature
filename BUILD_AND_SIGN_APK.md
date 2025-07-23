# Build, Sign, and Generate Production APK/AAB for MaBoutique.ma Flutter App

## 1. Generate a Keystore

Run the following command to generate a keystore file:

```bash
keytool -genkey -v -keystore ~/maboutique_keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias maboutique_alias
```

- Remember the keystore password, alias, and key password.

## 2. Create `key.properties` File

Create a file named `key.properties` in the `android/` directory with the following content:

```
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=maboutique_alias
storeFile=/absolute/path/to/maboutique_keystore.jks
```

Replace the placeholders with your actual keystore details.

## 3. Update `android/app/build.gradle`

Add the following signing config to `android/app/build.gradle`:

```gradle
def keystorePropertiesFile = rootProject.file("key.properties")
def keystoreProperties = new Properties()
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

## 4. Versioning Setup

Update `android/app/build.gradle` with your app version:

```gradle
defaultConfig {
    ...
    versionCode 1
    versionName "1.0.0"
}
```

Increment these values for each release.

## 5. Build the APK or AAB

- To build APK:

```bash
flutter build apk --release
```

- To build AAB (recommended for Play Store):

```bash
flutter build appbundle --release
```

The output will be in `build/app/outputs/flutter-apk/` or `build/app/outputs/bundle/release/`.

## 6. Play Store Assets

- **App Icons:** Use `flutter_launcher_icons` package to generate icons.
- **Screenshots:** Prepare screenshots for various device sizes.
- **Description:** Write clear, localized app descriptions.
- **Privacy Policy:** Provide a URL for your privacy policy.
- **Feature Graphic:** Prepare a feature graphic image for Play Store.

## 7. Firebase Production Setup

- Replace `google-services.json` in `android/app/` with your production Firebase config.
- Ensure Firebase project is configured for production.
- Update API keys and endpoints as needed.

## 8. Additional Notes

- Test the release build on real devices.
- Follow Google Play Store guidelines.
- Consider setting up CI/CD for automated builds and deployment.

---

This guide helps you prepare and publish your Flutter app MaBoutique.ma on the Google Play Store.
