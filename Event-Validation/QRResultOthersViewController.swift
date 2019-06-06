//
//  QRResultOthersViewController.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 3/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import UIKit

class QRResultOthersViewController: UIViewController {
    @IBOutlet weak var txtQrDetails: UITextView!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var lblSnideComment: UILabel!
    
    var qrData                  :String                         = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(qrData)
        
        var snideComment        :String                         = ""
        let btnDone                                             = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        self.navigationItem.rightBarButtonItem                  = btnDone
        
        if(qrData.firstIndex(of: ":") != nil){
            switch String(qrData.prefix(upTo: qrData.firstIndex(of: ":")!)).lowercased() {
            case "http":
                snideComment                                    = "\("SNIDE_COMMENT_WEBSITE".localized)\n\("SUPPORTED".localized)"
            case "https":
                snideComment                                    = "\("SNIDE_COMMENT_WEBSITE".localized)\n\("SUPPORTED".localized)"
            case "mailto":
                snideComment                                    = "\("SNIDE_COMMENT_EMAIL".localized)\n\("SUPPORTED".localized)"
            case "smsto":
                snideComment                                    = "\("SNIDE_COMMENT_SMS".localized)\n\("PARTIAL_SUPPORT".localized)"
            case "tel":
                snideComment                                    = "\("SNIDE_COMMENT_PHONE".localized)\n\("SUPPORTED".localized)"
            case "wifi":
                snideComment                                    = "\("SNIDE_COMMENT_WIFI".localized)\n\("NOT_SUPPORTED".localized)"
            case "mecard":
                snideComment                                    = "\("SNIDE_COMMENT_MECARD".localized)\n\("PARTIAL_SUPPORT".localized)"
            case "bitcoin":
                snideComment                                    = "\("SNIDE_COMMENT_BITCOIN".localized)\n\("NOT_SUPPORTED".localized)"
            case "begin":
                switch String(qrData.prefix(upTo: qrData.firstIndex(of: "\n")!)).lowercased() {
                case "begin:vcard":
                    snideComment                                = "\("SNIDE_COMMENT_VCARD".localized)\n\("PARTIAL_SUPPORT".localized)"
                case "begin:vevent":
                    snideComment                                = "\("SNIDE_COMMENT_VEVENT".localized)\n\("NOT_SUPPORTED".localized)"
                default:
                    snideComment                                = "\("SNIDE_COMMENT_DUNNO".localized)"
                }
            default:
                snideComment                                    = "\("SNIDE_COMMENT_DUNNO".localized)"
            }
        }else if(qrData.range(of: RGX_WEBSITE, options: .regularExpression, range: nil, locale: nil) != nil){
            snideComment                                        = "\("SNIDE_COMMENT_WEBSITE".localized)\n\("SUPPORTED".localized)"
        }else{
            snideComment                                        = "\("SNIDE_COMMENT_DUNNO".localized)"
        }
        
        lblWarning.text                                         = "OPENING".localized
        lblSnideComment.text                                    = snideComment
        txtQrDetails.text                                       = qrData
    }

    // MARK: - Button Action
    @objc func dismissViewController(){
        dismiss(animated: true, completion: nil)
    }
}
