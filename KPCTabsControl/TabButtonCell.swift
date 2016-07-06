//
//  TabButtonCell.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation
import AppKit

let titleMargin: CGFloat = 5.0

class TabButtonCell: NSButtonCell {
    
    override var state: Int {
        get { return super.state }
        set {
            if self.controlView?.isKindOfClass(TabButton) == true {
                super.state = newValue
                self.controlView?.needsDisplay = true
            }
        }
    }
    
    override var image: NSImage? {
        get { return super.image }
        set {
            if self.controlView?.isKindOfClass(TabButton) == true {
                super.image = newValue
                self.controlView?.needsDisplay = true
            }
        }
    }
    
    var hasTitleAlternativeIcon: Bool = false
    var isSelected: Bool {
        get { return self.state == NSOnState }
    }

    var showsMenu: Bool {
        get { return self.showsMenu }
        set {
            self.showsMenu = newValue
            self.controlView?.needsDisplay = true
        }
    }
    
    var tabStyle: KPCTabStyle = KPCTabStyleNumbersApp
    var borderMask: KPCBorderMask = KPCBorderMaskTop
    
    var tabBorderColor: NSColor?
    var tabTitleColor: NSColor?
    var tabBackgroundColor: NSColor?
    var tabHighlightedBackgroundColor: NSColor?
    
    var tabSelectedBorderColor: NSColor?
    var tabSelectedTitleColor: NSColor?
    var tabSelectedBackgroundColor: NSColor?
    
    override init(textCell aString: String) {
        super.init(textCell: aString)

        self.bordered = true
        self.backgroundStyle = .Light
        self.highlightsBy = .ChangeBackgroundCellMask
        self.lineBreakMode = .ByTruncatingTail
        self.focusRingType = .None

        self.tabBorderColor = NSColor.KPC_defaultTabBorderColor()
        self.tabTitleColor = NSColor.KPC_defaultTabTitleColor()
        self.tabBackgroundColor = NSColor.KPC_defaultTabBackgroundColor()
        self.tabHighlightedBackgroundColor = NSColor.KPC_defaultTabHighlightedBackgroundColor()
        
        self.tabSelectedBorderColor = NSColor.KPC_defaultTabSelectedBorderColor()
        self.tabSelectedTitleColor = NSColor.KPC_defaultTabSelectedTitleColor()
        self.tabSelectedBackgroundColor = NSColor.KPC_defaultTabSelectedBackgroundColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func copy() -> AnyObject {
        let copy = TabButtonCell(textCell:self.title)
        
        copy.tabBorderColor = self.tabBorderColor
        copy.tabTitleColor = self.tabTitleColor
        copy.tabBackgroundColor = self.tabBackgroundColor
        copy.tabHighlightedBackgroundColor = self.tabHighlightedBackgroundColor
        
        copy.tabSelectedBorderColor = self.tabSelectedBorderColor
        copy.tabSelectedTitleColor = self.tabSelectedTitleColor
        copy.tabSelectedBackgroundColor = self.tabSelectedBackgroundColor
        
        copy.borderMask = self.borderMask
        copy.state = self.state
        copy.showsMenu = self.showsMenu
        copy.highlighted = self.highlighted
        copy.hasTitleAlternativeIcon = self.hasTitleAlternativeIcon
        
        return copy
    }
    
    func editingRectForBounds(rect: NSRect) -> NSRect {
        return self.titleRectForBounds(NSOffsetRect(rect, 0, 0)) // used to be != 0...
    }
    
    func highlight(flag: Bool) {
        self.highlighted = flag
        self.controlView?.needsDisplay = true
    }
    
    func hasRoomToDrawFullTitle(inRect rect: NSRect) -> Bool {
        let titleDrawRect = self.titleRectForBounds(rect)
        let requiredMinimumWidth = self.attributedTitle.size().width + 2.0*titleMargin;
        return requiredMinimumWidth <= NSWidth(titleDrawRect);
    }
}