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
        get { return self.state == NSControl.StateValue.on }
    }
    
    var selectionState: TabSelectionState {
        return self.isEnabled == false ? TabSelectionState.unselectable : (self.isSelected ? TabSelectionState.selected : TabSelectionState.normal)
    }

    var showsIcon: Bool {
        get { return (self.controlView as! TabButton).icon != nil }
    }

    var showsMenu: Bool {
        get { return self.menu?.items.count > 0 }
    }

    var buttonPosition: TabPosition = .middle {
        didSet { self.controlView?.needsDisplay = true }
    }

    var style: Style!

    // MARK: - Initializers & Copy
    
    override init(textCell aString: String) {
        super.init(textCell: aString)

        self.isBordered = true
        self.backgroundStyle = .light
        self.highlightsBy = NSCell.StyleMask.changeBackgroundCellMask
        self.lineBreakMode = .byTruncatingTail
        self.focusRingType = .none
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func copy() -> Any {
        let copy = TabButtonCell(textCell:self.title)

        copy.hasTitleAlternativeIcon = self.hasTitleAlternativeIcon
        copy.buttonPosition = self.buttonPosition

        copy.state = self.state
        copy.isHighlighted = self.isHighlighted
        
        return copy
    }
    
    // MARK: - Properties & Rects

    static func popupImage() -> NSImage {
        let path = Bundle(for: self).pathForImageResource(NSImage.Name(rawValue: "KPCPullDownTemplate"))!
        return NSImage(contentsOfFile: path)!.imageWithTint(NSColor.darkGray)
    }

    func hasRoomToDrawFullTitle(inRect rect: NSRect) -> Bool {
        let title = self.style.attributedTitle(content: self.title, selectionState: self.selectionState)
        let requiredMinimumWidth = title.size().width + 2.0*titleMargin
        let titleDrawRect = self.titleRect(forBounds: rect)
        return requiredMinimumWidth <= NSWidth(titleDrawRect)
    }

    override func cellSize(forBounds aRect: NSRect) -> NSSize {
        let title = self.style.attributedTitle(content: self.title, selectionState: self.selectionState)
        let titleSize = title.size()
        let popupSize = (self.menu == nil) ? NSZeroSize : TabButtonCell.popupImage().size
        let cellSize = NSMakeSize(titleSize.width + (popupSize.width * 2) + 36, max(titleSize.height, popupSize.height))
        self.controlView?.invalidateIntrinsicContentSize()
        return cellSize
    }
    
    fileprivate func popupRectWithFrame(_ cellFrame: NSRect) -> NSRect {
        var popupRect = NSZeroRect
        popupRect.size = TabButtonCell.popupImage().size
        popupRect.origin = NSMakePoint(NSMaxX(cellFrame) - NSWidth(popupRect) - 8, NSMidY(cellFrame) - NSHeight(popupRect) / 2)
        return popupRect
    }
    
    override func trackMouse(with theEvent: NSEvent,
                             in cellFrame: NSRect,
                                    of controlView: NSView,
                                           untilMouseUp flag: Bool) -> Bool
    {
        if self.hitTest(for: theEvent,
                                in: controlView.superview!.frame,
                                of: controlView.superview!) != NSCell.HitResult()
        {
        
            let popupRect = self.popupRectWithFrame(cellFrame)
            let location = controlView.convert(theEvent.locationInWindow, from: nil)
            
            if self.menu?.items.count > 0 && NSPointInRect(location, popupRect) {
                self.menu?.popUp(positioning: self.menu!.items.first,
                                                    at: NSMakePoint(NSMidX(popupRect), NSMaxY(popupRect)),
                                                    in: controlView)
                
                return true
            }
        }
        
        return super.trackMouse(with: theEvent, in: cellFrame, of: controlView, untilMouseUp: flag)
    }
    
    override func titleRect(forBounds theRect: NSRect) -> NSRect {
        let title = self.style.attributedTitle(content: self.title, selectionState: self.selectionState)
        var rect = self.style.titleRect(title: title, inBounds: theRect, showingIcon: self.showsIcon)
        if self.showsMenu {
            let popupRect = self.popupRectWithFrame(theRect)
            rect.size.width -= popupRect.width + 2*titleMargin
        }
        return rect
    }

    // MARK: - Editing

    func edit(fieldEditor: NSText, inView view: NSView, delegate: NSTextDelegate) {

        self.isHighlighted = true

        let frame = self.editingRectForBounds(view.bounds)
        self.select(withFrame: frame,
                             in: view,
                             editor: fieldEditor,
                             delegate: delegate,
                             start: 0,
                             length: 0)

        fieldEditor.drawsBackground = false
        fieldEditor.isHorizontallyResizable = true
        fieldEditor.isEditable = true

        let editorSettings = self.style.titleEditorSettings()
        fieldEditor.font = editorSettings.font
        fieldEditor.alignment = editorSettings.alignment
        fieldEditor.textColor = editorSettings.textColor

        // Replace content so that resizing is triggered
        fieldEditor.string = ""
        fieldEditor.insertText(self.title)
        fieldEditor.selectAll(self)

        self.title = ""
    }

    func finishEditing(fieldEditor: NSText, newValue: String) {
        self.endEditing(fieldEditor)
        self.title = newValue
    }

    func editingRectForBounds(_ rect: NSRect) -> NSRect {
        return self.titleRect(forBounds: rect)//.offsetBy(dx: 0, dy: 1))
    }
    
    // MARK: - Drawing

    override func draw(withFrame frame: NSRect, in controlView: NSView) {

        self.style.drawTabButtonBezel(frame: frame, position: self.buttonPosition, isSelected: self.isSelected)
        
        if self.hasRoomToDrawFullTitle(inRect: frame) || self.hasTitleAlternativeIcon == false {
            let title = self.style.attributedTitle(content: self.title, selectionState: self.selectionState)
            _ = self.drawTitle(title, withFrame: frame, in: controlView)
        }

        if self.showsMenu {
            self.drawPopupButtonWithFrame(frame)
        }
    }

    override func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
        let titleRect = self.titleRect(forBounds: frame)
        title.draw(in: titleRect)
        return titleRect
    }

    fileprivate func drawPopupButtonWithFrame(_ frame: NSRect) {
        let image = TabButtonCell.popupImage()
        image.draw(in: self.popupRectWithFrame(frame),
                         from: NSZeroRect,
                         operation: .sourceOver,
                         fraction: 1.0,
                         respectFlipped: true,
                         hints: nil)
    }
}
