//
//  EggTest.swift
//  agent-ios
//
//  Created by Yohei Okubo on 12/21/15.
//  Copyright © 2015 bko. All rights reserved.
//

import XCTest
@testable import Egg

/* test class */
class Token_AtomicTest: EggTestBase {

  /* test basic token */
  typealias $ = Egg

  private let hogeT = $.tokenize("hoge")
  private let fooT = $.tokenize("foo")

  /* tokenize test */
  func testTokenizeParseValidString() {

    let expect = TokenResult(
      isSuccess: true,
      index: "hoge".characters.count,
      tokenized: ["hoge"]
    )

    let testList = [
      "hoge",
      "hogepiyo",
      ].map({ ($0, expect)})

    execTest(testList, token: HogeT)
  }

  func testTokenizeParseInValidString() {

    let expect = TokenResult(
      isSuccess: false,
      index: 0,
      tokenized: []
    )

    let testList = [
      "foobar",
      "3hoge",
      "ho--ge"
      ].map({ ($0, expect)})

    execTest(testList, token: HogeT)
  }
}
