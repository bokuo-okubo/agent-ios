//
//  CSPathLexers.swift
//  agent-ios
//
//  Created by Yohei Okubo on 12/14/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Egg

// agent-iOS内でのEggの型指定
typealias CSLexer = Lexer<CSLexResult>
typealias EggLexer = Lexer<LexResult>
typealias CSToken = Egg.Token

/********************
 ** ATOMS (private) **
 *********************/
private typealias $ = CSLexer
// "/"
private let slashL = $.create("/")
// ":"
private let colonL = $.create(":")
// "/"
private let pathSpL = slashL
// ":"
private let paramSpL = colonL
// "/:"
private let pathParamSpL = $.seq(slashL, colonL)
// 'a', 'b', 'c' ...
private let alphaL = $.char("abcdefghijklmnopqrstuvwxyz")
// '0', '1', '2'...
private let numberL = $.char("0123456789")
// "hfjdska", "jf9384"
private let urlCharsL = $.many( $.or(alphaL, numberL) )

private let realParamL = $.seq(slashL, urlCharsL.concat())


/********************************
 ** COMBINED PARSERS (internal) **
 *********************************/
 /*
 [pathL, pathL]            /foo/bar    | OK -> alse many OK
 [pathL, pathParamL]       /foo/:baz   | OK
 [pathParamL, pathL]       /:baz/foo   | OK
 [pathParamL, pathParamL]  /:baz/:foo  | OK -> also many OK
 [pathParamL, paramL]      /:baz:foo   | OK? NG? -> NG.
 */
internal struct CSPathLexers {

  // "/foo/:hoge/piyo/fuga"
  // < /hoge [ /huga | /:piyo ]... >
  static let pathSchemeL = $.seq(pathL, $.many( $.or(pathL, pathParamL)), $.eof() )

  // path token "/hoge", "/foo"
  static let pathL = $.seq(pathSpL, urlCharsL).unify(name: "PATH")

  // param token "/:hoge"
  static let pathParamL = $.seq(pathParamSpL, urlCharsL).unify(name: "PARAM")

  // 前のTokenが持っていたValueを次のTokenのKeyにする
  static func realParamLexer(key: String) -> CSLexer {
    return realParamL.unify(name: "REALPARAM", key: key)
  }

  static func realPathLexer() -> CSLexer {
    return pathL.unify(name: "REALPATH")
  }
}
