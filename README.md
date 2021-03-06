openfl-webview-extension
========================

An extension for openFL compiling for iOS platform that allows one to open a browser window and to control it. 

Setup (assuming no Mac experience)
==================================

- Become apple iOS developer (99$ per year on 2014)

- Get a Mac with OSX (or OSX running in virtualbox)

- Install XCode from app store

- Enable third party apps to be installed (Settings->Privacy->padlock in bottom corner)

- Install HaXe and OpenFL: http://www.openfl.org/documentation/setup/install-haxe/

- Tell haxelib where the extension is located (in mobile folder):
  
        haxelib dev WebViewExtension WebViewExtension

- Building the native extension:
  
        lime rebuild WebViewExtension ios -clean

- Building and running on simulator:
  
        lime build iphonesim
        lime run iphonesim

- Building project for real phone:
  (set up phone and xcode by creating a test app and deploying it on phone)
  
      lime build ios
      lime run ios
  
Deviations from that ideal
==========================

Currently, resource files are moved to a place where they are not included in mainBundle and I have found no command-line way around that.There is a fairly easy XCode solution though:

- Open XCode
- File->Open, browse to Export/ios/ folder and click open
- In left pane (files) open Resources/WVTest/assets/assets
- Select all three files in the folder (shift+down arrow key)
- Drag and move them to Resources root
- Now click "Run" on toolbar or from Product menu

I would REALLY like to be able to bypass that step so if anyone figures out how, please do let me know!

## Other minor annoyances

Currently, we cannot use autogenerated Info.plist for the following reasons:
- Cannot set important metadata like keys (like capabilities, etc)
- Cannot set allowed orientations
- Cannot set launch screen to a xib file

Automatic script does a good job of creating all the required icon sizes, but only creates white launch screens. Would be cool if it could autogrenerate those as well, by cropping or resizing one fixed-size svg launch image.

Hints for first time Mac developers
===================================

- iOS debug output is accessible from XCode 6 at Window->Devices. Console is at the bottom of the screen but is initially hidden under a small triangle you need to click to open the log

- if you open a WebView in iOS, you get access to its console and tools via Safari Developer menu.

Inspirations
============

### NME extension for WebView by Suat Eyrice
- https://github.com/SuatEyrice/NMEWebview
- Rewrote most of the code as the author did not reply to licence requests
- Also, OpenFL extensions are different enough so changes were needed anyways
- On the plus side - his code also has an Android version while this is iOS only at this point

### Building a web browser for iOS
- Useful to go through to familiarize yourself with the basics of "normal" iOS development
- http://iosdeveloperzone.com/2013/11/17/tutorial-building-a-web-browser-with-uiwebview-revisited-part-1/
- http://iosdeveloperzone.com/2013/11/19/tutorial-building-a-web-browser-with-uiwebview-revisited-part-2/
- http://iosdeveloperzone.com/2013/11/20/tutorial-building-a-web-browser-with-uiwebview-revisited-part-3/
