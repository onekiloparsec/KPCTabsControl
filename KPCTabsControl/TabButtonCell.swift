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
    
    var hasTitleAlternativeIcon: Bool = false
    
    var isSelected: Bool {
        get { return self.state == NSOnState }
    }

    var showsMenu: Bool = false {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabStyle: TabsControlTabsStyle = .NumbersApp {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var borderMask: TabsControlBorderMask = .Top {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabBorderColor: NSColor = NSColor.KPC_defaultTabBorderColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabTitleColor: NSColor = NSColor.KPC_defaultTabTitleColor() {
        didSet { self.controlView?.needsDisplay = true }
    }

    var activeBackgroundColor: NSColor {
        if self.highlighted {
            return self.tabHighlightedBackgroundColor
        }

        return self.tabBackgroundColor
    }

    var tabBackgroundColor: NSColor = NSColor.KPC_defaultTabBackgroundColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabHighlightedBackgroundColor: NSColor = NSColor.KPC_defaultTabHighlightedBackgroundColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabSelectedBorderColor: NSColor = NSColor.KPC_defaultTabSelectedBorderColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabSelectedTitleColor: NSColor = NSColor.KPC_defaultTabSelectedTitleColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var tabSelectedBackgroundColor: NSColor = NSColor.KPC_defaultTabSelectedBackgroundColor() {
        didSet { self.controlView?.needsDisplay = true }
    }
    
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
        
        copy.tabBorderColor = self.tabBorderColor
        copy.tabTitleColor = self.tabTitleColor
        copy.tabBackgroundColor = self.tabBackgroundColor
        copy.tabHighlightedBackgroundColor = self.tabHighlightedBackgroundColor
        
        copy.tabSelectedBorderColor = self.tabSelectedBorderColor
        copy.tabSelectedTitleColor = self.tabSelectedTitleColor
        copy.tabSelectedBackgroundColor = self.tabSelectedBackgroundColor
        
        copy.tabStyle = self.tabStyle
        copy.borderMask = self.borderMask
        copy.showsMenu = self.showsMenu
        copy.hasTitleAlternativeIcon = self.hasTitleAlternativeIcon

        copy.state = self.state
        copy.highlighted = self.highlighted

        return copy
    }
    
    func highlight(flag: Bool) {
        self.highlighted = flag
        self.controlView?.needsDisplay = true
    }
    
    // MARK: - Properties & Rects

    static func popupImage() -> NSImage {
        let path = NSBundle(forClass: self).pathForImageResource("KPCPullDownTemplate")!
        return NSImage(contentsOfFile: path)!.KPC_imageWithTint(NSColor.darkGrayColor())
    }
    
    override var attributedTitle: NSAttributedString {
        set { super.attributedTitle = newValue }
        get {
            let at: NSMutableAttributedString = super.attributedTitle.mutableCopy() as! NSMutableAttributedString
            
            let color = (self.isSelected == true) ? self.tabSelectedTitleColor : self.tabTitleColor
            at.addAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(0, at.length))
            
            let font = (self.highlighted == true) ? NSFont.boldSystemFontOfSize(13) : NSFont.systemFontOfSize(13)
            at.addAttributes([NSFontAttributeName : font], range: NSMakeRange(0, at.length))
            
            return at.copy() as! NSAttributedString
        }
    }
    
    func hasRoomToDrawFullTitle(inRect rect: NSRect) -> Bool {
        let titleDrawRect = self.titleRectForBounds(rect)
        let requiredMinimumWidth = self.attributedTitle.size().width + 2.0*titleMargin;
        return requiredMinimumWidth <= NSWidth(titleDrawRect);
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
                self.menu?.popUpMenuPositioningItem(self.menu!.itemArray.first, atLocation: NSMakePoint(NSMidX(popupRect), NSMaxY(popupRect)), inView: controlView)
                
                self.showsMenu = true
                return true
            }
        }
        
        return super.trackMouse(theEvent, inRect: cellFrame, ofView: controlView, untilMouseUp: flag)
    }
    
    override func titleRectForBounds(theRect: NSRect) -> NSRect {
        let titleSize = self.attributedTitle.size()
        return NSMakeRect(NSMinX(theRect), NSMidY(theRect) - titleSize.height/2.0, NSWidth(theRect), titleSize.height)
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

        fieldEditor.backgroundColor = self.activeBackgroundColor
        fieldEditor.drawsBackground = true
        fieldEditor.horizontallyResizable = true
        fieldEditor.font = self.font
        fieldEditor.alignment = self.alignment
        fieldEditor.textColor = NSColor.darkGrayColor().blendedColorWithFraction(0.5, ofColor: NSColor.blackColor())

        // Replace content so that resizing is triggered
        fieldEditor.string = ""
        fieldEditor.insertText(self.title)
    }

    func editingRectForBounds(rect: NSRect) -> NSRect {
        return self.titleRectForBounds(NSOffsetRect(rect, 0, 0)) // used to be different from 0...
    }
    
    // MARK: - Drawing

    override func drawWithFrame(frame: NSRect, inView controlView: NSView) {
        self.drawBezelWithFrame(frame, inView: controlView)
        
        if self.hasRoomToDrawFullTitle(inRect: frame) || self.hasTitleAlternativeIcon == false {
            self.drawTitle(self.attributedTitle, withFrame: frame, inView: controlView)
        }
        
        if self.image != nil && self.imagePosition != .NoImage {
            let tint = (self.highlighted == true) ? NSColor.darkGrayColor() : NSColor.lightGrayColor()
            self.drawImage(self.image!.KPC_imageWithTint(tint), withFrame: frame, inView: controlView)
        }
        
        if self.showsMenu == true {
            TabButtonCell.popupImage().drawInRect(self.popupRectWithFrame(frame), fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1.0, respectFlipped: true, hints: nil)
        }
    }
    
    override func drawTitle(title: NSAttributedString, withFrame frame: NSRect, inView controlView: NSView) -> NSRect {
        let titleRect = self.titleRectForBounds(frame)
        title.drawInRect(titleRect)
        return titleRect
    }

    override func drawBezelWithFrame(frame: NSRect, inView controlView: NSView) {
        if controlView.isKindOfClass(TabButton) {
            switch self.tabStyle {
            case .NumbersApp:
                self.drawNumbersTabsWithFrame(frame, inView: controlView)
            case .ChromeBrowser:
                self.drawChromeTabsWithFrame(frame, inView: controlView)
            default:
                break
            }
        }
        else {
            let color = self.activeBackgroundColor
            color.setFill()
            NSRectFill(frame)
        }
    }
    
    func drawNumbersTabsWithFrame(frame: NSRect, inView controlView: NSView) {
        var borderRects: Array<NSRect> = [NSZeroRect, NSZeroRect, NSZeroRect, NSZeroRect]
        var borderRectCount: NSInteger = 0
        
        if RectArrayWithBorderMask(frame, borderMask: self.borderMask, rectArray: &borderRects, rectCount: &borderRectCount) {
            let color = (self.isSelected == true) ? self.tabSelectedBorderColor : self.tabBorderColor
            color.setFill()
            self.tabBorderColor.setStroke()
            NSRectFillList(borderRects, borderRectCount)
        }
    }

    func drawChromeTabsWithFrame(frame: NSRect, inView controlView: NSView) {
        self.activeBackgroundColor.setFill()
        NSRectFill(frame)
        
        let path = NSBezierPath()
        
//        let top = CGRectGetMinY(controlView.bounds)+1
        let bottom = CGRectGetMaxY(controlView.bounds)
        let left = CGRectGetMinX(controlView.bounds)
//        let right = CGRectGetMaxX(controlView.bounds)
        
        let startPoint = CGPointMake(left, bottom)
        path.moveToPoint(startPoint)
        
        let risingFromPoint = CGPointMake(left+5.0, bottom)
        let risingPoint = CGPointMake(left+5.0, bottom-3.0)
        path.appendBezierPathWithArcFromPoint(risingFromPoint, toPoint:risingPoint, radius:3.0)
        
        //    CGPoint beforeTopPoint = CGPointMake(left+20.0, top+5.0);
        //    [path lineToPoint:beforeTopPoint];
        //
        //    CGPoint topPoint = CGPointMake(left+25.0, top);
        //    [path lineToPoint:topPoint];
        //
        //    CGPoint secondTopPoint = CGPointMake(right-15.0, top);
        //    [path lineToPoint:secondTopPoint];
        //
        //    CGPoint fallingPoint = CGPointMake(right-10.0, top+5.0);
        //    [path lineToPoint:fallingPoint];
        //
        //    CGPoint finishPoint = CGPointMake(right-5.0, bottom-5.0);
        //    [path lineToPoint:finishPoint];
        //
        //    CGPoint endPoint = CGPointMake(right, bottom);
        //    [path lineToPoint:endPoint];
        
        NSColor.redColor().setStroke()
        path.lineWidth = 1.0
        path.stroke()
        //    [path closePath];
        //    [path fill];

    }
}


func RectArrayWithBorderMask(sourceRect: NSRect, borderMask: TabsControlBorderMask, inout rectArray: Array<NSRect>, inout rectCount: NSInteger) -> Bool
{
    var outputCount: NSInteger = 0
    var remainderRect: NSRect = NSZeroRect
    
    if borderMask.contains(.Top) {
        NSDivideRect(sourceRect, &rectArray[outputCount], &remainderRect, 1, .MinY)
        outputCount += 1
    }
    if borderMask.contains(.Left) {
        NSDivideRect(sourceRect, &rectArray[outputCount], &remainderRect, 1, .MinX)
        outputCount += 1
    }
    if borderMask.contains(.Right) {
        NSDivideRect(sourceRect, &rectArray[outputCount], &remainderRect, 1, .MaxX)
        outputCount += 1
    }
    if borderMask.contains(.Bottom) {
        NSDivideRect(sourceRect, &rectArray[outputCount], &remainderRect, 1, .MaxY)
        outputCount += 1
    }
    
    rectCount = outputCount
    
    return (outputCount > 0)
}




