//
//  CxPropertiesExt.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/4/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation

extension CxProperties: Identifiable {
  public var uiBaseURL: String {
    get { return self.baseURL ?? "" }
    set {
      self.baseURL = newValue
      update()
    }
  }
  
  public var uiLabel: String {
    get { return self.label ?? "" }
    set {
      self.label = newValue
      update()
    }
  }
  
  public var uiProxyServer: String {
    get { return self.proxyServer ?? "" }
    set {
      self.proxyServer = newValue
      update()
    }
  }
  
  public var uiProxyServerUser: String {
    get { return self.proxyServerUser ?? "" }
    set {
      self.proxyServerUser = newValue
      update()
    }
  }
  
  public var uiProxyServerPassword: String {
    get { return self.proxyServerPassword ?? "" }
    set {
      self.proxyServerPassword = newValue
      update()
    }
  }
  
  public var uiFilterCategory: String {
    get { return self.filterCategory ?? "" }
    set {
      self.filterCategory = newValue
      update()
    }
  }
  
  public var uiFilterSeverityHigh: Bool {
    get { self.filterSeverityHigh }
    set {
      self.filterSeverityHigh = newValue
      update()
    }
  }
  
  public var uiFilterSeverityMedium: Bool {
    get { self.filterSeverityMedium }
    set {
      self.filterSeverityMedium = newValue
      update()
    }
  }
  
  public var uiFilterSeverityLow: Bool {
    get { self.filterSeverityLow }
    set {
      self.filterSeverityLow = newValue
      update()
    }
  }
  
  public var uiFilterSeverityInfo: Bool {
    get { self.filterSeverityInfo }
    set {
      self.filterSeverityInfo = newValue
      update()
    }
  }
  
  public var uiFilterStatusNew: Bool {
    get { self.filterStatusNew }
    set {
      self.filterStatusNew = newValue
      update()
    }
  }
  
  public var uiFilterStatusConfirmed: Bool {
    get { self.filterStatusConfirmed }
    set {
      self.filterStatusConfirmed = newValue
      update()
    }
  }
  
  public var uiUsername: String {
    get { return self.username ?? "" }
    set {
      self.username = newValue
      update()
    }
  }
  
  public var uiPassword: String {
    get { self.password ?? "" }
    set {
      self.password = newValue
      update()
    }
  }
  
  public var uiAppName: String {
    get { self.appName ?? "" }
    set {
      self.appName = newValue
      update()
    }
  }
  
  public var uiProjectName: String {
    get { self.projectName ?? "" }
    set {
      self.projectName = newValue
      update()
    }
  }
  
  public var uiScanPreset: String {
    get { self.scanPreset ?? "" }
    set {
      self.scanPreset = newValue
      update()
    }
  }
  
  public var uiCxFlowPath: String {
    get { self.cxFlowPath ?? "" }
    set {
      self.cxFlowPath = newValue
      update()
    }
  }
  
  public var uiSourcePath: String {
    get { self.sourcePath ?? "" }
    set {
      self.sourcePath = newValue
      update()
    }
  }
  
  public var uiIncremental: Bool {
    get { self.incremental }
    set {
      self.incremental = newValue
      update()
    }
  }
  
  public var uiUseProxyServer: Bool {
    get { self.userProxyServer }
    set {
      self.userProxyServer = newValue
      update()
    }
  }
  
  public var uiTeam: String {
    get { self.team ?? "" }
    set {
      self.team = newValue
      update()
    }
  }
  
  func update() {
    CxCoreData.shared.update()
  }
}
