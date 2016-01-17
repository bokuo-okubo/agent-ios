//
//  CSRouter.swift
//  agent-ios
//
//  Created by Yohei Okubo on 1/10/16.
//  Copyright © 2016 bko. All rights reserved.
//

import Foundation

class CSRouter {

  typealias Server = PseudoServer

  var route: [String: Server.MiddleWare]

  init(routemap: Server.RouteMap) {
    let mid = Server.MiddleWare(funcs:[Server.Acts.notFound])
    self.route = ["*": mid]

    routemap.forEach({ path, handlers in
      register(path, handlers: handlers)
    })
  }

  private func register(path: String, handlers: [Server.Responsible]) {
    if !self.route.keys.contains(path) {
      self.route[path] = Server.MiddleWare(funcs: handlers)
    }
  }

  func handle(req: Server.Request, res: Server.Response) -> Server.Response {
    if let path = req["path"] {
      if let middle = self.route[path] {
        return middle.handle(req, res: res)
      } else {
        return res.payload("404 NOT FOUND")
      }
    } else {
      return res.payload("BAD REQUEST")
    }
  }
}
