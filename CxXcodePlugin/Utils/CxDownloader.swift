//
//  CxDownloader.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/11/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation

//
/// This is for fetching the most recent version of CxFlow from GitHub.
//
class CxDownloader: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
  private lazy var urlSession = URLSession(configuration: .default,
                                           delegate: self,
                                           delegateQueue: nil)
  public var isRunning: Bool = false
  private var cxFlowUrl: String = ""
  private var jdkVersion: String = "11"
  //
  /// We always get a 302 redirect back to the current Tag in GitHub, this tracks it.
  //
  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  willPerformHTTPRedirection response: HTTPURLResponse,
                  newRequest request: URLRequest,
                  completionHandler: @escaping (URLRequest?) -> Void) {
    if response.statusCode == 302 {
      let targetUrl = response.url?.path
      let location = response.allHeaderFields["Location"] as! String
      if targetUrl != self.cxFlowUrl {
        //
        /// This happens on the initial call as GitHub redirects us to the page with the latest release,
        /// we can use the location there to deduce the location of the file we want.
        //
        let parts = location.split(separator: "/")
        let curVersion: String = String(parts.last!)
        var cxFlowUrl = ""
        if self.jdkVersion == "11" {
          cxFlowUrl = "https://github.com/checkmarx-ltd/cx-flow/releases/download/\(curVersion)/cx-flow-\(curVersion)-java11.jar"
          self.cxFlowUrl = "/checkmarx-ltd/cx-flow/releases/download/\(curVersion)/cx-flow-\(curVersion)-java11.jar"
        } else {
          cxFlowUrl = "https://github.com/checkmarx-ltd/cx-flow/releases/download/\(curVersion)/cx-flow-\(curVersion).jar"
          self.cxFlowUrl = "/checkmarx-ltd/cx-flow/releases/download/\(curVersion)/cx-flow-\(curVersion).jar"
        }
        self.download(targetURL: cxFlowUrl)
      } else {
        //
        /// The redirect can proceed without modification because it should be an S3 link to the file we want.
        //
        self.download(targetURL: location)
      }
    }
  }
  
  func startDownload(jdkVersion: String) {
    self.isRunning = true
    self.jdkVersion = jdkVersion
    self.download(targetURL: "https://github.com/checkmarx-ltd/cx-flow/releases/latest")
  }
  
  private func download(targetURL: String) {
    let downloadTask = self.urlSession.downloadTask(with: URL(string: targetURL)!) { urlOrNil, responseOrNil, errorOrNil in
      guard let fileURL = urlOrNil else { return }
      do {
        let documentsURL = try
            FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        let savedURL = documentsURL.appendingPathComponent("cxflow\(self.jdkVersion).jar")
        try FileManager.default.moveItem(at: fileURL, to: savedURL)
        self.isRunning = false
      } catch {
        print ("file error: \(error)")
      }
    }
    downloadTask.resume()
  }
}
