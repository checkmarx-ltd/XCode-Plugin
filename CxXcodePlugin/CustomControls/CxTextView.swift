//
//  Testit.swift
//  CxXcodePlugin
//
//  Created by Jeff Armstrong on 7/7/20.
//  Copyright © 2020 Checkmarx. All rights reserved.
//
import SwiftUI

struct CxTextView: NSViewRepresentable {
  @Binding var text: String
  var textView = NSTextView(frame: .zero)
    
  func makeNSView(context: Context) -> NSTextView {
    self.textView.backgroundColor = NSColor.gray
    self.textView.frame = NSRect(x: 0, y: 0, width: 500, height: 10)
    return self.textView
  }

  func updateNSView(_ textView: NSTextView, context: Context) {
    textView.string = text
    print(textView.frame)
  }
}

class ScrollableInput: NSView {
    var scrollView = NSScrollView()
    var textView = NSTextView()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        let rect = CGRect(
            x: 0, y: 0,
            width: 0, height: CGFloat.greatestFiniteMagnitude
        )

        let layoutManager = NSLayoutManager()

        let textContainer = NSTextContainer(size: rect.size)
        layoutManager.addTextContainer(textContainer)
        textView = NSTextView(frame: rect, textContainer: textContainer)
        textView.maxSize = NSSize(width: 0, height: CGFloat.greatestFiniteMagnitude)

        textContainer.heightTracksTextView = false
        textContainer.widthTracksTextView = true

        textView.isRichText = false
        textView.importsGraphics = false
        textView.isEditable = true
        textView.isSelectable = true
        //textView.font = R.font.text
        //textView.textColor = R.color.text
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false

        addSubview(scrollView)
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        scrollView.drawsBackground = false
        textView.drawsBackground = false

  

        scrollView.documentView = textView
        textView.autoresizingMask = [.width]
    }

    required init?(coder decoder: NSCoder) {
        fatalError()
    }
}
