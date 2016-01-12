//
//  lexer+StandardTests.swift
//  Egg
//
//  Created by Yohei Okubo on 12/24/15.
//  Copyright © 2015 bko. All rights reserved.
//

import XCTest
@testable import Egg

class Lexer_StandardTests: XCTestCase {

  typealias Result = LexResult
  typealias $ = Lexer<Result>

  let hogeLexer = $.create("hoge")
  let fooLexer = $.create("foo")

  func assert(real: Result, _ expect: Result) {
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.count, expect.data.count)
  }

  func execTest(targetStrExpectList: [(String, Result)], lexer: $) {
    for tuple in targetStrExpectList {
      let real =  lexer.apply(tuple.0)
      let expect = tuple.1
      assert(real, expect)
    }
  }

  func testOrMethodParseValidString() {

    let hogeOrfooLexer = $.or(hogeLexer, fooLexer)

    let expectHoge = Result.trueResult(
      "hoge",
      index: "hoge".characters.count,
      data: [Token.create(value: "hoge")]) as Result

    let expectFoo = Result.trueResult(
      "foo",
      index: "foo".characters.count,
      data: [Token.create(value: "foo")]) as Result

    let testList = [
      ("hoge", expectHoge),
      ("foo", expectFoo),
    ]
    for (tag, expect) in testList {
      let real = hogeOrfooLexer.apply(tag)
      XCTAssertEqual(real.target, expect.target)
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data.count, expect.data.count)
    }
  }

  func testOrMethodParseWithTripleLexer() {
    let hogeOrfooOrBarLexer = $.or(hogeLexer, fooLexer, $.create("bar"))
    let testStrss = ["hoge", "foo", "bar"]
    let results = testStrss.map { hogeOrfooOrBarLexer.apply($0)}
    zip(results, testStrss).forEach { (res: Result, exp: String) -> () in
      XCTAssertEqual(res.data.first?.value, exp)
    }
  }

  private func genFalse(target: String) -> Result {
    return Result.falseResult(target, index: 0) as Result
  }

  func testOrlexerParseIvalidString() {

    let HogeOrfooLexer = $.or(hogeLexer, fooLexer)

    let testList = [
      "ugaa",
      "hogfoo",
      "fohoge",
      ].map({ ($0, genFalse($0))})

    execTest(testList, lexer: HogeOrfooLexer)
  }

  func testNotlexerParseValidString() {

    let NothogeLexer = $.not(hogeLexer)

    let testList = [
      "foo",
      "あいうえお",
      "0123456"
      ].map({
        ($0, Result.trueResult($0, index: 0, data: []) as Result)
      })

    for (tag, expect) in testList {
      let real = NothogeLexer.apply(tag)
      XCTAssertEqual(real.target, expect.target)
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data.count, expect.data.count)
    }
  }

  func testNotlexerParseIvalidString() {

    let NothogeLexer = $.not(hogeLexer)

    let testList = [("hoge", genFalse("hoge"))]

    execTest(testList, lexer: NothogeLexer)
  }

  /**
   Sequenceのテスト
   */
  func testSeqlexerParseValidString() {
    let HogefooLexer = $.seq(hogeLexer, fooLexer)
    let real = HogefooLexer.apply("hogefoo")
    let expect = Result.trueResult("hogefoo",
      index: "hogefoo".characters.count,
      data: [Token.create(value: "hoge"), Token.create(value: "foo")])
    assert(real, expect)
  }

  func testSeqlexerParseInvalidString() {

    let HogefooLexer = $.seq(hogeLexer, fooLexer)

    let testList = [
      "hoge",
      "foo",
      "hogfoo",
      "foohog"
      ].map({ ($0, genFalse($0) )})
    execTest(testList, lexer: HogefooLexer)
  }

  func testManyHogeString() {
    let testStr = "hogehoge"
    let manyHoge = Lexer.many(hogeLexer)
    let real = manyHoge.apply(testStr)
    let expect = Result.trueResult(testStr, index: testStr.characters.count, data: [Token.create(value: "hoge"), Token.create(value: "hoge")])
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.count, expect.data.count)
  }

  func testManyOrParseValidString() {
    let hogeOrfooLexer = $.or(hogeLexer, fooLexer)
    let manyHogeOrfooLexer = $.many(hogeOrfooLexer)
    let testStr = "hogefoohogefoo"

    let hogeT = Token.create(value: "hoge")
    let fooT = Token.create(value: "foo")

    let real = manyHogeOrfooLexer.apply(testStr)
    let expect = Result.trueResult(testStr,
      index: testStr.characters.count,
      data: [hogeT, fooT, hogeT, fooT])
    assert(real, expect)
  }

  func testManyOrParseInValidString() {
    let hogeOrfooLexer = $.or(hogeLexer, fooLexer)
    let manyHogeOrfooLexer = $.many(hogeOrfooLexer)
    let testStr = "hogfohogfo"

    let real = manyHogeOrfooLexer.apply(testStr)
    let expect = Result.falseResult(testStr, index: 0)
    assert(real, expect)
  }


  func testCharParseValidString() {
    let alphaStr = "abcdefghijklmnopqrstuvwxyz"
    let alphaT = $.char(alphaStr)

    let testStrList = alphaStr.characters.map({ String($0)})
    let tuples = testStrList.map({
      ($0, Result.trueResult($0, index: $0.characters.count, data: [Token.create(value: $0)]) as Result)
    })
    execTest(tuples, lexer: alphaT)
  }

  func testCharParseInValidString() {
    let alphaStr = "abcdefghijklmnopqrstuvwxyz"
    let alphaT = $.char(alphaStr)

    let testStrList = "0123456789!@#$%^&*()_+|[]{}'/?!,.<>".characters.map({ String($0) })
    let tuples = testStrList.map({
      ($0, Result.falseResult($0, index: 0) as Result)
    })
    //execTest(tuples, lexer: alphaT)
    for (tag, expect) in tuples {
      let real = alphaT.apply(tag)
      XCTAssertEqual(real.target, expect.target)
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data.count, expect.data.count)
    }
  }
}
