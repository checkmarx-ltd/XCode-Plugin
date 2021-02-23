//
//  ResultReview.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 6/30/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import SwiftUI

struct CxResultsSummaryView: View {
  @EnvironmentObject var cxOptions: CxOptions

  func countSeverity(_ severityFilter: String) -> String {
    let cnt = cxOptions.results!.xissues!.filter { issue in
      issue.severity == severityFilter
    }.count
    return "\(cnt)"
  }
  
  var body: some View {
    TabView(selection: self.$cxOptions.currentTab) {
      //
      /// High results
      //
      CxResultsView(severityFilter: "High")
      .tabItem {
        Text("High \(countSeverity("High"))")
      }
      .tag(1)
      .onAppear() {
        self.cxOptions.height = 700
        self.cxOptions.width = 800
      }
      //
      /// Medium results
      //
      CxResultsView(severityFilter: "Medium")
      .tabItem {
        Text("Medium \(countSeverity("Medium"))")
      }
      .tag(2)
      .onAppear() {
        self.cxOptions.height = 700
        self.cxOptions.width = 800
      }
      //
      /// Low results
      //
      CxResultsView(severityFilter: "Low")
      .tabItem {
        Text("Low \(countSeverity("Low"))")
      }
      .tag(3)
      .onAppear() {
        self.cxOptions.height = 700
        self.cxOptions.width = 800
      }
      //
      /// Info results
      //
      CxResultsView(severityFilter: "Info")
      .tabItem {
        Text("Info \(countSeverity("Info"))")
      }
      .tag(4)
      .onAppear() {
        self.cxOptions.height = 700
        self.cxOptions.width = 800
      }
    }
  }
}
