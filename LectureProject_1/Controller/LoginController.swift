
//
//  LoginController.swift
//  LectureProject_1
//
//  Created by Nijat Mukhtarov on 02.07.22.
//

import UIKit
import ProgressHUD

class LoginController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var flagView: UIView!
    @IBOutlet weak var greenBackgroundView: UIView!
    
    var model = [Credentials]()
    var newUser: Credentials?
    var registered = false
    var loggedUser: Credentials?
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldAnimation()
        basicCornerAnimation()
        basicRotateAnimation()
        transformAnimation()
        
        jsonSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapForHidingKeyboard()
        textFieldSetup()
    }
    
    
    func tapForHidingKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func basicCornerAnimation(){
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = 0
        animation.toValue = 32
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        greenBackgroundView.layer.add(animation, forKey: nil)
    }

    func transformAnimation(){
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat]) {
            self.flagView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        
    }
    
    func basicRotateAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 1
        animation.autoreverses = false
        animation.repeatCount = .infinity
        //animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        greenBackgroundView.layer.add(animation, forKey: nil)
        
    }
    
    func buttonAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.enterButton.alpha = 1
            self.registerButton.alpha = 0.5
        } completion: { _ in
            self.enterButton.isEnabled = true
            self.registerButton.isEnabled = true
        }
    }
    
    func textFieldAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.emailConstraint.constant = 0
            self.passwordConstraint.constant = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.buttonAnimation()
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func navigate(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "CountryListController") as! CountryListController
        controller.loggedUser = loggedUser
        controller.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.show(controller, sender: nil)
    }
    
    func textFieldSetup() {
        emailView.layer.cornerRadius = 15
        passwordView.layer.cornerRadius = 15
        enterButton.layer.cornerRadius = 15
        emailView.layer.borderColor = UIColor.gray.cgColor
        passwordView.layer.borderColor = UIColor.gray.cgColor
        emailView.layer.borderWidth = 1
        passwordView.layer.borderWidth = 1
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
                model = try JSONDecoder().decode([Credentials].self, from: data)
            } catch{
                print(error.localizedDescription)
            }
        }
        
    }
    func credentialCheck() -> Bool{
        var i = 0
        while i < model.count {
            if(model[i].email == emailTextField.text && model[i].password == passwordTextField.text){
                loggedUser = model[i]
                return true
            }
            i += 1
        }
        return false
    }
    
    func wrongCredentialsEntered(){
        let dialogMessage = UIAlertController(title: "Error", message: "Password or email incorrect, please try again!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
      
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        passwordTextField.text = ""
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
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let viewCont = storyboard?.instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
        viewCont.credentials = model
        navigationController?.show(viewCont, sender: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if !isValidEmail(emailTextField.text!){
            unvalidEmailEntered()
        } else if credentialCheck() {
            ProgressHUD.show()
            let randomNumber = Double.random(in: 0..<2)
            Timer.scheduledTimer(withTimeInterval: randomNumber, repeats: false) { _ in
                ProgressHUD.dismiss()
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                self.navigate()
            }
        } else {
            wrongCredentialsEntered()
        }
    }
}
