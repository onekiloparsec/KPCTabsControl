//
//  TabButtonCell.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 14/06/16.
//  Licensed under the MIT License (see LICENSE file)
//

import Foundation
import AppKit

let titleMargin: CGFloat = 5.0

class TabButtonCell: NSButtonCell {
    
    var hasTitleAlternativeIcon: Bool = false
    
    var isSelected: Bool {
        get { return self.state == NSOnState }
    }

    var showsIcon: Bool = false {
        didSet { self.controlView?.needsDisplay = true }
    }

    var showsMenu: Bool = false {
        didSet { self.controlView?.needsDisplay = true }
    }

    @available(*, deprecated=1.0)
    var tabStyle: TabsControlTabsStyle = .NumbersApp {
        didSet { self.controlView?.needsDisplay = true }
    }

    @available(*, deprecated=1.0, message="replaces KPC_auxiliaryButton's borderMask setting; move this to different drawing methods")
    var isAuxiliary = false

    var buttonPosition: TabButtonPosition = .middle {
        didSet { self.controlView?.needsDisplay = true }
    }

    var style: Style!

    @available(*, deprecated=1.0)
    var theme: Theme = DefaultTheme() {
        didSet { self.controlView?.needsDisplay = true }
    }

    @available(*, deprecated=1.0)
    var tabTitleColor: NSColor { return theme.tabStyle.titleColor }
    @available(*, deprecated=1.0)
    var tabSelectedTitleColor: NSColor { return theme.selectedTabStyle.titleColor }

    // MARK: - Initializers & Copy
    
