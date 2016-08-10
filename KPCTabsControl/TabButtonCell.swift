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
    
    var tabStyle: TabsControlTabsStyle = .NumbersApp {
        didSet { self.controlView?.needsDisplay = true }
    }
    
    var borderMask: TabsControlBorderMask = .Top {
        didSet { self.controlView?.needsDisplay = true }
    }

    var theme: Theme = DefaultTheme() {
        didSet { self.controlView?.needsDisplay = true }
    }

    var tabBorderColor: NSColor { return theme.tabStyle.borderColor }
    var tabTitleColor: NSColor { return theme.tabStyle.titleColor }
    var tabBackgroundColor: NSColor { return theme.tabStyle.backgroundColor }
    
    var tabSelectedBorderColor: NSColor { return theme.selectedTabStyle.borderColor }
    var tabSelectedTitleColor: NSColor { return theme.selectedTabStyle.titleColor }
    var tabSelectedBackgroundColor: NSColor { return theme.selectedTabStyle.backgroundColor }
    
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
        copy.borderMask = self.borderMask
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

        let titleSize = self.attributedTitle.size()
        let fullWidthRect = NSMakeRect(NSMinX(theRect), NSMidY(theRect) - titleSize.height/2.0, NSWidth(theRect), titleSize.height)

        return padedRectForIcon(fullWidthRect)
    }

    private func padedRectForIcon(rect: NSRect) -> NSRect {

        guard self.showsIcon else { return rect }

        let width = CGFloat(19) // TODO replace assumption about icon size with different mechanism (like handing down the `icon` to this cell, using `image` and code from commit `2f56dbdbfed4d15fa063b03301ed49d5e00cad6e`)
        let padding = CGFloat(8)
        let horizontalOffset = width + padding

        return rect.offsetBy(dx: horizontalOffset, dy: 0).shrinkBy(dx: horizontalOffset, dy: 0)
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

    var activeBorderColor: NSColor {
        get { return (self.isSelected) ? self.tabSelectedBorderColor : self.tabBorderColor }
    }
    
    var activeTitleColor: NSColor {
        get { return (self.isSelected) ? self.tabSelectedTitleColor : self.tabTitleColor }
    }

    var activeBackgroundColor: NSColor {
        get { return (self.isSelected) ? self.tabSelectedBackgroundColor : self.tabBackgroundColor }
    }

    override func drawWithFrame(frame: NSRect, inView controlView: NSView) {
        self.drawBezelWithFrame(frame, inView: controlView)
        
        if self.hasRoomToDrawFullTitle(inRect: frame)
            || self.hasTitleAlternativeIcon == false {

            self.drawTitle(self.attributedTitle, withFrame: frame, inView: controlView)
        }

        if self.showsMenu {
            self.drawPopupButtonWithFrame(frame)
        }
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
    }
    
    func drawNumbersTabsWithFrame(frame: NSRect, inView controlView: NSView) {
        let color = self.activeBackgroundColor
        color.setFill()
        NSRectFill(frame)
        
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




