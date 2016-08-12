//
//  TabsControl.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 15/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

/// TabsControl is the main class of the library, and is designed to suffice for implementing tabs in your app.
/// The only necessary thing for it to work is an implementation of its `dataSource`.
public class TabsControl: NSControl, TabEditingDelegate {
    
    private var ScrollViewObservationContext: UnsafeMutablePointer<Void> = nil // hm, wrong?
    private var delegateInterceptor = MessageInterceptor()

    private var scrollView: NSScrollView!
    private var tabsView: NSView!

    private var addButton: NSButton? = nil
    private var scrollLeftButton: NSButton? = nil
    private var scrollRightButton: NSButton? = nil
    private weak var selectedButton: TabButton? = nil

    private var hideScrollButtons: Bool = true
//    private var isHighlighted: Bool = false

    private var tabsControlCell: TabsControlCell {
        get { return self.cell as! TabsControlCell }
    }

    // MARK: - Data Source & Delegate
    
    /// The dataSource of the tabs control, providing all the necessary information for the class to build the tabs.
    @IBOutlet public weak var dataSource: TabsControlDataSource?
    
    /// The delegate of the tabs control, providing additional possibilities for customization and precise behavior.
    @IBOutlet public weak var delegate: TabsControlDelegate? {
        get { return self.delegateInterceptor.receiver as? TabsControlDelegate }
        set { self.delegateInterceptor.receiver = newValue as? NSObject }
    }
    
    // MARK: - Styling

    /**
     *  Indicates whether the tabs control should span the whole available width or not. Default is `NO`. If set to `YES`,
     *  the tabs may occur to have a width smaller than `minTabWidth` or larger than `maxTabWidth`.
     */
    private(set) var prefersFullWidthTabs: Bool = false

    public func preferFullWidthTabs(state: Bool, animated: Bool = false) {
        self.prefersFullWidthTabs = state
        self.updateTabs(animated: animated)
    }

    public var style: Style = ThemedStyle(theme: DefaultTheme()) {
        didSet {
            self.tabsControlCell.style = self.style
            self.tabButtons().forEach { $0.style = self.style }
            self.updateTabs()
        }
    }

    private func updateTabs(animated animated: Bool = false) {
        self.layoutTabButtons(self.tabButtons(), animated: animated)
        self.updateAuxiliaryButtons()
    }

    /**
     *  When `preferFullWidthTabs` is NO, the minimum width of tabs. Given the total width of the tabs control, it will
     *  adjust the tab width between the specified minimum and maximum values. All tabs have the same width, always.
     */
    public var minTabWidth: CGFloat { return self.style.tabWidth.min }

    /**
     *  When `preferFullWidthTabs` is `NO`, the maximum width of tabs. Given the total width of the tabs control, it will
     *  adjust the tab width between the specified minimum and maximum values. All tabs have the same width, always.
     */
    public var maxTabWidth: CGFloat { return self.style.tabWidth.max }
    
    // MARK: - Initializers & Setup
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    private func setup() {
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.cell = TabsControlCell(textCell: "")
       
        self.configureSubviews()
    }
    
