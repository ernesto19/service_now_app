import UIKit
import Flutter
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
    GMSServices.provideAPIKey("AIzaSyBZOZ2FwSFPiqCwdLLNw9WwXBYcwZdyz0E")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    ApplicationDelegate.shared.application(
      app,
      open: url,
      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    )
  }  

  // @available(iOS 9.0, *)
  //   override  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
  //   -> Bool {
  //       return FBSDKApplicationDelegate.sharedInstance().application(application,  open: url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
  // }

  // // para iOS menor a 9.0
  // override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
  //   return FBSDKApplicationDelegate.sharedInstance().application(application,open: url as URL?,sourceApplication: sourceApplication,annotation: annotation)
  // }
}
