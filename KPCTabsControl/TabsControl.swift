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
open class TabsControl: NSControl, NSTextDelegate {
    
    fileprivate var ScrollViewObservationContext: UnsafeMutableRawPointer? = nil // hm, wrong?
    fileprivate var delegateInterceptor = MessageInterceptor()

    fileprivate var scrollView: NSScrollView!
    fileprivate var tabsView: NSView!

    fileprivate var addButton: NSButton? = nil
    fileprivate var scrollLeftButton: NSButton? = nil
    fileprivate var scrollRightButton: NSButton? = nil
    fileprivate var hideScrollButtons: Bool = true

    fileprivate var editingTab: (title: String, button: TabButton)?

    fileprivate var tabsControlCell: TabsControlCell {
        get { return self.cell as! TabsControlCell }
    }

    // MARK: - Data Source & Delegate
    
    /// The dataSource of the tabs control, providing all the necessary information for the class to build the tabs.
    @IBOutlet open weak var dataSource: TabsControlDataSource?
    
    /// The delegate of the tabs control, providing additional possibilities for customization and precise behavior.
    @IBOutlet open weak var delegate: TabsControlDelegate? {
        get { return self.delegateInterceptor.receiver as? TabsControlDelegate }
        set { self.delegateInterceptor.receiver = newValue as? NSObject }
    }
    
    // MARK: - Styling

