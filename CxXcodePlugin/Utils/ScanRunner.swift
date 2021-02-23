//
//  ScanRunner.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 6/25/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation

class ScanRunner: ObservableObject {
  var cxOptions: CxOptions
  var cxProperties: CxProperties
  var cxScanView: CxScanView
  
  init(cxOptions: CxOptions, cxScanView: CxScanView) {
    self.cxOptions = cxOptions
    self.cxProperties = cxOptions.cxProps
    self.cxScanView = cxScanView
  }
  
  func startScan() {
    self.cxOptions.consoleMsg = "";
    let pipe = Pipe()
    let task = Process()
    let cxFlowPath = self.findCxFlowPath(cxFlowType: "11")!
    print(self.cxProperties.baseURL as Any)
    print(self.cxProperties.username as Any)
    print(self.cxProperties.password as Any)
    print(self.cxProperties.incremental as Any)
    print(self.cxProperties.scanPreset as Any)
    print(self.cxProperties.team as Any)
    print(self.findCxFlowResultsPath() as Any)
    print(self.cxProperties.projectName as Any)
    print(self.cxProperties.appName as Any)
    print(self.cxProperties.sourcePath as Any)
    task.standardOutput = pipe
    task.launchPath = "/usr/bin/java"
    //
    /// Figure out if serverity filters are required
    //
    var severityFilter = "--cx-flow.filter-severity="
    if cxProperties.filterSeverityHigh == true {
        severityFilter += "High,"
    }
    if cxProperties.filterSeverityMedium == true {
        severityFilter += "Medium,"
    }
    if cxProperties.filterSeverityLow == true {
        severityFilter += "Low,"
    }
    if cxProperties.filterSeverityInfo == true {
        severityFilter += "Info,"
    }
    //
    /// Filter status
    //
    var statusFilter = "--cx-flow.filter-status="
    if cxProperties.filterStatusNew == true {
        statusFilter += "New,"
    }
    if cxProperties.filterStatusConfirmed == true {
        statusFilter += "Confirmed,"
    }
    //
    /// Filter category
    //
    var categoryFilter = "--cx-flow.filter-category="
    if cxProperties.filterCategory != nil {
        categoryFilter += cxProperties.filterCategory!
    }
    //
    /// Setup the properties to send to the server
    //
    task.arguments = ["-jar",
                      cxFlowPath,
                      "--scan",
                      severityFilter,
                      statusFilter,
                      categoryFilter,
                      "--checkmarx.base-url=\(self.cxProperties.baseURL!)",
                      "--checkmarx.username=\(self.cxProperties.username!)",
                      "--checkmarx.password=\(self.cxProperties.password!)",
                      "--checkmarx.incremental=\(self.cxProperties.incremental)",
                      "--checkmarx.scan-preset=\(self.cxProperties.scanPreset!)",
                      "--checkmarx.team=\(self.cxProperties.team!)",
                      "--json.data-folder=\(self.findCxFlowResultsPath()!)",
                      "--cx-project=\(self.cxProperties.projectName!)",
                      "--app=\(self.cxProperties.appName!)",
                      "--f=\(self.cxProperties.sourcePath!)"]
    task.launch()
    var tmpCnt = 0
    pipe.fileHandleForReading.readabilityHandler = { fileHandle in
      let data = fileHandle.availableData
      if let string = String(data: data, encoding: String.Encoding.utf8) {
        // TODO: this is a hack to preven some kind of buffer error and it needs fixed
        if tmpCnt < 50 {
          self.cxOptions.consoleMsg += string
        }
        tmpCnt += 1
      }
    }
    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
      if task.isRunning {
        print("Task is running")
      } else {
        print("Task has finished")
        timer.invalidate()
        let projectName = self.cxOptions.cxProps.projectName!
        let csr = CxScanReportManager.shared.create(projectName: projectName)!
        self.cxOptions.scanHistory = CxScanReportManager.shared.fetch()
        let dirURL = FileManager.default.homeDirectoryForCurrentUser
        var srcFile = dirURL.absoluteURL
        srcFile.appendPathComponent("results/report.json")
        var dstFile = dirURL.absoluteURL
        dstFile.appendPathComponent("results/\(csr.filename!)")
        do {
          // Rename the report its long term name
          if FileManager.default.fileExists(atPath: srcFile.path) {
            try FileManager.default.copyItem(at: srcFile, to: dstFile)
            try FileManager.default.removeItem(at: srcFile)
          }
          // Remove the zip file sent to Cx
          let fileURLs = try FileManager.default.contentsOfDirectory(at: dirURL,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
          for fileURL in fileURLs {
            if fileURL.pathExtension == "zip" {
              try FileManager.default.removeItem(at: fileURL)
            }
            //if fileURL.pathExtension == "log" {
            //  try FileManager.default.removeItem(at: fileURL)
            //}
          }
          // Go ahead and display the results
          self.loadScanReport(fileName: csr.filename!)
        } catch {
          print("Caught exception decoding report!")
        }
      }
    }
  }

