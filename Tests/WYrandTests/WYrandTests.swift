import XCTest
@testable import WYrand

final class WYrandTests: XCTestCase {
  func testBasic() {
    var gen = WYrand(seed: 42)
    XCTAssertEqual(gen.next(), 12558987674375533620)
    XCTAssertEqual(gen.next(), 16846851108956068306)
    XCTAssertEqual(gen.next(), 14652274819296609082)
  }
  
  func testProtocolConformance() {
    var g = WYrand(seed: 42)
    XCTAssertEqual((1...10).shuffled(using: &g),
                   [7, 10, 9, 2, 1, 4, 5, 8, 6, 3])
  }
  
  func testNumberSequence() {
    var numbers = sequence(state: WYrand(seed: 42)) {
      return Int.random(in: Int.min...Int.max, using: &$0)
    }
    // Array init copies the value - `UnfoldSequence` and `WYrand`
    // are both value types.
    XCTAssertEqual(Array(numbers.prefix(2)),
                   [-5887756399334017996, -1599892964753483310])
    XCTAssertEqual(numbers.next(), -5887756399334017996)
    
    XCTAssertEqual(Array(numbers.prefix(2)),
                   [-1599892964753483310, -3794469254412942534])
    XCTAssertEqual(numbers.next(), -1599892964753483310)
    XCTAssertEqual(numbers.next(), -3794469254412942534)
    
    measure {
      _ = Array(numbers.lazy.prefix(524288))
    }
  }
  
  func testNumberSequenceBoundedPerformance() {
    let numbers = sequence(state: WYrand(seed: 42)) {
      Int.random(in: Int.min...(Int.max / 2 + 1), using: &$0)
    }
    measure {
      _ = Array(numbers.lazy.prefix(524288))
    }
  }
  
  func testRawGeneratorPerformance() {
    var g = WYrand(seed: 42)
    var a = Array(repeating: UInt64(0), count: 524288)
    
    measure {
      for i in a.indices {
        a[i] = g.next()
      }
    }
  }
  
  func testBoundedGeneratorPerformance() {
    var g = WYrand(seed: 42)
    var a = Array(repeating: UInt64(0), count: 524288)
    let b = UInt64.max / 2 + 1
    
    measure {
      for i in a.indices {
        a[i] = g.next(upperBound: b)
      }
    }
  }
  
  static var allTests = [
    ("testBasic", testBasic),
    ("testProtocolConformance", testProtocolConformance),
    ("testNumberSequence", testNumberSequence),
  ]
}
