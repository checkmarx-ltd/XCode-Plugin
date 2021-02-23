//
//  CxXcodeSync.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 8/13/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation
import SwiftUI

class CxXcodeSync {
  var cxOptions: CxOptions
  var cxProps: CxProperties
  
  init(cxOptions: CxOptions) {
    self.cxOptions = cxOptions
    self.cxProps = self.cxOptions.cxProps
  }
  
  func sync() {
    let bpFiles = findBreakpointFiles(projDir: self.cxProps.uiSourcePath)
    let projDir = self.cxProps.uiSourcePath
    let dirPathURL = NSURL(fileURLWithPath: projDir) as URL
    let cab = CxAccessBookmarks()
    cab.verifyDirAccess(dirToVerify: dirPathURL, onSuccess: {
      for bpFile in bpFiles {
        let bpFileURL = NSURL(fileURLWithPath: bpFile) as URL
        self.processBreakpointData(breakpointURL: bpFileURL)
      }
    })
  }
  
  //
  /// The breakpoint files will be named Breakpoints_v2.xcbkptlist and they can exist
  /// in multiple locations, this searches for them.
  //
  func findBreakpointFiles(projDir: String) -> [String] {
    var breakPointFiles: [String] = []
    do {
      let projItems = try FileManager.default.contentsOfDirectory(atPath: projDir)
      for projItem in projItems {
        if projItem.contains(".xcodeproj") {
          let fullDir = "\(projDir)/\(projItem)"
          let items = FileManager.default.subpaths(atPath: fullDir)
          for item in items! {
            if item.contains("Breakpoints_v2.xcbkptlist") {
              breakPointFiles.append("\(fullDir)/\(item)")
            }
          }
        }
      }
    }
    catch let error {
      print(error.localizedDescription)
    }
    return breakPointFiles
  }
  
  func processBreakpointData(breakpointURL: URL) {
    do {
      let xmlData = try String(contentsOf: breakpointURL, encoding: .utf8)
      var newFile = ""
      var evalBreakPoint = false
      var cxBreakPoint = false
      var breakPointCache = ""
      xmlData.enumerateLines { (line, stop) -> () in
        //
        /// Examin each breakpoint found and remove any Cx ones. This ensures
        /// when we add our issues they will be unique and that issues that have
        /// gone away are removed.
        //
        if line.contains("<BreakpointProxy") {
          evalBreakPoint = true
          cxBreakPoint = false
          breakPointCache = ""
        }
        // If we're reached the end of the breakpoint then figure out
        // if we're keeping it or not.
        if evalBreakPoint && line.contains("</BreakpointProxy>") {
          if !cxBreakPoint {
            breakPointCache += (line + "\n")
            newFile += breakPointCache
          }
          evalBreakPoint = false
        } else {
          if evalBreakPoint {
            breakPointCache += (line + "\n")
          } else {
            //
            /// Have we reached the end of the file? If so then we can start adding the
            /// current issues
            //
            if line.contains("</Breakpoints>") {
              for issue in self.cxOptions.results!.xissues! {
                newFile += self.createBreakPoint(issue: issue)
              }
            }
            newFile += (line + "\n")
          }
        }
        // If this is a cxIssue the mark it for removal
        if line.contains("cxIssue = \"1\"") {
          cxBreakPoint = true
        }
      }
      //
      /// Write out the new file
      //
      try newFile.write(to: breakpointURL,
                        atomically: true,
                        encoding: String.Encoding.utf8)
    }
    catch let error {
      print("Error reading the file")
      print(error.localizedDescription)
    }
  }
  
  func createBreakPoint(issue: XIssue) -> String {
    let uuid = UUID()
    let lineNum = issue.additionalDetails.results[0].source.line
    let filePath = issue.filename!
    let name = issue.vulnerability!
    let bp = """
    <BreakpointProxy
       BreakpointExtensionID = "Xcode.Breakpoint.FileBreakpoint">
       <BreakpointContent
          uuid = "\(uuid.uuidString)"
          shouldBeEnabled = "No"
          nameForDebugger = "\(name)"
          ignoreCount = "0"
          cxIssue = "1"
          continueAfterRunningActions = "No"
          filePath = "\(filePath)"
          startingColumnNumber = "9223372036854775807"
          endingColumnNumber = "9223372036854775807"
          startingLineNumber = "\(lineNum)"
          endingLineNumber = "\(lineNum)"
          landmarkName = "perform(with:completionHandler:)"
          landmarkType = "7">
       </BreakpointContent>
    </BreakpointProxy>\n
    """
    return bp
  }
}
