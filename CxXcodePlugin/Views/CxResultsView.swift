//
//  CxResultsView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/6/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import SwiftUI

struct CxResultsView: View {
  @EnvironmentObject var cxOptions: CxOptions
  @State var severityFilter: String
  @State private var codeDesc = ""
  @State private var htmlDesc = ""
   
  var body: some View {
    return VStack(alignment: .leading, spacing: 5) {
      Text("Description")
        .bold()
        .font(.system(size: 15))
        //.underline()
      Text(htmlDesc)
        .font(.system(size: 14))
        .padding()
        .frame(width: 740, height: 160)
        .background(Color.white)
        .foregroundColor(Color.black)
        .border(Color.black, width: 2)
      Spacer()
      Text("Code Sample")
        .bold()
        .font(.system(size: 15))
        //.underline()
      Text(codeDesc)
        .font(.system(size: 14))
        .padding()
        .frame(width: 740, height: 60)
        .background(Color.white)
        .foregroundColor(Color.black)
        .border(Color.black, width: 2)
      Spacer()
      Text("Issue Lists")
        .bold()
        .font(.system(size: 15))
        //.underline()
      CxResultList(severityFilter: self.$severityFilter,
                   codeDesc: self.$codeDesc,
                   htmlDesc: self.$htmlDesc)
      VStack(spacing: 30) {
        HStack {
          Button(action: {
            let cxs = CxXcodeSync(cxOptions: self.cxOptions)
            cxs.sync()
          }) {
            Text("Sync Xcode")
          }
          Button(action: {
            self.cxOptions.resetAppViewState()
          }) {
            Text("Close Report")
          }
        }
      }
      .offset(x: 530, y: 5)
    }
    .padding()
  }
}
