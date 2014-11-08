KPCTabsControl
==============

An multi-tab control *not using AutoLayout*, designed to look and behave like the tab control in Apple's Numbers spreadsheet, with enhanced capabilities. Borrowed initially from the excellent [LITabControl](https://github.com/monyschuk/LITabControl).

The reason for not doing a fork, but a new lib? Well, I used the LITabControl since some time, and it diverged quite a lot. More importantly, AutoLayout is way too instable and hard to debug in a complex app (with various intricated split views with dynamic constraints), like the ones I am currently developing.

Below a screenshot of the demo app with two series of tabs (showing the highlight effect). 
![Demo Tabs Screenshot](http://onekilopars.ec/blog/files/screen-shot-2014-11-05-at-17.36.32.png)

I also added the possibility to provide alternative icons for titles too large to be drawn without linebreak. When the icons are visible, the tabs titles are moved to the tooltips of the buttons.
[![Demo Tabs Movie](http://onekilopars.ec/resources/Screen-Shot-2014-11-08-at-09.45.22.png)](http://onekilopars.ec/blog/files/page0_blog_entry6_2.mov)


Installation
------------

Using CocoaPods: `pod 'KPCTabsControl'`


Usage
-----

KPCTabsControl is designed for you to use only the `KPCTabsControl` class, and its associated data source methods. You can also assign a delegate method if you want to play with the editing of the tab titles.

Customization
-------------

Tabs can be customized: max width, min width, full-size width, colors, hightlighted colors, borders, selection colors, color titles etc. Each tab can have an icon and/or a menu (whose arrow appears only when mouse is over).

Tabs titles can be edited in place, and tabs can be reordred by simple drag & drop (with small animations).


Highlighting
------------

The tabs control support the possibility to be highlighted. This is useful when you have multiple subviews, each with tab controls, and you need to indicate to the user which subview is actually 'active'.


LICENSE & NOTES
---------------

KPCTabsControl is licensed under the MIT license and hosted on GitHub at https://github.com/onekiloparsec/KPCTabsControl/ Fork the project and feel free to send pull requests with your changes!


