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

![](https://img.shields.io/badge/Swift-4.0-blue.svg?style=flat)
[![Build Status](http://img.shields.io/travis/onekiloparsec/KPCTabsControl.svg?style=flat)](https://travis-ci.org/onekiloparsec/KPCTabsControl)
![Version](https://img.shields.io/cocoapods/v/KPCTabsControl.svg?style=flat)
![License](https://img.shields.io/cocoapods/l/KPCTabsControl.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/KPCTabsControl.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Codewake](https://www.codewake.com/badges/ask_question.svg)](https://www.codewake.com/p/kpctabscontrol)
 
A multi-tabs control first designed to look and behave like the tab control in Apple's Numbers spreadsheet, with enhanced capabilities, but now with new tab styles, such as Chrome & Safari, as well as custom ones.  

On master, you'll find the latest Swift4 releases. If you need to stay with Swift2, switch to the swift-2.2 branch. If you need to stay with Swift3, switch to the swift-3.1 branch.
 
![Demo Tabs Screenshot](http://www.onekilopars.ec/s/KPCTabsControl2Screenshot.png)

KPCTabsControl provides the following features:

* Custom styles and themes! Default (Numbers.app-like), Chrome and Safari are provided. But you can easily write your own!
* Styles & themes comprise title styles, title editor style, (un)selected/unselectable backgrounds, borders, colors, fonts etc.
* Common dataSource/delegate Cocoa APIs
* Tabs can span the whole view width, or be flexible inside min&max.
* Tabs can be reordered, and renamed in place.
* When provided, the title can be replaced by an alternative icon when the width is too narrow for the title to be drawn.


 ![Demo Auxiliary Icons](http://www.onekilopars.ec/s/KPCTabsControl2Demo.gif) 


Documentation
=======

The documentation generated from the code itself is available at [http://onekiloparsec.github.io/KPCTabsControl](http://onekiloparsec.github.io/KPCTabsControl).


Installation
------------

Using [Carthage](https://github.com/Carthage/Carthage): add `github "onekiloparsec/KPCTabsControl"` to your `Cartfile` and then run `carthage update`.

Using [CocoaPods](http://cocoapods.org/): `pod 'KPCTabsControl'`. 


Usage
-----

KPCTabsControl is designed for you to use only the `KPCTabsControl` class, and its associated data source methods. Simply place a `NSView` in a xib, where you need tabs, change its class to `KPCTabsControl` and assign its dataSource property. Then implement the data source methods in your controller.

You can also assign a delegate if you want to play with the editing and the reordering of the tab titles.


Authors
------

[Cédric Foellmi](https://github.com/onekiloparsec) ([@onekiloparsec](https://twitter.com/onekiloparsec)) <br/>
[Christian Tietze](https://github.com/DivineDominion) ([@ctietze](https://twitter.com/ctietze))


LICENSE & NOTES
---------------

KPCTabsControl is licensed under the MIT license and hosted on GitHub at https://github.com/onekiloparsec/KPCTabsControl/ Fork the project and feel free to send pull requests with your changes!


