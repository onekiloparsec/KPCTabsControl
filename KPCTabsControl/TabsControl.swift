//
//  TabsControl.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import AppKit

public class TabsControl: NSControl {
    private var ScrollViewObservationContext: UnsafeMutablePointer<Void> = nil // hm, wrong
    private var delegateInterceptor = MessageInterceptor()
    
    private var scrollView: NSScrollView? = nil
    private var tabsView: NSView? = nil
    private var editingTextField: NSTextField? = nil

    private var addButton: NSButton? = nil
    private var scrollLeftButton: NSButton? = nil
    private var scrollRightButton: NSButton? = nil
    private weak var selectedButton: TabButton? = nil

    private var hideScrollButtons: Bool = true
    private var isHighlighted: Bool = false

    // MARK: - Public Properties
    
    @IBOutlet public weak var dataSource: TabsControlDataSource?
    @IBOutlet public weak var delegate: TabsControlDelegate? {
        get { return self.delegateInterceptor.receiver as? TabsControlDelegate }
        set { self.delegateInterceptor.receiver = newValue as? NSObject }
    }

    public var automaticSideBorderMasks: Bool = true {
        didSet { self.propagateBorderMask() }
    }
    public var preferFullWidthTabs: Bool = false {
        didSet {
            self.layoutTabButtons(self.tabButtons(), animated: true)
            self.updateAuxiliaryButtons()
        }
    }
    
    public var minTabWidth: CGFloat =  50.0 {
        didSet {
            self.layoutTabButtons(self.tabButtons(), animated: true)
            self.updateAuxiliaryButtons()
        }
    }
    public var maxTabWidth: CGFloat = 150.0 {
        didSet {
            self.layoutTabButtons(self.tabButtons(), animated: true)
            self.updateAuxiliaryButtons()
        }
    }

//    public override var highlighted: Bool {
//        get { return true }
//    }
    
    // MARK: - Public Computed Properties
    
    var tabButtonCell: TabButtonCell {
        get { return self.cell as! TabButtonCell }
    }

    public var tabsStyle: TabsControlTabsStyle {
        get { return self.tabButtonCell.tabStyle }
        set {
            self.tabButtonCell.tabStyle = newValue
            self.tabButtons().forEach { $0.tabButtonCell?.tabStyle = newValue }
        }
    }
    public var bordersMask: TabsControlBorderMask {
        get { return self.tabButtonCell.borderMask }
        set {
            self.tabButtonCell.borderMask = newValue
            self.propagateBorderMask()
        }
    }
    
    // MARK: - Public TabControl Color Properties
    
    public var controlBorderColor: NSColor = NSColor.KPC_defaultControlBorderColor() {
        didSet { self.needsDisplay = true }
    }
    public var controlBackgroundColor: NSColor = NSColor.KPC_defaultControlBackgroundColor() {
        didSet { self.needsDisplay = true }
    }
    public var controlHighlightedBackgroundColor: NSColor = NSColor.KPC_defaultControlHighlightedBackgroundColor() {
        didSet { self.needsDisplay = true }
    }

    // MARK: - Public Tabs Color Properties

    public var tabBorderColor: NSColor = NSColor.KPC_defaultTabBorderColor() {
        didSet { self.tabButtons().forEach{ $0.tabButtonCell?.tabBorderColor = self.tabBorderColor } }
    }
    public var tabTitleColor: NSColor = NSColor.KPC_defaultTabBorderColor() {
        didSet { self.tabButtons().forEach{ $0.tabButtonCell?.tabTitleColor = self.tabTitleColor } }
    }
    public var tabBackgroundColor: NSColor = NSColor.KPC_defaultTabTitleColor() {
        didSet { self.tabButtons().forEach{ $0.tabButtonCell?.tabBackgroundColor = self.tabBackgroundColor } }
    }
    public var tabHighlightedBackgroundColor: NSColor = NSColor.KPC_defaultTabBackgroundColor() {
        didSet { self.tabButtons().forEach{ $0.tabButtonCell?.tabHighlightedBackgroundColor = self.tabHighlightedBackgroundColor } }
    }
    public var tabSelectedBorderColor: NSColor = NSColor.KPC_defaultTabHighlightedBackgroundColor() {
        didSet { self.tabButtons().forEach{ $0.tabButtonCell?.tabSelectedBorderColor = self.tabSelectedBorderColor } }
    }
    public var tabSelectedTitleColor: NSColor = NSColor.KPC_defaultTabSelectedTitleColor() {
        didSet { self.tabButtons().forEach{ $0.tabButtonCell?.tabSelectedTitleColor = self.tabSelectedTitleColor } }
    }
    public var tabSelectedBackgroundColor: NSColor = NSColor.KPC_defaultTabSelectedBackgroundColor() {
        didSet { self.tabButtons().forEach{ $0.tabButtonCell?.tabSelectedBackgroundColor = self.tabSelectedBackgroundColor } }
    }
    
