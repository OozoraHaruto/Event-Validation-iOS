//
//  structs.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 2/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import Foundation
import BigInt


struct QRData: Codable{
    var e                   :String         // eventName
    var d                   :String         // date
    var w                   :String         // website
    var v                   :Double         // QR version
    var l                   :Int            // Prime number length
    var g                   :Int            // Generator Index
    var p                   :Int            // Prime Number Index
    var y                   :String         // Public Key
    var k                   :Int            // Private Key
    var h                   :String         // Hash of unencrypted data
}

struct QRSecrets{
    var p                   :BigInt         // Prime
    var g                   :BigInt         // Generator
    var y                   :BigInt         // Public Key
    var k                   :BigInt         // Private Key
    var s                   :BigInt         // Shared Key
    
    init(prime: String, generator: String, publicKey: String, privateKey: String){
        p                   = BigInt(prime)!
        g                   = BigInt(generator)!
        y                   = BigInt(publicKey)!
        k                   = BigInt(privateKey)!
        s                   = calculateSharedKey(privateKey: k, publicKey: y, prime: p)
    }
}
