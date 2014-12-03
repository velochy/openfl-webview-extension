openfl-webview-extension
========================

An extension for openFL compiling for iOS platform that allows one to open a browser window and to control it. 

Setup for iOS development for non-Mac developers
================================================

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