    // MARK: - Initializers & Setup
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    func setup() {
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.cell = TabButtonCell(textCell: "")
        self.cell?.font = NSFont.systemFontOfSize(13)
        
        self.bordersMask = .Top
        self.tabsStyle = .NumbersApp
        
        self.highlight(false)
        if self.scrollView == nil {
            self.configureSubviews()
        }
    }
    
    private func configureSubviews() {
        self.scrollView = NSScrollView(frame: self.bounds)
        self.scrollView?.drawsBackground = false
        self.scrollView?.hasHorizontalScroller = false
        self.scrollView?.hasVerticalScroller = false
        self.scrollView?.usesPredominantAxisScrolling = true
        self.scrollView?.horizontalScrollElasticity = .Allowed
        self.scrollView?.verticalScrollElasticity = .None
        self.scrollView?.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        self.scrollView?.translatesAutoresizingMaskIntoConstraints = true
        
        self.tabsView = NSView(frame: self.scrollView!.bounds)
        self.scrollView?.documentView = self.tabsView
        
        self.addSubview(self.scrollView!)
        
        if self.hideScrollButtons == false {
            self.scrollLeftButton = NSButton.KPC_auxiliaryButton(withImageNamed: "KPCTabLeftTemplate", target: self, action: #selector(TabsControl.scrollTabView(_:)))
            
            self.scrollRightButton = NSButton.KPC_auxiliaryButton(withImageNamed: "KPCTabRightTemplate", target: self, action: #selector(TabsControl.scrollTabView(_:)))
            
            self.scrollLeftButton?.autoresizingMask = .ViewMinXMargin
            self.scrollLeftButton?.autoresizingMask = .ViewMinXMargin
            
            let leftCell = self.scrollLeftButton!.cell as! TabButtonCell
            leftCell.borderMask = leftCell.borderMask.union(.Left)
            
            self.addSubview(self.scrollLeftButton!)
            self.addSubview(self.scrollRightButton!)
            
            // This is typically what's autolayout is supposed to help avoiding.
            // But for pixel-control freaking guys like me, I see no escape.
            var r = CGRectZero
            r.size.height = CGRectGetHeight(self.scrollView!.frame)
            r.size.width = CGRectGetWidth(self.scrollLeftButton!.frame)
            r.origin.x = CGRectGetMaxX(self.scrollView!.frame) - r.size.width
            self.scrollRightButton!.frame = r;
            r.origin.x -= r.size.width;
            self.scrollLeftButton!.frame = r;
        }
        
        self.startObservingScrollView()
        self.updateAuxiliaryButtons()
    }
    
    deinit {
        self.stopObservingScrollView()
    }
    
    // MARK: - Public Overrides

    public override func menuForEvent(event: NSEvent) -> NSMenu? {
        return nil
    }
    
    // MARK: - Data Source
    
    public func reloadTabs() {
        guard let dataSource = self.dataSource else {
            // no effect if there is dataSource
            return
        }
        
        let tabCell = self.cell as! TabButtonCell
        self.tabButtons().forEach { $0.removeFromSuperview() }
        
        let newItemsCount = dataSource.tabsControlNumberOfTabs(self)
        for i in 0..<newItemsCount {
            let item = dataSource.tabsControl(self, itemAtIndex: i)
            let button = TabButton(withItem: item, target: self, action: #selector(TabsControl.selectTab(_:)))
            
            var borderMask = tabCell.borderMask
            if i == 0 && self.automaticSideBorderMasks == true {
                borderMask = borderMask.union(.Left)
            }
            if i == newItemsCount-1 && self.automaticSideBorderMasks == true {
                borderMask = borderMask.union(.Right)
            }
            let buttonCell = button.cell as! TabButtonCell
            buttonCell.borderMask = borderMask
            
            button.title = dataSource.tabsControl(self, titleForItem: item)
            button.state = (item === self.selectedItem) ? NSOnState : NSOffState // yes triple === to check for instances
            button.highlight(self.isHighlighted)
            
            if let img = dataSource.tabsControl?(self, iconForItem: item) {
                button.icon = img
            }
            if let menu = dataSource.tabsControl?(self, menuForItem: item) {
                button.menu = menu
            }
            if let altIcon = dataSource.tabsControl?(self, titleAlternativeIconForItem: item) {
                button.alternativeTitleIcon = altIcon
            }
            
            self.tabsView?.addSubview(button)
        }
        
        self.layoutTabButtons(nil, animated: false)
        self.updateAuxiliaryButtons()
        self.invalidateRestorableState()
    }
    
    // MARK: - Layout

    private func layoutTabButtons(buttons: Array<TabButton>?, animated anim: Bool) {
        let tabButtons = (buttons != nil) ? buttons! : self.tabButtons()
        var tabsViewWidth = CGFloat(0.0)
        
        let fullSizeWidth = CGRectGetWidth(self.scrollView!.frame) / CGFloat(tabButtons.count)
        let buttonHeight = CGRectGetHeight(self.tabsView!.frame)
        
        for (index, button) in tabButtons.enumerate() {
            var buttonWidth = (self.preferFullWidthTabs == true) ? fullSizeWidth : min(self.maxTabWidth, fullSizeWidth)
            buttonWidth = max(buttonWidth, self.minTabWidth)
            let r = CGRectMake(CGFloat(index)*buttonWidth, 0.0, buttonWidth, buttonHeight)
            
            if anim == true && button.hidden == false {
                button.animator().frame = r
            }
            else {
                button.frame = r
            }
            
            if let delegateReceiver = self.delegateInterceptor.receiver as? TabsControlDelegate {
                if delegateReceiver.tabsControl?(self, canSelectItem: button.tabButtonCell!.representedObject!) != nil {
                    button.tabButtonCell!.selectable = delegateReceiver.tabsControl!(self, canSelectItem: button.tabButtonCell!.representedObject!)
                    // not entirely sure this swift code does what I want...
                }
            }
            
            button.tag = index
            tabsViewWidth += buttonWidth
        }
        
        self.tabsView!.frame = CGRectMake(0.0, 0.0, tabsViewWidth, buttonHeight)
    }
    
    private func updateAuxiliaryButtons() {
        let contentView = self.scrollView!.contentView
        var showScrollButtons = (contentView.subviews.count > 0) && (NSMaxX(contentView.subviews[0].frame) > NSWidth(contentView.bounds))
        showScrollButtons = showScrollButtons || (self.preferFullWidthTabs == true && self.currentTabWidth() == self.minTabWidth)
        
        
        self.scrollLeftButton?.hidden = !showScrollButtons
        self.scrollRightButton?.hidden = !showScrollButtons
        if showScrollButtons == true {
            self.scrollLeftButton?.enabled = self.visibilityCondition(self.scrollLeftButton!, forLeft: true)
            self.scrollRightButton?.enabled = self.visibilityCondition(self.scrollRightButton!, forLeft: false)
        }
    }

    // MARK: - ScrollView Observation
    
    private func startObservingScrollView() {
        self.scrollView?.addObserver(self, forKeyPath: "frame", options: .New, context: &ScrollViewObservationContext)
        self.scrollView?.addObserver(self, forKeyPath: "documentView.frame", options: .New, context: &ScrollViewObservationContext)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabsControl.scrollViewDidScroll(_:)), name: NSViewFrameDidChangeNotification, object: self.scrollView)
    }
    
    private func stopObservingScrollView() {
        self.scrollView?.removeObserver(self, forKeyPath: "frame", context: &ScrollViewObservationContext)
        self.scrollView?.removeObserver(self, forKeyPath: "documentView.frame", context: &ScrollViewObservationContext)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSViewFrameDidChangeNotification, object: self.scrollView)
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &ScrollViewObservationContext {
            self.updateAuxiliaryButtons()
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    @objc private func scrollViewDidScroll(notification: NSNotification) {
        self.layoutTabButtons(nil, animated: false)
        self.updateAuxiliaryButtons()
        self.invalidateRestorableState()
    }
    
    // MARK: - Actions
    
    func scrollTabView(sender: AnyObject?) {
        let forLeft = (sender as? NSButton == self.scrollLeftButton)
        let tab = self.tabButtons().filter({ self.visibilityCondition($0, forLeft: forLeft) }).first
            
        if (tab != nil) {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.allowsImplicitAnimation = true
                tab?.scrollRectToVisible(tab!.bounds)
                }, completionHandler: {
                    self.invalidateRestorableState()
            })
        }
    }
    
