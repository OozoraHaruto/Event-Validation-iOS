//
//  WebViewController.swift
//  Event-Validation
//
//  Created by Malcolm Chew on 6/6/19.
//  Copyright © 2019 太陽のアプリ. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView                     :WKWebView!
    var webURL                      :String                 = ""
    
    var flexibleSpace               :UIBarButtonItem        = UIBarButtonItem()
    var btnGoBack                   :UIBarButtonItem        = UIBarButtonItem()
    var btnGoForward                :UIBarButtonItem        = UIBarButtonItem()
    var btnRefresh                  :UIBarButtonItem        = UIBarButtonItem()
    var btnStopLoading              :UIBarButtonItem        = UIBarButtonItem()
    var btnShare                    :UIBarButtonItem        = UIBarButtonItem()
    
    override func loadView() {
        let webConfiguration                                = WKWebViewConfiguration()
        webView                                             = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate                                  = self
        view                                                = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate                          = self
        webView.load(URLRequest(url: URL(string: webURL)!))
        flexibleSpace                                       = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        btnGoBack                                           = UIBarButtonItem(title: "〈", style: .plain, target: webView, action: #selector(webView.goBack))
        btnGoForward                                        = UIBarButtonItem(title: "〉", style: .plain, target: webView, action: #selector(webView.goForward))
        btnRefresh                                          = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        btnStopLoading                                      = UIBarButtonItem(barButtonSystemItem: .stop, target: webView, action: #selector(webView.stopLoading))
        btnShare                                            = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.displayShareSheet))
        
        refreshUI()
        navigationController?.isToolbarHidden = false
    }
    
    //MARK : WKNavigationDelete Methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        refreshUI()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        refreshUI()
    }
    
    //MARK: Other Functions
    
    func refreshUI(){
        self.title                                          = webView.title
        
        btnGoBack.isEnabled                                 = webView.canGoBack
        btnGoForward.isEnabled                              = webView.canGoForward
        
        toolbarItems = [btnGoBack, flexibleSpace, btnGoForward, flexibleSpace, (webView.isLoading ? btnStopLoading : btnRefresh), flexibleSpace, btnShare];
    }
    
    @objc func displayShareSheet(){
        let activityViewController                          = UIActivityViewController(activityItems: [webView.url!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

}
