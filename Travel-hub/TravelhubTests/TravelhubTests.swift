//
//  TravelhubTests.swift
//  TravelhubTests
//
//  Created by Jonas Groll on 11.02.26.
//

#if canImport(Testing)
import Testing
@testable import Travelhub

@Suite("Travelhub Tests")
struct TravelhubTests {

    @Test("Basic addition works")
    func testExample() {
        // Write basic assertions with #expect
        let a = 2
        let b = 3
        #expect(a + b == 5)
    }

    @Test("Async throws example")
    func testAsyncThrowsExample() async throws {
        // You can throw or await here, then assert
        let value: Int? = 42
        let unwrapped = try #require(value)
        #expect(unwrapped == 42)
    }

    @Test("Performance example")
    func testPerformanceExample() {
        // Simple computation; if you need metrics, consider adding a dedicated performance test later
        var sum = 0
        for i in 0..<10_000 {
            sum += i
        }
        // Ensure the computation is used and check a simple invariant
        #expect(sum > 0)
    }
}
#elseif canImport(XCTest)
import XCTest
@testable import Travelhub

final class TravelhubTests: XCTestCase {

    func testBasicAdditionWorks() {
        let a = 2
        let b = 3
        XCTAssertEqual(a + b, 5)
    }

    func testAsyncThrowsExample() async throws {
        let value: Int? = 42
        let unwrapped = try XCTUnwrap(value)
        XCTAssertEqual(unwrapped, 42)
    }

    func testPerformanceExample() {
        var sum = 0
        for i in 0..<10_000 {
            sum += i
        }
        XCTAssertGreaterThan(sum, 0)
    }
}
#else
// Neither Swift Testing nor XCTest is available; define a no-op to avoid build errors.
struct TravelhubTests_Placeholder {}
#endif

