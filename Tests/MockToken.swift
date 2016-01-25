//
//  MockToken.swift
//  Egg
//
//  Created by Yohei Okubo on 12/24/15.
//  Copyright © 2015 bko. All rights reserved.
//

@testable import Egg

typealias $ = Lexer<LexResult>

/**
 *  Test Utility
 */
struct MockToken {
  
  static let urlPathSchemeToken = $.seq( manyPathAndParamT, $.eof() )
}

// "/"
let slashT = $.create("/")

// ":"
let colonT = $.create(":")

// "/"
let pathSepalatorT = slashT

// ["/:" | ":"]
let paramSepalatorT = $.or(colonT, $.seq(slashT, colonT))

// 'a', 'b', 'c' ...
let alphaT = $.char("abcdefghijklmnopqrstuvwxyz")

// "abc", "hoge" ...
// private let alphasT = $.many(alphaT)

// '0', '1', '2'...
let numberT = $.char("0123456789")

// '00', '123', '2'...
// private let numbersT = $.many(numberT)

// "hfjdska", "jf9384"
let urlCharsT = $.many( $.or(alphaT, numberT) ) // ID

// path token "/hoge", "/foo"
let primitivepathT = $.seq( pathSepalatorT, urlCharsT ).concat()

// private let pathT = $.map(primitivepathT, callback: callback )
let pathT = primitivepathT

// param token "/:hoge", ":hoge"
let paramT = $.seq( paramSepalatorT, urlCharsT ).concat()

let manyPathAndParamT = $.many($.or(paramT, pathT))
