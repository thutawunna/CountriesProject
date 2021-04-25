//
//  FavoritesCollectionViewController.swift
//  HWProject2
//
//  Created by Thuta on 4/23/21.
//

import UIKit

private let reuseIdentifier = "FavCell"


let userDefaults = UserDefaults.standard

class FavoritesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var itemSize: CGSize = CGSize(width: 0, height: 0)
    var places: [Place] = []
    var currentPlace: Place?
    var countriesArray: [Country] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let numPlacesInRow: CGFloat = 3
            let padding: CGFloat = 5
            let totalPadding: CGFloat = padding * (numPlacesInRow - 1)
            let placePadding: CGFloat = totalPadding / numPlacesInRow
            let width = collectionView.frame.width / numPlacesInRow - placePadding
            let height = width
            layout.minimumLineSpacing = padding
            layout.minimumInteritemSpacing = 0
            layout.estimatedItemSize = itemSize
            itemSize = CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func loadFavorites() {
        let favoritesArray: [String] = userDefaults.stringArray(forKey: "favorites") ?? []
        
        var i = 0
        while (i < countriesArray.count) {
            var j = 0
            while (j < countriesArray[i].places.count) {
                let place = countriesArray[i].places[j]
                if (favoritesArray.contains(place.name)) {
                    places.append(place)
                }
                j += 1
            }
            i += 1
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let c = cell as? FavoritesCollectionViewCell {
            c.placeImage.image = UIImage(named: places[indexPath.row].image)
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPlace = places[indexPath.row]
        performSegue(withIdentifier: "showPlace", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ViewController {
            viewController.place = currentPlace
        }
    }

}
