//
//  CxScanReportManager.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/3/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation
import CoreData

struct CxScanReportManager {
  static let shared = CxScanReportManager()
  let context: NSManagedObjectContext = CxCoreData.shared.context

  func create(projectName: String) -> CxScanReport? {
    let scanReport = CxScanReport(context: context)
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US")
    scanReport.id = UUID()
    scanReport.when = Date()
    df.dateFormat = "yyyy-MM-dd-HHmmss"
    let timeStamp = df.string(from: scanReport.when!)
    scanReport.filename = "report-\(timeStamp).json"
    df.dateFormat = "HH:mm a MM/dd/yyyy"
    let scanStamp = df.string(from: scanReport.when!)
    scanReport.label = "\(projectName) \(scanStamp)"
    do {
      try context.save()
      let fetchRequest = NSFetchRequest<CxScanReport>(entityName: "CxScanReport")
      fetchRequest.fetchLimit = 1
      fetchRequest.predicate = NSPredicate(format: "id == %@", "\(scanReport.id!)")
      let scanReport = try context.fetch(fetchRequest)
      return scanReport[0]
    } catch let createError {
      print("Failed to create: \(createError)")
    }
    return nil
  }
  
  private func createRootEntry() -> [CxScanReport] {
    let prevScanReport = CxScanReport(context: context)
    prevScanReport.id = UUID(uuidString: "0F7AD5B5-5861-47FE-94E4-12ABA76D0F7F")
    prevScanReport.when = Date()
    prevScanReport.filename = ""
    prevScanReport.label = "Latest Scan"
    let scanReport = CxScanReport(context: context)
    scanReport.id = UUID(uuidString: "E075A66F-1CCD-4020-90F3-624EC564D4A4")
    scanReport.when = Date()
    scanReport.filename = ""
    scanReport.label = "New Scan"
    do {
      try context.save()
      let fetchRequest = NSFetchRequest<CxScanReport>(entityName: "CxScanReport")
      return try context.fetch(fetchRequest)
    } catch let createError {
      print("Failed to create: \(createError)")
    }
    return []
  }
  
  func fetch() -> [CxScanReport] {
    // self.deleteAll()
    let fetchRequest = NSFetchRequest<CxScanReport>(entityName: "CxScanReport")
    do {
      let scanReports =  try context.fetch(fetchRequest)
      if scanReports.count != 0 {
        return scanReports
      }
      else {
        return createRootEntry()
      }
    }
    catch let fetchError {
      print("Failed to fetch: \(fetchError)")
    }
    return []
  }
  
  func deleteAll() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CxScanReport")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
      try context.execute(deleteRequest)
    } catch let error as NSError {
      print("Error deleting all entries \(error)")
    }
  }
  
  func update(cxEnvironment: CxEnvironmentSettings) {
    do {
      try context.save()
    } catch let createError {
      print("Failed to update: \(createError)")
    }
  }
}
