//
//  ActivityView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/7/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import SwiftUI

struct CxActivityView: NSViewRepresentable {
  @Binding var running: Bool
  var progressBar = NSProgressIndicator()

  func makeNSView(context: Context) -> NSProgressIndicator {
    progressBar.frame = NSRect(x:100, y:20, width:150, height:10)
    progressBar.minValue = 0
    progressBar.maxValue = 100
    progressBar.startAnimation(self)
    return progressBar
  }

  func updateNSView(_ progressBar: NSProgressIndicator, context: Context) {
    print("Updating progress")
    /*
    if running {
      self.progressBar.startAnimation(self)
    }
    else {
      self.progressBar.stopAnimation(self)
    }
    */
  }
}
