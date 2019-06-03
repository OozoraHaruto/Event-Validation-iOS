//
//  functions.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 2/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import Foundation
import BigInt

func textToQRData(objStr: String) -> QRData{
    let decoder             = JSONDecoder()
    var data                : QRData            = QRData()
    
    do {
        data                = try decoder.decode(QRData.self, from: objStr.data(using: .utf8)!);
    }catch {
        print("Not app QR")
    }
    
    return data
}

func base64ToNumber(base64: String) -> String{
    let rixits                                  = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/"
    var result              :String             = ""
    
    for rixit in base64 {
        result = "\(result)\(rixits.distance(from: rixits.startIndex, to: rixits.firstIndex(of: rixit)!))"
    }
    
    return result
}


// MARK: For Decryption

func getSecrets(data: QRData) -> QRSecrets{
    var prime               :String
    var generator           :String
    var privateKey          :String
    var startIndex          :String.Index
    
    switch data.l {
        case 10: prime      = secrets.P_10.components(separatedBy: ";")[data.p]; break;
        default: prime      = secrets.P_10.components(separatedBy: ";")[data.p]; break;
    }
    
    startIndex              = prime.firstIndex(of: "[")!
    generator               = String(prime.suffix(from: startIndex))
    generator               = generator.replacingOccurrences(of: "[\\[\\]]", with: "", options: .regularExpression)
    generator               = generator.components(separatedBy: ")")[data.g]
    prime                   = String(prime.prefix(upTo: startIndex))
    
    startIndex              = generator.firstIndex(of: "(")!
    privateKey              = String(generator.suffix(from: startIndex))
    privateKey              = privateKey.replacingOccurrences(of: "(", with: "")
    privateKey              = privateKey.components(separatedBy: ",")[data.k]
    generator               = String(generator.prefix(upTo: startIndex))
    
    return QRSecrets(prime: prime, generator: generator, publicKey: data.y, privateKey: privateKey);
}

func calculateSharedKey(privateKey: BigInt, publicKey: BigInt, prime: BigInt) -> BigInt{
    return (publicKey.power(privateKey, modulus: prime))
}

func decryptData(cipherText: String, secrets: QRSecrets, primeLength: Int) -> String{
    var encryptedParts      :[String]           = cipherText.components(separatedBy: ",");
    var decryptedString     :String             = ""
    let mLength             :Int                = primeLength - 1
    let lastIndex           :Int                = encryptedParts.count - 1
    let lastPartLength      :Int                = Int(String(encryptedParts[lastIndex].suffix(from: encryptedParts[lastIndex].index(encryptedParts[lastIndex].firstIndex(of: ";")!, offsetBy: 1))))!
    encryptedParts[lastIndex]                   = String(encryptedParts[lastIndex].prefix(upTo: encryptedParts[lastIndex].firstIndex(of: ";")!))
    var counter             :Int                = 0
    
    for encryptedPart in encryptedParts {
        var tmp             = base64ToNumber(base64: encryptedPart)
        var tmpNo           = BigInt(tmp)!
        tmpNo               = tmpNo * secrets.s.inverse(secrets.p)!
        tmpNo               = tmpNo % secrets.p
        tmp                 = String(tmpNo)
        
        let stringLength    = (counter == lastIndex ? lastPartLength : mLength)
        
        while(tmp.count < stringLength){
            tmp             = "0\(tmp)"
        }
        decryptedString     = "\(decryptedString)\(tmp)"
        counter            += 1
    }
    
    return decodeText(data: decryptedString)
}

func decodeText(data: String) -> String{ //decimal -> Hex -> ASCII
    var str                 :String             = ""
    var i                   :Int                = 0
    
    while(i < data.count){
        let text            = "\(String(format:"%x", Int("\(data[(i)])\(data[(i+1)])")!))\(String(format:"%x", Int("\(data[(i+2)])\(data[(i+3)])")!))"
        str                 = "\(str)\(Character(UnicodeScalar(UInt32(text, radix: 16)!)!))"
        i                  += 4
    }
    str = str.removingPercentEncoding!
    
    return str;
}
