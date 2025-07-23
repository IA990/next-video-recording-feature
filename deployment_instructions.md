# Deployment Instructions

## New Video Recording Feature

This release adds a new video recording feature to the Flutter app and backend:

- Flutter dependencies added: `camera`, `video_player`, `path_provider`
- Backend new router: `/videos` for secure video upload and download
- Flutter screen: `VideoRecordingScreen` with recording, pause, stop, preview, and history carousel
- Home screen drawer updated with navigation to video recording screen

### Flutter

1. Replace `pubspec.yaml` with `pubspec_updated.yaml` or merge dependencies:
   - `camera: ^0.10.0+1`
   - `video_player: ^2.4.0`
   - `path_provider: ^2.0.11`

2. Run:
   ```
   flutter pub get
   ```

3. Ensure camera and microphone permissions are added in platform-specific files:
   - Android: `AndroidManifest.xml`
   - iOS: `Info.plist`

### Backend

1. The new router `videos.py` handles video uploads and downloads.
2. Uploaded videos are stored in `backend/uploads/videos/`.
3. Ensure this directory exists and is writable.
4. The router requires authentication via OAuth2 Bearer tokens.

### CI/CD

- Backend workflow installs dependencies and runs tests as usual.
- Flutter workflow installs dependencies, analyzes code, and runs tests.

### Notes

- Update Dockerfiles if needed to include new dependencies.
- Review security audit for file upload handling.


## Prerequisites
- Render account (https://render.com)
- Docker installed locally (optional for local testing)
- PostgreSQL database with PostGIS enabled (provisioned via Render)

## Steps

### 1. Provision PostgreSQL Database on Render
- Log in to Render dashboard
- Create a new PostgreSQL database service
- Choose version 14 or higher
- Enable PostGIS extension in the database settings
- Note the database connection string (DATABASE_URL)

### 2. Prepare Environment Variables
- SECRET_KEY: A secure random string for JWT signing
- FIREBASE_CREDENTIALS_JSON: JSON string of your Firebase service account credentials
- DATABASE_URL: Connection string from the database provisioned above

### 3. Configure Render Service
- Create a new Web Service on Render
- Connect your GitHub repository or upload your code
- Select Docker as the environment
- Specify the Dockerfile path (`./Dockerfile`)
- Set the environment variables as above

### 4. Deploy
- Trigger deployment on Render
- Monitor build logs for errors
- Once deployed, your FastAPI backend will be accessible

### 5. CORS Configuration
- Ensure your Flutter app's domain or IP is added to the CORS allowed origins in your FastAPI app

### 6. Testing
- Test API endpoints using Postman or curl
- Test push notifications via Firebase integration

---

# Optional: Railway Deployment

- Similar steps apply for Railway (https://railway.app)
- Provision PostgreSQL with PostGIS plugin
- Set environment variables in Railway dashboard
- Deploy using Docker or native Python environment

---

# Notes

- Keep your Firebase credentials secure and do not commit them to source control
- Use Render secrets or Railway environment variables for sensitive data
- Monitor logs and metrics via Render or Railway dashboards
- Set up CI/CD pipelines for automated deployment (GitHub Actions recommended)

---

This guide helps you deploy a production-ready backend for MaBoutique.ma with PostgreSQL/PostGIS, Firebase push notifications, and secure environment management.
