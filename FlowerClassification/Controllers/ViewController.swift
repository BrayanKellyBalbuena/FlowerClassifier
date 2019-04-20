//
//  ViewController.swift
//  FlowerClassification
//
//  Created by Brayan Kelly Balbuena on 4/12/19.
//  Copyright © 2019 Brayan Kelly Balbuena. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

public class ViewController: UIViewController , UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var extractText: UITextView!
    var flowerName = "Bubble D"
    
    var wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    let imagePicker = UIImagePickerController()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    
    @IBAction func tapCameraButton(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    
    func getFlawerIntro(named flawerName: String) {
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flawerName,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize": "500"
        ]
        
        AF.request(wikipediaURl, parameters: parameters).validate().responseJSON { response in
    
            switch response.result {
                case .success:
                    let data =  response.data
                    let json = try! JSON(data: data!)
                    print(json)
                    let pageId = json["query"]["pageids"][0].intValue
                    let extract = json["query"]["pages"]["\(pageId)"]["extract"].stringValue
                    let flowerImageUrl = json["query"]["pages"]["\(pageId)"]["thumbnail"]["source"].stringValue
                    
                    self.imageView.sd_setImage(with: URL(string: flowerImageUrl))
                   self.extractText.text = extract
                   print(extract)
                
                case .failure(let error):
                print(error)
            }
        }
    }
    

}


