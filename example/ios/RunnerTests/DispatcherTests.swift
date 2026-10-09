//
//  DispatcherTests.swift
//  RunnerTests
//
//  Created by Victor Kachalov on 09.10.26.
//

import XCTest
import Flutter
import HealthKitReporter
@testable import health_kit_reporter

/// The dispatcher replies on the platform thread, with errors coded by the Dart method name
final class DispatcherTests: XCTestCase {
    private let messenger = MessengerSpy()

    private func reply(
        _ method: String,
        _ arguments: [String: Any]? = nil,
        reporter: HealthKitReporter? = HealthKitReporter()
    ) -> (Any?, SwiftHealthKitReporterPlugin) {
        let sut = SwiftHealthKitReporterPlugin(binaryMessenger: messenger, reporter: reporter)
        let replied = expectation(description: method)
        var value: Any?
        sut.handle(FlutterMethodCall(methodName: method, arguments: arguments)) { result in
            XCTAssertTrue(Thread.isMainThread)
            value = result
            replied.fulfill()
        }
        wait(for: [replied], timeout: 5)
        return (value, sut)
    }

    func testUnknownMethodIsNotImplemented() {
        let (result, _) = reply("noSuchMethod")
        XCTAssertTrue((result as AnyObject) === (FlutterMethodNotImplemented as AnyObject))
    }

    func testIsAvailableAnswersWithoutHealthData() {
        let (result, _) = reply("isAvailable", reporter: nil)
        XCTAssertEqual(result as? Bool, HealthKitReporter.isHealthDataAvailable)
    }

    func testEveryOtherMethodFailsWithoutHealthData() {
        for method in ["quantityQuery", "observerQuery", "anchoredObjectQuery", "save"] {
            let (result, _) = reply(method, reporter: nil)
            let error = result as? FlutterError
            XCTAssertEqual(error?.code, method)
            XCTAssertEqual(error?.message, "HealthKit data is not available")
        }
    }

    func testMissingArgumentsFailWithTheMethodCode() {
        let (result, _) = reply("quantityQuery", [:])
        let error = result as? FlutterError
        XCTAssertEqual(error?.code, "quantityQuery")
        XCTAssertTrue(error?.message?.contains("identifier") == true)
        XCTAssertTrue(error?.details is String)
    }

    func testWorkoutRoutesNeedAWellFormedWorkoutUUID() {
        let (missing, _) = reply("workoutRouteQueryForWorkout", [:])
        XCTAssertEqual((missing as? FlutterError)?.code, "workoutRouteQueryForWorkout")
        XCTAssertTrue((missing as? FlutterError)?.message?.contains("workoutUUID") == true)
        let (malformed, _) = reply("workoutRouteQueryForWorkout", ["workoutUUID": "not-a-uuid"])
        XCTAssertEqual((malformed as? FlutterError)?.code, "workoutRouteQueryForWorkout")
    }

    func testSaveRejectsAnUnknownSampleKind() {
        let (result, _) = reply("save", ["unknown": [:]])
        XCTAssertEqual((result as? FlutterError)?.code, "save")
    }

    func testIsWritable() {
        let (steps, _) = reply("isWritable", ["identifier": "HKQuantityTypeIdentifierStepCount"])
        XCTAssertEqual(steps as? Bool, true)
        let (exercise, _) = reply("isWritable", ["identifier": "HKQuantityTypeIdentifierAppleExerciseTime"])
        XCTAssertEqual(exercise as? Bool, false)
    }

    func testEarliestPermittedSampleDateIsSeconds() {
        let (result, _) = reply("earliestPermittedSampleDate")
        XCTAssertNotNil(result as? Double)
    }

    func testLiveQueryOpensAChannelOfItsOwn() {
        let arguments: [String: Any] = ["identifiers": ["HKQuantityTypeIdentifierStepCount"]]
        let (first, sut) = reply("observerQuery", arguments)
        let name = try? XCTUnwrap(first as? String)
        XCTAssertTrue(name?.hasPrefix("health_kit_reporter_event_channel_observerQuery_") == true)
        XCTAssertEqual(sut.eventChannels.count, 1)
        XCTAssertTrue(messenger.channels.contains(name ?? ""))
        let (second, _) = reply("observerQuery", arguments)
        XCTAssertNotEqual(first as? String, second as? String)
    }

    func testLiveQueryWithInvalidArgumentsFailsBeforeOpeningAChannel() {
        let (result, sut) = reply("anchoredObjectQuery", ["identifiers": ["HKUnknown"]])
        let error = result as? FlutterError
        XCTAssertEqual(error?.code, "anchoredObjectQuery")
        XCTAssertEqual(error?.message, "Not a sample type: HKUnknown")
        XCTAssertTrue(sut.eventChannels.isEmpty)
    }

    func testCancelStopsTheQueriesAndClosesTheChannel() throws {
        let sut = SwiftHealthKitReporterPlugin(binaryMessenger: messenger, reporter: HealthKitReporter())
        let name = try sut.openEventChannel(
            .observerQuery,
            reporter: try XCTUnwrap(sut.reporter),
            arguments: ["identifiers": ["HKQuantityTypeIdentifierStepCount"]]
        )
        let handler = ObserverQueryStreamHandler(reporter: try XCTUnwrap(sut.reporter))
        try handler.plan(arguments: ["identifiers": ["HKQuantityTypeIdentifierStepCount"]])
        XCTAssertEqual(handler.plannedQueries.count, 1)
        XCTAssertNil(handler.onListen(withArguments: nil) { _ in })
        XCTAssertEqual(handler.activeQueries.count, 1)
        var closed = false
        handler.onClose = { closed = true }
        XCTAssertNil(handler.onCancel(withArguments: nil))
        XCTAssertTrue(handler.activeQueries.isEmpty)
        XCTAssertNil(handler.eventSink)
        XCTAssertTrue(closed)
        XCTAssertNotNil(sut.eventChannels[name])
    }
}

/// Records the channels the plugin listens on
private final class MessengerSpy: NSObject, FlutterBinaryMessenger {
    private(set) var channels = Set<String>()

    func send(onChannel channel: String, message: Data?) {}

    func send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply? = nil) {}

    func setMessageHandlerOnChannel(
        _ channel: String,
        binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil
    ) -> FlutterBinaryMessengerConnection {
        if handler == nil {
            channels.remove(channel)
        } else {
            channels.insert(channel)
        }
        return 0
    }

    func cleanUpConnection(_ connection: FlutterBinaryMessengerConnection) {}
}
