//
//  CxOptionsEnv.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/6/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//

import SwiftUI
import Foundation

struct CxOptionsKey: EnvironmentKey {
  typealias Value = CxOptions
  static var defaultValue: CxOptions = CxOptions()
}

extension EnvironmentValues {
    var cxTestKey: CxOptions {
        get { self[CxOptionsKey.self] }
        set { self[CxOptionsKey.self] = newValue }
    }
}
