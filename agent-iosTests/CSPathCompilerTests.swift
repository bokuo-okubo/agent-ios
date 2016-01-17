//
//  CSPathParserTests.swift
//  agent-ios
//
//  Created by Yohei Okubo on 1/6/16.
//  Copyright © 2016 bko. All rights reserved.
//

import XCTest
import Egg

@testable import agent_ios

class CSPathCompilerTests: XCTestCase {

  let validTestPathScheme = "/api/:version/entries/:id/assess"
  let validTestPathReal = "/api/v1/entries/123/assess"
  

  func testCompileMethodWhenHandOffAValidURLPath() {
    let compiler = CSPathCompiler(validator: CSPathLexers.pathSchemeL)

    let realPathLexer = compiler.compile(validTestPathScheme)

    let result: CSLexResult = realPathLexer.apply(validTestPathReal)
    XCTAssert( result.isSuccess == true)

    XCTAssertEqual(result.params, ["/:version":"/v1","/:id" : "/123"])

    let (path, param) = ("REALPATH", "REALPARAM")
    let expectKeys = ["/api", "/:version", "/entries", "/:id", "/assess"]
    let expectVals = ["/api", "/v1", "/entries", "/123", "/assess"]
    let expectNames = [path, param, path, param, path]

    for (token, expect) in zip(result.data, expectVals) {
      XCTAssertEqual(token.value, expect)
    }

    let testSeq = zip( zip(result.data, expectKeys), expectNames)
    for ((token, expect), name) in testSeq {
      XCTAssertEqual(token.label.key, expect)
      XCTAssertEqual(token.label.name, name)
    }
  }
}
