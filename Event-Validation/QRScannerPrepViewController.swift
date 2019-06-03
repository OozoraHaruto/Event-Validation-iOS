//
//  ViewController.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 31/5/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class QRScannerPrepViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var btnQRScanner: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        if (!QRCodeReader.isAvailable()){
            lblInstruction.text         = "CAMERA_DISABLED".localized
        }else{
            lblInstruction.text         = "CAMERA_OK".localized
            btnQRScanner.isEnabled      = true
        }
    }
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton          = true
            $0.showSwitchCameraButton   = false
            $0.showCancelButton         = true
            $0.showOverlayView          = true
            $0.rectOfInterest           = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBAction func scanAction(_ sender: AnyObject) {
        readerVC.delegate = self
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        var VC                                                          = UIViewController();
        let data                                                        = textToQRData(objStr: result.value)
        
        reader.stopScanning()
        if (data.e != ""){
            VC                                                          = self.storyboard?.instantiateViewController(withIdentifier: SID_CORRECT_QR) as! QRResultCorrectTableViewController
            (VC as! QRResultCorrectTableViewController).qrData          = data
            (VC as! QRResultCorrectTableViewController).qrSecrets       = getSecrets(data: data)
        }else{
            VC                                                          = self.storyboard?.instantiateViewController(withIdentifier: SID_WRONG_QR) as! QRResultOthersViewController
            (VC as! QRResultOthersViewController).qrData                = result.value
        }
        
        dismiss(animated: true, completion: nil)
        self.present(UINavigationController(rootViewController: VC), animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    //    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
    //        if let cameraName = newCaptureDevice.device.localizedName {
    //            print("Switching capture to: \(cameraName)")
    //        }
    //    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

