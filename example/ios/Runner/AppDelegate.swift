import UIKit
import Flutter
import HealthKitReporter
import health_kit_reporter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let rootViewController = window.rootViewController {
        let handler = HealthKitReporterStreamHandler(viewController: rootViewController)
        handler.setStreamHandler(for: .observerQuery)
        handler.setStreamHandler(for: .anchoredObjectQuery)
        handler.setStreamHandler(for: .heartbeatSeriesQuery)
        handler.setStreamHandler(for: .queryActivitySummary)
        handler.setStreamHandler(for: .statisticsCollectionQuery)
        handler.setStreamHandler(for: .workoutRouteQuery)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
