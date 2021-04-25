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
        
//        if (currentDarkModeStyle == 1) {
//            darkModeStatus = true
//            setNeedsStatusBarAppearanceUpdate()
//            self.overrideUserInterfaceStyle = .dark
//        }
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
                controller.countriesArray = countriesArray
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
//            print(dictionary)
            let urlsDictionary = dictionary["countries"]! as! [[String:String]]
            print(urlsDictionary)
            for i in 0...urlsDictionary.count - 1 {
                let country = urlsDictionary[i]
                populateCountries(api: country["url"]!, name: country["name"]!)
                
            }
        }
    }
    
    func populateCountries(api: String, name: String) {
        print(name)
        let url = URL(string: api)!

        let jsonData = try? Data(contentsOf: url)

        if (jsonData != nil) {
            let dictionary = (try!JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)) as! NSDictionary
//            print(dictionary)

            let placeDict = dictionary["places"]! as! [[String:String]]
//            print(placeDict)
            let country = Country()
            var placesArray = [Place]()
            country.name = "\(flags[name] ?? "") "
            country.name += dictionary["name"]! as! String
            country.continent = dictionary["continent"]! as! String
//            country.name = "\u{1F1EB}\u{1F1F7}"

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
        
//        let country1 = Country()
//        country1.name = "France"
//        country1.continent = "Europe"
//
//        var places1 = [Place]()
//        let place1 = Place()
//        place1.name = "Eiffel Tower"
//        place1.image = "eiffel.jpg"
//        place1.location = "Paris"
//        place1.url = "http://www.google.com"
//        places1.append(place1)
//
//        let place2 = Place()
//        place2.name = "Louvre Museum"
//        place2.image = "louvre.jpg"
//        place2.location = "Paris"
//        place2.url = "http://www.google.com"
//        places1.append(place2)
//
//        country1.places = places1
//        countriesArray.append(country1)
//
//        let japan = Country()
//        japan.name = "Japan"
//        japan.continent = "Asia"
//
//        var japanPlaces = [Place]()
//        let japanPlace1 = Place()
//        japanPlace1.name = "Mount Fuji"
//        japanPlace1.image = "fuji.jpg"
//        japanPlace1.location = "Fujinomiya"
//
//        let japanPlace2 = Place()
//        japanPlace2.name = "Sensō\u{2011}ji Temple"
//        japanPlace2.image = "temple.jpg"
//        japanPlace2.location = "Tokyo"
//
//        let japanPlace3 = Place()
//        japanPlace3.name = "Vintage Clothing Stores"
//        japanPlace3.image = "vintage.jpg"
//        japanPlace3.location = "Kyoto"
//
//        japanPlaces.append(japanPlace1)
//        japanPlaces.append(japanPlace2)
//        japanPlaces.append(japanPlace3)
//
//        japan.places = japanPlaces
//
//        countriesArray.append(japan)
//
//        let switzerland = Country()
//        switzerland.name = "Switzerland"
//        switzerland.continent = "Europe"
//
//        var switzPlaces = [Place]()
//        let switz1 = Place()
//        switz1.name = "Bern"
//        switz1.image = "bern.jpg"
//        switz1.location = ""
//
//        let switz2 = Place()
//        switz2.name = "Kandergrund"
//        switz2.image = "kandergrund.jpg"
//        switz2.location = ""
//
//        switzPlaces.append(switz1)
//        switzPlaces.append(switz2)
//
//        switzerland.places = switzPlaces
//
//        countriesArray.append(switzerland)
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let data = try! encoder.encode(countriesArray)
//        print(String(data: data, encoding: .utf8)!)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if darkModeStatus {
            return .lightContent
        } else {
            return .darkContent
        }
    }
}
