//
//  AccountController.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 12.07.22.
//

import UIKit

class AccountController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var loggedUser: Credentials?
    var hiddenPassword = ""
    var isPasswordHidden = true
    var users = [Credentials] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "AccountCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        jsonSetupForCredentials()
        findLoggedUser()
        table.reloadData()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        controller.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.show(controller, sender: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "EditSectionController") as! EditSectionController
        controller.title = "Edit Page"
        controller.loggedUser = loggedUser
        navigationController?.show(controller, sender: nil)
    }
    func getDocumentsDirectoryUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func findLoggedUser(){
        let loggedMail = UserDefaults.standard.string(forKey: "loggedUser")
  
        for user in users{
            if(user.email == loggedMail){
                loggedUser = user
            }
        }
    }
    func jsonSetupForCredentials() {
        let jsonFile = self.getDocumentsDirectoryUrl().appendingPathComponent("Credentials.json")
        
        if let data = try? Data(contentsOf: jsonFile) {
            do {
                users = try JSONDecoder().decode([Credentials].self, from: data)
            } catch{
                print(error.localizedDescription)
            }
        }
        
    }
}

extension AccountController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        cell.isUserInteractionEnabled = false
        switch indexPath.row{
        case 0:
            cell.leftLabel.text = "Name: "
            cell.rightLabel.text = loggedUser?.name
        case 1:
            cell.leftLabel.text = "Surname: "
            cell.rightLabel.text = loggedUser?.surname
        case 2:
            cell.leftLabel.text = "Email: "
            cell.rightLabel.text = loggedUser?.email
        case 3:
            cell.leftLabel.text = "Password: "
            var i = 0
            while i < loggedUser?.password.count ?? 8{
                hiddenPassword += "*"
                i += 1
            }
            cell.rightLabel.text = hiddenPassword
            cell.isUserInteractionEnabled = true
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("okay")
        let cell = tableView.cellForRow(at: indexPath) as! AccountCell
        if indexPath.row == 3 {
            if isPasswordHidden{
                cell.rightLabel.text = loggedUser?.password
                isPasswordHidden = false
            }
            else{
                cell.rightLabel.text = hiddenPassword
                isPasswordHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}
