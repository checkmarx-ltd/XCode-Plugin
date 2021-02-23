//
//  CxOptions.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/6/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation

class CxOptions: ObservableObject {
  init() {
    let ces = CxEnvironmentManager.shared.fetch()!
    let curCxPropsID = ces.curCxPropsID ?? UUID()
    let props = CxPropertiesManager.shared.fetchProperties(curCxPropsID: curCxPropsID)!
    self.cxProps = props
    self.curCxPropsID = curCxPropsID
    self.scanHistory = CxScanReportManager.shared.fetch()
  }
  @Published var results: ResultModel?
  @Published var previousScanID = UUID(uuidString: "E075A66F-1CCD-4020-90F3-624EC564D4A4")
  @Published var latestScanID = UUID(uuidString: "0F7AD5B5-5861-47FE-94E4-12ABA76D0F7F")
  @Published var curCxPropsID: UUID = UUID()
  @Published var cxProps: CxProperties
  @Published var height: CGFloat = 300
  @Published var width: CGFloat = 600
  @Published var showReportView = false
  @Published var showCxFlowLog = false
  @Published var showScanProgress = false
  @Published var progressUpdate = false
  @Published var showCxFlowUpdate = false
  @Published var consoleMsg = ""
  @Published var currentTab = 1
  @Published var scanHistory: [CxScanReport]
  
  func resetAppViewState() {
    height = 300
    width = 600
    showReportView = false
    showCxFlowLog = false
    showScanProgress = false
    progressUpdate = false
    showCxFlowUpdate = false
    currentTab = 1
  }
}
