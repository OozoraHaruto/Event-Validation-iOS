//
//  structs.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 2/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import Foundation

struct QRData: Codable{
    var e                   :String         // eventName
    var d                   :String         // date
    var w                   :String         // website
    var v                   :Double         // QR version
    var g                   :Int            // Generator Index
    var p                   :Int            // Prime Number Index
    var y                   :String         // Public Key
    var k                   :Int            // Private Key
    var h                   :String         // Hash of unencrypted data
}
