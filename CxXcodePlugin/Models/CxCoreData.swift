//
//  CxCoreData.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/6/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation
import CoreData

struct CxCoreData {
  static var shared = CxCoreData()
  
  let context: NSManagedObjectContext = {
    let container = NSPersistentContainer(name: "CxCoreData")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error {
        fatalError("Loading of store failed \(error)")
      }
    }
    return container.viewContext
  } ()
  
  func update() {
    do {
      try context.save()
    } catch let createError {
      print("Failed to update: \(createError)")
    }
  }
}
