//
//  TSActivityIndicator.swift
// DailyHeadlinesApp
//

import UIKit

class TSActivityIndicator: UIActivityIndicatorView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Add Custom activity indicator
    func setupTSActivityIndicator(_ container: UIView) {
        let window = UIApplication.shared.keyWindow
        container.frame = UIScreen.main.bounds
        container.backgroundColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.1)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = container.center
        loadingView.backgroundColor = .black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 5
        
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.hidesWhenStopped = true
        self.style = UIActivityIndicatorView.Style.whiteLarge
        self.color = .white
        self.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(self)
        container.addSubview(loadingView)
        window?.addSubview(container)
        self.startAnimating()
    }
}
