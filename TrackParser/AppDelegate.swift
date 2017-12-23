//
//  AppDelegate.swift
//  TrackParser
//
//  Created by Ritam Sarmah on 12/23/17.
//  Copyright © 2017 Ritam Sarmah. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var exportItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func exportSelected(_ sender: NSMenuItem) {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "info.csv"
        if let window = NSApplication.shared.windows.first {
            panel.beginSheetModal(for: window, completionHandler: { (response) in
                switch response {
                case .OK:
                    guard let file = panel.url else {
                        return
                    }
                    let vc = window.contentViewController as! ViewController
                    
                    // Create heading row
                    let text = vc.availableHeadings.joined(separator: ",") + "\n" + vc.resultTextView.string
                    
                    // Write file
                    do {
                        try text.write(to: file, atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        print(error)
                    }
                case .cancel:
                    print("not done")
                default:
                    print("something else")
                }
            })
        }
    }
}