    func visibilityCondition(button: NSButton, forLeft: Bool) -> Bool {
        let visibleRect = self.tabsView!.visibleRect
        if forLeft == true {
            return NSMinX(button.frame) < NSMinX(visibleRect)
        }
        else {
            return NSMaxX(button.frame) > NSMaxX(visibleRect) - 2.0*NSWidth(self.scrollLeftButton!.frame)
        }
    }
    
    // MARK: - Reordering
    
    func reorderTab(tab: TabButton, withEvent event: NSEvent) {
        var orderedTabs = self.tabButtons()
        let tabX = NSMinX(tab.frame)
        let dragPoint = self.tabsView!.convertPoint(event.locationInWindow, fromView: nil)

        var prevPoint = dragPoint
        var reordered = false
        
        let draggingTab = tab.copy() as! TabButton
        self.addSubview(draggingTab as NSView)
        tab.hidden = true
        
        while(true) {
            let mask: Int = Int(NSEventMask.LeftMouseUpMask.union(.LeftMouseDraggedMask).rawValue)
            let event: NSEvent! = self.window?.nextEventMatchingMask(mask , untilDate: NSDate.distantFuture(), inMode: NSEventTrackingRunLoopMode, dequeue: false)!
            
            if event.type == NSEventType.LeftMouseUp {
                NSAnimationContext.currentContext().completionHandler = {
                    draggingTab.removeFromSuperview()
                    tab.hidden = false
                    let items = orderedTabs.map({ return $0.tabButtonCell!.representedObject! })
                    if reordered == true && self.delegate?.tabsControl?(self, didReorderItems: items) != nil {
                        
                    }
                    self.reloadTabs()
                }
                draggingTab.animator().frame = tab.frame
                break
            }
            
            let nextPoint = self.tabsView!.convertPoint(event.locationInWindow, fromView: nil)
            let nextX = tabX + (nextPoint.x - dragPoint.x)
            
            var r = draggingTab.frame
            r.origin.x = nextX
            draggingTab.frame = r
            
            let movingLeft = (nextPoint.x < prevPoint.x)
            prevPoint = nextPoint
            let index = orderedTabs.indexOf(tab)!
            
            if movingLeft == true && NSMidX(draggingTab.frame) < NSMinX(tab.frame) && tab !== orderedTabs.first! {
                // shift left
                swap(&orderedTabs[index], &orderedTabs[index-1])
                reordered = true
            }
            else if movingLeft == false && NSMidX(draggingTab.frame) > NSMaxX(tab.frame) && tab != orderedTabs.last! {
                swap(&orderedTabs[index+1], &orderedTabs[index])
                reordered = true
            }
            
            if reordered == true {
                self.layoutTabButtons(orderedTabs, animated: true)
            }
        }
    }
    
