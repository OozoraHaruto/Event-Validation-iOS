//
//  functions.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 2/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import Foundation

func textToJson(objStr: String) -> QRData{
    let decoder         = JSONDecoder()
    let data            = try! decoder.decode(QRData.self, from: objStr.data(using: .utf8)!);
    print(data.e);
    return data
}
