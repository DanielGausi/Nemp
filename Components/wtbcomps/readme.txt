FspWinTaskbar - Windows7 Taskbar Components

Version - 0.81

(c) FSPro Labs, 2010
http://delphi.fsprolabs.com
License: see license.txt

This component set is designed to develop application that supports new feature of Windows 7 task bar.

It’s compatible with  Delphi 5,6,7,2006,2007,2009 and 2010. 
Most probably, it will work with BCB.
Note: I tested it only with Delphi 5, Delphi 7 and Delphi 2010!!!

Components:
-----------

TfspTaskbarMgr – sets button overlay icon, progress bar and thumb buttons.
Allows you to set your own Application ID (different AppIDs for each instance 
of the same application prevent Windows from joining all these  
instances in one application button on the taskbar).

TfspTaskbarPreviews lets you to create own icon preview for you application.

TfspTaskbarTabMgr creates tabs on taskbar button like Internet Explorer does.


Installation
------------

Delphi5:

Install design-time package dclfspWinTaskbar_D5.dpk

Delphi 7-2010

Install design-time package dclfspWinTaskbar_DX.dpk

Sorry, no idea about Delphi 6.

If something goes wrong with installation, you may try to install 
fspWinTaskbarReg.pas to a New Package (use Component->Install Component)

Comments
--------

If you have Delphi 2007 or higher, it’s recommended to use
    Application.MainFormOnTaskBar := True in the dpr file (see "TaskBarMgr&Previews" example)

We use  CoInitializeEx(nil, COINIT_APARTMENTTHREADED ) in one of our units;
In some cases, your main thread may require multi-threaded object concurrency (COINIT_MULTITHREADED). 
If so, define FSP_COINIT_MULTITHREADED in the Project defines.

Known Issues
------------

TfspTaskbarPreviews

When you use TThemeManager and set preview to display a TPanel (see  "TaskBarMgr&Previews" sample), 
you should set ThemeManager.toSubclassPanel to False. 
 


Feedback
--------

Send feedbacks to delphi@fsprolabs.com



History
---------


0.81 - fixed bug with iconic previews when Aero disabled
0.8 - First public release