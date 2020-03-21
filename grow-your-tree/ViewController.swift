//
//  ViewController.swift
//  grow-your-tree
//
//  Created by Tim Hotfilter on 21.03.20.
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit
import CoreLocation


extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var score_label: UILabel!
    
    var network : Network!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D!
    var locationAvailable = 0
    var homeLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var timer = Timer()
    var score : Int = 0
    var internalRanking : [Network.UserItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        score_label.text = "Looking for GPS..."
        
        // Do any additional setup after loading the view, typically from a nib.
        
        network = Network()
        
        self.locationManager = CLLocationManager()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    @IBAction func buttonTest(_ sender: Any) {


    }
    
    @IBAction func rankingButton(_ sender: Any) {
        //self.performSegue(withIdentifier: "rankingViewSegue", sender: self)
    }
    
    func loadSettings() {
        let settings = UserDefaults.standard
        let first_time_use = settings.bool(forKey: "firstUse")
        if (first_time_use == false){
            // store the users settings...
            settings.set(currentLocation.latitude, forKey: "homeLat")
            settings.set(currentLocation.longitude, forKey: "homeLon")
            settings.set(true, forKey: "firstUse")
            homeLocation = currentLocation
        } else {
            let lat = settings.double(forKey: "homeLat")
            let lon = settings.double(forKey: "homeLon")
            homeLocation.latitude = lat
            homeLocation.longitude = lon
        }
    }
    
    @objc func updateDisplay() {
        score_label.text = String(format: "Score: %d", arguments: [score])
        score += 1
        
        self.internalRanking = network.getRanking(places: 5)
    }
    
    func updateLocation() {
        // distance
        let distance = homeLocation.distance(from: currentLocation)
        
        timer.invalidate()
        
        if (abs(distance) < 50) // in meters
        {
            // start the timer
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateDisplay), userInfo: nil, repeats: true)
        }
        
        updateDisplay()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "rankingViewSegue"){
            let rankingView = segue.destination as! RankingView
            rankingView.ranking = self.internalRanking
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentLocation = locValue
        
        if(locationAvailable == 0){
            locationAvailable = 1
            loadSettings()
        } else {
            updateLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}

