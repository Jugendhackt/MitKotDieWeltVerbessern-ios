//
//  HighscoreViewController.swift
//  KotFuerDieWelt
//
//  Created by Pascal Boehler on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        punkteInfoLabel()
        punktestandLabel(punktestand: 10)
        
    }
    
    func punkteInfoLabel () {
        let punkteInfoLabel = UILabel(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! + 20, width: self.view.bounds.width, height: 40))
        
        punkteInfoLabel.text = "aktueller Punktestand:"
        punkteInfoLabel.font = punkteInfoLabel.font.withSize(30)
        punkteInfoLabel.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(punkteInfoLabel)
        
    }
    
    func punktestandLabel (punktestand: Int){
        let punktestandLabel = UILabel(frame: CGRect(x: self.view.bounds.minX, y: (self.navigationController?.navigationBar.bounds.height)! + 60 + 8, width: self.view.bounds.width, height: 100))
        
        punktestandLabel.text = "\(punktestand)"
        punktestandLabel.font = punktestandLabel.font.withSize(60)
        punktestandLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(punktestandLabel)
        
    }
}
