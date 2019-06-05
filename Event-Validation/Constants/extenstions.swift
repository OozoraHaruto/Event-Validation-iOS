//
//  extenstions.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 2/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import Foundation

// Get String at Index              = https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language/38215613#38215613
// localize string                  = https://stackoverflow.com/questions/25081757/whats-nslocalizedstring-equivalent-in-swift/29384360#29384360
// Check date In Between            = https://stackoverflow.com/questions/32859569/check-if-date-falls-between-2-dates/40057117#40057117
// Date setting and getting         = https://stackoverflow.com/a/52855320

extension StringProtocol {
    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    subscript(_ range: Range<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
    func indexDistance(of string: Self) -> Int? {
        guard let index = range(of: string)?.lowerBound else { return nil }
        return distance(from: startIndex, to: index)
    }
}

extension Collection where Element: Equatable {
    func indexDistance(of element: Element) -> Int? {
        guard let index = firstIndex(of: element) else { return nil }
        return distance(from: startIndex, to: index)
    }
}

extension LosslessStringConvertible {
    var string: String { return .init(self) }
}

extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    func toDate(withFormat format: String) -> Date{
        let dateFormatter               = DateFormatter()
        dateFormatter.timeZone          = .current
        dateFormatter.locale            = .current
        dateFormatter.calendar          = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat        = format
        
        return dateFormatter.date(from: self)!
    }
}


extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    func  toString(withFormat format: String) -> String {
        let dateFormatter               = DateFormatter()
        dateFormatter.timeZone          = .current
        dateFormatter.locale            = .current
        dateFormatter.calendar          = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat        = format
        
        return dateFormatter.string(from: self)
    }
}