    // MARK: - Selection
    
    func selectTab(sender: AnyObject?) {
        guard let button = sender else {
            return
        }
        self.selectedButton = button as? TabButton
        let item: AnyObject! = self.selectedButton?.tabButtonCell?.representedObject
        
        for button in self.tabButtons() {
            button.state = (button === self.selectedButton!) ? NSOnState : NSOffState
            button.highlighted = self.isHighlighted
        }
        
        NSApplication.sharedApplication().sendAction(self.action, to: self.target, from: self)
        NSNotificationCenter.defaultCenter().postNotificationName(TabsControlSelectionDidChangeNotification, object: self)
        
        if let currentEvent = NSApp.currentEvent {
            if currentEvent.type == .LeftMouseDown && currentEvent.clickCount > 1 {
                self.editTabButton(self.selectedButton!)
            }
            else if self.delegate?.tabsControl?(self, canReorderItem: item) == true {
                let mask: Int = Int(NSEventMask.LeftMouseUpMask.union(.LeftMouseDraggedMask).rawValue)
                let event: NSEvent! = self.window?.nextEventMatchingMask(mask , untilDate: NSDate.distantFuture(), inMode: NSEventTrackingRunLoopMode, dequeue: false)!
                
                if event.type == NSEventType.LeftMouseDragged {
                    self.reorderTab(self.selectedButton!, withEvent:currentEvent)
                }
            }
        }
    }
    
