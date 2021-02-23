//
//  CxFlowUpdateView.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/14/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//

import SwiftUI

struct CxFlowUpdateView: View {
  @EnvironmentObject var cxOptions: CxOptions
  
  var body: some View {
    VStack() {
      Text("Updating CxFlow, please wait...")
      CxActivityView(running: self.$cxOptions.progressUpdate)
        .frame(width: 200)
    }
  }
}

struct CxFlowUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        CxFlowUpdateView()
    }
}
