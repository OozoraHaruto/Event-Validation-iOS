//
//  QRResultCorrectTableViewController.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 3/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import UIKit

class QRResultCorrectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblEventName     : UILabel!
    @IBOutlet weak var lblEventStatus   : UILabel!
    @IBOutlet weak var tblEventDetails  : UITableView!
    
    var language                        :String                 = NSLocale.current.languageCode!
    var qrData                          :QRData                 = QRData();
    var qrSecrets                       :QRSecrets              = QRSecrets()
    var tableSectionsTitle              :[String]               = []
    var tableData                       :[[String]]             = []
    var dateTypeUsed                    :dateType               = .list
    var datePrintFormat                 :String                 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch language {
        case "ja":
            datePrintFormat                                 = DFT_PRINTING_FORMAT_JA
        case "zh":
            datePrintFormat                                 = DFT_PRINTING_FORMAT_JA
        default:
            datePrintFormat                                 = DFT_PRINTING_FORMAT_DEFAULT
        }
        
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        self.navigationItem.rightBarButtonItem                  = btnDone
        tblEventDetails.dataSource                              = self
        tblEventDetails.delegate                                = self
        self.title                                              = "EVENT_DETAILS".localized
        
        lblEventName.text                                       = decryptData(cipherText: qrData.e, secrets: qrSecrets, primeLength: qrData.l)
        
        let dates                                               = decryptData(cipherText: qrData.d, secrets: qrSecrets, primeLength: qrData.l)
        if(dates != ""){
            var eventHappeningNow       :Bool                   = false
            var tmpData                 :[String]               = []
            if (dates.firstIndex(of: "-") != nil){
                tableSectionsTitle.append("DATE_DURATION".localized)
                dateTypeUsed                                    = .range
                tmpData                                         = dates.components(separatedBy: "-")
                eventHappeningNow                               = Date().isBetween(tmpData[0].toDate(withFormat: DFT_INITIAL_FORMAT), and: tmpData[1].toDate(withFormat: DFT_INITIAL_FORMAT))
            }else{
                tableSectionsTitle.append("DATE_LIST".localized)
                dateTypeUsed                                    = .list
                tmpData                                         = dates.firstIndex(of: ",") != nil ? dates.components(separatedBy: ",") : [dates]
                print(tmpData[0])
                for strDate in tmpData {
                    if (strDate.toDate(withFormat: DFT_INITIAL_FORMAT).toString(withFormat: DFT_PRINTING_FORMAT_DEFAULT) == Date().toString(withFormat: DFT_PRINTING_FORMAT_DEFAULT)){
                        eventHappeningNow                       = true
                        break;
                    }
                }
            }
            tableData.append(tmpData)
            
            if(eventHappeningNow == true){
                lblEventStatus.text                             = "EVENT_HAPPENING_NOW".localized
                lblEventStatus.textColor                        = .green
            }else{
                lblEventStatus.text                             = "EVENT_NOT_HAPPENING_NOW".localized
                lblEventStatus.textColor                        = .red
            }
        }
        if (qrData.w != ""){
            tableSectionsTitle.append("WEBSITE".localized)
            tableData.append([decryptData(cipherText: qrData.w, secrets: qrSecrets, primeLength: qrData.l)])
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSectionsTitle[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell                                                = UITableViewCell();
        let rowData                                             = tableData[indexPath.section][indexPath.row]
        
        if (rowData.range(of: RGX_DATE, options: .regularExpression, range: nil, locale: nil) != nil){
            var lblDate                 :UILabel                = UILabel()
            
            switch dateTypeUsed {
            case .range:
                cell                                        = tblEventDetails.dequeueReusableCell(withIdentifier: RIDLeftDetail, for: indexPath)
                let lblLabel        :UILabel                = cell.viewWithTag(1) as! UILabel
                lblDate                                     = cell.viewWithTag(2) as! UILabel
                
                lblLabel.text                               = (indexPath.row == 0) ? "FROM".localized : "TO".localized
                break;
            case .list:
                cell                                        = tblEventDetails.dequeueReusableCell(withIdentifier: RIDBasic, for: indexPath)
                lblDate                                     = cell.viewWithTag(1) as! UILabel
                
                cell.isUserInteractionEnabled               = true
            }
            
            lblDate.text                                        = rowData.toDate(withFormat: DFT_INITIAL_FORMAT).toString(withFormat: datePrintFormat)
        }else if(tableSectionsTitle[indexPath.section] == "WEBSITE".localized){
            cell                                                = tblEventDetails.dequeueReusableCell(withIdentifier: RIDBasic, for: indexPath)
            let lblWebsite          :UILabel                    = cell.viewWithTag(1) as! UILabel
            
            cell.isUserInteractionEnabled                       = true
            lblWebsite.text                                     = rowData
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var VC                                                  = UIViewController()
        if (tableSectionsTitle[indexPath.section] == "WEBSITE".localized){
            VC                                                  = self.storyboard?.instantiateViewController(withIdentifier: SID_WEBVIEW) as! WebViewController
            (VC as! WebViewController).webURL                   = tableData[indexPath.section][indexPath.row]
        }
        tblEventDetails.deselectRow(at: indexPath, animated: true);
        self.navigationController?.pushViewController(VC, animated: true);
        
    }
    
    
    // MARK: - Button Action
    @objc func dismissViewController(){
        dismiss(animated: true, completion: nil)
    }
    
}
