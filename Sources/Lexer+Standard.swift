//
//  Lexer+Standard.swift
//  Egg : the Swift lexerizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

public protocol Standard {

  typealias Result: LexResultable

  /**
   受け取った複数個のLexerのうち、一つでもTrueならば全体としてもTrueを返すLexerを返す

   ```
   let hogeLex = Lexer.create("hoge")
   let fooLex = Lexer.create("foo")

   let hogeFooLex = Lexer.or(hogeLex, fooLex) // (this is also OK) Lexer.or([hogeLex, fooLex])

   hogeFooLex.apply("hoge") // true
   hogeFooLex.apply("foo") //true

   hogeFooLex.apply("hoo") //false
   ```

   */
  static func or(parsers: [Lexer<Result>]) -> Lexer<Result>
  static func or(parsers: Lexer<Result>...) -> Lexer<Result>

  /*
  受け取った複数のLexerのsymbolの並びと
  対象文字列が同じように並んでいる際にTrueを返すようなLexerを返す
  */
  static func seq(lexers: Lexer<Result>...) -> Lexer<Result>
  static func seq(lexers: [Lexer<Result>]) -> Lexer<Result>
  /**
   幾つかのLexerを組み合わせた際に、読み取り対象文字列の一番最後まで読み取ったことを保証する

   ```
   let hogeLex = Lexer.create("hoge")
   let fooLex = Lexer.create("foo")

   let eof = Lexer.eof()

   let hogeFooEOFLex = Lexer.seq(hogeLex, fooLex, eof)

   hogeFooLex.apply("hogefoo") // true

   hogeFooLex.apply("hoge") //false
   ```
   
   */
  static func eof(str: String) -> Lexer<Result>
  static func eof() -> Lexer<Result>

  /**
   連続して同じパターンが登場する際にTrueを返す

   ```
   let hogeLex = Lexer.create("hoge")

   let manyHogeLex = Lexer.many(hogeLex)

   manyHogeLex.apply("hoge") // true
   manyHogeLex.apply("hogehogehoge") // true
   manyHogeLex.apply("hogehogefoo") // true

   hogeFooLex.apply("foo") //false
   hogeFooLex.apply("foohogehoge") //false
   ```
   
   */
  static func many(lexer: Lexer<Result>) -> Lexer<Result>
  /**
   受け取った文字列をCharacterに分解し、そのうちのどれかの文字を読み取ったさいに
   Trueを返すようなLexerを返す

   ```
   let alphaLexer = Lexer.char("abcdefghijklmnopqrstuvwxyz")

   alphaLexer.apply("a") // true
   alphaLexer.apply("b") // true
   alphaLexer.apply("d") // true

   alphaLexer.apply("7") // false
   ```
   
   */
  static func char(str: String) -> Lexer<Result>

  /**
   受け取ったLexerの真偽判定をひっくり返す
   */
  static func not(lexer: Lexer<Result>) -> Lexer<Result>

  /**
   何を読んでもcursorを進めるようなLexerを返す
   */
  static func option(lexer: Lexer<Result>) -> Lexer<Result>
}

extension Lexer: Standard {

 public static func or(lexers: [Lexer]) -> Lexer {
    return Lexer(
      name: LexType.OR,
      method: Strategies.orMethod(lexers.map { $0.method })
    )
  }
  public static func or(lexers: Lexer...) -> Lexer {
    return or(lexers)
  }


  public static func seq(lexers: [Lexer]) -> Lexer {
    return Lexer(
      name: LexType.SEQ(lexers.map { $0.name }),
      method: Strategies.seqMethod(lexers.map { $0.method })
    )
  }
  public static func seq(lexers: Lexer...) -> Lexer {
    return seq(lexers)
  }


  public static func eof(str: String) -> Lexer {
    let lexer = Lexer.create(str)
    return Lexer(
      name: LexType.EOF,
      method: Strategies.eofMethod(lexer.method)
    )
  }
  public static func eof() -> Lexer {
    return Lexer(
      name: LexType.EOF,
      method: Strategies.eofMethod()
    )
  }

  public static func many(lexer: Lexer) -> Lexer {
    return Lexer(
      name: LexType.MANY(lexer.name),
      method: Strategies.manyMethod(lexer.method)
    )
  }


  public static func char(str: String) -> Lexer {
    let charSet = Set(str.characters)
    let lettersT = charSet.map({ char in Lexer.create(String(char)) })
    return or(lettersT)
  }

  public static func not(lexer: Lexer) -> Lexer {

    return Lexer(
      name: LexType.NOT(lexer.name),
      method: Strategies.notMethod(lexer.method)
    )
  }
  public static func option(lexer: Lexer) -> Lexer {
    
    return Lexer(
      name: LexType.OPTION(lexer.name),
      method: or(lexer, not(lexer)).method
    )
  }
}


/**
 *  Closureを生成する構造体
 *  各LexingMethodに対応するアルゴリズムの実体
 */
private struct Strategies<Result: LexResultable> {

  /// Lexing : 文字列を解析するものは必ずこの型の関数を持つ
  typealias Lexing = (target: String, cursor: Int) -> Result

  static func orMethod(methods: [Lexing]) -> Lexing {
    return { (target: String, cursor: Int) -> Result in
      let results: [Result] = methods.map { $0(target: target, cursor: cursor) }
      let first: Result = Result.falseResult(target, index: cursor)
      return results.reduce(first) { $0.isSuccess ? $0 : $1 }
    }
  }

  static func eofMethod(method: Lexing) -> Lexing {
    return { (target: String, cursor: Int) -> Result in
      let result = method(target: target, cursor: cursor)
      return result.override(index: -1, data: [])
    }
  }

  static func eofMethod() -> Lexing {
    return { (target: String, cursor: Int) -> Result in
      let isLast = cursor == target.characters.count
      if isLast {
        return Result.trueResult(target, index: -1, data: [])
      } else {
        return Result.falseResult(target, index: cursor)
      }
    }
  }

  static func manyMethod(method: Lexing) -> Lexing {
    return { (target: String, cursor: Int) -> Result in
      var current: Int = cursor
      var rtnData: [Result.Content] = []
      while true {
        let result = method(target: target, cursor: current)
        if result.isSuccess {
          rtnData.appendContentsOf(result.data)
          current = result.index
        } else {
          break
        }
      }

      if rtnData.count > 0 {
        return Result.trueResult(target, index: current, data: rtnData)
      } else {
        return Result.falseResult(target, index: current)
      }
    }
  }

  static func notMethod(method: Lexing) -> Lexing {
    return { (target: String, cursor: Int) -> Result in
      let result = method(target: target, cursor: cursor)
      return result.isSuccess
        ? Result.falseResult(target, index: cursor)
        : Result.trueResult(target, index: cursor, data: [])
    }
  }

  static func seqMethod(methods: [Lexing]) -> Lexing {
    return { (target: String, cursor: Int) -> Result in

      var rtnData: [Result.Content] = []
      var current = cursor

      for method in methods {
        let result = method(target: target, cursor: current)

        if result.isSuccess {
          rtnData.appendContentsOf(result.data)
          current = result.index
        } else {
          return Result.falseResult(target, index: cursor)
        }
      }
      return Result.trueResult(target, index: current, data: rtnData)
    }
  }
}
