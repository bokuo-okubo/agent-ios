//
//  CSLexResult.swift
//  agent-ios
//
//  Created by Yohei Okubo on 1/6/16.
//  Copyright © 2016 bko. All rights reserved.
//

import Foundation
import Egg

struct CSRealPathTokenType {
  static let REALPATH  = "REALPATH"
  static let REALPARAM = "REALPARAM"
  static let EMPTY = "EMPTY"
}

/**
 *  Egg.LexResultに、Paramプロパティを追加した形のもの
 */
struct CSLexResult: Egg.LexResultable {

  typealias Content = Token

  var isSuccess: Bool
  var index: Int
  var target: String
  var data: [Content]

  typealias ParamType = [String : String]
  var params: ParamType = [:]

  private init(isSuccess: Bool, target: String, index: Int, data: [Content], params: ParamType) {
    self.isSuccess = isSuccess
    self.target = target
    self.index = index
    self.data = data
    self.params = params
  }

  static func create(isSuccess isSuccess: Bool, target: String, index: Int, data: [Content]) -> CSLexResult {
    var rtnParams: [String:String] = [:]
    for token in data {
      switch token.label.name {
      case CSRealPathTokenType.REALPARAM:
        rtnParams += [token.label.key : token.value]
      default:
        break
      }
    }

    return self.init(isSuccess: isSuccess, target: target, index: index, data: data, params: rtnParams)
  }

  static func trueResult(target: String, index: Int, data: [Content]) -> CSLexResult {
    return CSLexResult.create(isSuccess: true, target: target, index: index, data: data)
  }

  static func falseResult(target: String, index: Int) -> CSLexResult {
    return CSLexResult(isSuccess: false, target: target, index: index, data: [], params: [:])
  }
}
