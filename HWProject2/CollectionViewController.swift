//
//  CollectionViewController.swift
//  HWProject2
//
//  Created by Thuta on 4/22/21.
//

import UIKit

private let reuseIdentifier = "CVCell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var countryName: UINavigationItem!
    
    var itemSize: CGSize = CGSize(width: 0, height: 0)
    var places: [Place] = []
    var currentPlace: Place?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPlace = places[indexPath.row]
        performSegue(withIdentifier: "showPlace", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ViewController {
            viewController.place = currentPlace
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
        
        if let c = cell as? CollectionViewCell {
            c.placeImage.image = UIImage(named: places[indexPath.row].image)
        }
    
        return cell
    }

    @IBAction func segueToFavoritesView(_ sender: Any) {
        performSegue(withIdentifier: "showFavorites", sender: nil)
    }

}
