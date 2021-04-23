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
            let itemsPerRow: CGFloat = 3
            let padding: CGFloat = 5
            let totalPadding: CGFloat = padding * (itemsPerRow - 1)
            let individualPadding: CGFloat = totalPadding / itemsPerRow
            let width = collectionView.frame.width / itemsPerRow - individualPadding
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return places.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        
        if let c = cell as? FavoritesCollectionViewCell {
//            c.placeLabel.text = places[indexPath.row].name
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
