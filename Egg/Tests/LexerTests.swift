//
//  TokenTests.swift
//  Egg
//
//  Created by Yohei Okubo on 12/24/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation
import XCTest
@testable import Egg

/* test class */
class LexerTests: XCTestCase {

  /* test basic token */
  typealias Result = LexResult
  typealias $ = Lexer<Result>

  private let hogeLexer = $.create("hoge")
  private let fooLexer = $.create("foo")
  private let emptyLexer = $.create()


  func assert(real: Result, _ expect: Result) {
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.count, expect.data.count)
  }


  // TODO : very tmp
  // -> やってることは結局concat. concatの名前をちゃんと考える
  func testNewToken() {
    let idLexer = $.create("/:id")
    let idToken = idLexer.unify(name: "PARAM")

    let res1 = idToken.apply("hoge")
    XCTAssert(res1.isSuccess == false)

    let res2 = idToken.apply("/:id")

    let token = res2.data.first!

    switch token.name {
    case"PARAM":
      XCTAssertEqual(token.value, "/:id")
    default:
      XCTFail()
    }

  }

  func testCreateStandartlexer() {
    let result = hogeLexer.apply("hoge")
    let expect = Result.create(
      isSuccess: true,
      target: "hoge",
      index: 4,
      data: [Token.create(value: "hoge")]
    )

    XCTAssertEqual(result.index, expect.index)
    XCTAssertEqual(result.isSuccess, expect.isSuccess)
    XCTAssertEqual(result.data.count, 1)
    XCTAssertNotNil(result.data.first?.value)
    XCTAssertEqual(result.data.first?.value, "hoge")
    if let name = result.data.first?.name {
      switch name {
      case LabelTypes.ATOM:
        XCTAssertTrue(true)
      default:
        XCTFail()
      }
    }
  }


  func execTest(expectList: [(String, Result)], lexer: $) {
    for tuple in expectList {
      let real =  lexer.apply(tuple.0)
      let expect = tuple.1
      assert(real, expect)
    }
  }

  /* tokenize test */
  func testInit() {

    let real = emptyLexer.apply("")

    let expect = Result.trueResult("", index: 0, data: [])
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.first?.value, "")
  }

  /* tokenize test */
  func testInitParseInValid() {

    let real = emptyLexer.apply("ll")
    let expect = Result.falseResult("ll", index: 0)
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.count, expect.data.count)
  }

  func testTokenizeParseInValidString() {

    let expect = Result.falseResult("hoge", index: 0)

    let testList = [
      "foobar",
      "3hoge",
      "ho--ge"
    ]
    for real in testList.map({ hogeLexer.apply($0) }) {
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data.count, expect.data.count)
    }
  }
}

