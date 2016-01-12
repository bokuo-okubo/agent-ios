//
//  LexResult.swift
//  Egg : Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

/**
 *  Egg内でResultを扱う際の起点になるProtocol
 */
public protocol LexResultable: Resultable, Promise {

  typealias Content: Tokenable

  /**
   結果がtrueの時専用のイニシャライザ
   */
  static func trueResult(target: String, index: Int, data: [Content]) -> Self

  /**
   結果がfalseの時専用のイニシャライザ
   */
  static func falseResult(target: String, index: Int) -> Self
}

extension LexResultable {
  /**
   結果を上書きする

   - parameter index: カーソル
   - parameter data:  データ

   - returns: 上書きされたResult
   */
  public func override(index index: Int, data: [Content]) -> Self {
    switch self.isSuccess {
    case true:
      return Self.trueResult(self.target, index: index, data: data)
    case false:
      return Self.falseResult(self.target, index: self.index)
    }
  }
}

/**
 *  Egg内で使うResultableの実体
 */
public struct LexResult: LexResultable {

  public typealias Content = Token

  public let isSuccess: Bool
  public let target: String
  public let index: Int
  public let data: [Content]

  private init(isSuccess: Bool, target: String, index: Int, data: [Content]) {
    self.isSuccess = isSuccess
    self.target = target
    self.index = index
    self.data = data
  }

  public static func create(
    isSuccess isSuccess: Bool,
    target: String,
    index: Int,
    data: [Content]) -> LexResult {
      return LexResult(isSuccess: isSuccess, target: target, index: index, data: data)
  }

  public static func trueResult(target: String, index: Int, data: [Content]) -> LexResult {
    return LexResult(isSuccess: true, target: target, index: index, data: data)
  }

  public static func falseResult(target: String, index: Int) -> LexResult {
    return LexResult(isSuccess: false, target: target, index: index, data: [])
  }
}
