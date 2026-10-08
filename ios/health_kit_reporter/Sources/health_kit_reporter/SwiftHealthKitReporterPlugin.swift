import Flutter
import HealthKitReporter

public class SwiftHealthKitReporterPlugin: NSObject, FlutterPlugin {
    var reporter: HealthKitReporter?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftHealthKitReporterPlugin()
        let binaryMessenger = registrar.messenger()
        registerMethodChannel(
            registrar: registrar,
            binaryMessenger: binaryMessenger,
            instance: instance
        )
        guard HealthKitReporter.isHealthDataAvailable else {
            return
        }
        let reporter = HealthKitReporter()
        instance.reporter = reporter
        registerEventChannel(
            binaryMessenger: binaryMessenger,
            reporter: reporter
        )
    }
    private static func registerMethodChannel(
        registrar: FlutterPluginRegistrar,
        binaryMessenger: FlutterBinaryMessenger,
        instance: SwiftHealthKitReporterPlugin
    ) {
        for method in MethodChannel.allCases {
            let methodChannel = FlutterMethodChannel(
                name: method.rawValue,
                binaryMessenger: binaryMessenger
            )
            registrar.addMethodCallDelegate(instance, channel: methodChannel)
        }
    }
    private static func registerEventChannel(
        binaryMessenger: FlutterBinaryMessenger,
        reporter: HealthKitReporter
    ) {
        for event in EventChannel.allCases {
            let eventChannel = FlutterEventChannel(
                name: event.rawValue,
                binaryMessenger: binaryMessenger
            )
            eventChannel.setStreamHandler(StreamHandlerFactory.make(with: reporter, for: event))
        }
    }
}
