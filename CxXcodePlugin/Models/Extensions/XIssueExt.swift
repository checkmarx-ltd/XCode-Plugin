//
//  XIssueExt.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/12/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation

extension XIssue: Identifiable {
  public var id: UUID {
    get { return UUID() }    
  }
}
