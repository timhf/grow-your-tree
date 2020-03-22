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

    @IBOutlet weak var navigationbar: UINavigationItem!
    @IBOutlet weak var score_label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var network : Network!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D!
    var locationAvailable = 0
    var homeLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var timer = Timer()
    var score : Int = 0
    var internalRanking : [Network.UserItem] = []
    
    var currentUserName = "Tim"
    var delayCounter = 0
    var scoreFeteched = false
    var userReady = false
    var createUser = false
    

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
        
        let settings = UserDefaults.standard
        //settings.removeObject(forKey: "username")
        let username = settings.string(forKey: "username") ?? nil
        if(username == nil){
            let alert = UIAlertController(title: "Pick a name", message: "Enter your username", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0]
                print("Text field: \(String(describing: textField.text))")
                self.currentUserName = textField.text!
                self.userReady = true
                self.createUser = true
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            self.userReady = true
            self.currentUserName = username!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func buttonTest(_ sender: Any) {
        // 
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
            //self.currentUserName = settings.string(forKey: "username") ?? "not found"
        }
        if (self.createUser){
            let user = Network.UserItem(score: 0, username: currentUserName, location: [currentLocation.latitude, currentLocation.longitude])
            self.network.insertUser(user: user)
            settings.set(currentUserName, forKey: "username")
        }
        self.network.refresh()
    }
    
    @objc func updateDisplay() {
        if (network.dataReady){
            if(!scoreFeteched){
                score = network.findScore(userName: currentUserName)
                scoreFeteched = true
            }
            
            let lvl = Level(score: score)
            
            score_label.text = String(format: "Score: %d (%d)", score, lvl.level)
            self.imageView.image = lvl.treeImage
            score += 1
            
            delayCounter += 1
        } else {
            score_label.text = "Looking for network..."
        }
        
        if (delayCounter > 50){
            network.updateScore(userName: currentUserName, score: score)
            self.network.refresh()
            delayCounter = 0
        }
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
            self.network.refresh()
            self.internalRanking = network.getRanking(places: 5)
            // fixme perform update
            let rankingView = segue.destination as! RankingView
            rankingView.ranking = self.internalRanking
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentLocation = locValue
        
        if(userReady){
            if(locationAvailable == 0){
                locationAvailable = 1
                loadSettings()
            } else {
                updateLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}

