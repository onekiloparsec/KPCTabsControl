//
//  TabButton.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 06/07/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import Foundation
import AppKit

public class TabButton: NSButton {
    var iconView: NSImageView?
    var alternativeTitleIconView: NSImageView?
    var trackingArea: NSTrackingArea?
    
    var tabButtonCell: TabButtonCell? {
        get { return self.cell as? TabButtonCell }
    }

    var representedObject: AnyObject? {
        get { return self.tabButtonCell?.representedObject }
        set { self.tabButtonCell?.representedObject = newValue }
    }

    var editable: Bool {
        get { return self.cell?.editable ?? false }
        set { self.cell?.editable = newValue }
    }

    public var icon: NSImage? = nil {
        didSet {
            if self.icon != nil && self.iconView == nil {
                self.iconView = NSImageView(frame: NSZeroRect)
                self.iconView?.imageFrameStyle = .None
                self.addSubview(self.iconView!)
            }
            else if (self.icon == nil && self.iconView != nil) {
                self.iconView?.removeFromSuperview()
                self.iconView = nil
            }
            self.iconView?.image = self.icon
            self.needsDisplay = true
        }
    }
    
    public var alternativeTitleIcon: NSImage? = nil {
        didSet {
            self.tabButtonCell?.hasTitleAlternativeIcon = (self.alternativeTitleIcon != nil)
            
            if self.alternativeTitleIcon != nil && self.alternativeTitleIconView == nil {
                self.alternativeTitleIconView = NSImageView(frame: NSZeroRect)
                self.alternativeTitleIconView?.imageFrameStyle = .None
                self.addSubview(self.alternativeTitleIconView!)
            }
            else if self.alternativeTitleIcon == nil && self.alternativeTitleIconView != nil {
                self.alternativeTitleIconView?.removeFromSuperview()
                self.alternativeTitleIconView = nil
            }
            self.alternativeTitleIconView?.image = self.alternativeTitleIcon
            self.needsDisplay = true
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.cell = TabButtonCell(textCell: "")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withItem item: AnyObject, target: AnyObject?, action:Selector) {
        super.init(frame: NSZeroRect)

        let tabCell = TabButtonCell(textCell: "")
        
        tabCell.representedObject = item
        tabCell.imagePosition = .NoImage
        
        tabCell.borderMask = [.Right, .Bottom]
        tabCell.target = target
        tabCell.action = action
        
        tabCell.sendActionOn(Int(NSEventMask.LeftMouseDownMask.rawValue))
        self.cell = tabCell
    }
    
    override public func copy() -> AnyObject {
        let copy = TabButton(frame: self.frame)
        copy.cell = self.cell?.copy() as? NSCell
        copy.icon = self.icon
        copy.alternativeTitleIcon = self.alternativeTitleIcon
        return copy
    }
    
    private func buttonCell() -> TabButtonCell? {
        return self.cell as? TabButtonCell
    }
    
//    public override func highlight(flag: Bool) {
//        if let c = self.cell as? TabButtonCell {
//            c.highlight(flag)
//        }
//    }
    
    public override var menu: NSMenu? {
        get { return self.cell?.menu }
        set {
            self.cell?.menu = newValue
            self.updateTrackingAreas()
        }
    }
    
    public override func updateTrackingAreas() {
        if let ta = self.trackingArea {
            self.removeTrackingArea(ta)
        }
        
        let item: AnyObject? = self.cell?.representedObject
        
        let userInfo: [String: AnyObject]? = (item != nil) ? ["item": item!] : nil
        self.trackingArea = NSTrackingArea(rect: self.bounds,
                                           options: [.MouseEnteredAndExited, .ActiveInActiveApp, .InVisibleRect],
                                           owner: self, userInfo: userInfo)
        
        self.addTrackingArea(self.trackingArea!)
        
        if let w = self.window, e = NSApp.currentEvent {
            let mouseLocation = w.mouseLocationOutsideOfEventStream
            let convertedMouseLocation = self.convertPoint(mouseLocation, fromView: nil)
        
            if NSPointInRect(convertedMouseLocation, self.bounds) {
                self.mouseEntered(e)
            }
            else {
                self.mouseExited(e)
            }
        }
        
        super.updateTrackingAreas()
    }
    
    public override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        self.tabButtonCell?.showsMenu = self.cell?.menu?.itemArray.count > 0
    }
    
    public override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent)
        self.tabButtonCell?.showsMenu = false
    }
    
    public override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: NSCursor.arrowCursor())
    }
    
    public override func drawRect(dirtyRect: NSRect) {
        let y: CGFloat = 2.0
        let s = CGRectGetHeight(self.frame) - 2*y
        let x = CGRectGetWidth(self.frame) / 2.0 - s / 2.0
        let scale = (self.layer != nil) ? self.layer!.contentsScale : 1.0
        
        self.iconView?.frame = NSMakeRect(10.0, y, s, s)
        self.alternativeTitleIconView?.frame = NSMakeRect(x, y, s, s)
                
        if self.icon?.size.width > 1.2*s*scale {
            let smallIcon = NSImage(size: NSMakeSize(s, s))
            smallIcon.addRepresentation(NSBitmapImageRep(data: self.icon!.TIFFRepresentation!)!)
            self.iconView?.image = smallIcon
        }
        
        if self.alternativeTitleIcon?.size.width > 1.2*s*scale {
            let smallIcon = NSImage(size: NSMakeSize(s, s))
            smallIcon.addRepresentation(NSBitmapImageRep(data: self.alternativeTitleIcon!.TIFFRepresentation!)!)
            self.alternativeTitleIconView?.image = smallIcon
        }
        
        if let tbc = self.tabButtonCell {
            let hasRoom = tbc.hasRoomToDrawFullTitle(inRect: self.bounds)
            self.alternativeTitleIconView?.hidden = hasRoom
            self.toolTip = (hasRoom == true) ? nil : self.title
        }
        
        super.drawRect(dirtyRect)
    }

    func edit(fieldEditor fieldEditor: NSText, delegate: NSTextDelegate) {
        tabButtonCell?.edit(fieldEditor: fieldEditor, inView: self, delegate: delegate)
    }
}
