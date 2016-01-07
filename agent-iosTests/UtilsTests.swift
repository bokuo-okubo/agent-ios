//
//   UtilsTests.swift
//
//  Created by Yohei Okubo on 12/15/15.
//
//

import XCTest
@testable import agent_ios

class UtilsTests: XCTestCase {

  let testStr = "123456"

  // 対象の文字列より内側の範囲を指定したら、正しくsubstrが取れる
  func testStringrangeDesignateInnerRange() {
    let innerRange = stringRange(testStr, from: 0, to: 4)
    XCTAssertEqual( testStr.substringWithRange(innerRange), "1234")
  }

  // 対象の文字列より終わりが外側の範囲を指定したら、最後までの文字列が取れる
  func testStringrangeDesignateEndIsOuterRange() {
    let outerRange = stringRange(testStr, from: 4, to: 4)
    XCTAssertEqual( testStr.substringWithRange(outerRange), "56")
  }

  // 対象の文字列より始まりが外側の範囲を指定したら、最後までの文字列が取れる
  func testStringrangeDesignateStartIsOuterRange() {
    let outerRange = stringRange(testStr, from: 7, to: 9)
    XCTAssertEqual( testStr.substringWithRange(outerRange), "")
  }
}
