//
//  HighscoreViewController.swift
//  KotFuerDieWelt
//
//  Created by Pascal Boehler on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bestenListeTableView :UITableView!
    let abstandNavigationBar = 40
    let hoeheLabel: CGFloat = 120
    var bestenListeNameArray = ["Test1", "Test2", "Test3", "Test4", "Test5", "Test6", "Test7"]
    var bestenListePunktestandArray = [100, 99, 98, 97, 96, 95, 94]
    var fetchingMore = false
    var items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 10, 11, 12, 13, 14, 15]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        punktestandView()
        punkteInfoLabel()
        punktestandLabel(punktestand: 10)
        bestenListeTableViewFunc()
        
    }
    
    func punktestandView() {
        let view = UIView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! + 20, width: self.view.bounds.width, height: 120))
        view.backgroundColor = UIColor(red: 255/255, green: 218/255, blue: 22/255, alpha: 1.0)
        
        self.view.addSubview(view)
    }
    
    func punkteInfoLabel () {

        let punkteInfoLabel = UILabel(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! + CGFloat(abstandNavigationBar), width: self.view.bounds.width/2, height: 40))
        
        punkteInfoLabel.text = "score:"
        punkteInfoLabel.font = punkteInfoLabel.font.withSize(25)
        punkteInfoLabel.backgroundColor = UIColor(red: 255/255, green: 218/255, blue: 22/255, alpha: 1.0)
        punkteInfoLabel.textAlignment = NSTextAlignment.left
        
        self.view.addSubview(punkteInfoLabel)
        
    }
    
    func punktestandLabel (punktestand: Int){
        let punktestandLabel = UILabel(frame: CGRect(x: self.view.bounds.width/4, y: (self.navigationController?.navigationBar.bounds.height)! + CGFloat(abstandNavigationBar), width: self.view.bounds.width/2, height: 100))
        punktestandLabel.textAlignment = .center
        punktestandLabel.backgroundColor = .clear
        
        punktestandLabel.text = "\(punktestand)"
        punktestandLabel.font = punktestandLabel.font.withSize(80)
        self.view.addSubview(punktestandLabel)
        
    }
    
    func bestenListeTableViewFunc() {
        let hoeheNavigationBar = (self.navigationController?.navigationBar.bounds.height)!
        
        bestenListeTableView = UITableView(frame: CGRect(x: 0, y: hoeheNavigationBar + hoeheLabel + 10, width: self.view.bounds.width, height: 500))
        //bestenListeTableView.backgroundColor = UIColor(red: 255/255, green: 218/255, blue: 22/255, alpha: 0.8)
        bestenListeTableView.delegate = self
        bestenListeTableView.dataSource = self
        bestenListeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "bestenListe")
        
        self.view.addSubview(bestenListeTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bestenListe")
        //cell?.textLabel?.text = "\(indexPath.row + 1). \(bestenListeNameArray[indexPath.row]) has \(bestenListePunktestandArray[indexPath.row]) points"
        cell?.textLabel?.text = "Item #\(items[indexPath.row])"
        
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        print ("offsetY: \(offsetY) | contentHeight \(contentHeight)")
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                print("beginBatchFetch!")
                beginBatchFetch()
            }
        }
    }
    
    
    func beginBatchFetch() {
        fetchingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newItems = (self.items.count...self.items.count + 12).map { index in index }
            self.items.append(contentsOf: newItems)
            self.fetchingMore = false
            self.bestenListeTableView.reloadData()
        }
    }
}
