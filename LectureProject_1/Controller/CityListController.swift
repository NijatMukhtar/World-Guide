//
//  CityListController.swift
//  LectureProject_1
//
//  Created by Shamkhal Guliyev on 25.06.22.
//

import UIKit

class CityListController: UIViewController {
    @IBOutlet weak var collection: UICollectionView!
    
    let itemNumberInOneRow = 4
    
    var cityModel = [CityModel]()
    var loggedUser: Credentials?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //changeImageSize()
    }

}



extension CityListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cityModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.alpha = 0
        cell.label.text = cityModel[indexPath.item].name
        cell.img.image = UIImage(named: cityModel[indexPath.item].image)
        gridAnimation(cell: cell, index: indexPath)
        return cell
    }
    func gridAnimation(cell: CollectionViewCell, index: IndexPath){
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        var delay: Double = 1
        let column = Double(index.item % itemNumberInOneRow)
        let row = Double(index.item / itemNumberInOneRow)
        let distance = sqrt(pow(column, 2) + pow(row, 2))
        delay = sqrt(distance) * 0.1
        UIView.animate(withDuration: 0.5, delay: delay) {
            cell.transform = .identity
            cell.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if(indexPath.item % 4 == 0) {
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
//        }
        return CGSize(width: collectionView.frame.width / CGFloat(itemNumberInOneRow), height: collectionView.frame.width / CGFloat(itemNumberInOneRow))
    }
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewCont = storyboard?.instantiateViewController(withIdentifier: "PlaceController") as! PlaceController
        viewCont.title = cityModel[indexPath.item].name
        viewCont.places = cityModel[indexPath.item].places
        viewCont.loggedUser = loggedUser
        
        navigationController?.show(viewCont, sender: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func changeImageSize(){
        var backImage = UIImage(named: "backButton")!
        backImage = resizeImage(image: backImage, newWidth: 40)!
        backImage = backImage.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.leftBarButtonItem?.image = UIImage(named: "backButton")
    }
}
