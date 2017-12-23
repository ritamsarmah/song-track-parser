//
//  TrackParser.swift
//  TrackParser
//
//  Created by Ritam Sarmah on 12/19/17.
//  Copyright © 2017 Ritam Sarmah. All rights reserved.
//

import Foundation

class TrackParser {
    
    func parseTimes(input: String) -> [String]? {
        var timestamps = [String]()
        let lines = input.split(separator: "\n").map { String($0) }
        
        for line in lines {
            do {
                let regex = try NSRegularExpression(pattern: "([0-9]+:)?[0-5]?[0-9]:[0-5][0-9]")
                let matches = regex.matches(in: line,
                                            options: [],
                                            range: NSRange(line.startIndex..., in: line))
                let results = matches.map {
                    String(line[Range($0.range, in: line)!])
                }
                
                if let timestamp = results.first {
                    timestamps.append(timestamp)
                }
            } catch {
                print("Error with regex")
                return nil
            }
        }
        return timestamps
    }
    
    // Parameter "format" includes TIME, NUM, and TITLE
    // e.g. "1) [00:00] - Song Title" corresponds with "NUM) [TIME] - TITLE"
    func parseAll(input: String, pattern: String) -> [[String: String]]? {
        var results = [[String: String]]()
        let lines = input.split(separator: "\n").map { String($0) }
        
        if !validatePattern(pattern) {
            return nil
        }
        
        let regexString = regexFrom(string: pattern)
        let order = getTagOrder(pattern)
        
        for line in lines {
            do {
                let regex = try NSRegularExpression(pattern: regexString)
                let matches = regex.matches(in: line,
                                            options: [],
                                            range: NSRange(line.startIndex..., in: line))
                
                for match in matches {
                    var matchDict = [String: String]()
                    for n in 1..<match.numberOfRanges {
                        let nsRange = match.range(at: n)
                        if let range = Range(nsRange, in: line) {
                            // Get order of tag index using regex capture group index - 1
                            matchDict[order[n-1]] = String(line[range]).trimmingCharacters(in: .whitespaces)
                        }
                    }
                    results.append(matchDict)
                }
            } catch {
                print("Error with regex")
                return nil
            }
        }
        
        return results
    }
    
    private func getTagOrder(_ pattern: String) -> [String] {
        if !validatePattern(pattern) {
            return []
        }
        
        var order = [String: String.Index]()
        
        let title = "title"
        let num = "num"
        let time = "time"
        let artist = "artist"
        
        if let titleRange = pattern.range(of: "TITLE") {
            order[title] = titleRange.lowerBound
        }
        if let numRange = pattern.range(of: "NUM") {
            order[num] = numRange.lowerBound
        }
        if let timeRange = pattern.range(of: "TIME") {
            order[time] = timeRange.lowerBound
        }
        if let artistRange = pattern.range(of: "ARTIST") {
            order[artist] = artistRange.lowerBound
        }
        
        return Array(order.keys).sorted {order[$0]! < order[$1]!}
    }
    
    func validatePattern(_ pattern: String) -> Bool {
        let tags = ["TITLE", "TIME"] // May also contain "NUM" or "ARTIST"
        for tag in tags {
            if !pattern.contains(tag) {
                return false
            }
        }
        return true
    }
    
    private func regexFrom(string pattern: String) -> String {
        
        let regexEscapedCharacterSet = "[]^$.|?*+(){}".map { String($0) }
        var regexString = pattern
        
        for char in regexEscapedCharacterSet {
            regexString = regexString.replacingOccurrences(of: char, with: "\\" + char)
        }
        
        regexString = regexString.replacingOccurrences(of: "TITLE", with: "(.+)")
        regexString = regexString.replacingOccurrences(of: "ARTIST", with: "(.+)")
        regexString = regexString.replacingOccurrences(of: "NUM", with: "([0-9]+)")
        regexString = regexString.replacingOccurrences(of: "TIME", with: "((?:[0-9]+:)?[0-5]?[0-9]:[0-5][0-9])")
        
        return regexString
    }
}