  //
  /// Pulls the latest scan from the server
  //
  func fetchLatestScan() {
    self.cxOptions.consoleMsg = "";
    let pipe = Pipe()
    let task = Process()
    let cxFlowPath = self.findCxFlowPath(cxFlowType: "11")!
    print(self.cxProperties.baseURL as Any)
    print(self.cxProperties.username as Any)
    print(self.cxProperties.password as Any)
    print(self.cxProperties.team as Any)
    print(self.findCxFlowResultsPath() as Any)
    print(self.cxProperties.projectName as Any)
    print(self.cxProperties.appName as Any)
    print(self.cxProperties.sourcePath as Any)
    task.standardOutput = pipe
    task.launchPath = "/usr/bin/java"
    //
    /// Figure out if serverity filters are required
    //
    var severityFilter = "--cx-flow.filter-severity="
    if cxProperties.filterSeverityHigh == true {
        severityFilter += "High,"
    }
    if cxProperties.filterSeverityMedium == true {
        severityFilter += "Medium,"
    }
    if cxProperties.filterSeverityLow == true {
        severityFilter += "Low,"
    }
    if cxProperties.filterSeverityInfo == true {
        severityFilter += "Info,"
    }
    //
    /// Filter status
    //
    var statusFilter = "--cx-flow.filter-status="
    if cxProperties.filterStatusNew == true {
        statusFilter += "New,"
    }
    if cxProperties.filterStatusConfirmed == true {
        statusFilter += "Confirmed,"
    }
    //
    /// Filter category
    //
    var categoryFilter = "--cx-flow.filter-category="
    if cxProperties.filterCategory != nil {
        categoryFilter += cxProperties.filterCategory!
    }
    //
    /// Setup the properties to send to the server
    //
    task.arguments = ["-jar",
                      cxFlowPath,
                      "--project",
                      severityFilter,
                      statusFilter,
                      categoryFilter,
                      "--checkmarx.base-url=\(self.cxProperties.baseURL!)",
                      "--checkmarx.username=\(self.cxProperties.username!)",
                      "--checkmarx.password=\(self.cxProperties.password!)",
                      "--json.data-folder=\(self.findCxFlowResultsPath()!)",
                      "--cx-team=\(self.cxProperties.team!)",                      
                      "--cx-project=\(self.cxProperties.projectName!)",
                      "--app=\(self.cxProperties.appName!)"]
    task.launch()
    var tmpCnt = 0
    pipe.fileHandleForReading.readabilityHandler = { fileHandle in
      let data = fileHandle.availableData
      if let string = String(data: data, encoding: String.Encoding.utf8) {
        // TODO: this is a hack to preven some kind of buffer error and it needs fixed
        if tmpCnt < 50 {
          self.cxOptions.consoleMsg += string
        }
        tmpCnt += 1
      }
    }
    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
      if task.isRunning {
        print("Task is running")
      } else {
        print("Task has finished")
        timer.invalidate()
        let projectName = self.cxOptions.cxProps.projectName!
        let csr = CxScanReportManager.shared.create(projectName: projectName)!
        self.cxOptions.scanHistory = CxScanReportManager.shared.fetch()
        let dirURL = FileManager.default.homeDirectoryForCurrentUser
        var srcFile = dirURL.absoluteURL
        srcFile.appendPathComponent("results/report.json")
        var dstFile = dirURL.absoluteURL
        dstFile.appendPathComponent("results/\(csr.filename!)")
        do {
          // Rename the report its long term name
          if FileManager.default.fileExists(atPath: srcFile.path) {
            try FileManager.default.copyItem(at: srcFile, to: dstFile)
            try FileManager.default.removeItem(at: srcFile)
          }
          // Remove the zip file sent to Cx
          let fileURLs = try FileManager.default.contentsOfDirectory(at: dirURL,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
          for fileURL in fileURLs {
            if fileURL.pathExtension == "zip" {
              try FileManager.default.removeItem(at: fileURL)
            }
            //if fileURL.pathExtension == "log" {
            //  try FileManager.default.removeItem(at: fileURL)
            //}
          }
          // Go ahead and display the results
          self.loadScanReport(fileName: csr.filename!)
        } catch {
          print("Caught exception decoding report!")
        }
      }
    }
  }
  
