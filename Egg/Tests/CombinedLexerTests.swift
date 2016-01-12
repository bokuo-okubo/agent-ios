//
//  CombinedTokenTests.swift
//  Egg
//
//  Created by Yohei Okubo on 12/24/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation
import XCTest
@testable import Egg

class CombinedLexerTests: XCTestCase {

  func testParamT() {
    let testStr = "/:hoge"
    let real = paramT.apply(testStr)
    let expect = LexResult.trueResult(testStr,
      index: testStr.characters.count,
      data: [Token.create(value: "/:hoge")])

    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.count, expect.data.count)

  }

  func testParamSeparatorT() {
    let testStr = "/:"
    let real = paramSepalatorT.apply(testStr)
    let expect = LexResult.trueResult(testStr,
      index: testStr.characters.count,
      data: testStr.characters.map { Token.create(value: String($0)) })

    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.count, expect.data.count)
  }

  func testManyPathAndParamT() {
    let entryAPIScheme =  "/api/:version/entries/:id/assess"
    let expectTokenized = [ "/api", "/:version", "/entries", "/:id", "/assess"]

    let expect = LexResult.trueResult(
      entryAPIScheme,
      index: entryAPIScheme.characters.count,
      data: expectTokenized.map { Token.create(value: $0) })
    let real = manyPathAndParamT.apply(entryAPIScheme)

    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.count, expect.data.count)

  }

  func testUrlHoge() {
    let entryAPIScheme =  "/api/:version/entries/:id/assess"
    let expectTokenized = [ "/api", "/:version", "/entries", "/:id", "/assess"]

    let expect = LexResult.trueResult(
      entryAPIScheme,
      index: -1,
      data: expectTokenized.map { Token.create(value: $0) })
    let real = MockToken.urlPathSchemeToken.apply(entryAPIScheme)

    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data.count, expect.data.count)

  }

  func testUrlPathTokenParsesValidString() {
    let entryAPISchemes = [
      "/api/:version/entries/:id/assess",
      "/api/:version/entries/:id/assess/:foo:bar"
    ]
    let expectTokenizeds: [[String]] = [
      [ "/api", "/:version", "/entries", "/:id", "/assess"],
      ["/api", "/:version", "/entries", "/:id", "/assess", "/:foo", ":bar"]
    ]

    for (expectTokenized, entryAPIScheme) in zip(expectTokenizeds, entryAPISchemes) {
      let expect = LexResult.trueResult(entryAPIScheme, index: -1, data: expectTokenized.map { Token.create(value: $0) })

      let real = MockToken.urlPathSchemeToken.apply(entryAPIScheme)
      XCTAssertEqual(real.target, expect.target)
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data.count, expect.data.count)
    }
  }
}