    override init(textCell aString: String) {
        super.init(textCell: aString)

        self.bordered = true
        self.backgroundStyle = .Light
        self.highlightsBy = .ChangeBackgroundCellMask
        self.lineBreakMode = .ByTruncatingTail
        self.focusRingType = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func copy() -> AnyObject {
        let copy = TabButtonCell(textCell:self.title)

        copy.theme = self.theme
        copy.tabStyle = self.tabStyle
        copy.showsMenu = self.showsMenu
        copy.hasTitleAlternativeIcon = self.hasTitleAlternativeIcon

        copy.state = self.state
        copy.highlighted = self.highlighted
        return copy
    }
    
//    func highlight(flag: Bool) {
//        self.highlighted = flag
//        self.controlView?.needsDisplay = true
//    }
    
    // MARK: - Properties & Rects

    static func popupImage() -> NSImage {
        let path = NSBundle(forClass: self).pathForImageResource("KPCPullDownTemplate")!
        return NSImage(contentsOfFile: path)!.KPC_imageWithTint(NSColor.darkGrayColor())
    }

    override var attributedTitle: NSAttributedString {
        set { super.attributedTitle = newValue }
        get {
            let at: NSMutableAttributedString = super.attributedTitle.mutableCopy() as! NSMutableAttributedString
            
            at.addAttributes([NSForegroundColorAttributeName: self.activeTitleColor], range: NSMakeRange(0, at.length))
            
            let font = (self.isSelected == true) ? NSFont.boldSystemFontOfSize(13) : NSFont.systemFontOfSize(13)
            at.addAttributes([NSFontAttributeName : font], range: NSMakeRange(0, at.length))
            
            return at.copy() as! NSAttributedString
        }
    }
    
    func hasRoomToDrawFullTitle(inRect rect: NSRect) -> Bool {
        let titleDrawRect = self.titleRectForBounds(rect)
        let requiredMinimumWidth = self.attributedTitle.size().width + 2.0*titleMargin
        return requiredMinimumWidth <= NSWidth(titleDrawRect)
    }

    override func cellSizeForBounds(aRect: NSRect) -> NSSize {
        let titleSize = self.attributedTitle.size()
        let popupSize = (self.menu == nil) ? NSZeroSize : TabButtonCell.popupImage().size
        let cellSize = NSMakeSize(titleSize.width + (popupSize.width * 2) + 36, max(titleSize.height, popupSize.height));
        self.controlView?.invalidateIntrinsicContentSize()
        return cellSize;
    }
    
    func popupRectWithFrame(cellFrame: NSRect) -> NSRect {
        var popupRect = NSZeroRect
        popupRect.size = TabButtonCell.popupImage().size
        popupRect.origin = NSMakePoint(NSMaxX(cellFrame) - NSWidth(popupRect) - 8, NSMidY(cellFrame) - NSHeight(popupRect) / 2);
        return popupRect;
    }
    
    override func trackMouse(theEvent: NSEvent, inRect cellFrame: NSRect, ofView controlView: NSView, untilMouseUp flag: Bool) -> Bool {
        
        if self.hitTestForEvent(theEvent, inRect: controlView.superview!.frame, ofView: controlView.superview!) != NSCellHitResult.None {
        
            let popupRect = self.popupRectWithFrame(cellFrame)
            let location = controlView.convertPoint(theEvent.locationInWindow, fromView: nil)
            
            if self.menu?.itemArray.count > 0 && NSPointInRect(location, popupRect) {
                self.menu?.popUpMenuPositioningItem(self.menu!.itemArray.first,
                                                    atLocation: NSMakePoint(NSMidX(popupRect), NSMaxY(popupRect)),
                                                    inView: controlView)
                
                self.showsMenu = true
                return true
            }
        }
        
        return super.trackMouse(theEvent, inRect: cellFrame, ofView: controlView, untilMouseUp: flag)
    }
    
    override func titleRectForBounds(theRect: NSRect) -> NSRect {
        return style.titleRect(title: self.attributedTitle, inBounds: theRect, showingIcon: self.showsIcon)
    }

    // MARK: - Editing

    func edit(fieldEditor fieldEditor: NSText, inView view: NSView, delegate: NSTextDelegate) {

        self.highlighted = true

        let frame = editingRectForBounds(view.bounds)
        let length = (self.stringValue as NSString).length
        self.selectWithFrame(frame,
                             inView: view,
                             editor: fieldEditor,
                             delegate: delegate,
                             start: 0,
                             length: length)

        fieldEditor.drawsBackground = false
        fieldEditor.horizontallyResizable = true
        fieldEditor.font = self.font
        fieldEditor.alignment = self.alignment
        fieldEditor.textColor = NSColor.darkGrayColor().blendedColorWithFraction(0.5, ofColor: NSColor.blackColor())

        // Replace content so that resizing is triggered
        fieldEditor.string = ""
        fieldEditor.insertText(self.title)

        self.title = ""
    }

    func finishEditing(newValue: String) {
        self.title = newValue
    }

    func editingRectForBounds(rect: NSRect) -> NSRect {
        return self.titleRectForBounds(rect)//.offsetBy(dx: 0, dy: 1))
    }
    
    // MARK: - Drawing

    var activeTitleColor: NSColor {
        get { return (self.isSelected) ? self.tabSelectedTitleColor : self.tabTitleColor }
    }

    override func drawWithFrame(frame: NSRect, inView controlView: NSView) {

        self.style.drawTabBezel(frame: frame, position: self.buttonPosition, isSelected: self.isSelected)
        
        if self.hasRoomToDrawFullTitle(inRect: frame)
            || self.hasTitleAlternativeIcon == false {

            self.drawTitle(self.attributedTitle, withFrame: frame, inView: controlView)
        }

        if self.showsMenu {
            self.drawPopupButtonWithFrame(frame)
        }
    }

    override func drawTitle(title: NSAttributedString, withFrame frame: NSRect, inView controlView: NSView) -> NSRect {

        let titleRect = self.titleRectForBounds(frame)
        title.drawInRect(titleRect)
        return titleRect
    }

    private func drawPopupButtonWithFrame(frame: NSRect) {
        let image = TabButtonCell.popupImage()
        image.drawInRect(
            self.popupRectWithFrame(frame),
            fromRect: NSZeroRect,
            operation: .CompositeSourceOver,
            fraction: 1.0,
            respectFlipped: true,
            hints: nil)
    }
}
