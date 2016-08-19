//
//  TabEditing.swift
//  KPCTabsControl
//
//  Created by Christian Tietze on 04/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

protocol TabEditingDelegate: class {
    func tabButtonDidEndEditing(tabButton: TabButton, newTitle: String)
}

class TabEditing: NSObject, NSTextDelegate, NSTextViewDelegate {

    let tabButton: TabButton
    let fieldEditor: NSText
    private(set) var delegate: TabEditingDelegate?

    @available(*, unavailable)
    override required init() {
        fatalMethodNotImplemented()
    }

    init(tabButton: TabButton, fieldEditor: NSText, delegate: TabEditingDelegate) {
        self.tabButton = tabButton
        self.fieldEditor = fieldEditor
        self.delegate = delegate
        super.init()
    }

    func edit() {
        self.tabButton.edit(fieldEditor: self.fieldEditor, delegate: self)
    }

    func textDidEndEditing(notification: NSNotification) {
        guard let editingTextField = notification.object as? NSText else {
            assertionFailure("Expected field editor.")
            return
        }

        let newValue = editingTextField.string ?? ""
        self.tabButton.finishEditing(newValue)
        self.delegate?.tabButtonDidEndEditing(self.tabButton, newTitle: newValue)
    }
}
