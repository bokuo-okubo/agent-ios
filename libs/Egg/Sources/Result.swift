//
//  Result.swift
//  Egg
//
//  Created by Yohei Okubo on 1/12/16.
//  Copyright © 2016 bko. All rights reserved.
//

/**
 *  結果を運ぶコンテナ 抽象度高い。 Eggに全然依存しない
 */
public protocol Resultable {

  var isSuccess: Bool { get }
  var target: String { get }
  var index: Int { get }
  typealias Content
  var data: [Content] { get }

  /**
   公開イニシャライザ

   - parameter isSuccess: 処理が成功したかどうか
   - parameter target:    処理を行った対象
   - parameter index:     現在の読み位置
   - parameter data:      実際のデータ

   - returns: Resultable
   */
  static func create(isSuccess isSuccess: Bool, target: String, index: Int, data: [Content]) -> Self
}

// MARK: - ResultableのPromiseライクな実装
public protocol Promise: Resultable {
  typealias Content
}
extension Promise {
  /**
   前のResultの後に処理を付け加えるためのメソッド monadic: >>=

   - parameter method: indexとdataを引数に取り、Resultを返すような関数

   - returns: method適用を行った後のResult. 前の結果がfalseの場合はfalseのまま返す
   */
  public func then(method: (index: Int, data: [Content]) -> Self ) -> Self {
    switch self.isSuccess {
    case true:
      return method(index: self.index, data: self.data)
    case false:
      return Self.create(isSuccess: false, target: self.target, index: self.index, data: [])
    }
  }
}
