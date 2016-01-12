//
//  TokenTests.swift
//  Egg
//
//  Created by Yohei Okubo on 1/11/16.
//  Copyright © 2016 bko. All rights reserved.
//

import XCTest
@testable import Egg

class TokenTests: XCTestCase {

  let hogeToken = Token.create(value: "hoge")
  let fooToken = Token.create(value: "foo")

  func testToken() {
    XCTAssertEqual(hogeToken.name, "ATOM")
    XCTAssertEqual(hogeToken.value, "hoge")
  }

  func testArrayExtensionUnifyWithName() {
    let tokens: [Token] = [hogeToken, fooToken]
    let newName = "UNIFIED(HOGE,FOO)"
    let newToken = tokens.unify(name: newName)
    XCTAssertEqual(newToken.name, newName)
    XCTAssertEqual(newToken.value, hogeToken.value + fooToken.value)
  }

  func testArrayExtensionUnifyWithNameAndKey() {
    let tokens: [Token] = [hogeToken, fooToken]
    let newName = "new"
    let newToken = tokens.unify(name: newName, key: "keen")
    XCTAssertEqual(newToken.name, newName)
    XCTAssertEqual(newToken.key, "keen")
    XCTAssertEqual(newToken.value, hogeToken.value + fooToken.value)
  }

}
