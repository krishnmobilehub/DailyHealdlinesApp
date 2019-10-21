//
//  MySafariViewController.swift
//  DailyNews
//

import UIKit
import SafariServices

class MySafariViewController: SFSafariViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.preferredControlTintColor = .black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
}
