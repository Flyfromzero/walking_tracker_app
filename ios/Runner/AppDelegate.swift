import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyBH-E7mOvJbNd4CHsryrxBxzTF4gOgsqFU")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//AIzaSyBH-E7mOvJbNd4CHsryrxBxzTF4gOgsqFU
