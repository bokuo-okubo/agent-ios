////
////  PseudoServer.swift
////  ReactNativeWithPods
////
////  Created by Yohei Okubo on 11/26/15.
////  Copyright © 2015 bko. All rights reserved.
////
//
//import Foundation
//import Dollar
//
//struct PseudoServer {
//
//    /* -----------------------------------------------
//    *   main
//    *  ----------------------------------------------- */
//    static let ROUTE: RouteMap = [
//        "/foo": [Acts.session, Acts.auth],
//        "/bar": [Acts.session ]
//    ]
//
//    static func query(path:String) -> Response {
//
//        let router = Router(routemap: ROUTE)
//        let server = Server(router: router)
//
//        return invoke(server, path: path)
//    }
//
//    private static func invoke(server: Server, path: String) -> Response {
//        let req: Request = ["path": path]
//        return server.call(req, res: Response() );
//    }
//
//
//    struct Acts {
//
//        static let session: Responsible = { req, res -> Response in
//            res.payload("SESSION wirte")
//            return res
//        }
//
//        static let auth: Responsible = { req, res -> Response in
//            return res
//        }
//    }
//
//    /* ----------------------------------------------- */
//
//    typealias RouteMap = [String : [Responsible]]
//
//    typealias Responsible = (Request,Response) -> Response
//
//    typealias Request = Dictionary<String,String>
//
//    /* ----------------------------------------------- */
//
//    class Response {
//
//        // TODO : wrap primitive response type
//        var header : [String]
//        var payload : [String]
//
//        convenience init() {
//            self.init(header: [""], payload: [""])
//        }
//
//        init(header: [String], payload: [String]) {
//            (self.header,self.payload) = (header,payload)
//        }
//
//        func header(header: String...) -> Response {
//            self.header += header
//            return self
//        }
//
//        func payload(payload: String...) -> Response {
//            self.payload += payload
//            return self
//        }
//
//        func end() -> Response {
//            p("end:", header.debugDescription, payload.debugDescription )
//            return self
//        }
//    }
//
//    /* ----------------------------------------------- */
//
//    class MiddleWare {
//
//        var stack: [ Responsible ]
//
//        init(funcs: [ Responsible ] ) { stack = funcs }
//
//        func handle(req: Request, res:Response) -> Response{
//            return MiddleWare.reduce(self.stack, req: req, res: res)
//        }
//
//        func register(fn: Responsible) {
//            self.stack += [fn]
//        }
//
//        static func reduce(stack: [Responsible], req: Request, res:Response) -> Response{
//            if stack.count == 0 {
//                return res
//            }
//            let (first, left) = ( stack.first!, stack.dropFirst() )
//            let rtn_res = first(req, res)
//            self.reduce(Array(left), req: req, res: rtn_res)
//            return res // いらないはず
//        }
//    }
//    /* ----------------------------------------------- */
//
//    class Router {
//        var route: [String: MiddleWare]
//
//        init() {
//            let mid = MiddleWare(funcs: <#T##[Responsible]#>)
//        }
//
//        private func register(path: String, handlers: [Responsible]) {
//            if !self.route.keys.contains(path) {
//                self.route[path] = MiddleWare(funcs: handlers)
//            }
//        }
//
//        func handle(req: Request, res: Response)-> Response {
//            if let path = req["path"] {
//                if let middle = self.route[path] {
//                    return middle.handle(req, res: res)
//                } else {
//                    return res.payload("404 NOT FOUND")
//                }
//            } else {
//                return res.payload("BAD REQUEST")
//            }
//        }
//    }
//
//    /* ----------------------------------------------- */
//    class Server {
//
//        let router: Router
//
//        init(router: Router) {
//            self.router = router
//        }
//
//        func call(req: Request,res: Response) -> Response {
//            p("[Request]:", req.debugDescription)
//            return self.router.handle(req, res: res)
//        }
//    }
//}