    open var style: Style = DefaultStyle() {
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
    
    fileprivate func setup() {
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.cell = TabsControlCell(textCell: "")
        self.configureSubviews()
    }
    
    fileprivate func configureSubviews() {
        self.scrollView = NSScrollView(frame: self.bounds)
        self.scrollView.drawsBackground = false
        self.scrollView.hasHorizontalScroller = false
        self.scrollView.hasVerticalScroller = false
        self.scrollView.usesPredominantAxisScrolling = true
        self.scrollView.horizontalScrollElasticity = .allowed
        self.scrollView.verticalScrollElasticity = .none
        self.scrollView.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        self.tabsView = NSView(frame: self.scrollView.bounds)
        self.scrollView.documentView = self.tabsView
        
        self.addSubview(self.scrollView)
        
        if self.hideScrollButtons == false {
            self.scrollLeftButton = NSButton.auxiliaryButton(withImageNamed: "KPCTabLeftTemplate",
                                                             target: self,
                                                             action: #selector(TabsControl.scrollTabView(_:)))
            
            self.scrollRightButton = NSButton.auxiliaryButton(withImageNamed: "KPCTabRightTemplate",
                                                              target: self,
                                                              action: #selector(TabsControl.scrollTabView(_:)))
            
            self.scrollLeftButton?.autoresizingMask = NSView.AutoresizingMask.minXMargin
            self.scrollLeftButton?.autoresizingMask = NSView.AutoresizingMask.minXMargin
            
            let leftCell = self.scrollLeftButton!.cell as! TabButtonCell
            leftCell.buttonPosition = .first

            self.addSubview(self.scrollLeftButton!)
            self.addSubview(self.scrollRightButton!)
            
            // This is typically what's autolayout is supposed to help avoiding.
            // But for pixel-control freaking guys like me, I see no escape.
            var r = CGRect.zero
            r.size.height = self.scrollView.frame.height
            r.size.width = self.scrollLeftButton!.frame.width
            r.origin.x = self.scrollView.frame.maxX - r.size.width
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

    open override func menu(for event: NSEvent) -> NSMenu? {
        return nil
    }
    
    // MARK: - Data Source
    
    /**
     Reloads all tabs of the tabs control. Used when the `dataSource` has changed for instance.
     */
    open func reloadTabs() {
        guard let dataSource = self.dataSource else { return }
                
        let oldItemsCount = self.tabButtons.count
        let newItemsCount = dataSource.tabsControlNumberOfTabs(self)
        
        if newItemsCount < oldItemsCount {
            self.tabButtons.filter({ $0.index >= newItemsCount }).forEach({ $0.removeFromSuperview() })
        }
        
        var tabButtons = self.tabButtons
        for i in 0..<newItemsCount {
            let item = dataSource.tabsControl(self, itemAtIndex: i)
            
            var button : TabButton
            if i >= oldItemsCount {
                button = TabButton(index: i,
                                   item: item,
                                   target: self,
                                   action: #selector(TabsControl.selectTab(_:)),
                                   style: self.style)
                
                button.wantsLayer = true
                button.state = NSControl.StateValue.off
                self.tabsView.addSubview(button)
            }
            else {
                button = tabButtons[i]
            }
            
            button.index = i
            button.item = item
            
            button.editable = self.delegate?.tabsControl?(self, canEditTitleOfItem: item) == true
            button.buttonPosition = TabPosition.fromIndex(i, totalCount: newItemsCount)
            button.style = self.style

            button.title = dataSource.tabsControl(self, titleForItem: item)
            button.icon = dataSource.tabsControl?(self, iconForItem: item)
            button.menu = dataSource.tabsControl?(self, menuForItem: item)
            button.alternativeTitleIcon = dataSource.tabsControl?(self, titleAlternativeIconForItem: item) 
        }
        
        self.layoutTabButtons(nil, animated: false)
        self.updateAuxiliaryButtons()
        self.invalidateRestorableState()
    }
    
    // MARK: - Layout

    fileprivate func updateTabs(animated: Bool = false) {
        self.layoutTabButtons(nil, animated: animated)
        self.updateAuxiliaryButtons()
        self.invalidateRestorableState()
    }

    fileprivate func layoutTabButtons(_ buttons: [TabButton]?, animated: Bool) {
        let tabButtons = buttons ?? self.tabButtons
        var tabsViewWidth = CGFloat(0.0)
        
        let fullWidth = self.scrollView.frame.width / CGFloat(tabButtons.count)
        let buttonHeight = self.tabsView.frame.height

        var buttonWidth = CGFloat(0)
        switch self.style.tabButtonWidth {
        case .full:
            buttonWidth = fullWidth
        case .flexible(let minWidth, let maxWidth):
            buttonWidth = max(minWidth, min(maxWidth, fullWidth))
        }

        var buttonX = CGFloat(0)
        for (index, button) in tabButtons.enumerated() {
            
            let offset = self.style.tabButtonOffset(position: button.buttonPosition)
            let buttonFrame = CGRect(x: buttonX + offset.x, y: offset.y, width: buttonWidth, height: buttonHeight)
            buttonX += buttonWidth + offset.x

            button.layer?.zPosition = button.state == NSControl.StateValue.on ? CGFloat(Float.greatestFiniteMagnitude) : CGFloat(index)

            if animated && !button.isHidden {
                button.animator().frame = buttonFrame
            } else {
                button.frame = buttonFrame
            }
            
            if let selectable = self.delegate?.tabsControl?(self, canSelectItem: button.representedObject!) {
                button.isEnabled = selectable
            }

            tabsViewWidth += buttonWidth
        }

        let viewFrame = CGRect(x: 0.0, y: 0.0, width: tabsViewWidth, height: buttonHeight)
        if animated {
            self.tabsView.animator().frame = viewFrame
        }
        else {
            self.tabsView.frame = viewFrame
        }
    }
    
    fileprivate func updateAuxiliaryButtons() {
        let contentView = self.scrollView.contentView
        let showScrollButtons = (contentView.subviews.count > 0) && (NSMaxX(contentView.subviews[0].frame) > NSWidth(contentView.bounds))
        
        self.scrollLeftButton?.isHidden = !showScrollButtons
        self.scrollRightButton?.isHidden = !showScrollButtons
        
        if showScrollButtons == true {
            self.scrollLeftButton?.isEnabled = self.visibilityCondition(forButton: self.scrollLeftButton!, forLeftHandSide: true)
            self.scrollRightButton?.isEnabled = self.visibilityCondition(forButton: self.scrollRightButton!, forLeftHandSide: false)
        }
    }

    // MARK: - ScrollView Observation
    
    fileprivate func startObservingScrollView() {
        // TODO replace this with scroll view change notifications
        self.scrollView.addObserver(self, forKeyPath: "frame", options: .new, context: &ScrollViewObservationContext)
        self.scrollView.addObserver(self, forKeyPath: "documentView.frame", options: .new, context: &ScrollViewObservationContext)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(TabsControl.scrollViewDidScroll(_:)),
                                                         name: NSView.frameDidChangeNotification,
                                                         object: self.scrollView)
    }
    
    fileprivate func stopObservingScrollView() {
        self.scrollView.removeObserver(self, forKeyPath: "frame", context: &ScrollViewObservationContext)
        self.scrollView.removeObserver(self, forKeyPath: "documentView.frame", context: &ScrollViewObservationContext)
        
        NotificationCenter.default.removeObserver(self,
                                                            name: NSView.frameDidChangeNotification,
                                                            object: self.scrollView)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &ScrollViewObservationContext {
            self.updateAuxiliaryButtons()
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc fileprivate func scrollViewDidScroll(_ notification: Notification) {
        self.layoutTabButtons(nil, animated: false)
        self.updateAuxiliaryButtons()
        self.invalidateRestorableState()
    }
    
    // MARK: - Actions
    
    @objc fileprivate func scrollTabView(_ sender: AnyObject?) {
        let forLeft = (sender as? NSButton == self.scrollLeftButton)
            
        guard let tab = self.tabButtons.findFirst({ self.visibilityCondition(forButton: $0, forLeftHandSide: forLeft) })
            else { return }

        NSAnimationContext.runAnimationGroup({ (context) in
            context.allowsImplicitAnimation = true
            tab.scrollToVisible(tab.bounds)
            }, completionHandler: {
                self.invalidateRestorableState()
        })
    }
    
    fileprivate func visibilityCondition(forButton button: NSButton, forLeftHandSide: Bool) -> Bool {
        let visibleRect = self.tabsView.visibleRect
        if forLeftHandSide == true {
            return NSMinX(button.frame) < NSMinX(visibleRect)
        }
        else {
            return NSMaxX(button.frame) > NSMaxX(visibleRect) - 2.0*NSWidth(self.scrollLeftButton!.frame)
        }
    }
    
    // MARK: - Reordering
    
    fileprivate func reorderTab(_ tab: TabButton, withEvent event: NSEvent) {
        var orderedTabs = self.tabButtons
        let tabX = NSMinX(tab.frame)
        let dragPoint = self.tabsView.convert(event.locationInWindow, from: nil)

        var prevPoint = dragPoint
        var reordered = false
        
        let draggingTab = tab.copy() as! TabButton
        self.addSubview(draggingTab)
        tab.isHidden = true

        var temporarySelectedButtonIndex = self.selectedButtonIndex!
        while(true) {
            let mask: Int = Int(NSEvent.EventTypeMask.leftMouseUp.union(NSEvent.EventTypeMask.leftMouseDragged).rawValue)
            let event: NSEvent! = self.window?.nextEvent(matching: NSEvent.EventTypeMask(rawValue: UInt64(mask)))
            
            if event.type == NSEvent.EventType.leftMouseUp {
                NSAnimationContext.current.completionHandler = {
                    draggingTab.removeFromSuperview()
                    tab.isHidden = false

                    if reordered == true {
                        let items = orderedTabs.map({ return $0.representedObject! })
                        self.delegate?.tabsControl?(self, didReorderItems: items)
                    }

                    self.reloadTabs()
                    self.invalidateRestorableState()
                    self.selectedButtonIndex = temporarySelectedButtonIndex
                }
                draggingTab.animator().frame = tab.frame
                break
            }
            
            let nextPoint = self.tabsView.convert(event.locationInWindow, from: nil)
            let nextX = tabX + (nextPoint.x - dragPoint.x)
            
            var r = draggingTab.frame
            r.origin.x = nextX
            draggingTab.frame = r
            
            let movingLeft = (nextPoint.x < prevPoint.x)
            prevPoint = nextPoint
            
            let primaryIndex = orderedTabs.index(of: tab)!
            var secondaryIndex : Int?
            
            if movingLeft == true && NSMidX(draggingTab.frame) < NSMinX(tab.frame) && tab !== orderedTabs.first! {
                // shift left
                secondaryIndex = primaryIndex-1
            }
            else if movingLeft == false && NSMidX(draggingTab.frame) > NSMaxX(tab.frame) && tab != orderedTabs.last! {
                secondaryIndex = primaryIndex+1
            }
            
            if let secondIndex = secondaryIndex {
                orderedTabs.swapAt(primaryIndex, secondIndex)
                
                // Shouldn't indexes be swapped too????? But if we do so, it doesn't work!
                orderedTabs[primaryIndex].buttonPosition = TabPosition.fromIndex(primaryIndex, totalCount: orderedTabs.count)
                orderedTabs[secondIndex].buttonPosition = TabPosition.fromIndex(secondIndex, totalCount: orderedTabs.count)
                
                temporarySelectedButtonIndex += secondIndex-primaryIndex
                self.layoutTabButtons(orderedTabs, animated: true)
                self.invalidateRestorableState()
                reordered = true
            }
        }
    }
    
    // MARK: - Selection

    @objc fileprivate func selectTab(_ sender: AnyObject?) {
        guard let button = sender as? TabButton
            , button.isEnabled
            else { return }

        self.selectedButtonIndex = button.index
        self.invalidateRestorableState()

        if let action = self.action,
            let target = self.target {
            NSApp.sendAction(action, to: target, from: self)
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: TabsControlSelectionDidChangeNotification), object: self)
        self.delegate?.tabsControlDidChangeSelection?(self, item: button.representedObject!)

        guard let currentEvent = NSApp.currentEvent else { return }

        if currentEvent.type == .leftMouseDown && currentEvent.clickCount > 1 {
            self.editTabButton(button)
        }
        else if let item = button.representedObject
            , self.delegate?.tabsControl?(self, canReorderItem: item) == true {

            let mask: NSEvent.EventTypeMask = NSEvent.EventTypeMask.leftMouseUp.union(NSEvent.EventTypeMask.leftMouseDragged)

            guard let event = self.window?.nextEvent(matching: NSEvent.EventTypeMask(rawValue: UInt64(Int(mask.rawValue))), until: Date.distantFuture, inMode: RunLoopMode.eventTrackingRunLoopMode, dequeue: false)
                , event.type == NSEvent.EventType.leftMouseDragged
                else { return }

            self.reorderTab(button, withEvent: currentEvent)
        }
    }

    fileprivate func scrollToSelectedButton() {
        guard let selectedButton = self.selectedButton else { return }

        NSAnimationContext.runAnimationGroup({ (context) in
            context.allowsImplicitAnimation = true
            selectedButton.scrollToVisible(selectedButton.bounds)
            }, completionHandler: nil)

    }

    fileprivate var selectedButton: TabButton? {
        guard let index = self.selectedButtonIndex else { return nil }
        return self.tabButtons.findFirst({ $0.index == index })
    }

    var selectedButtonIndex: Int? = nil {
        didSet {
            self.scrollToSelectedButton()
            
            self.updateButtonStatesForSelection()
            self.layoutTabButtons(nil, animated: false)
            self.invalidateRestorableState()

            NotificationCenter.default.post(name: Notification.Name(rawValue: TabsControlSelectionDidChangeNotification), object: self)
        }
    }
    
    /**
     Select an item at a given index. Selecting an invalid index will unselected all tabs.
     
     - parameter index: An integer indicating the index of the item to be selected.
     */
    open func selectItemAtIndex(_ index: Int) {
        guard let button = self.tabButtons[safe: index] else { return }
        self.selectTab(button)
    }

    fileprivate func updateButtonStatesForSelection() {
        for button in self.tabButtons {
            guard let selectedIndex = self.selectedButtonIndex else {
                button.state = NSControl.StateValue.off
                continue
            }

            button.state = button.index == selectedIndex ? NSControl.StateValue.on : NSControl.StateValue.off
        }
    }

    // MARK: - Editing

    /// Starts editing the tab as if the user double-clicked on it. If `index` is out of bounds, it does nothing.
    open func editTabAtIndex(_ index: Int) {
        
        guard let tabButton = self.tabButtons[safe: index] else { return }

        self.editTabButton(tabButton)
    }

    func editTabButton(_ tab: TabButton) {

        guard let representedObject = tab.representedObject
            , self.delegate?.tabsControl?(self, canEditTitleOfItem: representedObject) == true
            else { return }

        guard let fieldEditor = self.window?.fieldEditor(true, for: tab)
            else { return }

        self.window?.makeFirstResponder(self)
        
        self.editingTab = (tab.title, tab)
        tab.edit(fieldEditor: fieldEditor, delegate: self)
    }
    
    // MARK : - NSTextDelegate
    
    open func textDidEndEditing(_ notification: Notification) {
        guard let fieldEditor = notification.object as? NSText else {
            assertionFailure("Expected field editor.")
            return
        }
        
        let newValue = fieldEditor.string 
        self.editingTab?.button.finishEditing(fieldEditor: fieldEditor, newValue: newValue)
        self.window?.makeFirstResponder(self)
        
        defer {
            self.editingTab = nil
        }
        
        guard let item = self.editingTab?.button.representedObject
            , newValue != self.editingTab?.title
            else { return }
        
        self.delegate?.tabsControl?(self, setTitle: newValue, forItem: item)
        self.editingTab?.button.representedObject = self.dataSource?.tabsControl(self, itemAtIndex: self.selectedButtonIndex!)
    }

    // MARK: - Drawing
    
    override open var isOpaque: Bool {
        return false
    }

    override open var isFlipped: Bool {
        return true
    }
    
    // MARK: - Tab Widths
    
    open func currentTabWidth() -> CGFloat {
        let tabs = self.tabButtons
        guard let firstTab = tabs.first else { return 0.0 }
        return firstTab.frame.width
    }
    
    // MARK: - State Restoration

    fileprivate enum RestorationKeys {
        static let scrollXOffset = "scrollOrigin"
        static let selectedButtonIndex = "selectedButtonIndex"
    }

    open override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        let scrollXOffset: CGFloat = self.scrollView.contentView.bounds.origin.x
        let selectedButtonIndex: Int = self.selectedButtonIndex ?? NSNotFound

        coder.encode(Double(scrollXOffset), forKey: RestorationKeys.scrollXOffset)
        coder.encode(selectedButtonIndex, forKey: RestorationKeys.selectedButtonIndex)
    }

    open override func restoreState(with coder: NSCoder) {
        super.restoreState(with: coder)
        
        let scrollXOffset = coder.decodeDouble(forKey: RestorationKeys.scrollXOffset)
        let selectedButtonIndex = coder.decodeInteger(forKey: RestorationKeys.selectedButtonIndex)
        
        var bounds = self.scrollView.contentView.bounds
        bounds.origin.x = CGFloat(scrollXOffset)
        self.scrollView.contentView.bounds = bounds

        guard selectedButtonIndex != NSNotFound,
            let selectedButton = self.tabButtons.findFirst({ $0.index == selectedButtonIndex })
            else { return }

        self.selectTab(selectedButton)
    }
    
    // MARK: - Helpers
    
    fileprivate var tabButtons: [TabButton] {
        guard let tabsView = self.tabsView else { return [] }
        return tabsView.subviews.flatMap({ $0 as? TabButton }).sorted(by: { $0.index < $1.index })
    }
}
