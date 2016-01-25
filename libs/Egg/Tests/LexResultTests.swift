//
//  LexResultTests.swift
//  Egg
//
//  Created by Yohei Okubo on 1/12/16.
//  Copyright © 2016 bko. All rights reserved.
//

import XCTest
@testable import Egg

class LexResultTests: XCTestCase {

  func testLexResultOverRideMethod() {
    let pre = LexResult.trueResult("hoge", index: 0, data: [])
    let result = pre.override(index: 1, data: [Token.create()])
    XCTAssertEqual(result.index, 1)
    XCTAssertEqual(result.target, "hoge")
    XCTAssertEqual(result.data.count, 1)

    let pre2 = LexResult.falseResult("hoge", index: 99)
    let result2 = pre2.override(index: 1, data: [Token.create()])
    XCTAssertEqual(result2.index, 99)
    XCTAssertEqual(result2.target, "hoge")
    XCTAssertEqual(result2.data.count, 0)
  }
}
