//
//  ViewController.swift
//  HWProject2
//
//  Created by Thuta on 4/22/21.
//

import Foundation
import UIKit
import SafariServices

class ViewController: UIViewController {
    

    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeLocation: UILabel!
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let p = place {
            placeName.text = p.name
            placeImage.image = UIImage(named: p.image)
            placeLocation.text = p.location
            
            let toCheckLength = p.name.split(separator: " ")
            var i = 0
            var maxLength = 0
            while (i < toCheckLength.count) {
                if (toCheckLength[i].count > maxLength) {
                    maxLength = toCheckLength[i].count
                }
                i += 1
            }
            if (maxLength > 8) {
                placeName.font = UIFont.boldSystemFont(ofSize: CGFloat(60))
            }
            let favoritesArray: [String] = userDefaults.stringArray(forKey: "favorites") ?? []
            if (favoritesArray.contains(p.name)) {
                heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            heartButton.image(for: .normal)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 140))
        }
        
    }
    
    @IBAction func openLink(_ sender: Any) {
        if let p = place {
            if let link = URL(string: p.url) {
                let safariVC = SFSafariViewController(url: link)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        var favoritesArray: [String] = userDefaults.stringArray(forKey: "favorites") ?? []
        var favoriteStatus = ""
        let alert = UIAlertController(title: "", message: favoriteStatus, preferredStyle: .alert)
        if let p = place {
            if (!favoritesArray.contains(p.name)) {
                favoritesArray.append(p.name)
                userDefaults.set(favoritesArray, forKey: "favorites")
                heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteStatus = "Added to Favorites"
                let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAlert)
            } else {
                favoritesArray = favoritesArray.filter{$0 != p.name}
//                var newFavorites = [String]()
//                var i = 0
//                while (i < favoritesArray.count) {
//                    if (favoritesArray[i] != p.name) {
//                        newFavorites.append(favoritesArray[i])
//                    }
//                    i += 1
//                }
                favoriteStatus = "Remove from Favorites?"
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
                    userDefaults.set(favoritesArray, forKey: "favorites")
                    self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    self.dismiss(animated: true, completion: nil)
                })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)
            }
            alert.message = favoriteStatus
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

}

