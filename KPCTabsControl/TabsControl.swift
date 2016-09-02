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
public class TabsControl: NSControl, NSTextDelegate {
    
    private var ScrollViewObservationContext: UnsafeMutablePointer<Void> = nil // hm, wrong?
    private var delegateInterceptor = MessageInterceptor()

    private var scrollView: NSScrollView!
    private var tabsView: NSView!

    private var addButton: NSButton? = nil
    private var scrollLeftButton: NSButton? = nil
    private var scrollRightButton: NSButton? = nil
    private var hideScrollButtons: Bool = true

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

    public var style: Style = DefaultStyle() {
        didSet {
            self.tabsControlCell.style = self.style
            self.tabButtons.forEach { $0.style = self.style }
            self.updateTabs()
        }
    }

    // MARK: - Initializers & Setup
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    public override init(frame frameRect: NSRect) {
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
        guard let dataSource = self.dataSource else { return }
        
        self.tabButtons.forEach { $0.removeFromSuperview() }
        
        let newItemsCount = dataSource.tabsControlNumberOfTabs(self)
        for i in 0..<newItemsCount {
            let item = dataSource.tabsControl(self, itemAtIndex: i)
            let button = TabButton(index: i,
                                   item: item,
                                   target: self,
                                   action: #selector(TabsControl.selectTab(_:)),
                                   style: self.style)
            
            button.wantsLayer = true
            button.state = NSOffState
            button.editable = self.delegate?.tabsControl?(self, canEditTitleOfItem: item) == true
            button.buttonPosition = TabButtonPosition.fromIndex(i, totalCount: newItemsCount)

            button.title = dataSource.tabsControl(self, titleForItem: item)
            
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

    private func updateTabs(animated animated: Bool = false) {
        self.layoutTabButtons(nil, animated: animated)
        self.updateAuxiliaryButtons()
    }

    private func layoutTabButtons(buttons: [TabButton]?, animated: Bool) {
        let tabButtons = buttons ?? self.tabButtons
        var tabsViewWidth = CGFloat(0.0)
        
        let fullWidth = CGRectGetWidth(self.scrollView.frame) / CGFloat(tabButtons.count)
        let buttonHeight = self.tabsView.frame.height

        var buttonWidth = CGFloat(0)
        switch self.style.tabButtonWidth {
        case .Full:
            buttonWidth = fullWidth
        case .Flexible(let minWidth, let maxWidth):
            buttonWidth = max(minWidth, min(maxWidth, fullWidth))
        }

        var buttonX = CGFloat(0)
        for (index, button) in tabButtons.enumerate() {
            
            let offset = self.style.tabButtonOffset(position: button.buttonPosition)
            let buttonFrame = CGRectMake(buttonX + offset.x, offset.y, buttonWidth, buttonHeight)
            buttonX += buttonWidth + offset.x

            button.layer?.zPosition = button.state == NSOnState ? CGFloat(FLT_MAX) : CGFloat(index)

            if animated && !button.hidden {
                button.animator().frame = buttonFrame
            } else {
                button.frame = buttonFrame
            }
            
            if let selectable = self.delegate?.tabsControl?(self, canSelectItem: button.representedObject!) {
                button.enabled = selectable
            }

            tabsViewWidth += buttonWidth
        }

        let viewFrame = CGRectMake(0.0, 0.0, tabsViewWidth, buttonHeight)
        if animated {
            self.tabsView.animator().frame = viewFrame
        }
        else {
            self.tabsView.frame = viewFrame
        }
    }
    
    private func updateAuxiliaryButtons() {
        let contentView = self.scrollView.contentView
        let showScrollButtons = (contentView.subviews.count > 0) && (NSMaxX(contentView.subviews[0].frame) > NSWidth(contentView.bounds))
        
        self.scrollLeftButton?.hidden = !showScrollButtons
        self.scrollRightButton?.hidden = !showScrollButtons
        if showScrollButtons == true {
            self.scrollLeftButton?.enabled = self.visibilityCondition(forButton: self.scrollLeftButton!, forLeftHandSide: true)
            self.scrollRightButton?.enabled = self.visibilityCondition(forButton: self.scrollRightButton!, forLeftHandSide: false)
        }
    }

    // MARK: - ScrollView Observation
    
    private func startObservingScrollView() {
        // TODO replace this with scroll view change notifications
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
            
        guard let tab = self.tabButtons.findFirst({ self.visibilityCondition(forButton: $0, forLeftHandSide: forLeft) })
            else { return }

        NSAnimationContext.runAnimationGroup({ (context) in
            context.allowsImplicitAnimation = true
            tab.scrollRectToVisible(tab.bounds)
            }, completionHandler: {
                self.invalidateRestorableState()
        })
    }
    
    private func visibilityCondition(forButton button: NSButton, forLeftHandSide: Bool) -> Bool {
        let visibleRect = self.tabsView.visibleRect
        if forLeftHandSide == true {
            return NSMinX(button.frame) < NSMinX(visibleRect)
        }
        else {
            return NSMaxX(button.frame) > NSMaxX(visibleRect) - 2.0*NSWidth(self.scrollLeftButton!.frame)
        }
    }
    
    // MARK: - Reordering
    
    private func reorderTab(tab: TabButton, withEvent event: NSEvent) {
        var orderedTabs = self.tabButtons
        let tabX = NSMinX(tab.frame)
        let dragPoint = self.tabsView.convertPoint(event.locationInWindow, fromView: nil)

        var prevPoint = dragPoint
        var reordered = false
        
        let draggingTab = tab.copy() as! TabButton
        self.addSubview(draggingTab)
        tab.hidden = true

        var temporarySelectedButtonIndex = self.selectedButtonIndex!
        while(true) {
            let mask: Int = Int(NSEventMask.LeftMouseUpMask.union(.LeftMouseDraggedMask).rawValue)
            let event: NSEvent! = self.window?.nextEventMatchingMask(mask)
            
            if event.type == NSEventType.LeftMouseUp {
                NSAnimationContext.currentContext().completionHandler = {
                    draggingTab.removeFromSuperview()
                    tab.hidden = false

                    if reordered == true {
                        let items = orderedTabs.map({ return $0.representedObject! })
                        self.delegate?.tabsControl?(self, didReorderItems: items)
                    }

                    self.reloadTabs()
                    self.selectedButtonIndex = temporarySelectedButtonIndex
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
            
            let primaryIndex = orderedTabs.indexOf(tab)!
            var secondaryIndex : Int?
            
            if movingLeft == true && NSMidX(draggingTab.frame) < NSMinX(tab.frame) && tab !== orderedTabs.first! {
                // shift left
                secondaryIndex = primaryIndex-1
            }
            else if movingLeft == false && NSMidX(draggingTab.frame) > NSMaxX(tab.frame) && tab != orderedTabs.last! {
                secondaryIndex = primaryIndex+1
            }
            
            if let secondIndex = secondaryIndex {
                swap(&orderedTabs[primaryIndex], &orderedTabs[secondIndex])
                
                // Shouldn't indexes be swapped too????? But if we do so, it doesn't work!
                orderedTabs[primaryIndex].buttonPosition = TabButtonPosition.fromIndex(primaryIndex, totalCount: orderedTabs.count)
                orderedTabs[secondIndex].buttonPosition = TabButtonPosition.fromIndex(secondIndex, totalCount: orderedTabs.count)
                
                temporarySelectedButtonIndex += secondIndex-primaryIndex
                self.layoutTabButtons(orderedTabs, animated: true)
                reordered = true
            }
        }
    }
    
    // MARK: - Selection

    @objc private func selectTab(sender: AnyObject?) {
        guard let button = sender as? TabButton
            where button.enabled
            else { return }

        self.selectedButtonIndex = button.index

        NSApp.sendAction(self.action, to: self.target, from: self)
        NSNotificationCenter.defaultCenter().postNotificationName(TabsControlSelectionDidChangeNotification, object: self)
        self.delegate?.tabsControlDidChangeSelection?(self, item: button.representedObject!)

        guard let currentEvent = NSApp.currentEvent else { return }

        if currentEvent.type == .LeftMouseDown && currentEvent.clickCount > 1 {
            self.editTabButton(button)
        }
        else if let item = button.representedObject
            where self.delegate?.tabsControl?(self, canReorderItem: item) == true {

            let mask: NSEventMask = NSEventMask.LeftMouseUpMask.union(.LeftMouseDraggedMask)

            guard let event = self.window?.nextEventMatchingMask(Int(mask.rawValue), untilDate: NSDate.distantFuture(), inMode: NSEventTrackingRunLoopMode, dequeue: false)
                where event.type == NSEventType.LeftMouseDragged
                else { return }

            self.reorderTab(button, withEvent: currentEvent)
        }
    }

    private func scrollToSelectedButton() {
        guard let selectedButton = self.selectedButton else { return }

        NSAnimationContext.runAnimationGroup({ (context) in
            context.allowsImplicitAnimation = true
            selectedButton.scrollRectToVisible(selectedButton.bounds)
            }, completionHandler: nil)

    }

    private var selectedButton: TabButton? {
        guard let index = self.selectedButtonIndex else { return nil }
        return self.tabButtons.findFirst({ $0.index == index })
    }

    var selectedButtonIndex: Int? = nil {
        didSet {
            self.scrollToSelectedButton()
            self.updateButtonStatesForSelection()
            self.layoutTabButtons(nil, animated: false)

            NSNotificationCenter.defaultCenter().postNotificationName(TabsControlSelectionDidChangeNotification, object: self)
            self.invalidateRestorableState()
        }
    }
    
    /**
     Select an item at a given index. Selecting an invalid index will unselected all tabs.
     
     - parameter index: An integer indicating the index of the item to be selected.
     */
    public func selectItemAtIndex(index: Int) {
        guard let button = self.tabButtons[safe: index] else { return }
        self.selectTab(button)
    }

    private func updateButtonStatesForSelection() {
        for button in self.tabButtons {
            guard let selectedIndex = self.selectedButtonIndex else {
                button.state = NSOffState
                continue
            }

            button.state = button.index == selectedIndex ? NSOnState : NSOffState
        }
    }

    // MARK: - Editing

    private var editingTab: (title: String, button: TabButton)?

    /// Starts editing the tab as if the user double-clicked on it. 
    /// If `index` is out of bounds, it does nothing.
    public func editTabAtIndex(index: Int) {

        guard let tabButton = self.tabButtons[safe: index] else { return }

        editTabButton(tabButton)
    }

    func editTabButton(tab: TabButton) {

        guard let representedObject = tab.representedObject
            where self.delegate?.tabsControl?(self, canEditTitleOfItem: representedObject) == true
            else { return }

        guard let fieldEditor = self.window?.fieldEditor(true, forObject: tab)
            else { return }

        self.window?.makeFirstResponder(self)
        
        self.editingTab = (tab.title, tab)
        tab.edit(fieldEditor: fieldEditor, delegate: self)
    }
    
    // MARK : - NSTextDelegate
    
    public func textDidEndEditing(notification: NSNotification) {
        guard let fieldEditor = notification.object as? NSText else {
            assertionFailure("Expected field editor.")
            return
        }
        
        let newValue = fieldEditor.string ?? ""
        self.editingTab?.button.finishEditing(fieldEditor: fieldEditor, newValue: newValue)
        self.window?.makeFirstResponder(self)
        
        defer {
            self.editingTab = nil
        }
        
        guard let item = self.editingTab?.button.representedObject
            where newValue != self.editingTab?.title
            else { return }
        
        self.delegate?.tabsControl?(self, setTitle: newValue, forItem: item)
        self.editingTab?.button.representedObject = self.dataSource?.tabsControl(self, itemAtIndex: self.selectedButtonIndex!)
    }

    // MARK: - Drawing
    
    override public var opaque: Bool {
        return false
    }

    override public var flipped: Bool {
        return true
    }
    
    // MARK: - Tab Widths
    
    public func currentTabWidth() -> CGFloat {
        let tabs = self.tabButtons
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
        let selectedButtonIndex: Int = self.selectedButtonIndex ?? NSNotFound

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

        guard selectedButtonIndex != NSNotFound,
            let selectedButton = self.tabButtons.findFirst({ $0.index == selectedButtonIndex })
            else { return }

        self.selectTab(selectedButton)
    }
    
    // MARK: - Helpers
    
    var tabButtons: [TabButton] {
        guard let tabsView = self.tabsView else { return [] }
        return tabsView.subviews.flatMap { $0 as? TabButton }
    }
}