    public var selectedItem: AnyObject? {
        get { return self.selectedButton?.tabButtonCell?.representedObject }
        set {
            for button in self.tabButtons() {
                if button.tabButtonCell?.representedObject === newValue {
                    button.state = NSOnState
                    self.selectedButton = button
                    NSAnimationContext.runAnimationGroup({ (context) in
                        context.allowsImplicitAnimation = true
                        button.scrollRectToVisible(button.bounds)
                        }, completionHandler: nil)
                }
                else {
                    button.state = NSOffState
                }
            }
            NSNotificationCenter.defaultCenter().postNotificationName(TabsControlSelectionDidChangeNotification, object: self)
            self.invalidateRestorableState()
        }
    }
    
    public var selectedItemIndex: Int {
        get { return (self.selectedButton != nil) ? self.selectedButton!.tag : -1 }
    }
    
    public func selectItemAtIndex(index: Int) {
        let buttons = self.tabButtons()
        if buttons.count > index {
            self.selectTab(buttons[index])
        }
    }
    
    
    
    // MARK: - Editing
    
    public func editTabButton(button: NSButton) {
        
    }
    
    // MARK: - Drawing
    
    override public var opaque: Bool {
        return true
    }

    override public var flipped: Bool {
        return true
    }
    
    private func tabButtons() -> Array<TabButton> {
        guard let tb = self.tabsView else {
            return []
        }
        
        let subviews = tb.subviews
        let filteredSubviews = subviews.filter({ (view) -> Bool in
            view is TabButton
        }) as! Array<TabButton>
        return filteredSubviews
    }
    
    public func highlight(flag: Bool) {
        self.isHighlighted = flag
        
    }
    
    // MARK: - Tab Widths
    
    public func currentTabWidth() -> CGFloat {
        let tabs = self.tabButtons()
        if tabs.count > 0 {
            return CGRectGetWidth(tabs.first!.frame)
        }
        return 0.0
    }
    
    // MARK: - State Restoration
    
    public override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        // TODO: complete!
    }

    public override func restoreStateWithCoder(coder: NSCoder) {
        super.restoreStateWithCoder(coder)
        // TODO: complete!
    }
    
    // MARK: Helpers
    
    private func propagateBorderMask() {
        let buttons = self.tabButtons()
        var borderMask = self.tabButtonCell.borderMask
        
        for (index, button) in buttons.enumerate() {
            if index == 0 && self.automaticSideBorderMasks == true {
                borderMask = borderMask.union(.Left)
            }
            if index == buttons.count-1 && self.automaticSideBorderMasks == true {
                borderMask = borderMask.union(.Right)
            }
            let buttonCell = button.cell as! TabButtonCell
            buttonCell.borderMask = borderMask
        }
    }
}