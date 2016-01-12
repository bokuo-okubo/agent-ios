//
//  Token+StandardTests.swift
//  Egg
//
//  Created by Yohei Okubo on 12/24/15.
//  Copyright © 2015 bko. All rights reserved.
//

import XCTest
@testable import Egg

class Token_StandardTests: EggTestBase {

  typealias $ = Egg

  let hogeT = $.tokenize("hoge")
  let fooT = $.tokenize("foo")

  let expectFailResult = TokenResult(isSuccess: false, index: 0, tokenized: [])

  func testOrMethodParseValidString() {

    let hogeOrFooT = $.or(hogeT, fooT)

    let expectHoge = TokenResult(
      isSuccess: true,
      index: "hoge".characters.count,
      tokenized: ["hoge"]
    )
    let expectFoo = TokenResult(
      isSuccess: true,
      index: "foo".characters.count,
      tokenized: ["foo"]
    )

    let testList = [
      ("hoge", expectHoge),
      ("foo", expectFoo),
      ("hogefoo", expectHoge),
      ("foohoge", expectFoo)
    ]
    execTest(testList, token: hogeOrFooT )
  }

  func testOrTokenParseIvalidString() {

    let HogeOrFooT = $.or(hogeT, fooT)

    let expect = expectFailResult

    let testList = [
      "ugaa",
      "hogfoo",
      "fohoge",
      ].map({ ($0, expect)})

    execTest(testList, token: HogeOrFooT)
  }

  func testNotTokenParseValidString() {

    let NotHogeT = $.not(hogeT)

    let testList = [
      "foo",
      "あいうえお",
      "0123456"
      ].map({
        ($0, TokenResult(isSuccess: true, index: $0.characters.count, tokenized: []))
      })

    execTest(testList, token: NotHogeT)
  }

  func testNotTokenParseIvalidString() {

    let NotHogeT = $.not(hogeT)

    let expect = TokenResult(isSuccess: false, index: 0, tokenized: [])

    let testList = [("hoge", expect)]

    execTest(testList, token: NotHogeT)
  }

  /**
   Sequenceのテスト
   */
  func testSeqTokenParseValidString() {
    let HogeFooT = $.seq(hogeT, fooT)
    let real = HogeFooT.resolve("hogefoo")
    let expect = TokenResult(isSuccess: true, index: 7, tokenized: ["hoge", "foo"])
    assert(real, expect)
  }

  func testSeqTokenParseInvalidString() {

    let HogeFooT = $.seq(hogeT, fooT)

    let testList = [
      "hoge",
      "foo",
      "hogfoo",
      "foohog"
      ].map({ ($0, expectFailResult )})
    execTest(testList, token: HogeFooT)
  }

  func testManyOrParse() {
    let hogeOrFooT = $.or(hogeT, fooT)
    let manyHogeOrFooT = $.many(hogeOrFooT)
    let testStr = "hogefoohogefoo"

    let real = manyHogeOrFooT.resolve(testStr)
    let expect = TokenResult(isSuccess: true,
      index: testStr.characters.count,
      tokenized: ["hoge", "foo", "hoge", "foo"])
    assert(real, expect)
  }
}
