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

## License

Proprietary - Nimble Development LLC
