//
//  RegisterController.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 05.07.22.
//
import ProgressHUD
import UIKit

class RegisterController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var credentials = [Credentials]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func unvalidEmailEntered(){
        let dialogMessage = UIAlertController(title: "Error", message: "You entered unvalid email, please try again!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        emailTextField.text = ""
    }
    
    func unvalidPasswordEntered(){
        let dialogMessage = UIAlertController(title: "Error", message: "Your password should contain at least 8 characters, please try again!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        passwordTextField.text = ""
    }
    
    func emptyCheck() -> Bool{
        if nameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" || surnameTextField.text == ""{
            return true
        }
        if !isValidEmail(emailTextField.text!) {
            unvalidEmailEntered()
            return true
        }
        if passwordTextField.text!.count < 8 {
            unvalidPasswordEntered()
            return true
        }
        return false
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        register()
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
    func reusedUserCheck(user: Credentials) -> Bool{
        var i = 0
        while i < credentials.count{
            if(user.email == credentials[i].email){
                return true
            }
            i += 1
        }
        return false
    }
    func register() {
        if !emptyCheck(){
            let viewCont = storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            let user: Credentials = Credentials(name: nameTextField.text!, surname: surnameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
            
            if !reusedUserCheck(user: user) {
                credentials.append(user)
                ProgressHUD.show()
                //
                writeToJson(newModel: credentials)
                
                viewCont.navigationItem.hidesBackButton = true
                Timer.scheduledTimer(withTimeInterval: TimeInterval(Int.random(in: 1..<3)), repeats: false) { _ in
                    ProgressHUD.dismiss()
                    self.navigationController?.show(viewCont, sender: nil)
                }
            }
            else {
                unvalidEmailEntered()
            }
            print(credentials)
            
        }
    }
    
}
