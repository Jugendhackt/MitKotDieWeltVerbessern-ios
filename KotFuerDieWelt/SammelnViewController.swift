//
//  SammelnViewController.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit
import MapKit

class SammelnViewController :UIViewController{
    private var mapView :MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Sammeln"
        super.navigationController?.navigationBar.prefersLargeTitles = true
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(mapView)
    }
}
