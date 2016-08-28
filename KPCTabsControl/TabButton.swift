//
//  TabButton.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 06/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

public class TabButton: NSButton {

    private var iconView: NSImageView?
    private var alternativeTitleIconView: NSImageView?
    private var trackingArea: NSTrackingArea?
    
    private var tabButtonCell: TabButtonCell? {
        get { return self.cell as? TabButtonCell }
    }

    public var style: Style! {
        didSet { self.tabButtonCell?.style = self.style }
    }

    /// The button is aware of its last known index in the tab bar.
    var index: Int? = nil

    public var buttonPosition: TabButtonPosition! {
        get { return tabButtonCell?.buttonPosition }
        set { self.tabButtonCell?.buttonPosition = newValue }
    }

    public var representedObject: AnyObject? {
        get { return self.tabButtonCell?.representedObject }
        set { self.tabButtonCell?.representedObject = newValue }
    }

    public var editable: Bool {
        get { return self.tabButtonCell?.editable ?? false }
        set { self.tabButtonCell?.editable = newValue }
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
            self.tabButtonCell?.showsIcon = (self.icon != nil)
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
    
    // MARK: - Init

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.cell = TabButtonCell(textCell: "")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(index: Int, item: AnyObject, target: AnyObject?, action:Selector, style: Style) {
        super.init(frame: NSZeroRect)

        self.index = index
        self.style = style

        let tabCell = TabButtonCell(textCell: "")
        
        tabCell.representedObject = item
        tabCell.imagePosition = .NoImage
        
        tabCell.target = target
        tabCell.action = action
        tabCell.style = style
        
        tabCell.sendActionOn(Int(NSEventMask.LeftMouseDownMask.rawValue))
        self.cell = tabCell
    }
    
    override public func copy() -> AnyObject {
        let copy = TabButton(frame: self.frame)
        copy.cell = self.cell?.copy() as? NSCell
        copy.icon = self.icon
        copy.style = self.style
        copy.alternativeTitleIcon = self.alternativeTitleIcon
        copy.state = self.state
        copy.index = self.index
        return copy
    }
        
    public override var menu: NSMenu? {
        get { return self.cell?.menu }
        set {
            self.cell?.menu = newValue
            self.updateTrackingAreas()
        }
    }
    
    // MARK: - Drawing

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

        guard let tabButtonCell = self.tabButtonCell
            else { assertionFailure("TabButtonCell expected in drawRect(_:)"); return }

        let iconFrames = self.style.iconFrames(tabRect: self.frame)
        self.iconView?.frame = iconFrames.iconFrame
        self.alternativeTitleIconView?.frame = iconFrames.alternativeTitleIconFrame

        let scale: CGFloat = (self.layer != nil) ? self.layer!.contentsScale : 1.0

        if self.icon?.size.width > CGRectGetHeight(iconFrames.iconFrame)*scale {
            let smallIcon = NSImage(size: iconFrames.iconFrame.size)
            smallIcon.addRepresentation(NSBitmapImageRep(data: self.icon!.TIFFRepresentation!)!)
            self.iconView?.image = smallIcon
        }

        if self.alternativeTitleIcon?.size.width > CGRectGetHeight(iconFrames.alternativeTitleIconFrame)*scale {
            let smallIcon = NSImage(size: iconFrames.alternativeTitleIconFrame.size)
            smallIcon.addRepresentation(NSBitmapImageRep(data: self.alternativeTitleIcon!.TIFFRepresentation!)!)
            self.alternativeTitleIconView?.image = smallIcon
        }

        let hasRoom = tabButtonCell.hasRoomToDrawFullTitle(inRect: self.bounds)
        self.alternativeTitleIconView?.hidden = hasRoom
        self.toolTip = (hasRoom == true) ? nil : self.title

        super.drawRect(dirtyRect)
    }

    
    // MARK: - Editing
    
    internal func edit(fieldEditor fieldEditor: NSText, delegate: NSTextDelegate) {
        self.tabButtonCell?.edit(fieldEditor: fieldEditor, inView: self, delegate: delegate)
    }
    
    internal func finishEditing(fieldEditor fieldEditor: NSText, newValue: String) {
        self.tabButtonCell?.finishEditing(fieldEditor: fieldEditor, newValue: newValue)
    }
}
