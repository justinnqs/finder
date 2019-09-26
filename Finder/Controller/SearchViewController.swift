//
//  SearchViewController.swift
//  Finder
//
//  Created by Justin Sian on 04/12/2018.
//  Copyright © 2018 Justin Sian. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var price: Int = 1
    var distance: Int = 0
    var urlWithParams: String = ""
    
    @IBOutlet weak var cuisineTF: UITextField!
    @IBOutlet weak var priceSeg: UISegmentedControl!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceIndicator: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCurrLocation() // get users location
        distanceIndicator.text = "\(round(distanceSlider.value/1609.34)) mi" // initialize slider texts
        enableSearchButton(enabled: false) // init search button to false
        // Do any additional setup after loading the view.
    }
    
    // check if user is typing
    @IBAction func searchFieldChanged(_ sender: UITextField) {
        if(searchTF.text != "") {
             // enable search to true only if text field is not empty
            enableSearchButton(enabled: true)
        } else {
            // disable search button if text field is empty
            enableSearchButton(enabled: false)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        Helper.helper.logOut()
    }
    
    // update UILabel when slider changes value
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        distanceIndicator.text = "\(round(distanceSlider.value/1609.34)) mi" // convert from meters to miles
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        let requestUrl = "https://api.yelp.com/v3/businesses/search"
        let cuisine = cuisineTF.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let price = priceSeg.selectedSegmentIndex+1
        let distance = Int(distanceSlider.value)
        
        // Set up parameters with user input
        urlWithParams = requestUrl + "?term=\(cuisine ?? "")&latitude=\(latitude)&longitude=\(longitude)&radius=\(distance)&limit=\(50)&price=\(price)"
        
        performSegue(withIdentifier: "RestaurantSegue", sender: self)
    }
    
    // setup for CLLocation
    func determineCurrLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // ask user for permission
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            // start retrieving users location
            locationManager.startUpdatingLocation()
        }
    }
    
    // set users location to variables
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currLocation:CLLocation = locations[locations.count - 1]
        longitude = currLocation.coordinate.longitude
        latitude = currLocation.coordinate.latitude
    }

    func enableSearchButton(enabled: Bool) {
        if enabled {
            searchButton.alpha = 1.0
            searchButton.isEnabled = true
        } else {
            searchButton.alpha = 0.5
            searchButton.isEnabled = false
        }
    }
    
    // send information to restaurant view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is RestaurantViewController) {
            let vc = segue.destination as? RestaurantViewController
            vc?.searchUrl = urlWithParams // set searchUrl parametr in view controller
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
