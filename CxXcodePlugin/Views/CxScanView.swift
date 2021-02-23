//
//  ScanView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 6/23/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation
import Combine
import SwiftUI

struct CxScanResultsRowView: View {
    var cxScanReport: CxScanReport

    var body: some View {
      return Text(cxScanReport.label!)
    }
}

struct CxScanView: View {
  @EnvironmentObject var cxOptions: CxOptions
  @State private var showingAlert = false
  @State private var alertMsgTitle = ""
  @State private var alertMsg = ""  
  private let alertResultsDecodeTitle = "Scan Results Error"
  private let alertResultsDecodeMsg = "There was an error decoding SAST scan results."
  private let alertReportCopyErrorTitle = "Error Copying Report File!"
  private let alertReportCopyErrorMsg = "There was an error copying the report file to storage."
  
  
  @State private var scanReports = CxScanReportManager.shared.fetch()
  @State private var testScanID = UUID(uuidString: "E075A66F-1CCD-4020-90F3-624EC564D4A4")
  
  var body: some View {
    return VStack(alignment: .leading, spacing: 5) {
      //
      /// Pick type of scan to run
      //
      Picker(selection: $cxOptions.previousScanID, label: Text("Pick Scan").bold()) {
        ForEach(cxOptions.scanHistory) { scanHistory in
          CxScanResultsRowView(cxScanReport: scanHistory)
        }
      }
      //
      /// Decide what the button does
      //
      if cxOptions.previousScanID == UUID(uuidString: "E075A66F-1CCD-4020-90F3-624EC564D4A4") {
        //
        /// Trigger a new scan
        //
        Button(action: {
          let scanRunner = ScanRunner(cxOptions: self.cxOptions, cxScanView: self)
          let cxFlowType = self.cxOptions.cxProps.cxFlowType!
          // Types: 8, 11, Go11, Go8
          let cxFlowPath = scanRunner.findCxFlowPath(cxFlowType: cxFlowType)
          if FileManager.default.fileExists(atPath: cxFlowPath!) {
            // CxFlow already exists, so just go with it!
            self.cxOptions.showScanProgress = true
            scanRunner.startScan()
          }
          else {
            // CxFlow needs to be downloaded first, the scan will continue when this is done
            self.cxOptions.showCxFlowUpdate = true
            scanRunner.downloadCxFlow(cxFlowType: cxFlowType)
          }
        }) {
          Text("Run Scan")
        }
        .offset(x: 647)
      }
      else if cxOptions.previousScanID == UUID(uuidString: "0F7AD5B5-5861-47FE-94E4-12ABA76D0F7F") {
        //
        /// Load a latest scan
        //
        Button(action: {
          let scanRunner = ScanRunner(cxOptions: self.cxOptions, cxScanView: self)
          let cxFlowType = self.cxOptions.cxProps.cxFlowType!
          // Types: 8, 11, Go11, Go8
          let cxFlowPath = scanRunner.findCxFlowPath(cxFlowType: cxFlowType)
          if FileManager.default.fileExists(atPath: cxFlowPath!) {
            // CxFlow already exists, so just go with it!
            self.cxOptions.showScanProgress = true
            scanRunner.fetchLatestScan()
          }
          else {
            // CxFlow needs to be downloaded first, the scan will continue when this is done
            self.cxOptions.showCxFlowUpdate = true
            scanRunner.downloadCxFlow(cxFlowType: cxFlowType)
          }
        }) {
          Text("Latest Scan")
        }
        .offset(x: 636)
      }
      else {
        //
        /// Load a previous scan (from local HD)
        //
        Button(action: {
          var fileName = ""
          for scanItem in self.cxOptions.scanHistory {
            if scanItem.id == self.cxOptions.previousScanID {
              //try FileManager.default.removeItem(at: fileURL)
              fileName = scanItem.filename!
            }
          }
          self.loadScanReport(fileName: fileName)
        }) {
          Text("Load Scan")
        }
        .offset(x: 642)
      }
    }
    .alert(isPresented: $showingAlert) {
      Alert(title: Text(self.alertMsgTitle),
              message: Text(self.alertMsg),
              dismissButton: .default(Text("Close")))
    }
    .padding()
  }
  
  func loadScanReport(fileName: String) {
    let drm = DecodeResultModel()
    let rm = drm.getResults(fileName: fileName)
    if rm != nil {
      self.cxOptions.results = rm
      self.cxOptions.showReportView = true
      self.cxOptions.showScanProgress = false
    } else {
      self.cxOptions.showScanProgress = false
      self.alertMsgTitle = self.alertResultsDecodeTitle
      self.alertMsg = self.alertResultsDecodeMsg
      self.showingAlert = true
    }
  }
  
  func urlSession(_ session: URLSession,
                  downloadTask: URLSessionDownloadTask,
                  didWriteData bytesWritten: Int64,
                  totalBytesWritten: Int64,
                  totalBytesExpectedToWrite: Int64) {
      print("Got Download update")
      /*
      if downloadTask == self.downloadTask {
          let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
          DispatchQueue.main.async {
              self.progressLabel.text = self.percentFormatter.string(from:
                  NSNumber(value: calculatedProgress))
      }
      */
  }
}
