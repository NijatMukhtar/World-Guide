//
//  PlaceController.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 28.06.22.
//

import UIKit

class PlaceController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    
    var identifier = "PlaceCell"
    var places = [PlaceModel]()
    var loggedUser: Credentials?

    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(accountTapped))
    }
    
    @IBAction func accountTapped(_ sender: Any) {
        let viewCont = storyboard?.instantiateViewController(withIdentifier: "AccountController") as! AccountController
        viewCont.title = "Profile"
        viewCont.loggedUser = loggedUser
        navigationController?.show(viewCont, sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PlaceCell
        cell.img.image = UIImage(named: places[indexPath.row].image[0])
        cell.label.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        176
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewCont = storyboard?.instantiateViewController(withIdentifier: "CityController") as! CityController
        viewCont.title = places[indexPath.row].name
        viewCont.place = places[indexPath.row]
        viewCont.loggedUser = loggedUser
        
        navigationController?.show(viewCont, sender: nil)
    }
    
}
