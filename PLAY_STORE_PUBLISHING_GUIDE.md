# Publishing MaBoutique.ma APK to Google Play Store

## Developer Console Setup
- Create a Google Play Developer account at https://play.google.com/console/signup
- Pay the one-time registration fee
- Complete your developer profile

## Create a New App
- Click "Create app" in the Play Console
- Enter app name, default language, and app type
- Accept developer agreement and privacy policy

## Store Listing Requirements
- App Title: Clear and concise
- Short Description: Brief summary of app features
- Full Description: Detailed description with keywords
- Screenshots: Upload for phone, tablet, and other devices
- App Icon: 512x512 PNG with transparent background
- Feature Graphic: 1024x500 PNG for Play Store banner
- Privacy Policy URL: Mandatory for apps collecting user data
- Contact Details: Email, website, phone (optional)

## Upload APK or AAB
- Navigate to "Release" > "Production" > "Create new release"
- Upload signed APK or AAB file
- Fill in release notes
- Review and roll out release

**Note:** Google recommends using Android App Bundle (AAB) for smaller app size and better delivery.

## Firebase and Google Maps API Keys in Production
- Use separate Firebase project for production
- Replace `google-services.json` in `android/app/` with production config
- Restrict API keys in Google Cloud Console to your app’s package name and SHA-1 fingerprint
- Use environment variables or secure storage to manage keys in Flutter app
- Avoid hardcoding keys in source code

## Additional Tips
- Test release build on real devices
- Follow Google Play policies and guidelines
- Monitor app performance and user feedback via Play Console
- Update app regularly with improvements and fixes

---

This guide helps you publish your MaBoutique.ma Flutter app APK or AAB to the Google Play Store securely and efficiently.
