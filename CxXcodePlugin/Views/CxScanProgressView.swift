//
//  ScanProgressView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/9/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import SwiftUI

struct CxScanProgressView: View {
  @EnvironmentObject var cxOptions: CxOptions
  
  var body: some View {
    VStack() {
      Text("Scanning, please wait...")
      CxActivityView(running: self.$cxOptions.progressUpdate)
        .frame(width: 200)
      Toggle(isOn: self.$cxOptions.showCxFlowLog) {
        Text("Show CxFlow Log")
      }
      if(self.cxOptions.showCxFlowLog) {
        ScrollView(.vertical) {
          Text(self.cxOptions.consoleMsg)
            .font(.system(size: 12))
            .foregroundColor(Color.black)
            .frame(width: 740)
            .padding()
        }
        .onAppear() {
          self.cxOptions.height = 600
        }
          .border(Color.black, width: 2)
          .background(Color.gray)
          .frame(width: 740, height: 400)
      }
    }
  }
}
