//
//  ArgumentsTests.swift
//  RunnerTests
//
//  Created by Victor Kachalov on 09.10.26.
//

import XCTest
import Flutter
import HealthKitReporter
@testable import health_kit_reporter

/// Reading the arguments Dart sends: missing keys, milliseconds, predicate options, anchors
final class ArgumentsTests: XCTestCase {
    func testMissingArgumentThrowsInvalidValue() {
        let sut: [String: Any] = [:]
        XCTAssertThrowsError(try sut.string("identifier")) { error in
            XCTAssertTrue(error.localizedDescription.contains("Missing or invalid argument identifier"))
        }
        XCTAssertThrowsError(try sut.double("value"))
        XCTAssertThrowsError(try sut.strings("identifiers"))
        XCTAssertThrowsError(try sut.dictionary("workout"))
    }

    func testDatesArriveAsMilliseconds() throws {
        let sut: [String: Any] = ["timestamp": 1_601_065_755_500]
        XCTAssertEqual(try sut.date("timestamp").timeIntervalSince1970, 1_601_065_755.5, accuracy: 0.001)
    }

    func testSamplesPredicateIsNilWithoutTimestamps() throws {
        XCTAssertNil(try [String: Any]().samplesPredicate())
        XCTAssertThrowsError(try [String: Any]().requiredSamplesPredicate())
    }

    func testSamplesPredicateNeedsBothTimestamps() {
        let sut: [String: Any] = ["startTimestamp": 0]
        XCTAssertThrowsError(try sut.samplesPredicate())
    }

    func testPredicateOptions() throws {
        for option in ["strictStartDate", "strictEndDate", "notStrict"] {
            let sut: [String: Any] = ["startTimestamp": 0, "endTimestamp": 1000, "predicateOptions": option]
            XCTAssertNotNil(try sut.samplesPredicate(), option)
        }
        let unknown: [String: Any] = ["startTimestamp": 0, "endTimestamp": 1000, "predicateOptions": "loose"]
        XCTAssertThrowsError(try unknown.samplesPredicate()) { error in
            XCTAssertEqual(error.localizedDescription, "Unknown predicate option loose")
        }
    }

    func testLimitDefaultsToNoLimitAndMustBePositive() throws {
        XCTAssertEqual(try [String: Any]().limit(), 0)
        XCTAssertEqual(try ["limit": 5].limit(), 5)
        XCTAssertThrowsError(try ["limit": 0].limit())
        XCTAssertThrowsError(try ["limit": "5"].limit())
    }

    func testAnchorIsABase64String() throws {
        XCTAssertNil(try [String: Any]().anchor())
        XCTAssertThrowsError(try ["anchor": "not base64!"].anchor())
        let anchor = try XCTUnwrap(try ["anchor": "QU5DSE9S"].anchor())
        XCTAssertEqual(Optional(anchor).asArgument, "QU5DSE9S")
        XCTAssertNil(Optional<Anchor>.none.asArgument)
    }

    func testIdentifiersResolveToTypes() throws {
        XCTAssertTrue(try "HKQuantityTypeIdentifierStepCount".asSampleType() is QuantityType)
        XCTAssertNotNil(try "HKCharacteristicTypeIdentifierBloodType".asObjectType())
        XCTAssertThrowsError(try "HKCharacteristicTypeIdentifierBloodType".asSampleType())
        XCTAssertThrowsError(try "HKUnknown".asObjectType()) { error in
            XCTAssertEqual(error.localizedDescription, "Unknown identifier: HKUnknown")
        }
    }

    func testFlutterErrorKeepsTheLocalizedDescriptionAndAStringDetail() {
        let sut = FlutterError(code: "save", error: HealthKitError.invalidValue("Bad value"))
        XCTAssertEqual(sut.code, "save")
        XCTAssertEqual(sut.message, "Bad value")
        XCTAssertTrue(sut.details is String)
        let unknown = FlutterError(code: "save", error: nil)
        XCTAssertEqual(unknown.message, "Unknown error")
        XCTAssertNil(unknown.details)
    }

    func testEventChannelNamesCarryTheMethodAndTheSubscription() {
        XCTAssertEqual(
            EventChannel.observerQuery.combinedWith(identifier: "1"),
            "health_kit_reporter_event_channel_observerQuery_1"
        )
        XCTAssertEqual(
            EventChannel.allCases.map(\.rawValue),
            ["observerQuery", "statisticsCollectionQuery", "queryActivitySummaryUpdates", "anchoredObjectQuery"]
        )
    }
}
