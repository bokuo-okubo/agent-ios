//
//  lexer.swift
//  Egg
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

/**
*  Lexerのようなもの
*/
public protocol Lexable {

  typealias Result: LexResultable

  /// 実際にLexingする時の関数
  typealias Lexing = (target: String, cursor: Int) -> Result
  var method: Lexing { get }

  /**
   単独のLexerを生成

   - parameter symbol: true判定になる文字列 空文字の場合、空文字を読み取るLexerが返る

   - returns: symbolをキャプチャしたLexer
   */
  static func create(symbol: String) -> Self
  static func create() -> Self

  /**
   実際の文字列をLexingする

   - parameter target: 対象となる文字列

   - returns: Lexingの結果
   */
  func apply(target: String) -> Result
}

/* private utility functions*/

private func atomName(str: String) -> String {
  return NameCreater.wrap(("ATOM(",")"))(name: str)
}

private func isEqualString(target: String, symbol: String, cursor: Int) -> Bool {
  let range = stringRange(target, from: cursor, to: symbol.characters.count)
  let isTooShort = target.characters.count < symbol.characters.count
  return target.substringWithRange(range) == symbol && !isTooShort
}

/**
 ある文字列を受け取った時に、それが正しい文字列ならばtrueを返し、
 strueならば、Tokenの列を返すようなLexerを返す

 ```
 let hogeLexer = Lexer.create("hoge") // -> "hoge" という文字列を読んだ時にtrueを返すLexer
 let exactStr = "hoge"
 let wrongStr = "foo"

 // true
 hogeLexer.apply(exactStr)
 //-> LexResult(isSuccess: true, target: "hoge",  index: 4, data: [Token(type: ATOM, value: "hoge")])

 // false
 hogeLexer.apply(weongStr)
 //-> LexResult(isSuccess: false, target: "foo",  index: 0, data: [])

 ```

 - parameter type:   Lexerの種類を表すEnum debug用　(コンソールでLexerの構文木が見られる)
 - parameter method: Lexing = (target: String, cursor: Int) -> LexResult 生成されるlexerが行う処理の本体
 - target: String 実際に読みにいく生の文字列
 - cursor: Int 現在読んでいるsrcの位置.次のlexerに渡す.
 - returns: Lexable
 */
public struct Lexer<Result: LexResultable>: Lexable {

  public typealias Lexing = (target: String, cursor: Int) -> Result

  /// デバッグ用
  internal let name: String

  public let method: Lexing

  // MARK: - static methods -
  init(name: String, method: (target: String, cursor: Int) -> Result) {
    self.name = name
    self.method = method
  }

  public static func create(symbol: String) -> Lexer {
    if symbol.characters.count == 0 {
      return create()
    }
    return Lexer(name: atomName(symbol), method: Strategies.createMethod(symbol))
  }

  public static func create() -> Lexer {
    return Lexer(name: LexType.EMPTY, method: Strategies.emptyMethod())
  }

  // MARK: - instance methods -
  public func apply(target: String) -> Result {
    return self.method(target: target, cursor: 0)
  }

  public func map(method: Lexer -> Lexing) -> Lexer {
    return Lexer(
      name: LexType.MAP,
      method: method(self)
    )
  }

  public func unify(name name: String) -> Lexer {
    return Lexer(
      name: LexType.UNIFY,
      method: Strategies.unifyMethod(name, method: self.method)
    )
  }

  public func unify(name name: String, key: String) -> Lexer {
    return Lexer(
      name: LexType.UNIFY,
      method: Strategies.unifyMethod(name, key: key, method: self.method)
    )
  }

  public func concat() -> Lexer {
    return Lexer(
      name: LexType.CONCAT,
      method: Strategies.concatMethod(self.method)
    )
  }
}

/**
 *  Lexerのための関数コンテナ
 */
private struct Strategies<Result: LexResultable> {

  private typealias Lexing = (target: String, cursor: Int) -> Result

  private static func createMethod(symbolStr: String) -> Lexing {
    /* target文字列とSymbolStrが同じならTrue */
    return { (target: String, cursor: Int) -> Result in
      if isEqualString(target, symbol: symbolStr, cursor: cursor) {
        return Result.trueResult(
          target,
          index: cursor + symbolStr.characters.count,
          data: [Result.Content.create(value: symbolStr)]
        )
      } else {
        return Result.falseResult(target, index: cursor)
      }
    }
  }

  private static func emptyMethod() -> Lexing {
    /* target文字列が""ならTrue */
    return { (target: String, cursor: Int) -> Result in
      if target.characters.count == 0 {
        return Result.trueResult(
          target,
          index: cursor,
          data: [ Result.Content.create() ]
        )
      } else {
        return Result.falseResult(target, index: cursor)
      }
    }
  }

  private static func unifyMethod(name: String, key: String? = nil, method: Lexing) -> Lexing {
    /* Resultで返るTokenを一つにまとめる*/
    switch key {
    case.Some:
      return { (target: String, cursor: Int) -> Result in
        let result: Result = method(target: target, cursor: cursor)
        return result.override(
          index: result.index,
          data:  [result.data.unify(name: name, key: key!)]
        )
      }
    case.None:
      return { (target: String, cursor: Int) -> Result in
        let result: Result = method(target: target, cursor: cursor)
        return result.override(
          index: result.index,
          data:  [result.data.unify(name: name)]
        )
      }
    }
  }

  private static func concatMethod(method: Lexing) -> Lexing {
    /* Resultで返るTokenを一つにまとめる*/
    return { (target: String, cursor: Int) -> Result in
      let result: Result = method(target: target, cursor: cursor)
      return result.override(index: result.index, data: [result.data.concat()] )
    }
  }
}
