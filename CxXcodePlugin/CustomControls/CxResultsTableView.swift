//
//  CxResultsTableView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/13/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import SwiftUI
import AppKit

class CxResultsTableView: NSTableView {
  // Define your NSTableView subclass as you would in an AppKit app
}

class Person {
  var name: String = ""
  var age: Int = 21
}

class CxResultsTableController: NSViewController {
  var tableView: NSTableView? = nil
  let tableData: NSArrayController = NSArrayController()
  // loadView() is required if you want to create your ViewController without a (.nib)
  override func loadView() {
    self.tableView = NSTableView()
    let i = NSUserInterfaceItemIdentifier("sourceFile")
    let nameColumn = NSTableColumn(identifier: i)
    //nameColumn?.width = tableWidth * 0.4
    //nameColumn?.headerCell.title = "Name"
    self.tableView!.addTableColumn(nameColumn)
    self.tableView!.bind(NSBindingName.content,
                         to: self.tableData,
                         withKeyPath: "arrangedObjects",
                         options: nil)
    self.view = self.tableView!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func refresh(_ xIssues: [XIssue]) {
    print("COunt here")
    print(xIssues.count)
    let p1 = Person()
    p1.name = "Jeff"
    self.tableData.addObject(p1)
    //self.tableView!.delegate = self
    self.tableView!.reloadData()
  }
}

struct CxResultsTable: NSViewControllerRepresentable {
  @Binding var xIssues: [XIssue]?
  let parent: CxResultsView
  
  typealias NSViewControllerType = CxResultsTableController

  func makeNSViewController(context: NSViewControllerRepresentableContext<CxResultsTable>)
    -> CxResultsTableController {
      return CxResultsTableController()
  }

  func updateNSViewController(
      _ nsViewController: CxResultsTableController,
      context: NSViewControllerRepresentableContext<CxResultsTable>) {
    if xIssues != nil {
      nsViewController.refresh(xIssues!)
    }
    return
  }
}
