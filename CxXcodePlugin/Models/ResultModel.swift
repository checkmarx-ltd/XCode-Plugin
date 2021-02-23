//
//  ResultModel.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 6/23/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation

// Alternative
struct ResultModelAlt: Codable, Identifiable {
  public let id = UUID()
  var projectId: String
  var team: String
  var project: String
}

struct FlowSummary: Codable {
  var High: Int
  var Low: Int
}

struct ScanSummary: Codable {
  var highSeverity: Int
  var mediumSeverity: Int
  var lowSeverity: Int
  var infoSeverity: Int
  var statisticsCalculationDate: String
}

struct AdditionalDetails: Codable {
  var numFailedLoc: String
  var scanRiskSeverity: String
  var scanId: String
  var scanStartDate: String
  var scanRisk: String
}

struct IssueDetail: Codable {
  var falsePositive: Bool
  var codeSnippet: String
  var comment: String
}

struct XIssueAdditionalDetailResultSink: Codable {
  var file: String
  var line: String
  var column: String
  var object: String
}

struct XIssueAdditionalDetailResultSource: Codable {
  var file: String
  var line: String
  var column: String
  var object: String
}

struct XIssueAdditionalDetailResult: Codable {
  var sink: XIssueAdditionalDetailResultSink
  var state: String
  var source: XIssueAdditionalDetailResultSource
}

struct XIssueAdditionalDetails: Codable {
  var recommendedFix: String? = nil
  var categories: String? = nil
  var results: [XIssueAdditionalDetailResult]
}

struct XIssue: Codable {
  var vulnerability: String? = nil
  var vulnerabilityStatus: String? = nil
  var similarityId: String? = nil
  var cwe: String? = nil
  var description: String? = nil
  var language: String? = nil
  var severity: String? = nil
  var link: String? = nil
  var filename: String? = nil
  var gitUrl: String? = nil
  var falsePositiveCount: Int? = nil
  var details: [String: IssueDetail]
  var additionalDetails: XIssueAdditionalDetails
  var allFalsePositive: Bool? = nil
}

struct ResultModel: Codable {
  var projectId: String
  var team: String
  var project: String
  var link: String
  var files: String
  var loc: String
  var scanType: String
  var additionalDetails: AdditionalDetails
  var scanSummary: ScanSummary
  var xissues: [XIssue]? = nil
}

public class DecodeResultModel {
  func getResults(fileName: String) -> ResultModel? {
    do {
      var dirURL = FileManager.default.homeDirectoryForCurrentUser
      dirURL.appendPathComponent("results")
      dirURL.appendPathComponent(fileName)
      let jsonData: Data! = try String(contentsOf: dirURL).data(using: .utf8)
      let results = try! JSONDecoder().decode(ResultModel.self, from: jsonData)
      return results
    }
    catch let error as NSError {
      print("Scan results could not be decoded: \(error)")
    }
    return nil
  }
}
