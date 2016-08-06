//
//  TabsControlCell.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 30/07/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Cocoa

class TabsControlCell: NSCell {
    
    var tabStyle: TabsControlTabsStyle = .NumbersApp {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var borderMask: TabsControlBorderMask = .Top {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabBorderColor: NSColor = NSColor.KPC_defaultTabBorderColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabBackgroundColor: NSColor = NSColor.KPC_defaultTabBackgroundColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabHighlightedBackgroundColor: NSColor = NSColor.KPC_defaultTabHighlightedBackgroundColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
   
    override init(textCell aString: String) {
        super.init(textCell: aString)
        
        self.bordered = true
        self.backgroundStyle = .Light
        self.focusRingType = .None
        self.enabled = false
        self.font = NSFont.systemFontOfSize(13)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

//    func highlight(flag: Bool) {
//        self.highlighted = flag
//        self.controlView?.needsDisplay = true
//    }
    
    override func cellSizeForBounds(aRect: NSRect) -> NSSize {
        return NSMakeSize(36.0, 0.0)
    }
    
    override func drawWithFrame(cellFrame: NSRect, inView controlView: NSView) {
        self.tabBackgroundColor.setFill()
        NSRectFill(cellFrame)
        
        var borderRects: Array<NSRect> = [NSZeroRect, NSZeroRect, NSZeroRect, NSZeroRect]
        var borderRectCount: NSInteger = 0
        
        if RectArrayWithBorderMask(cellFrame, borderMask: self.borderMask, rectArray: &borderRects, rectCount: &borderRectCount) {
            self.tabBorderColor.setFill()
            self.tabBorderColor.setStroke()
            NSRectFillList(borderRects, borderRectCount)
        }

    }
}