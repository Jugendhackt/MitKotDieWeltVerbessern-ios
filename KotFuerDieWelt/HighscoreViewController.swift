//
//  HighscoreViewController.swift
//  KotFuerDieWelt
//
//  Created by Pascal Boehler on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController {
    
    let abstandNavigationBar = 40
    let hoeheLabel: CGFloat = 120
    var bestenListeDict = ["Test1": 100, "Test2": 99, "Test3": 98, "Test4": 97, "Test5": 96, "Test6": 95, "Test7": 94]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        punkteInfoLabel()
        punktestandLabel(punktestand: 10)
        bestenListeTableView()
        
    }
    
    func punkteInfoLabel () {

        let punkteInfoLabel = UILabel(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! + CGFloat(abstandNavigationBar), width: self.view.bounds.width/2, height: 40))
        
        punkteInfoLabel.text = "score:"
        punkteInfoLabel.font = punkteInfoLabel.font.withSize(25)
        punkteInfoLabel.textAlignment = NSTextAlignment.left
        
        self.view.addSubview(punkteInfoLabel)
        
    }
    
    func punktestandLabel (punktestand: Int){
        let punktestandLabel = UILabel(frame: CGRect(x: self.view.bounds.maxX/2, y: (self.navigationController?.navigationBar.bounds.height)! + CGFloat(abstandNavigationBar), width: self.view.bounds.width/2, height: 100))
        
        punktestandLabel.text = "\(punktestand)"
        punktestandLabel.font = punktestandLabel.font.withSize(80)
        punktestandLabel.textAlignment = NSTextAlignment.left
        self.view.addSubview(punktestandLabel)
        
    }
    
    func bestenListeTableView() {
        let hoeheNavigationBar = (self.navigationController?.navigationBar.bounds.height)!
        
        let bestenListeTableView = UITableView(frame: CGRect(x: 0, y: hoeheNavigationBar + hoeheLabel, width: self.view.bounds.width, height: 500))
        
        self.view.addSubview(bestenListeTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestenListeDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option")
        cell?.textLabel?.text = "\(indexPath.row + 1)"
        
        return cell!
    }
}
