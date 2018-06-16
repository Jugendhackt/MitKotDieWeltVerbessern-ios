//
//  HighscoreViewController.swift
//  KotFuerDieWelt
//
//  Created by Pascal Boehler on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let abstandNavigationBar = 40
    let hoeheLabel: CGFloat = 120
    var bestenListeNameArray = ["Test1", "Test2", "Test3", "Test4", "Test5", "Test6", "Test7"]
    var bestenListePunktestandArray = [100, 99, 98, 97, 96, 95, 94]
    
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
        let punktestandLabel = UILabel(frame: CGRect(x: self.view.bounds.width/4, y: (self.navigationController?.navigationBar.bounds.height)! + CGFloat(abstandNavigationBar), width: self.view.bounds.width/2, height: 100))
        punktestandLabel.textAlignment = .center
        
        punktestandLabel.text = "\(punktestand)"
        punktestandLabel.font = punktestandLabel.font.withSize(80)
        self.view.addSubview(punktestandLabel)
        
    }
    
    func bestenListeTableView() {
        let hoeheNavigationBar = (self.navigationController?.navigationBar.bounds.height)!
        
        let bestenListeTableView = UITableView(frame: CGRect(x: 0, y: hoeheNavigationBar + hoeheLabel, width: self.view.bounds.width, height: 500))
        bestenListeTableView.delegate = self
        bestenListeTableView.dataSource = self
        bestenListeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "bestenListe")
        
        self.view.addSubview(bestenListeTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestenListeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bestenListe")
        cell?.textLabel?.text = "\(indexPath.row + 1). \(bestenListeNameArray[indexPath.row]) has \(bestenListePunktestandArray[indexPath.row]) points"
        
        return cell!
    }
}
