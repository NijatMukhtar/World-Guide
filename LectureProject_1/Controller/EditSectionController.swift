//
//  EditSectionController.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 17.07.22.
//

import UIKit

class EditSectionController: UIViewController {
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    
    var loggedUser: Credentials?
    var allUsers = [Credentials]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTexfields()
        jsonSetup()
    }

    func getDocumentsDirectoryUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func jsonSetup() {
        let jsonFile = self.getDocumentsDirectoryUrl().appendingPathComponent("Credentials.json")
        
        if let data = try? Data(contentsOf: jsonFile) {
            do {
                allUsers = try JSONDecoder().decode([Credentials].self, from: data)
            } catch{
                print(error.localizedDescription)
            }
        }
        
    }
    
    func setupTexfields(){
        nameTextfield.placeholder = loggedUser?.name
        surnameTextfield.placeholder = loggedUser?.surname
        emailTextfield.text = loggedUser?.email
        passwordTextField.placeholder = loggedUser?.password
        
    }
    
    func editCheck(){
        if(nameTextfield.text?.count == 0) {
            nameTextfield.text = loggedUser?.name
        }
        if(surnameTextfield.text?.count == 0){
            surnameTextfield.text = loggedUser?.surname
        }
        if(passwordTextField.text?.count == 0){
            passwordTextField.text = loggedUser?.password
        }
        if(passwordTextField.text!.count < 8) {
            let dialogMessage = UIAlertController(title: "Error", message: "Your password should contain at least 8 characters, please try again!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            passwordTextField.text = ""
            nameTextfield.text = ""
            surnameTextfield.text = ""
        }
    }
    
    func writeToJson(newModel: [Credentials]) {
        do {
            let data = try JSONEncoder().encode(newModel)
            if var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                url.appendPathComponent("Credentials.json")
                try data.write(to: url)
            }
        } catch {
            print("axi niye islemirsen")
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AccountController") as! AccountController
        editCheck()
        let tempUser: Credentials = Credentials(name: nameTextfield.text!, surname: surnameTextfield.text!, email: emailTextfield.text!, password: passwordTextField.text!)
        controller.loggedUser = tempUser
        
        var i = 0
        while i < allUsers.count{
            if(allUsers[i].email == tempUser.email) {
                print(allUsers[i].email)
                allUsers.remove(at: i)
                allUsers.append(tempUser)
                writeToJson(newModel: allUsers)
        }
            i += 1
        }
        
        navigationController?.popViewController(animated: true)
    }
    }
