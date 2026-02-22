#if canImport(Testing)
import Testing
@testable import Travelhub

@Suite("Travelhub basic tests")
struct TravelhubXCTests {

    @Test("Simple arithmetic example")
    func testSimpleArithmeticExample() {
        let a = 2
        let b = 3
        #expect(a + b == 5)
    }

    @Test("Async throws example")
    func testAsyncThrowsExample() async throws {
        let value: Int? = 42
        let unwrapped = try #require(value)
        #expect(unwrapped == 42)
    }

    @Test("Performance example")
    func testPerformanceExample() throws {
        try measure {
            var sum = 0
            for i in 0..<10_000 {
                sum += i
            }
            #expect(sum > 0)
        }
    }
}
#elseif canImport(XCTest)
import XCTest
@testable import Travelhub

final class TravelhubXCTests: XCTestCase {

    func testSimpleArithmeticExample() {
        let a = 2
        let b = 3
        XCTAssertEqual(a + b, 5)
    }

    func testAsyncThrowsExample() async throws {
        let value: Int? = 42
        let unwrapped = try XCTUnwrap(value)
        XCTAssertEqual(unwrapped, 42)
    }

    func testPerformanceExample() throws {
        measure {
            var sum = 0
            for i in 0..<10_000 {
                sum += i
            }
            XCTAssertGreaterThan(sum, 0)
        }
    }
}
#else
// No testing framework available; tests are disabled for this build configuration.
#endif
