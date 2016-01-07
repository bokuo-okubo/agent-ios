//
//  ViewController.swift
//  agent-ios
//
//  Created by Yohei Okubo on 12/10/15.
//  Copyright © 2015 bko. All rights reserved.
//

import UIKit

class CSStubRootViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let webView = UIWebView.init(frame: culcAvailableViewRect())
    let path = self.setupBundleFilePath(Config())

    NSURLProtocol.registerClass(CSURLProtocol)

    // TODO: リソースが取得できなかった時のエラーハンドリング
    webView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: path)))
    
    self.view.addSubview(webView)
  }

  // override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}


  /* -----------------
  *   private methods
  *  ----------------- */
  private func setupBundleFilePath(config: Config) -> String {
    let bundle = NSBundle.mainBundle()
    let (filename, type, path) = (config.localEntoryFile, "html", config.localDirName)
    return bundle.pathForResource(filename, ofType: type, inDirectory: path)!
  }

  private func culcAvailableViewRect() -> CGRect {
    let frameSizeRect = UIScreen.mainScreen().bounds
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    let (width, height) = (frameSizeRect.width, frameSizeRect.height - statusBarHeight)
    return CGRect(x: 0, y: statusBarHeight, width: width, height: height)
  }

}