    private func configureSubviews() {
        self.scrollView = NSScrollView(frame: self.bounds)
        self.scrollView.drawsBackground = false
        self.scrollView.hasHorizontalScroller = false
        self.scrollView.hasVerticalScroller = false
        self.scrollView.usesPredominantAxisScrolling = true
        self.scrollView.horizontalScrollElasticity = .Allowed
        self.scrollView.verticalScrollElasticity = .None
        self.scrollView.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        self.tabsView = NSView(frame: self.scrollView.bounds)
        self.scrollView.documentView = self.tabsView
        
        self.addSubview(self.scrollView)
        
        if self.hideScrollButtons == false {
            self.scrollLeftButton = NSButton.KPC_auxiliaryButton(withImageNamed: "KPCTabLeftTemplate",
                                                                 target: self,
                                                                 action: #selector(TabsControl.scrollTabView(_:)))
            
            self.scrollRightButton = NSButton.KPC_auxiliaryButton(withImageNamed: "KPCTabRightTemplate",
                                                                  target: self,
                                                                  action: #selector(TabsControl.scrollTabView(_:)))
            
            self.scrollLeftButton?.autoresizingMask = .ViewMinXMargin
            self.scrollLeftButton?.autoresizingMask = .ViewMinXMargin
            
            let leftCell = self.scrollLeftButton!.cell as! TabButtonCell
            leftCell.buttonPosition = .first

            self.addSubview(self.scrollLeftButton!)
            self.addSubview(self.scrollRightButton!)
            
            // This is typically what's autolayout is supposed to help avoiding.
            // But for pixel-control freaking guys like me, I see no escape.
            var r = CGRectZero
            r.size.height = CGRectGetHeight(self.scrollView.frame)
            r.size.width = CGRectGetWidth(self.scrollLeftButton!.frame)
            r.origin.x = CGRectGetMaxX(self.scrollView.frame) - r.size.width
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
    
    /**
     Reloads all tabs of the tabs control. Useful when the `dataSource` has changed.
     */
    public func reloadTabs() {
        guard let dataSource = self.dataSource else {
            // no effect if there is dataSource
            return
        }
        
        self.tabButtons().forEach { $0.removeFromSuperview() }
        
        let newItemsCount = dataSource.tabsControlNumberOfTabs(self)
        for i in 0..<newItemsCount {
            let item = dataSource.tabsControl(self, itemAtIndex: i)
            let button = TabButton(
                withItem: item,
                target: self,
                action: #selector(TabsControl.selectTab(_:)),
                style: style)
            button.editable = true

            button.tabButtonCell!.buttonPosition = {
                switch i {
                case 0: return .first
                case newItemsCount-1: return .last
                default: return .middle
                }
            }()

            button.title = dataSource.tabsControl(self, titleForItem: item)
            button.state = (item === self.selectedItem) ? NSOnState : NSOffState // yes triple === to check for instances
//            button.highlight(self.isHighlighted)
            
            if let img = dataSource.tabsControl?(self, iconForItem: item) {
                button.icon = img
            }
            if let menu = dataSource.tabsControl?(self, menuForItem: item) {
                button.menu = menu
            }
            if let altIcon = dataSource.tabsControl?(self, titleAlternativeIconForItem: item) {
                button.alternativeTitleIcon = altIcon
            }
            
            self.tabsView.addSubview(button)
        }
        
        self.layoutTabButtons(nil, animated: false)
        self.updateAuxiliaryButtons()
        self.invalidateRestorableState()
    }
    
    // MARK: - Layout

    var tabHeight: CGFloat { return self.tabsView.frame.height }

    private func layoutTabButtons(buttons: [TabButton]?, animated: Bool) {
        let tabButtons = (buttons != nil) ? buttons! : self.tabButtons()
        var tabsViewWidth = CGFloat(0.0)
        
        let fullSizeWidth = CGRectGetWidth(self.scrollView.frame) / CGFloat(tabButtons.count)
        let buttonHeight = self.tabHeight
        
        for (index, button) in tabButtons.enumerate() {
            var buttonWidth = (self.prefersFullWidthTabs == true) ? fullSizeWidth : min(self.maxTabWidth, fullSizeWidth)
            buttonWidth = max(buttonWidth, self.minTabWidth)
            let buttonFrame = CGRectMake(CGFloat(index)*buttonWidth, 0.0, buttonWidth, buttonHeight)
            
            if animated && !button.hidden {
                button.animator().frame = buttonFrame
            } else {
                button.frame = buttonFrame
            }
            
            if let delegateReceiver = self.delegateInterceptor.receiver as? TabsControlDelegate {
                if delegateReceiver.tabsControl?(self, canSelectItem: button.tabButtonCell!.representedObject!) != nil {
                    button.tabButtonCell!.selectable = delegateReceiver.tabsControl!(self, canSelectItem: button.tabButtonCell!.representedObject!)
                    // TODO: not entirely sure this swift code does what I want... fix that.
                }
            }
            
            button.tag = index
            tabsViewWidth += buttonWidth
        }

        let viewFrame = CGRectMake(0.0, 0.0, tabsViewWidth, buttonHeight)
        if animated {
            self.tabsView.animator().frame = viewFrame
        } else {
            self.tabsView.frame = viewFrame
        }
    }
    
    private func updateAuxiliaryButtons() {
        let contentView = self.scrollView.contentView
        var showScrollButtons = (contentView.subviews.count > 0) && (NSMaxX(contentView.subviews[0].frame) > NSWidth(contentView.bounds))
        showScrollButtons = showScrollButtons || (self.prefersFullWidthTabs == true && self.currentTabWidth() == self.minTabWidth)
        
        self.scrollLeftButton?.hidden = !showScrollButtons
        self.scrollRightButton?.hidden = !showScrollButtons
        if showScrollButtons == true {
            self.scrollLeftButton?.enabled = self.visibilityCondition(self.scrollLeftButton!, forLeft: true)
            self.scrollRightButton?.enabled = self.visibilityCondition(self.scrollRightButton!, forLeft: false)
        }
    }

    // MARK: - ScrollView Observation
    
    private func startObservingScrollView() {
        self.scrollView.addObserver(self, forKeyPath: "frame", options: .New, context: &ScrollViewObservationContext)
        self.scrollView.addObserver(self, forKeyPath: "documentView.frame", options: .New, context: &ScrollViewObservationContext)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(TabsControl.scrollViewDidScroll(_:)),
                                                         name: NSViewFrameDidChangeNotification,
                                                         object: self.scrollView)
    }
    
    private func stopObservingScrollView() {
        self.scrollView.removeObserver(self, forKeyPath: "frame", context: &ScrollViewObservationContext)
        self.scrollView.removeObserver(self, forKeyPath: "documentView.frame", context: &ScrollViewObservationContext)
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: NSViewFrameDidChangeNotification,
                                                            object: self.scrollView)
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
    
    @objc private func scrollTabView(sender: AnyObject?) {
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
    
    private func visibilityCondition(button: NSButton, forLeft: Bool) -> Bool {
        let visibleRect = self.tabsView.visibleRect
        if forLeft == true {
            return NSMinX(button.frame) < NSMinX(visibleRect)
        }
        else {
            return NSMaxX(button.frame) > NSMaxX(visibleRect) - 2.0*NSWidth(self.scrollLeftButton!.frame)
        }
    }
    
    // MARK: - Reordering
    
    private func reorderTab(tab: TabButton, withEvent event: NSEvent) {
        var orderedTabs = self.tabButtons()
        let tabX = NSMinX(tab.frame)
        let dragPoint = self.tabsView.convertPoint(event.locationInWindow, fromView: nil)

        var prevPoint = dragPoint
        var reordered = false
        
        let draggingTab = tab.copy() as! TabButton
        self.addSubview(draggingTab as NSView)
        tab.hidden = true
        
        while(true) {
            let mask: Int = Int(NSEventMask.LeftMouseUpMask.union(.LeftMouseDraggedMask).rawValue)
            let event: NSEvent! = self.window?.nextEventMatchingMask(mask)
            
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
            
            let nextPoint = self.tabsView.convertPoint(event.locationInWindow, fromView: nil)
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
    
    @objc private func selectTab(sender: AnyObject?) {
        guard let button = sender as? TabButton else {
            return
        }

        self.selectedButton = button
        self.tabButtons().forEach { $0.state = ($0 === self.selectedButton!) ? NSOnState : NSOffState }
        
        NSApp.sendAction(self.action, to: self.target, from: self)
        NSNotificationCenter.defaultCenter().postNotificationName(TabsControlSelectionDidChangeNotification, object: self)
        
        guard let currentEvent = NSApp.currentEvent else { return }

        if currentEvent.type == .LeftMouseDown && currentEvent.clickCount > 1 {
            self.editTabButton(button)
        }
        else if let item = self.selectedButton?.tabButtonCell?.representedObject
            where self.delegate?.tabsControl?(self, canReorderItem: item) == true {

            let mask: NSEventMask = NSEventMask.LeftMouseUpMask.union(.LeftMouseDraggedMask)

            guard let event = self.window?.nextEventMatchingMask(Int(mask.rawValue), untilDate: NSDate.distantFuture(), inMode: NSEventTrackingRunLoopMode, dequeue: false)
                where event.type == NSEventType.LeftMouseDragged else { return }

            self.reorderTab(button, withEvent: currentEvent)
        }
    }
    
    /**
     *  Each tab being represented by an item, this property points to the currently selected item. Assigning it to
     *  a new value triggers a new selection. Selecting an unknown item will unselect any tabs, and leave the tabs control
     *  with no tab selected.
     */
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
    
    /// The index of the selected item.
    public var selectedItemIndex: Int {
        get { return (self.selectedButton != nil) ? self.selectedButton!.tag : -1 }
    }
    
    /**
     Select an item at a given index. Selecting an invalid index will unselected all tabs.
     
     - parameter index: An integer indicating the index of the item to be selected.
     */
    public func selectItemAtIndex(index: Int) {
        let buttons = self.tabButtons()
        if buttons.count > index {
            self.selectTab(buttons[index])
        }
    }
    
    // MARK: - Editing

    private func forceEndEditing() {
        self.window?.makeFirstResponder(self)
    }

    var tabEditing: TabEditing?

    public func editTabButton(tab: TabButton) {

        guard let representedObject = tab.representedObject
            where self.delegate?.tabsControl?(self, canEditTitleOfItem: representedObject) == true
            else { return }

        self.forceEndEditing()

        guard let fieldEditor = self.window?.fieldEditor(true, forObject: tab) else { return }

        let newEditing = TabEditing(tabButton: tab, fieldEditor: fieldEditor, delegate: self)
        self.tabEditing = newEditing
        newEditing.edit()

        self.delegateInterceptor.middleMan = self
    }
    
    // MARK : - TabEditingDelegate
    
    func tabButtonDidEndEditing(tabButton: TabButton, newValue: String) {
        
        defer { self.reloadTabs() }
        
        guard !newValue.isEmpty
            && self.delegate?.tabsControl?(self, setTitle: newValue, forItem: tabButton.representedObject!) != nil else { return }
        
        // TODO add callback to client code to replace forwarding controlTextDidEndEditing(_:)
        
        tabButton.representedObject = self.dataSource?.tabsControl(self, itemAtIndex: self.selectedItemIndex)
    }

    // MARK: - Drawing
    
    override public var opaque: Bool {
        return true
    }

    override public var flipped: Bool {
        return true
    }
    
    /**
     (Un)highlight the tabs control.
     
     - parameter flag: A boolean value indicating whether the tabs control should adopt a 'highlighted' state
     (with slightly darker default background colors) or not.
     */
//    public func highlight(flag: Bool) {
//        self.isHighlighted = flag
//        self.tabButtonCell.highlight(flag)
//        self.scrollLeftButton.cell?.highlight(flag)
//        self.scrollRightButton.cell?.highlight(flag)
//        self.tabButtons().forEach { $0.highlight(flag) }
//    }
    
    // MARK: - Tab Widths
    
    public func currentTabWidth() -> CGFloat {
        let tabs = self.tabButtons()
        guard let firstTab = tabs.first else { return 0.0 }

        return CGRectGetWidth(firstTab.frame)
    }
    
    // MARK: - State Restoration

    private enum RestorationKeys {
        static let scrollXOffset = "scrollOrigin"
        static let selectedButtonIndex = "selectedButtonIndex"
    }

    public override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        
        let scrollXOffset: CGFloat = self.scrollView.contentView.bounds.origin.x ?? 0.0

        let buttons: [NSButton] = self.buttons()
        let selectedButtonIndex: Int = buttons.enumerate()
            .findFirst { $0.element.state == NSOnState }?
            .index ?? NSNotFound

        coder.encodeDouble(Double(scrollXOffset), forKey: RestorationKeys.scrollXOffset)
        coder.encodeInteger(selectedButtonIndex, forKey: RestorationKeys.selectedButtonIndex)
    }

    public override func restoreStateWithCoder(coder: NSCoder) {
        super.restoreStateWithCoder(coder)
        
        let scrollXOffset = coder.decodeDoubleForKey(RestorationKeys.scrollXOffset)
        let selectedButtonIndex = coder.decodeIntegerForKey(RestorationKeys.selectedButtonIndex)
        
        var bounds = self.scrollView.contentView.bounds
        bounds.origin.x = CGFloat(scrollXOffset)
        self.scrollView.contentView.bounds = bounds

        for (index, button) in self.buttons().enumerate() {
            button.state = (index == selectedButtonIndex) ? NSOnState : NSOffState
        }        
    }
    
    // MARK: - Helpers
    
    private func tabButtons() -> [TabButton] {
        guard let tabsView = self.tabsView else { return [] }
        
        return tabsView.subviews.flatMap { $0 as? TabButton }
    }

    /// - returns: All `NSButton` instances inside this view's `scrollView`.
    private func buttons() -> [NSButton] {
        return self.scrollView.documentView?.subviews.flatMap { $0 as? NSButton } ?? []
    }
}

extension MessageInterceptor: NSTextDelegate { }

