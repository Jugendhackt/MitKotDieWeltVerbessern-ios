//
//  MeldenViewController.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit

class MeldenViewController :UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var trashKindSelector :UITableView!
    let trashKinds = ["sharp-edged", "wet", "feces", "rotten", "multiple pieces"]
    
    var selectedTrashAttributes = [false, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Melden"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let backgroundColor = UIColor(red: (225/255), green: (225/255), blue: (225/255), alpha: 1)
        self.view.backgroundColor = backgroundColor
        trashKindSelector = UITableView(frame: CGRect(x: 0, y: 250, width: self.view.bounds.width, height: 250))
        trashKindSelector.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        trashKindSelector.dataSource = self
        trashKindSelector.delegate = self
        trashKindSelector.isScrollEnabled = false
        trashKindSelector.rowHeight = 35
        self.view.addSubview(trashKindSelector)
        
        let submitBtn = UIBarButtonItem(title: "Submit", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = submitBtn
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustTableViewSize(tableView: self.trashKindSelector)
    }
    
    
    func adjustTableViewSize(tableView: UITableView){
        var newFrame = tableView.frame
        newFrame.size.height = tableView.contentSize.height
        tableView.frame = newFrame
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType != .checkmark{
            cell?.accessoryType = .checkmark
            self.selectedTrashAttributes[indexPath.row] = true
        }else{
            cell?.accessoryType = .none
            self.selectedTrashAttributes[indexPath.row] = false
        }
        cell?.isSelected = false
    }
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option")
        
        if tableView == trashKindSelector{
            cell?.textLabel?.text = trashKinds[indexPath.row]
        }
        

        
        return cell!
    }
}
