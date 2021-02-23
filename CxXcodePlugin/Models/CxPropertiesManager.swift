//
//  CxPropertiesManager.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 6/23/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation
import CoreData

struct CxPropertiesManager {
  static let shared = CxPropertiesManager()  
  let context: NSManagedObjectContext = CxCoreData.shared.context

  func createProperties() -> CxProperties? {
    let cxProperties = CxProperties(context: context)
    cxProperties.id = UUID()
    cxProperties.label = "New Confiuration"
    cxProperties.scanMethod = ""
    cxProperties.cxFlowType = "11"
    do {
      try context.save()
      return cxProperties
    } catch let createError {
      print("Failed to create: \(createError)")
    }
    return nil
  }
  
  func fetchProperties(curCxPropsID: UUID) -> CxProperties? {
    let fetchRequest = NSFetchRequest<CxProperties>(entityName: "CxProperties")
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(format: "id == %@", curCxPropsID.uuidString)
    do {
      let properties =  try context.fetch(fetchRequest)
      if properties.count == 1 {
        return properties.last
      } else {
        let cxProperties = createProperties()
        let ces = CxEnvironmentManager.shared.fetch()!
        ces.curCxPropsID = cxProperties?.id
        CxEnvironmentManager.shared.update(cxEnvironment: ces)
        return cxProperties
      }
    }
    catch let fetchError {
      print("Failed to fetch: \(fetchError)")
    }
    return nil
  }
  
  func fetchProperties() -> [CxProperties] {
    let fetchRequest = NSFetchRequest<CxProperties>(entityName: "CxProperties")
    do {
      let properties =  try context.fetch(fetchRequest)
      if properties.count > 0 {
        return properties
      } else {
        return [createProperties()!]
      }
    }
    catch let fetchError {
      print("Failed to fetch: \(fetchError)")
    }
    return []
  }
    
  func deleteProperties(cxProperties: CxProperties) {
    context.delete(cxProperties)
    do {
      try context.save()
    } catch let saveError {
      print("Failed to delete: \(saveError)")
    }
  }
}
