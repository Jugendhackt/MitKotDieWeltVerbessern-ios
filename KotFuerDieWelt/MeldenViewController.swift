//
//  MeldenViewController.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit

class MeldenViewController :UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Melden"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = .gray
        
        let trashKindSelector = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 220))
        setupTableView(tableView: trashKindSelector)
    }
    
    
    func setupTableView(tableView: UITableView){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        self.view.addSubview(tableView)
    }
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option")
        cell?.textLabel?.text = "\(indexPath.row + 1)"
        
        return cell!
    }
}
