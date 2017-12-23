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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTextView.isRichText = false
        resultTextView.isRichText = false
        resultTextView.isEditable = false
        formatTextField.placeholderString = "Example: \"NUM. ARTIST - TITLE (TIME)\" for \"1. Artist - Song Title (3:12)\""
    }
    
    override func viewWillAppear() {
        self.view.window?.title = "TSParser"
        self.view.window?.contentMinSize = NSSize(width: 500, height: 400)
        self.view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    @IBAction func parseButtonPressed(_ sender: NSButton) {
        let parser = TrackParser()
        let trackInfo = infoTextView.string
        let lineFormat = formatTextField.stringValue
        
        if trackInfo.isEmpty {
            resultTextView.string = "Please enter track info."
            return
        } else if lineFormat.isEmpty {
            resultTextView.string = "Please enter line format."
            return
        }
        
        if !parser.validatePattern(lineFormat) {
            resultTextView.string = "Invalid line format."
            return
        }
        
        if let results = parser.parseAll(input: trackInfo, pattern: lineFormat) {
            if results.isEmpty {
                resultTextView.string = "Failed to parse track info. Check line format."
                return
            }
            var outputLines = [String]()
            for result in results {
                var outputLine = [String]()
                if let num = result["num"], numButton.state == .on {
                    outputLine.append(num)
                }
                if let title = result["title"], titleButton.state == .on {
                    outputLine.append(title)
                }
                if let artist = result["artist"], artistButton.state == .on {
                    outputLine.append(artist)
                }
                if let time = result["time"], timeButton.state == .on {
                    outputLine.append(time)
                }
                outputLines.append(outputLine.joined(separator: ","))
            }
            resultTextView.string = outputLines.joined(separator: "\n")
        } else {
            resultTextView.string = "Failed to parse track info. Check line format."
        }
    }
}

