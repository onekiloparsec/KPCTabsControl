[![Build Status](http://img.shields.io/travis/onekiloparsec/KPCTabsControl.svg?style=flat)](https://travis-ci.org/onekiloparsec/KPCTabsControl)
![Version](https://img.shields.io/cocoapods/v/KPCTabsControl.svg?style=flat)
![License](https://img.shields.io/cocoapods/l/KPCTabsControl.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/KPCTabsControl.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Codewake](https://www.codewake.com/badges/ask_question.svg)](https://www.codewake.com/p/kpctabscontrol)
 
KPCTabsControl
==============

A multi-tabs control designed to look and behave like the tab control in Apple's Numbers spreadsheet, with enhanced capabilities. Borrowed initially from the excellent [LITabControl](https://github.com/monyschuk/LITabControl).

The last stable (and Pod) version is 1.6.3, written in Obj-C. A complete rewrite in Swift is ongoing, and will labelled 2.0 and on. It will bring a slightly updated API, and, in the future, multiple tab styles, such as Chrome, Safari or Xcode. You can participate [here](https://github.com/onekiloparsec/KPCTabsControl/issues/9).
 
Below a screenshot of the demo app with two series of tabs (showing the highlight effect). 
![Demo Tabs Screenshot](http://www.onekilopars.ec/s/KPCTabsControlScreenshot1.png)

I also added the possibility to provide alternative icons for titles too large to be drawn without linebreak. When the icons are visible, the tabs titles are moved to the tooltips of the buttons.

 ![Demo Auxiliary Icons](http://www.onekilopars.ec/s/KPCTabsControlAuxiliaryIconMovie.gif) 


Installation
------------

Using [CocoaPods](http://cocoapods.org/): `pod 'KPCTabsControl'`
 
Using [Carthage](https://github.com/Carthage/Carthage): add `github "onekiloparsec/KPCTabsControl"` to your `Cartfile` and then run `carthage update`.



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

The tabs control support the possibility to be highlighted. This is useful when you have multiple subviews, each with tab controls, and you need to indicate to the user which subview is actually 'active'. (In the screenshot above, the upper tabs have a darker background than the lower ones).


Author
------

[Cédric Foellmi](https://github.com/onekiloparsec) ([@onekiloparsec](https://twitter.com/onekiloparsec))


LICENSE & NOTES
---------------

KPCTabsControl is licensed under the MIT license and hosted on GitHub at https://github.com/onekiloparsec/KPCTabsControl/ Fork the project and feel free to send pull requests with your changes!


