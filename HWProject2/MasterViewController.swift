//
//  MasterViewController.swift
//  HWProject2
//
//  Created by Thuta on 4/22/21.
//

import Foundation
import UIKit

var flags = ["France" : "\u{1F1EB}\u{1F1F7}","Japan" : "\u{1F1EF}\u{1F1F5}", "Switzerland": "\u{1F1E8}\u{1F1ED}"]

class MasterViewController : UITableViewController {
    
    var countriesArray = [Country]()
    var currentCountry: Country?
    var darkModeStatus = false
    var currentDarkModeStyle = UIScreen.main.traitCollection.userInterfaceStyle.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUrls()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCountry = countriesArray[indexPath.row]
        if (indexPath.section == 0) {
            performSegue(withIdentifier: "showFavorites", sender: nil)
        } else {
            performSegue(withIdentifier: "showPlacesGallery", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showPlacesGallery") {
            if let controller = segue.destination as? CollectionViewController {
                controller.places = currentCountry!.places
                controller.countryName.title = currentCountry!.name
            }
        } else if (segue.identifier == "showFavorites") {
            if let controller = segue.destination as? FavoritesCollectionViewController {
                var favorites = [Place]()
                let favoritesArray: [String] = userDefaults.stringArray(forKey: "favorites") ?? []
                
                var i = 0
                while (i < countriesArray.count) {
                    var j = 0
                    while (j < countriesArray[i].places.count) {
                        let place = countriesArray[i].places[j]
                        if (favoritesArray.contains(place.name)) {
                            favorites.append(place)
                        }
                        j += 1
                    }
                    i += 1
                }
                controller.places = favorites
            }
        }
        
    }
                   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch (section) {
            case 0:
                rows = 1
            case 1:
                rows = countriesArray.count
            default:
                break
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch (indexPath.section) {
            case 0:
                cell.textLabel?.text = "View Favorites"
                cell.imageView?.image = UIImage(systemName: "heart.fill")
                cell.detailTextLabel?.text = ""
                cell.imageView?.tintColor = .systemPink
            case 1:
                let countryName = countriesArray[indexPath.row]
                
                let tableCellTitle = UIFont(name: "Arial", size: 30)
                cell.textLabel?.text = countryName.name
                cell.textLabel?.font = tableCellTitle
                let tableCellSubtitle = UIFont(name: "Arial", size: 16)
                cell.detailTextLabel?.text = countryName.continent
                cell.detailTextLabel?.font = tableCellSubtitle
                cell.detailTextLabel?.textColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1)
            default:
                break
        }
        
        
        
        return cell
    }
    
    func populateUrls() {
        let api = "https://raw.githubusercontent.com/thutawunna/CountriesProject/main/HWProject2/countries.json"
        
        let url = URL(string: api)
        let jsonData = try? Data(contentsOf: url!)
        if (jsonData != nil) {
            let dictionary = (try! JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)) as! NSDictionary
            let urlsDictionary = dictionary["countries"]! as! [[String:String]]
            for i in 0...urlsDictionary.count - 1 {
                let country = urlsDictionary[i]
                populateCountries(api: country["url"]!, name: country["name"]!)
                
            }
        }
    }
    
    func populateCountries(api: String, name: String) {
        let url = URL(string: api)!

        let jsonData = try? Data(contentsOf: url)

        if (jsonData != nil) {
            let dictionary = (try!JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)) as! NSDictionary

            let placeDict = dictionary["places"]! as! [[String:String]]
            let country = Country()
            var placesArray = [Place]()
            country.name = "\(flags[name] ?? "") "
            country.name += dictionary["name"]! as! String
            country.continent = dictionary["continent"]! as! String

            for index in 0...placeDict.count - 1 {
                let singlePlace = placeDict[index]
                let place = Place()
                place.name = singlePlace["name"]!
                place.location = singlePlace["location"]!
                place.image = singlePlace["image"]!
                place.url = singlePlace["url"]!
                place.address = singlePlace["address"]!
                placesArray.append(place)
            }
            country.places = placesArray
            countriesArray.append(country)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if darkModeStatus {
            return .lightContent
        } else {
            return .darkContent
        }
    }
}