  func findCxFlowResultsPath() -> String? {
    let dirURL = FileManager.default.homeDirectoryForCurrentUser
    let resultsPath = dirURL.appendingPathComponent("results")
    return resultsPath.path
  }
  
  func findCxFlowPath(cxFlowType: String) -> String? {
    do {
      let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: false)
      let cxFlowURL = documentsURL.appendingPathComponent("cxflow\(cxFlowType).jar")
      return cxFlowURL.path
    }
    catch {
      print ("file error: \(error)")
    }
    return nil
  }
  
  func downloadCxFlow(cxFlowType: String) {
    createApplicationYML()
    createResultsDir()
    let downloader = CxDownloader()
    downloader.startDownload(jdkVersion: cxFlowType)
    print("Starting Download")
    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
      if downloader.isRunning {
        print("Still Downloading")
      }
      else {
        print("Done! Now we can run the scan")
        timer.invalidate()
        self.cxOptions.showScanProgress = true
        self.cxOptions.showCxFlowUpdate = false
        self.startScan()
      }
    }
  }
  
  func createResultsDir() {
    let docURL = FileManager.default.homeDirectoryForCurrentUser
    let absDocURL = docURL.absoluteURL
    let resultsURL = absDocURL.appendingPathComponent("results")
    if !FileManager.default.fileExists(atPath: resultsURL.absoluteString) {
        do {
            try FileManager.default.createDirectory(atPath: "results", withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Could not create results folder")
            print(error.localizedDescription);
        }
    }
  }
  
  func createApplicationYML() {
    do {
      let dirURL = FileManager.default.homeDirectoryForCurrentUser
      var ymlFile = dirURL.absoluteURL
      ymlFile.appendPathComponent("application.yml")
      //
      /// Known application.yml file with proper settings for plugin
      //
      try """
      logging:
        file:
          name: cx-flow.log

      cx-flow:
        bug-tracker: Json
        bug-tracker-impl:
          - Json
        filter-severity:
          - High
          - Medium
          - Low
        mitre-url: https://cwe.mitre.org/data/definitions/%s.html

      checkmarx:
        url: ${checkmarx.base-url}/cxrestapi
        portal-url: ${checkmarx.base-url}/cxwebinterface/Portal/CxWebService.asmx
        scan-timeout: 120

      json:
        file-name-format: "report.json"
      """.write(to: ymlFile, atomically: true, encoding: String.Encoding.utf8)
    } catch {
      print("Could not create CxFlow application.yaml file!")
    }
  }
  
  func loadScanReport(fileName: String) {
    print("Loading scan report")
    let drm = DecodeResultModel()
    let rm = drm.getResults(fileName: fileName)
    if rm != nil {
      self.cxOptions.results = rm
      self.cxOptions.showReportView = true
      self.cxOptions.showScanProgress = false
    } else {
      self.cxOptions.showScanProgress = false
    }
  }
}
