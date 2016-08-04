//
//  TabEditing.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 04/08/16.
//  Copyright © 2016 Cédric Foellmi. All rights reserved.
//

import AppKit

protocol TabEditingDelegate: class {

    func tabButtonDidEndEditing(tabButton: TabButton, newValue: String)
}

class TabEditing: NSObject, NSTextDelegate, NSTextViewDelegate {

    let tabButton: TabButton
    let fieldEditor: NSText
    private(set) var delegate: TabEditingDelegate?

    @available(*, unavailable)
    override required init() { fatalMethodNotImplemented() }

    init(tabButton: TabButton, fieldEditor: NSText, delegate: TabEditingDelegate) {

        self.tabButton = tabButton
        self.fieldEditor = fieldEditor
        self.delegate = delegate

        super.init()
    }

    func edit() {

        tabButton.edit(fieldEditor: fieldEditor, delegate: self)
    }

    func textDidEndEditing(notification: NSNotification) {

        guard let editingTextField = notification.object as? NSText
            else { assertionFailure("Expected field editor."); return }

        let newValue = editingTextField.string ?? ""

        tabButton.tabButtonCell?.finishEditing(newValue)

        delegate?.tabButtonDidEndEditing(tabButton, newValue: newValue)
    }
}
