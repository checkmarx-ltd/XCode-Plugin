//
//  String.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 8/15/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import Foundation

extension String {
  var persistentHash: Int {
    let unicodeScalars = self.unicodeScalars.map { $0.value }
    return unicodeScalars.reduce(0) {
      (Int($1) &+ ($0 << 6) &+ ($0 << 16)).addingReportingOverflow(-$0).partialValue
    }
  }
}
