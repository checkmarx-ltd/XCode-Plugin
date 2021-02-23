//
//  CxAccessBookmarks.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 8/13/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation
import SwiftUI

class CxAccessBookmarks {  
  //
  /// Looks to see if there's an existing bookmark for this resource
  //
  func accessExists(name: String) -> Bool {
    var state = false
    do {
      let bookmark = UserDefaults.standard.data(forKey: name)
      if bookmark != nil {
        var isStale = false
        let _ = try URL(resolvingBookmarkData: bookmark!,
                          options:[.withSecurityScope],
                          bookmarkDataIsStale: &isStale)
        if !isStale {
          state = true
        }
      }
    }
    catch let error as NSError {
      print("Error verifying resource URL access: \(error.description)")
    }
    return state
  }
  
  //
  /// This verify folder level access in a sandboxed environment trigger a callback function when complete
  //
  func verifyDirAccess(dirToVerify: URL, onSuccess: @escaping () -> Void) {
    let bookmarkName = "cxmark\(dirToVerify.absoluteURL.absoluteString.persistentHash)"
    if accessExists(name: bookmarkName) {
      onSuccess()
    }
    else {
      let openPanel = NSOpenPanel()
      openPanel.message = "Authorize access to project folder"
      openPanel.prompt = "Authorize"
      openPanel.canChooseFiles = false
      openPanel.canChooseDirectories = true
      openPanel.canCreateDirectories = false
      openPanel.directoryURL = dirToVerify
      openPanel.begin() {
        (result) -> Void in
          if (result.rawValue == NSApplication.ModalResponse.OK.rawValue) {
            do {
              let bookmark = try openPanel.directoryURL?.bookmarkData(options: .withSecurityScope)
              UserDefaults.standard.set(bookmark, forKey: bookmarkName)
            } catch let error as NSError {
              print("Set Bookmark Fails: \(error.description)")
            }
            onSuccess()
          }
      }
    }
  }
  
  //
  /// This asks the user to pick a directly to grant access too. The String representing the
  /// path back to the URL on the local HD
  //
  func promptForDirAccess(onSuccess: @escaping (String) -> Void) {
    let openPanel = NSOpenPanel()
    openPanel.message = "Choose project path"
    openPanel.prompt = "Choose"
    openPanel.canChooseFiles = false
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = false
    openPanel.begin() {
      (result) -> Void in
        if (result.rawValue == NSApplication.ModalResponse.OK.rawValue) {
          let dirName = openPanel.directoryURL!
          do {
            let bookmark = try dirName.bookmarkData(options: .withSecurityScope)
            let bookmarkName = "cxmark\(dirName.absoluteURL.absoluteString.persistentHash)"
            UserDefaults.standard.set(bookmark, forKey: bookmarkName)
          } catch let error as NSError {
            print("Set Bookmark Fails: \(error.description)")
          }
          onSuccess(dirName.path)
        }
    }
  }
}
