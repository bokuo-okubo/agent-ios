//
//  CSPathCompiler.swift
//  agent-ios
//
//  Created by Yohei Okubo on 12/28/15.
//  Copyright © 2015 bko. All rights reserved.
//

protocol Compiler {
  typealias Target
  typealias Result
  func compile(_: Target) -> Result
}

struct CSPathCompiler: Compiler {

  let validator: CSLexer

  init(validator: CSLexer) {
    self.validator = validator
  }
  /**
   URLPathSchemeの文字列を渡すと、そのSchemeに対応した、RealPathLexerを返す

   - parameter pathScheme: "/:id" 等を含んだURLScheme

   - returns: lexer
   */
  func compile(pathScheme: String) -> CSLexer {
    let result = self.validator.apply(pathScheme)
    switch result.isSuccess {
    case true:
      return toLexers(result.data)
    default:
      return CSLexer.create()
    }
  }

  private func toLexers(tokens: [CSToken]) -> CSLexer {
    return CSLexer.seq(tokens.map { createCSPathLexer($0) })
  }

  private func createCSPathLexer(token: CSToken) -> CSLexer {
    switch token.name {
    case "PATH":
      return CSPathLexers.realPathLexer()
    case "PARAM":
      return CSPathLexers.realParamLexer(token.value)
    default:
      return CSLexer.create()
    }
  }
}
