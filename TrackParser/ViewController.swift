//
//  ViewController.swift
//  TrackParser
//
//  Created by Ritam Sarmah on 12/23/17.
//  Copyright © 2017 Ritam Sarmah. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var infoTextView: NSTextView!
    @IBOutlet weak var resultTextView: NSTextView!
    @IBOutlet weak var formatTextField: NSTextField!
    @IBOutlet weak var parseButton: NSButton!
    
    @IBOutlet weak var titleButton: NSButton!
    @IBOutlet weak var timeButton: NSButton!
    @IBOutlet weak var numButton: NSButton!
    @IBOutlet weak var artistButton: NSButton!
    
    // Used for exporting to CSV
    var parseSuccess = false {
        didSet {
            let delegate = NSApplication.shared.delegate as! AppDelegate
            if parseSuccess {
                delegate.exportItem.isEnabled = true
            } else {
                availableHeadings.removeAll()
                delegate.exportItem.isEnabled = false
            }
        }
    }
    var availableHeadings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseSuccess = false
        infoTextView.isRichText = false
        resultTextView.isRichText = false
        resultTextView.isEditable = false
        
        let fontName = "Menlo"
        let fontSize: CGFloat = 12
        infoTextView.font = NSFont(name: fontName, size: fontSize)
        resultTextView.font = NSFont(name: fontName, size: fontSize)
        formatTextField.font = NSFont(name: fontName, size: fontSize)
        
        formatTextField.placeholderString = "e.g. \"NUM. ARTIST - TITLE (TIME)\""
    }
    
    override func viewWillAppear() {
        self.view.window?.title = "TrackParser"
        self.view.window?.contentMinSize = NSSize(width: 500, height: 400)
        self.view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    @IBAction func parseButtonPressed(_ sender: NSButton) {
        let parser = TrackParser()
        let trackInfo = infoTextView.string
        let lineFormat = formatTextField.stringValue
         availableHeadings.removeAll()
        
        if trackInfo.isEmpty {
            updateResult("Please enter track info.", success: false)
            return
        } else if lineFormat.isEmpty {
            updateResult("Please enter the line format.", success: false)
            return
        }
        
        if !parser.validatePattern(lineFormat) {
            updateResult(
                """
                Invalid line format.

                Required Tags
                * Title: TITLE
                * Time: TIME

                Optional Tags
                * Track Number: NUM
                * Artist: ARTIST
                """,
                success: false)
            return
        }
        
        if let results = parser.parseAll(input: trackInfo, pattern: lineFormat) {
            if results.isEmpty {
                updateResult("Failed to parse track info. Check line format.", success: false)
                return
            }
            print(results)
            var outputLines = [String]()
            for result in results {
                var outputLine = [String]()
                if let num = result["num"], numButton.state == .on {
                    outputLine.append(num)
                    if !availableHeadings.contains("#") {
                        availableHeadings.append("#")
                    }
                }
                if let title = result["title"], titleButton.state == .on {
                    outputLine.append("\"" + title + "\"")
                    if !availableHeadings.contains("Title") {
                        availableHeadings.append("Title")
                    }
                }
                if let artist = result["artist"], artistButton.state == .on {
                    outputLine.append("\"" + artist + "\"")
                    if !availableHeadings.contains("Artist") {
                        availableHeadings.append("Artist")
                    }
                }
                if let time = result["time"], timeButton.state == .on {
                    outputLine.append(time)
                    if !availableHeadings.contains("Time") {
                        availableHeadings.append("Time")
                    }
                }
                outputLines.append(outputLine.joined(separator: ","))
            }
            
            // Update available headings for export
            
            updateResult(outputLines.joined(separator: "\n"), success: true)
        } else {
            updateResult("Failed to parse track info. Check line format.", success: false)
        }
    }
    
    func updateResult(_ error: String, success: Bool) {
        resultTextView.string = error
        parseSuccess = success
        return
    }
}

