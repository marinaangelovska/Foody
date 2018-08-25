//
//  FoodViewController.swift
//  Foody
//
//  Created by Marina Angelovska on 4/30/18.
//  Copyright © 2018 Marina Angelovska. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications

class FoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let API_URL = "http://food2fork.com/api/search"
    let APP_ID = "f2863766154ac7eb386ec47630a3376a"
    var selected = -1

    @IBOutlet weak var foodTableView: UITableView!
    var foodList = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodTableView.delegate = self
        self.foodTableView.dataSource = self
        
        let params : [String : String] = ["key" : APP_ID]
        DispatchQueue.main.async {
            LoadingOverlay.shared.showOverlay(view: self.view)
            self.getData(url: self.API_URL, parameters: params)
        }
    
    }

    func getData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
                let dataJSON: JSON = JSON(response.result.value!)
                self.updateData(json: dataJSON)
                
            } else {
                print("error \(response.result.error)")
               
            }
        }
    }
    
    func updateData(json: JSON) {
        if let tempResult = json["recipes"].array {
            for item in tempResult {
                if let foodTitle = item["title"].string {
                    let foodOwner = item["publisher"].string
                    let imageURL = item["image_url"].string
                    let urlOwner = item["publisher_url"].string
                    let url = URL(string: imageURL!)
                    let data = try? Data(contentsOf: url!)
                    let image: UIImage = UIImage(data: data!)!
                    foodList.append(Food(title: foodTitle, owner: foodOwner!, image: image, url: urlOwner!))
                }
            }
            self.foodTableView.reloadData()
            LoadingOverlay.shared.hideOverlayView()
        } else {
            print("error getting data")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! CustomFoodTableViewCell
        cell.titleLabel.text = foodList[indexPath.row].title
        cell.chefLabel.text = foodList[indexPath.row].owner
        cell.imgView.image = foodList[indexPath.row].image
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "details", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FoodDetailsViewController
        destination.chef = foodList[selected].owner
        destination.title1 = foodList[selected].title
        destination.img = foodList[selected].image!
        destination.url = foodList[selected].url
    }

}
