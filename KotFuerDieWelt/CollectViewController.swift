//
//  SammelnViewController.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import Foundation
import SwiftyJSON

class CollectViewController :UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    private var mapView :MKMapView!
    private var popUpView :UIView!
    private var blurView :UIVisualEffectView!
    private let locationManager = CLLocationManager()
    //private var trashcans :Array<Data> = []
    
    
    func addTrashcan(location: CLLocationCoordinate2D){
        let trashcan = MKPointAnnotation()
        trashcan.coordinate = location
        trashcan.title = "Trashcan"
        
        self.mapView.addAnnotation(trashcan)
        self.mapView.selectAnnotation(trashcan, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Collect"
        super.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        //GPS Authorization
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: true)
        self.mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "loc")

        
        addTrashcan(location: CLLocationCoordinate2D(latitude: 37.77919, longitude: -122.41914))
        
        self.view.addSubview(self.mapView)
        
        let userLocation = self.mapView.userLocation.coordinate
        let message = "50.1043774,8.6758709"
        //let message = "\(userLocation.latitude),\(userLocation.longitude)"
        let address = "https://kfdw.herokuapp.com/trashcans"
        let request = address + "?position=\(message)"
        print(request)
        do{
            var trashcansJSON :Any?
            Alamofire.request(request).responseJSON { response in
                trashcansJSON = response.result.value
                }
            let json = JSON(trashcansJSON ?? "[]")
            let endIndex =  json.count
            for index in 0..<endIndex{
                let latitude = Double(json[index]["latitude"].stringValue)
                let longitude = Double(json[index]["longitude"].stringValue)
                self.addTrashcan(location: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
            }

        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.showsUserLocation = true
        print("position updated")
        print(locations)
    }
    
    func openPopUp(isTrashcan: Bool, location: CLLocationCoordinate2D, attributes:Array<String>){
        popUpView = UIView(frame: CGRect(x: self.view.bounds.width/2 - 150, y: self.view.bounds.height/2 - 100, width: 300, height: 200))
        popUpView.layer.cornerRadius = 20
        popUpView.layer.masksToBounds = true
        popUpView.backgroundColor = UIColor(displayP3Red: (225/255), green: (218/255), blue: (22/255), alpha: 1)
        
        let detailedMapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.popUpView.bounds.width, height: self.popUpView.bounds.height/2))
        
        detailedMapView.isScrollEnabled = false
        detailedMapView.isZoomEnabled = false
        detailedMapView.isRotateEnabled = false
        detailedMapView.isPitchEnabled = false
        
        
        let viewRegion = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.005, 0.005))
        detailedMapView.setRegion(viewRegion, animated: true)
        
        self.popUpView.addSubview(detailedMapView)
        
        let distanceLbl = UILabel(frame: CGRect(x: 5, y: self.popUpView.bounds.height/2 + 2, width: self.popUpView.bounds.width - 30, height: 50))
        distanceLbl.font = UIFont.boldSystemFont(ofSize: 30)
        distanceLbl.text = ""
        if isTrashcan{
            distanceLbl.text! += "Trashcan: "
        }else{
            distanceLbl.text! += "Trash: "
        }
        distanceLbl.text! += "0.8km"
        self.popUpView.addSubview(distanceLbl)
        
        
        var attributesLbl = UILabel(frame: CGRect(x: 10, y: self.popUpView.bounds.height/2 + 45, width: self.popUpView.bounds.height - 20, height: 25))
        attributesLbl.text = ""
        if isTrashcan{
            for attribute in attributes{
                attributesLbl.text! += attribute
                if attribute != attributes.last{
                    attributesLbl.text! += ", "
                }
            }
        }
        attributesLbl.font = UIFont.systemFont(ofSize: 17)
        self.popUpView.addSubview(attributesLbl)
        
        let blur = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        
        self.view.addSubview(blurView)
        self.view.addSubview(popUpView)
    }
    
    
    func closePopUp(){
        popUpView.removeFromSuperview()
        blurView.removeFromSuperview()
    }
    
    
    func selectAnnotation(_ annotation: MKAnnotation, animated: Bool) {
        print ("did select Annotation")
    }
 
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Did select Annotation")
        openPopUp(isTrashcan: true, location: (view.annotation?.coordinate)!, attributes: ["dog friendly"])
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Did select Annotation")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("location updated again")
        self.mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "loc")
        view.canShowCallout = true
        let infoBtn = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = infoBtn
        return view
    }
    
    
}

}
