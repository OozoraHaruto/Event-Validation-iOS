//
//  constants.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 3/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import Foundation

//MARK: Regex
let RGX_WEBSITE                                                         = #"^(http:/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$"#
let RGX_DATE                                                            = #"^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$"#


//MARK: TableViewCell Default
let RIDBasic                                                            = "BasicCell"
let RIDLeftDetail                                                       = "LeftDetailCell"


// MARK: StoryboardID's
let SID_CORRECT_QR                                                      = "correctQRVC"
let SID_WRONG_QR                                                        = "wrongQRVC"


// MARK: QRResultCorrectViewController
enum dateType{
    case range, list
}
let DFT_INITIAL_FORMAT                                                  = "dd/MM/yyyy"
let DFT_PRINTING_FORMAT_DEFAULT                                         = "EEEE, dd MMMM yyyy"
let DFT_PRINTING_FORMAT_JA                                              = "EEEE, MM月dd日yyyy年"
