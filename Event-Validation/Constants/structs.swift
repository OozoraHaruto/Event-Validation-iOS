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
    var e                   :String                 = ""                    // eventName
    var d                   :String                 = ""                    // date
    var w                   :String                 = ""                    // website
    var v                   :Double                 = 0.0                   // QR version
    var l                   :Int                    = 0                     // Prime number length
    var g                   :Int                    = 0                     // Generator Index
    var p                   :Int                    = 0                     // Prime Number Index
    var y                   :String                 = ""                    // Public Key
    var k                   :Int                    = 0                     // Private Key
    var h                   :String                 = ""                    // Hash of unencrypted data
    
    init(){}
    init(name: String, date: String, website: String, version: Double, primeLength: Int, generator: Int, primeIndex: Int, publicKey: String, privateIndex: Int, hash: String){
        e                   = name
        d                   = date
        w                   = website
        v                   = version
        l                   = primeIndex
        g                   = generator
        p                   = primeIndex
        y                   = publicKey
        k                   = privateIndex
        h                   = hash
    }
}

struct QRSecrets{
    var p                   :BigInt                 = BigInt(1)             // Prime
    var g                   :BigInt                 = BigInt(1)             // Generator
    var y                   :BigInt                 = BigInt(1)             // Public Key
    var k                   :BigInt                 = BigInt(1)             // Private Key
    var s                   :BigInt                 = BigInt(1)             // Shared Key
    
    init(){}
    init(prime: String, generator: String, publicKey: String, privateKey: String){
        p                   = BigInt(prime)!
        g                   = BigInt(generator)!
        y                   = BigInt(publicKey)!
        k                   = BigInt(privateKey)!
        s                   = calculateSharedKey(privateKey: k, publicKey: y, prime: p)
    }
    
}
