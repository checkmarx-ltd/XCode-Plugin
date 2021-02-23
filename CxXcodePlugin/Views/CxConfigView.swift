//
//  ConfigView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 6/23/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Combine
import SwiftUI

struct JdkVersion: Identifiable {
  var id: UUID
  var label: String
}

struct JdkVersionViewRow: View {
    var jdkVersion: JdkVersion

    var body: some View {
      Text(jdkVersion.label)
    }
}

struct CxPropertiesViewRow: View {
    var cxPoperties: CxProperties

    var body: some View {
      return Text(cxPoperties.label!)
    }
}

struct CxConfigView: View {
  @EnvironmentObject var cxOptions: CxOptions
  @State private var curCxPropsID: UUID = UUID()
  @State private var scanProperties = CxPropertiesManager.shared.fetchProperties()
  @State private var jdkVersionIdx: UUID = UUID(uuidString: "F04AFFD1-691E-4FA4-9376-52545A142937")!
  @State private var jdkVersions = [JdkVersion(id: UUID(uuidString: "A08E690E-990A-4D4B-A69B-D352BC811604")!, label: "8 or newer"),
                                    JdkVersion(id: UUID(uuidString: "F04AFFD1-691E-4FA4-9376-52545A142937")!, label: "11 or newer")]
  
  var body: some View {
    
    let curCxPropsIDBinding = Binding<UUID>(
      get: {
        return self.curCxPropsID
      },
      set: {
        self.curCxPropsID = $0
        self.cxOptions.curCxPropsID = $0
        self.cxOptions.cxProps = CxPropertiesManager.shared.fetchProperties(curCxPropsID: self.cxOptions.curCxPropsID)!
        let ces = CxEnvironmentManager.shared.fetch()!
        ces.curCxPropsID = $0
        CxCoreData.shared.update()
      })
    return Form {
      Group {
        HStack {
          Picker(selection: curCxPropsIDBinding, label: Text("Project")) {
            ForEach(self.scanProperties) { cxProperties in
              if cxProperties.id != nil {
                //CxPropertiesViewRow(cxPoperties: cxProperties).tag(cxProperties.id!)
                Text(cxProperties.label!).tag(cxProperties.id!)
              }
            }
          }
        }
        HStack {
          Picker(selection: $jdkVersionIdx, label: Text("JDK Version").bold()) {
            ForEach(self.jdkVersions) { jdkVersion in
              JdkVersionViewRow(jdkVersion: jdkVersion)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Name").offset(x: 40)
          }
          .frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiLabel)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Server Address").offset(x: 10)
          }
          .frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiBaseURL)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Username").offset(x: 25)
          }.frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiUsername)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Password").offset(x: 25)
          }.frame(width: 120)
          SecureField("", text: $cxOptions.cxProps.uiPassword)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Team Name").offset(x: 20)
          }.frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiTeam)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Application Name").offset(x: 0)
          }.frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiAppName)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Project Name").offset(x: 15)
          }.frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiProjectName)
        }
      }
      Group {
        HStack {
          VStack(alignment: .trailing) {
            Text("Scan Preset").offset(x: 20)
          }.frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiScanPreset)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Source Path").offset(x: 20)
          }.frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiSourcePath)
          Button(action: {
            let cab = CxAccessBookmarks()
            cab.promptForDirAccess(onSuccess: { (urlName: String) -> Void in
              self.cxOptions.cxProps.uiSourcePath = urlName              
            })
          }) {
            Text("Pick Project")
          }
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Category Filter").offset(x: 10)
          }.frame(width: 120)
          TextField("Comma separated list", text: $cxOptions.cxProps.uiFilterCategory)
        }
        HStack {
          Text("Severity Filter(s)")
          Toggle(isOn: $cxOptions.cxProps.filterSeverityHigh) {
            Text("High")
          }.offset(x: 20)
          Toggle(isOn: $cxOptions.cxProps.filterSeverityMedium) {
            Text("Medium")
          }.offset(x: 35)
          Toggle(isOn: $cxOptions.cxProps.filterSeverityLow) {
            Text("Low")
          }.offset(x: 60)
          Toggle(isOn: $cxOptions.cxProps.filterSeverityInfo) {
            Text("Info")
          }.offset(x: 80)
        }.offset(x: 20)
        HStack {
          Text("Status Filter(s)")
          Toggle(isOn: $cxOptions.cxProps.uiFilterStatusNew) {
            Text("New")
          }.offset(x: 20)
          Toggle(isOn: $cxOptions.cxProps.uiFilterStatusConfirmed) {
            Text("Confirmed")
          }.offset(x: 36)
        }.offset(x: 30)
        HStack {
          VStack(alignment: .trailing) {
            Text("Proxy Server").offset(x: 20)
          }.frame(width: 120)
          TextField("Proxy Server", text: $cxOptions.cxProps.uiProxyServer)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Proxy Server User").offset(x: 0)
          }.frame(width: 120)
          TextField("", text: $cxOptions.cxProps.uiProxyServerUser)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Password").offset(x: 25)
          }.frame(width: 120)
          SecureField("", text: $cxOptions.cxProps.uiProxyServerPassword)
        }
        HStack {
          VStack(alignment: .trailing) {
            Text("Incremental").offset(x: 20)
          }.frame(width: 120)
          Toggle(isOn: $cxOptions.cxProps.uiIncremental) {
            Text("")
          }
          VStack(alignment: .trailing) {
            Text("Use Proxy Server").offset(x: 20)
          }.frame(width: 145)
          Toggle(isOn: $cxOptions.cxProps.uiUseProxyServer) {
            Text("")
          }
        }
        HStack {
          Button(action: {
            let cxProps = CxPropertiesManager.shared.createProperties()!
            self.curCxPropsID = cxProps.id!
            self.cxOptions.curCxPropsID = self.curCxPropsID
            self.cxOptions.cxProps = cxProps
            let ces = CxEnvironmentManager.shared.fetch()!
            ces.curCxPropsID = self.curCxPropsID
            CxCoreData.shared.update()
            self.scanProperties = CxPropertiesManager.shared.fetchProperties()
          }) {
            Text("Add Project")
          }
          Button(action: {
            CxPropertiesManager.shared.deleteProperties(cxProperties: self.cxOptions.cxProps)
            self.curCxPropsID = self.scanProperties[0].id!
            self.scanProperties = CxPropertiesManager.shared.fetchProperties()
            self.cxOptions.curCxPropsID = self.curCxPropsID
            self.cxOptions.cxProps = CxPropertiesManager.shared.fetchProperties(curCxPropsID: self.cxOptions.curCxPropsID)!
            let ces = CxEnvironmentManager.shared.fetch()!
            ces.curCxPropsID = self.curCxPropsID
            CxCoreData.shared.update()
          }) {
            Text("Delete Project")
          }
          //.disabled(true)
        }
        .offset(x: 225)
      }
    }
    .padding()
    .onAppear() {
      self.curCxPropsID = self.cxOptions.curCxPropsID
    }
  }
}

struct CxConfigView_Previews: PreviewProvider {
  static var previews: some View {
    CxConfigView()
  }
}
