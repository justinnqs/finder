//
//  RestaurantActivityViewController.swift
//  Finder
//
//  Created by Justin Sian on 06/12/2018.
//  Copyright © 2018 Justin Sian. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class RestaurantViewController: UIViewController {
    var searchUrl: String = ""
    var nameArray: [String] = []
    var distanceArray: [Double] = []
    var imageArray: [String] = []
    var priceArray: [String] = []
    var ratingArray: [Int] = []
    var idArray: [Int] = []
    var currIndex: Int = 0
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize arrays with completion closure
        initializeArrays() { json in
            self.nameArray = json["businesses"].arrayValue.map({$0["name"].stringValue})
            self.distanceArray = json["businesses"].arrayValue.map({$0["distance"].doubleValue})
            self.imageArray = json["businesses"].arrayValue.map({$0["image_url"].stringValue})
            self.priceArray = json["businesses"].arrayValue.map({$0["price"].stringValue})
            self.ratingArray = json["businesses"].arrayValue.map({$0["rating"].intValue})
        }
        priceLabel.text = ""
        starLabel.text = ""
        distanceLabel.text = ""
    }
    
    func nextSuggestion() {
        // go to the next restaurant in the returned array
        currIndex += 1
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        // add restaurant to liked array in the singelton
        LikedRestaurants.likedRestaurants.restaurants.append(nameArray[currIndex])
        LikedRestaurants.likedRestaurants.saveToDatabase()
        nextSuggestion()
        updateView() // update view to show the next restaurant
        
        // notify the table view controller that it needs to update its information
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @IBAction func dislikePressed(_ sender: UIButton) {
        nextSuggestion()
        updateView()
    }
    
    func updateView() {
        // check if api call returned any results
        if(imageArray.count > 0) {
            let url = URL(string: imageArray[currIndex])
            restaurantImage.kf.setImage(with: url)
            priceLabel.text = "Price:\(priceArray[currIndex])"
            starLabel.text = "\(ratingArray[currIndex]) Stars"
            distanceLabel.text = "Distance: \(round(distanceArray[currIndex]/1609.32)) mi"
        } else {
            priceLabel.text = "No Results Found"
            starLabel.text = ""
            distanceLabel.text = ""
            return
        }
    }
    
    func initializeArrays(completion: @escaping (_ json: JSON)->Void) {
        // Create URL object
        guard let myUrl = URL(string: searchUrl) else
            { return }

        // Create request
        let request = NSMutableURLRequest(url: myUrl)

        // Set request HTTP type
        request.httpMethod = "GET"

        // Add Yelp API token for authorization
        request.addValue("Bearer kVYdmtqozeNjgT3oQzfk-yIxjuRknntJhsn_wOdww_woao0njxYO8JXGreLvH-GJWEWT6pMm9cTGDz191K3foaLiAKWQdO2tsYZJXJnKUMNjT-tXYy3SSJSrRbYIXHYx", forHTTPHeaderField: "Authorization")

        // Execute HTTP Request
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in

            if(error != nil) {
                print("Error: \(String(describing: error))")
                return
            }

            guard let data = data else
                { return }
            
            do {
                // parse json
                let json = try JSON(data: data)
                // perform completion block on the main thread
                DispatchQueue.main.async {
                    completion(json)
                    self.updateView()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
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
