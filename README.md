# RealDeal

Real Estate Investment Analysis Platform

## Architecture

```
realdeal/
├── landing/          <- Marketing site (Vite/React) → getrealdeal.ai
├── app/              <- Flutter app → app.getrealdeal.ai
├── functions/        <- Firebase Cloud Functions
├── firebase.json     <- Firebase configuration
└── .github/workflows <- CI/CD pipelines
```

## Deployments

| Component | Platform | URL |
|-----------|----------|-----|
| Landing Page | Vercel | https://getrealdeal.ai |
| Flutter App | Firebase Hosting | https://app.getrealdeal.ai |
| API Functions | Firebase Functions | Cloud endpoints |

## Development

### Landing Page
```bash
cd landing
npm install
npm run dev
```

### Flutter App
```bash
cd app
flutter pub get
flutter run -d chrome  # Web
flutter run            # Mobile
```

### Functions
```bash
cd functions
npm install
npm run serve  # Local emulator
```

## Deployment

- **Pull Request** → Firebase Preview Channel (auto)
- **Merge to main** → Production deploy (auto)

## Environment Variables

Required secrets in GitHub:
- `FIREBASE_SERVICE_ACCOUNT` - Firebase deploy credentials
- `FIREBASE_TOKEN` - Functions deploy token
- `VERCEL_TOKEN` - Vercel deploy token
- `VERCEL_ORG_ID` - Vercel organization
- `VERCEL_PROJECT_ID` - Vercel project
- `GMAPS_API_KEY` - Google Maps API key (injected at build time; see below)

### Google Maps API Key (`GMAPS_API_KEY`)

The Maps key is **never committed to source** (P0 security finding 2026-06-10).
It is injected at build time per platform. The Firebase web SDK keys in
`firebase_config.dart` / `google-services.json` / `GoogleService-Info.plist`
are a different thing — those are public-by-design client identifiers (see
`HOW-TO-SECURITY-PATCHES.md`) and stay committed.

| Platform | Mechanism |
|----------|-----------|
| Web | `app/web/index.html` ships `GMAPS_API_KEY_PLACEHOLDER`; CI runs `scripts/inject-gmaps-key.mjs` after `flutter build web` to substitute the key from the `GMAPS_API_KEY` env var into `app/build/web/index.html` |
| Dart (static maps in `widget_screenshot.dart`) | `--dart-define=GMAPS_API_KEY=...` at build/run time (`String.fromEnvironment`) |
| Android | `manifestPlaceholders` in `app/android/app/build.gradle`, resolved from `gmaps.apiKey` in `android/local.properties`, `-PGMAPS_API_KEY=...`, or the `GMAPS_API_KEY` env var |
| iOS | `$(GMAPS_API_KEY)` in `Info.plist`, resolved from `app/ios/Flutter/Secrets.xcconfig` (gitignored — copy `Secrets.xcconfig.example` and fill in) |

All platforms default to an **empty key** so builds don't hard-fail — maps
simply won't render until the key is supplied.

Local dev setup (get the key from the GCP console, project `apis-and-services`):

```powershell
# Web + Dart static maps:
cd app; flutter run -d chrome --dart-define=GMAPS_API_KEY=YOUR_KEY

# Android: add to app/android/local.properties (gitignored):
#   gmaps.apiKey=YOUR_KEY

# iOS: copy app/ios/Flutter/Secrets.xcconfig.example to Secrets.xcconfig
# (gitignored) and replace YOUR_KEY.

# Local web bundle with maps (placeholder substitution on the build artifact):
cd app; flutter build web; cd ..
$env:GMAPS_API_KEY = "YOUR_KEY"; node scripts/inject-gmaps-key.mjs app/build/web/index.html
```

## License

Proprietary - Nimble Development LLC
