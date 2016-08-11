//
//  TabsControlCell.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 30/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Cocoa

class TabsControlCell: NSCell {
    
    var borderMask: TabsControlBorderMask = .Top {
        didSet { self.controlView?.needsDisplay = true }
    }

    var theme: Theme = DefaultTheme() {
        didSet { self.controlView?.needsDisplay = true }
    }

    private var tabBarBorderColor: NSColor { return theme.tabBarStyle.borderColor }
    
    private var tabBarBackgroundColor: NSColor { return theme.tabBarStyle.backgroundColor }
    
    private var tabBarHighlightedBackgroundColor: NSColor { return theme.highlightedTabBarStyle.backgroundColor }
   
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
        self.tabBarBackgroundColor.setFill()
        NSRectFill(cellFrame)
        
        var borderRects: Array<NSRect> = [NSZeroRect, NSZeroRect, NSZeroRect, NSZeroRect]
        var borderRectCount: NSInteger = 0
        
        if RectArrayWithBorderMask(cellFrame, borderMask: self.borderMask, rectArray: &borderRects, rectCount: &borderRectCount) {
            self.tabBarBorderColor.setFill()
            self.tabBarBorderColor.setStroke()
            NSRectFillList(borderRects, borderRectCount)
        }

    }
}