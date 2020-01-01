//
//  MapViewCont.swift
//  QChat
//
//  Created by ÇağkanTaştekin on 2019. 12. 08..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

// Storyboard ID & Restoration ID --> MapVC

import UIKit
import MapKit

class MapViewCont: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        setupUI()
        createRightButton()
    }
    
    // MARK: SetupIU
    func setupUI() {
        var region = MKCoordinateRegion()
        region.center.latitude = location.coordinate.latitude
        region.center.longitude = location.coordinate.longitude
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    // MARK: Open In Maps
    func createRightButton() {
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Open In Maps", style: .plain, target: self, action: #selector(self.openInMap))]
    }
    
    @objc func openInMap() {
        let regionDestination: CLLocationDistance = 10000
        let coordinates = location.coordinate
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDestination, longitudinalMeters: regionDestination)
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        
        let placeMark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = "User's location"
        mapItem.openInMaps(launchOptions: options)
    }
}
