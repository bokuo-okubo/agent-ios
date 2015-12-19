//
//  CSURLProtocol.swift
//  agent-ios
//
//  Created by Yohei Okubo on 12/10/15.
//  Copyright © 2015 bko. All rights reserved.
//

import UIKit

class CSURLProtocol: NSURLProtocol {

    /* class methods */
    override static func canInitWithRequest(request: NSURLRequest) -> Bool {

        let defaultHost = Config().hostName

        if let requestHost = request.URL?.host {
            return requestHost == defaultHost
        } else {
            return false
        }
    }

    override static func canonicalRequestForRequest (request: NSURLRequest) -> NSURLRequest {
        return request
    }

    /* instance methods */
    override func startLoading() {
        if let reqURL = self.request.URL {
            print("in CSURLProtocol | requestURL:", reqURL)

            let path: String? = reqURL.path

            let res: PseudoServer.Response = PseudoServer.query(path!)

            print("in CSURLProtocol | response Header:", res.header)// for debug
            print("in CSURLProtocol | response Payload:", res.payload) // for debug
            let data = res.payload.joinWithSeparator("").dataUsingEncoding(NSUTF8StringEncoding)

            // TODO : migrate to my response.
            let response = NSHTTPURLResponse(URL: reqURL,
                statusCode: 200,
                HTTPVersion: "1.1",
                headerFields: ["Access-Control-Allow-Origin":"*"]) as NSURLResponse?
            self.client?.URLProtocol(self,
                didReceiveResponse: response!,
                cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
            self.client?.URLProtocol(self, didLoadData: data!)
        }
        self.client?.URLProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
