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
    private weak var selectedButton: NSButton? = nil

    private var hideScrollButtons: Bool = true
    private var isHighlighted: Bool = false


    @IBOutlet public weak var dataSource: TabsControlDataSource?
    @IBOutlet public weak var delegate: TabsControlDelegate?
    
    public weak var selectedItem: AnyObject? = nil
    
    public var preferFullWidthTabs: Bool = false
    
    public var minTabWidth: CGFloat =  50.0
    public var maxTabWidth: CGFloat = 150.0
    
//    public override var highlighted: Bool {
//        get { return true }
//    }
    
    public var tabsStyle: TabsControlTabsStyle = .NumbersApp
    public var bordersMask: TabsControlBorderMask = .Top
    public var automaticSideBorderMasks: Bool = true
    
    public var controlBorderColor: NSColor? = NSColor.KPC_defaultControlBorderColor()
    public var controlBackgroundColor: NSColor? = NSColor.KPC_defaultControlBackgroundColor()
    public var controlHighlightedBackgroundColor: NSColor? = NSColor.KPC_defaultControlHighlightedBackgroundColor()
    
    public var tabBorderColor: NSColor? = NSColor.KPC_defaultTabBorderColor() {
        didSet {
//            self.tabButtons.valueForKey("cell") setValue
//            [[[self tabButtons] valueForKey:@"cell"] setValue:tabBorderColor forKey:@"tabBorderColor"];

        }
    }
    public var tabTitleColor: NSColor? = NSColor.KPC_defaultTabBorderColor()
    public var tabBackgroundColor: NSColor? = NSColor.KPC_defaultTabTitleColor()
    public var tabHighlightedBackgroundColor: NSColor? = NSColor.KPC_defaultTabBackgroundColor()
    public var tabSelectedBorderColor: NSColor? = NSColor.KPC_defaultTabHighlightedBackgroundColor()
    public var tabSelectedTitleColor: NSColor? = NSColor.KPC_defaultTabSelectedTitleColor()
    public var tabSelectedBackgroundColor: NSColor? = NSColor.KPC_defaultTabSelectedBackgroundColor()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.cell = TabButtonCell(textCell: "")
        self.cell?.font = NSFont(name: "HelveticaNeue-Medium", size: 13.0)
        
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
            
        }
        
        self.startObservingScrollView()
        self.updateAuxiliaryButtons()
    }
    
    deinit {
        self.stopObservingScrollView()
    }
    
    public override func menuForEvent(event: NSEvent) -> NSMenu? {
        return nil
    }
    
    // MARK: Data Source
    
    public func reloadTabs() {
        let selectedItem = self.selectedItem
    }
    
    private func layoutTabButtons(buttons: Array<TabButton>?, animated anim: Bool) {
        
    }
    
    private func updateAuxiliaryButtons() {
        
    }

    // MARK: ScrollView Observation
    
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
    
    // MARK: Actions
    
    // MARK: Reordering
    
    // MARK : Selection
    
    public func selectedItemIndex() -> Int {
        return (self.selectedButton != nil) ? self.selectedButton!.tag : -1
    }
    
    public func selectItemAtIndex(index: Int) {
        
    }
    
    // MARK: Editing
    
    // MARK: Drawing
    
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
    
    // MARK: Border Mask
    
    // MARK: Tab Widths
    
    public func currentTabWidth() -> CGFloat {
        let tabs = self.tabButtons()
        if tabs.count > 0 {
            return CGRectGetWidth(tabs.first!.frame)
        }
        return 0.0
    }
    
    // MARK: Control Colors
    
    // MARK: State Restoration
    
}