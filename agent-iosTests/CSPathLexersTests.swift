//
//  CSPathLexersTests.swift
//  agent-ios
//
//  Created by Yohei Okubo on 1/6/16.
//  Copyright © 2016 bko. All rights reserved.
//

import XCTest
import Egg
@testable import agent_ios

class CSPathLexersTests: XCTestCase {

  func testSchemeLReturnTrueResultWhenParseValidSequencialParamString() {

    let entryAPIScheme = "/api/:version/entries/:id/assess/:foo/:bar/show"

    let path = "PATH"
    let pathparam = "PARAM"
    let expectPartials = [
      ("/api", path),
      ("/:version", pathparam),
      ("/entries", path),
      ("/:id", pathparam),
      ("/assess", path),
      ("/:foo", pathparam),
      ("/:bar", pathparam),
      ("/show", path)
    ]

    let result = CSPathLexers.pathSchemeL.apply(entryAPIScheme)
    XCTAssertEqual(result.isSuccess, true)
    XCTAssertEqual(result.index, -1)
    XCTAssertEqual(result.target, entryAPIScheme)
    XCTAssertEqual(result.data.count, expectPartials.count)
    zip(expectPartials, result.data).forEach {
      XCTAssertEqual($0.0, $1.value)
      switch $1.name {
      case path:
        XCTAssertEqual($0.1, "PATH")
      case pathparam:
        XCTAssertEqual($0.1, "PARAM")
      default:
        XCTFail()
      }
    }
  }

  func testSchemeLReturnTrueResultWhenParseValidString() {

    let entryAPIScheme = "/api/:version/entries/:id/assess"
    let expectPartials = [
      "/api",
      "/:version",
      "/entries",
      "/:id",
      "/assess"
    ]

    let result = CSPathLexers.pathSchemeL.apply(entryAPIScheme)
    XCTAssertEqual(result.isSuccess, true)
    XCTAssertEqual(result.index, -1)
    XCTAssertEqual(result.target, entryAPIScheme)
    XCTAssertEqual(result.data.count, expectPartials.count)
    zip(expectPartials, result.data).forEach {
      XCTAssertEqual($0, $1.value)
    }
  }

  func testSchemeLReturnFalseResultWhenParseInvalidPathParamString() {

    let entryAPIScheme = "/api/:version/entries/:id/assess:hoge"
    let result = CSPathLexers.pathSchemeL.apply(entryAPIScheme)
    XCTAssertEqual(result.isSuccess, false)
    XCTAssertEqual(result.index, 0)
    XCTAssertEqual(result.target, entryAPIScheme)
    XCTAssertEqual(result.data.count, 0)
  }

  func testSchemeLReturnFalseResultWhenParseInvalidPathParamParamLString() {

    let entryAPIScheme = "/api/:version/entries/:id/assess/:foo:bar/show"
    let result = CSPathLexers.pathSchemeL.apply(entryAPIScheme)
    XCTAssertEqual(result.isSuccess, false)
    XCTAssertEqual(result.index, 0)
    XCTAssertEqual(result.target, entryAPIScheme)
    XCTAssertEqual(result.data.count, 0)
  }

  func testRealPathL() {
    let testStr = "/resource"
    let result = CSPathLexers.realPathLexer().apply(testStr)
    XCTAssertEqual(result.isSuccess, true)

    let token = result.data.first!

    switch token.name {
    case CSRealPathTokenType.REALPATH:
      XCTAssertEqual(token.value, testStr)
    default:
      XCTFail()
    }
  }

  func testCreatRealParameLexer() {
    let testkey = "/:id"
    let testTarget = "/12345"

    let lex = CSPathLexers.realParamLexer(testkey)
    let result = lex.apply(testTarget)

    if let token = result.data.first {
      XCTAssertEqual(token.label.name, CSRealPathTokenType.REALPARAM)
      XCTAssertEqual(token.label.key, testkey)
      XCTAssertEqual(token.value, testTarget)

    } else {
      XCTFail()
    }
  }
}
