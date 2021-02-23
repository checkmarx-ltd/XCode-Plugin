//
//  ContentView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 6/22/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import SwiftUI
import Combine

struct ContentView: View {
  @EnvironmentObject var cxOptions: CxOptions
  var showScanProgress = false
  
  var body: some View {
    HStack {
      if cxOptions.showReportView {
        CxResultsSummaryView()
      }
      else if cxOptions.showScanProgress {        
        CxScanProgressView()
          .onAppear() {
            self.cxOptions.width = 800
            if self.cxOptions.showCxFlowLog {
              self.cxOptions.height = 600
            } else {
              self.cxOptions.height = 150
            }
          }
      }
      else if cxOptions.showCxFlowUpdate {
        CxFlowUpdateView()
          .onAppear() {
              print("Showing the View")
          }
      }
      else {
        TabView(selection: self.$cxOptions.currentTab) {
          CxScanView()
            .tabItem {
              Text("Run Scan") 
            }
            .tag(1)
            .onAppear() {
              self.cxOptions.height = 150
              self.cxOptions.width = 800
            }
          CxConfigView()
            .tabItem {
              Text("Configuration")
            }
            .tag(2)
            .onAppear() {
              print("Showing Config View")
              self.cxOptions.width = 600
              self.cxOptions.height = 660
            }
        }
      }
    }
    .padding()
    .frame(width: self.cxOptions.width, height: self.cxOptions.height)
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
