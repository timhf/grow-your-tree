//
//  RankingView.swift
//  grow-your-tree
//
//  Created by Tim Hotfilter on 21.03.20.
//  Copyright © 2020 Test. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class RankingView : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var table: UITableView!
    
    var network : Network!
    var ranking : [Network.UserItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        //loadData()
        populateTable()
        populateMap()
    }
    
   /* func loadData(){
        network = Network()
        
        ranking = network.getRanking(places: 5)
    } */
    
    func populateTable(){
        self.table.reloadData()
    }
    
    func populateMap(){
        for user in ranking{
            let coord = CLLocationCoordinate2D(latitude: user.location[0], longitude: user.location[1])
            let annotation = MKPointAnnotation()
            annotation.title = user.username
            annotation.coordinate = coord
            mapview.addAnnotation(annotation)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath)
        
        cell.textLabel?.text = "\((indexPath.row + 1)). \(ranking[indexPath.row].username)"
        cell.detailTextLabel?.text = String(ranking[indexPath.row].score)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coord = CLLocationCoordinate2D(latitude: ranking[indexPath.row].location[0], longitude: ranking[indexPath.row].location[1])
        let region = MKCoordinateRegion( center: coord, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)

        self.mapview.setRegion(region, animated: true)
        
    }
}
