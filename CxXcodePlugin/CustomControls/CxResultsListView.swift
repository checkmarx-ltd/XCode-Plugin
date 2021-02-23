//
//  CxResultsListView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/13/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import SwiftUI

struct CxResultRowView: View {
  let xIssue: XIssue?
  let backColor: Color
  @Binding var codeDesc: String
  @Binding var htmlDesc: String
  
  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading) {
        Text("Vulnerability: \(xIssue!.vulnerability!)")
          .frame(width: 500, alignment: .leading)
          .padding(.bottom, 2)
        Text("Source File: \((xIssue!.filename! as NSString).lastPathComponent)")
          .padding(.bottom, 2)
        Text("Source Line: \(xIssue!.additionalDetails.results[0].source.line)")
        Button(action: {
          // TODO: to remove hack to redirect to my server
          let hackedURL = self.xIssue!.link!.replacingOccurrences(of: "http://WIN-HH991UM5LUH", with: "http://jeffcx.ngrok.io")
          if let url = URL(string: hackedURL) {
            NSWorkspace.shared.open(url)
          }
        }) {
          Text("Checkmarx Result")
        }
        .position(x: 600, y: -40)
      }
      .padding(5)
      Spacer()
      /*
      Image("star-filled")
        .resizable()
        .renderingMode(.template)
        .foregroundColor(.yellow)
        .frame(width: 10, height: 10)
      */
    }
    .listRowInsets(EdgeInsets(top: -20, leading: 50, bottom: -20, trailing: 20))
    .padding(5)
    .background(backColor)
    .listRowBackground(backColor.frame(height: 80))
    .onTapGesture {
      let lineNum = self.xIssue!.additionalDetails.results[0].source.line
      self.codeDesc = self.xIssue!.details[lineNum]?.codeSnippet ?? ""
      self.htmlDesc = self.xIssue!.description ?? ""
    }
  }
}

struct CxResultList: View {
  @EnvironmentObject var cxOptions: CxOptions
  @Binding var severityFilter: String
  @Binding var codeDesc: String
  @Binding var htmlDesc: String
  let colorLight = Color(red: 92/255, green: 93/255, blue: 94/255)
  let colorDark = Color(red: 145/255, green: 149/255, blue: 153/255)
  
  var body: some View {
    List {
      //ForEach(cxOptions.results!.xissues!) { xIssue in
      ForEach(0 ..< filterIssues().count) { i in
        CxResultRowView(xIssue: self.filterIssues()[i],
                        backColor: (i % 2 == 0) ? self.colorLight : self.colorDark,
                        codeDesc: self.$codeDesc,
                        htmlDesc: self.$htmlDesc)
      }
    }
  }
  
  func filterIssues() -> [XIssue] {
    let issues = cxOptions.results!.xissues!.filter { issue in
      issue.severity == self.severityFilter
    }
    return issues
  }
}
