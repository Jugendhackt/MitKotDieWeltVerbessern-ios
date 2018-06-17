//
//  MeldenViewController.swift
//  KotFuerDieWelt
//
//  Created by Fynn Kiwitt on 16.06.18.
//  Copyright © 2018 Fynn Kiwitt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MeldenViewController :UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate{
    
    var trashKindSelector :UITableView!
    let trashKinds = ["sharp-edged", "wet", "feces", "rotten", "multiple pieces"]
    let trashPictureView = UIButton(frame: CGRect(x: 5, y: 5, width: 90, height: 90))
    var locationLbl: UILabel = UILabel()
    let locationManager = CLLocationManager()

    var locationComplete: String = "Tap to add a location"
    
    
    var selectedTrashAttributes = [false, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Melden"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let backgroundColor = UIColor(red: (225/255), green: (225/255), blue: (225/255), alpha: 1)
        self.view.backgroundColor = backgroundColor
        trashKindSelector = UITableView(frame: CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 250))
        trashKindSelector.register(UITableViewCell.self, forCellReuseIdentifier: "option")
        trashKindSelector.dataSource = self
        trashKindSelector.delegate = self
        trashKindSelector.isScrollEnabled = false
        trashKindSelector.rowHeight = 45
        trashKindSelector.backgroundColor = .white
        self.view.addSubview(trashKindSelector)
        
        let submitBtn = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitTrash))
        self.navigationItem.rightBarButtonItem = submitBtn
        
        
        
        let overviewView = UIButton(frame: CGRect(x: 0, y: 150, width: self.view.bounds.width, height: 100))
        let headlineLbl = UILabel(frame: CGRect(x: 100, y: 5, width: self.view.bounds.width - 110, height: 30))
        locationLbl = UILabel(frame: CGRect(x: 100, y: 40, width: self.view.bounds.width - 110, height: 30))
        overviewView.backgroundColor = .white
        headlineLbl.text = "New Trash"
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 25)
        locationLbl.text = locationComplete
        trashPictureView.backgroundColor = .darkGray
        trashPictureView.addTarget(self, action: #selector(activateCamera(sender:)) , for: .touchUpInside)
        overviewView.addTarget(self, action: #selector(getPosition(sender:)), for: .touchUpInside)
        overviewView.addSubview(trashPictureView)
        overviewView.addSubview(headlineLbl)
        overviewView.addSubview(locationLbl)
        overviewView.backgroundColor = .white
        self.view.addSubview(overviewView)
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
        
        cell?.backgroundColor = .white
        
        return cell!
    }
    
    //camera
    @objc func activateCamera(sender: UIButton) {

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
    
        
        
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        trashPictureView.setBackgroundImage(image, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func getPosition(sender: UIButton) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
                print (self.displayLocationInfo(pm))
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""

            guard let localityUnwrapped = locality else {return}
            guard let postalCodeUnwrapped = postalCode else {return}
            guard let administrativeAreaUnwrapped = administrativeArea else {return}
            guard let countryUnwrapped = country else {return}
            
            let fullAddress = "\(localityUnwrapped), \(postalCodeUnwrapped), \(administrativeAreaUnwrapped), \(countryUnwrapped)"
            
            locationComplete = fullAddress
            locationLbl.text = locationComplete
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    @objc func submitTrash(){
        let alert = UIAlertController(title: "Thanks", message: "Thank you for submitting!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
