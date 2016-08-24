<h3 align="center">
    <img src="http://onekilopars.ec/s/1kpcProComponents.png" width="100%" />
</h3>
<p align="center">
  <b>KPCTabsControl</b> &bull;
  <a href="https://github.com/onekiloparsec/KPCJumpBarControl">KPCJumpBarControl</a> &bull;
  <a href="https://github.com/onekiloparsec/KPCSplitPanes">KPCSplitPanes</a> &bull;
  <a href="https://github.com/onekiloparsec/KPCAppTermination">KPCAppTermination</a> &bull;
  <a href="https://github.com/onekiloparsec/KPCSearchableOutlineView">KPCSearchableOutlineView</a> &bull;
  <a href="https://github.com/onekiloparsec/KPCImportSheetController">KPCImportSheetController</a>
</p>

-------

KPCTabsControl
==============

[![Build Status](http://img.shields.io/travis/onekiloparsec/KPCTabsControl.svg?style=flat)](https://travis-ci.org/onekiloparsec/KPCTabsControl)
![Version](https://img.shields.io/cocoapods/v/KPCTabsControl.svg?style=flat)
![License](https://img.shields.io/cocoapods/l/KPCTabsControl.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/KPCTabsControl.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Codewake](https://www.codewake.com/badges/ask_question.svg)](https://www.codewake.com/p/kpctabscontrol)
 
A multi-tabs control first designed to look and behave like the tab control in Apple's Numbers spreadsheet, with enhanced capabilities, and soon, new tab styles, such as Chrome, Safari or Xcode as well as custom ones. 

The complete rewrite in Swift is ongoing, and will labelled 2.0 and on. You can participate [here](https://github.com/onekiloparsec/KPCTabsControl/issues/9). The last stable (and Pod) version (written in Obj-C) is 1.6.3 and is well suited for production, even in a Swift app. 
 
Below a screenshot of the 1.6.3 demo app with two series of tabs (showing the highlight effect). 
![Demo Tabs Screenshot](http://www.onekilopars.ec/s/KPCTabsControlScreenshot1.png)

KPCTabsControl also has the possibility to provide alternative icons for titles too large to be drawn without linebreak. When the icons are visible, the tabs titles are moved to the tooltips of the buttons.

 ![Demo Auxiliary Icons](http://www.onekilopars.ec/s/KPCTabsControlAuxiliaryIconMovie.gif) 


Installation
------------

Using [Carthage](https://github.com/Carthage/Carthage): add `github "onekiloparsec/KPCTabsControl"` to your `Cartfile` and then run `carthage update`.

Using [CocoaPods](http://cocoapods.org/): `pod 'KPCTabsControl'`


Usage
-----

KPCTabsControl is designed for you to use only the `KPCTabsControl` class, and its associated data source methods. Simply place a `NSView` in a xib, where you need tabs, change its class to `KPCTabsControl` and assign its dataSource property. Then implement the data source methods in your controller.

You can also assign a delegate if you want to play with the editing and the reordering of the tab titles.


Customization
-------------

Tabs can be customized: max width, min width, full-size width, colors, hightlighted colors, borders, selection colors, color titles etc. Each tab can have an icon and/or a menu (whose arrow appears only when mouse is over).

Tabs titles can be edited in place, and tabs can be reordred by simple drag & drop (with small animations).


Highlighting
------------

The tabs control support the possibility to be highlighted. This is useful when you have multiple subviews, for instance using <a href="https://github.com/onekiloparsec/KPCSplitPanes">KPCSplitPanes</a>, each with tab controls, and you need to indicate to the user which subview is actually 'active'. (In the screenshot above, the upper tabs have a darker background than the lower ones).


Author
------

[Cédric Foellmi](https://github.com/onekiloparsec) ([@onekiloparsec](https://twitter.com/onekiloparsec))


LICENSE & NOTES
---------------

KPCTabsControl is licensed under the MIT license and hosted on GitHub at https://github.com/onekiloparsec/KPCTabsControl/ Fork the project and feel free to send pull requests with your changes!


