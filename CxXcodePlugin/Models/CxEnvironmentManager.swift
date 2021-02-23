//
//  CxEnvironmentManager.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/2/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation
import CoreData

struct CxEnvironmentManager {
  static let shared = CxEnvironmentManager()
  let context: NSManagedObjectContext = CxCoreData.shared.context

  func create() -> [CxEnvironmentSettings] {
    let settings = CxEnvironmentSettings(context: context)
    settings.curCxPropsID = UUID()
    do {
      try context.save()
      let fetchRequest = NSFetchRequest<CxEnvironmentSettings>(entityName: "CxEnvironmentSettings")
      let settings = try context.fetch(fetchRequest)
      return settings
    } catch let createError {
      print("Failed to create: \(createError)")
    }
    return []
  }
  
  func fetch() -> CxEnvironmentSettings? {
    let fetchRequest = NSFetchRequest<CxEnvironmentSettings>(entityName: "CxEnvironmentSettings")
    fetchRequest.fetchLimit = 1
    do {
      let properties =  try context.fetch(fetchRequest)
      if properties.count == 1 {
        return properties.last!
      } else {
        return create().last!
      }
    }
    catch let fetchError {
      print("Failed to fetch: \(fetchError)")
    }
    return nil
  }
  
  func update(cxEnvironment: CxEnvironmentSettings) {
    do {
      try context.save()
    } catch let createError {
      print("Failed to update: \(createError)")
    }
  }
}
