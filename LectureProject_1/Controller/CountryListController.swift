//
//  CountryListController.swift
//  LectureProject_1
//
//  Created by Shamkhal Guliyev on 25.06.22.
//

import UIKit
import ProgressHUD

class CountryListController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var identifier = "CountryCell"
    var model = [CountryModel]()
    var loggedUser: Credentials?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        //progressSetup()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(accountTapped))
        jsonSetup()
        
        
    }
    @IBAction func accountTapped(_ sender: Any) {
        let viewCont = storyboard?.instantiateViewController(withIdentifier: "AccountController") as! AccountController
        viewCont.title = "Profile"
        viewCont.loggedUser = loggedUser
        navigationController?.show(viewCont, sender: nil)
    }
    func jsonSetup() {
        if let jsonFile = Bundle.main.url(forResource: "Country", withExtension: "json"), let data = try? Data(contentsOf: jsonFile) {
            do {
                model = try JSONDecoder().decode([CountryModel].self, from: data)
                table.reloadData()
            } catch{
                print(error.localizedDescription)
            }
        }
        
    }
}

extension CountryListController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func navigate(index: Int){
        print("buttonTapped")
        let viewCont = storyboard?.instantiateViewController(withIdentifier: "CityListController") as! CityListController
        let CountryModel = model[index]
        viewCont.title = CountryModel.name
        viewCont.cityModel = CountryModel.cities
        viewCont.loggedUser = loggedUser
        navigationController?.show(viewCont, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CountryCell
        cell.tag = indexPath.row
        cell.label.text = model[indexPath.row].name
        cell.img.image = UIImage(named: model[indexPath.row].flag)
        cell.img.layer.cornerRadius = 15
        cell.buttonCallback = { _ in
            self.navigate(index: cell.tag)
             
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    

    func progressSetup(){
        ProgressHUD.show("Loading...")
        ProgressHUD.animationType = .circleSpinFade
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            ProgressHUD.dismiss()
            self.table.isHidden = false
        }
    }
    
}
