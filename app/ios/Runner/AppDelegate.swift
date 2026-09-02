import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Key is injected at build time from GMapsAPIKey in Info.plist, which
    // resolves $(GMAPS_API_KEY) from ios/Flutter/Secrets.xcconfig (gitignored;
    // see Secrets.xcconfig.example). Never hardcode the key here.
    if let mapsApiKey = Bundle.main.object(forInfoDictionaryKey: "GMapsAPIKey") as? String,
       !mapsApiKey.isEmpty {
      GMSServices.provideAPIKey(mapsApiKey)
    } else {
      NSLog("WARNING: GMapsAPIKey is empty — Google Maps will not work. Set GMAPS_API_KEY in ios/Flutter/Secrets.xcconfig (see Secrets.xcconfig.example).")
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
