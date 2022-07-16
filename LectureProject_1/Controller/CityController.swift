//
//  CityController.swift
//  LectureProject_1
//
//  Created by Shamkhal Guliyev on 25.06.22.
//

import UIKit

class CityController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    var place: PlaceModel?
    var loggedUser: Credentials?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = place?.text


    }
    
    
} 

extension CityController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        place?.image.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "PlacePhotoCell", for: indexPath) as! PlacePhotoCell
        if indexPath.item == 0 {
            cell.img.image = UIImage(named: place?.image[indexPath.item] ?? "")
        }
        else{
            cell.img.image = UIImage(named: (place?.image[0] ?? "") + String(indexPath.item))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: Int = Int(collectionView.frame.width * 1)
        return CGSize(width: size, height: size)
    }
    
}


