//
//  LoginController.swift
//  Pole
//
//  Created by Apple Macintosh on 10/15/18.
//  Copyright © 2018 Apple Macintosh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftValidator

class loginController: UIViewController, UITextFieldDelegate, ValidationDelegate  {
    
    // Api Login
    var loginsuccess = "Login Success"
    
    // UI Image View
    @IBOutlet weak var logoPole: UIImageView!
    
    // Text Field
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    // Label
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    // Validate
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Validate
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
        validator.registerField(usernameText, errorLabel: usernameError, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordText, errorLabel: passwordError, rules: [RequiredRule()])
        
        usernameText.delegate = self
        passwordText.delegate = self
        
        usernameText.setBottomBorder(borderColor: .lightGray)
        passwordText.setBottomBorder(borderColor: .lightGray)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Validating...")
        validator.validate(self)
    }
    
    // Validate
    func validationSuccessful() {
        print("Validation Success!")
        
        loginAPI {
            let selectRoomView = self.storyboard?.instantiateViewController(withIdentifier: "selectedRoomViewController")as! UINavigationController
            self.present(selectRoomView, animated: true, completion: nil)
        }
        
    }
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        print("Validation FAILED!")
    }
    
    // Login API
    func loginAPI (completetion : @escaping () -> ()) {
        let parameters: Parameters = ["user": "\(usernameText.text!)", "pass": "\(passwordText.text!)"]
        let baseURL = "http://january.banana.co.th/api/auth/login"
        //let header = ["Apikey": "banana_app_iot", "Content-Type": "application/x-www-form-urlencoded"]
        let header = ["Content-Type": "application/x-www-form-urlencoded"]
        print(parameters)
        Alamofire.request(baseURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    let status = JSON["status"] as! String
                    if status == self.loginsuccess {
                        let message = JSON["message"] as! Dictionary<String,String>
                        let token = message["token"]
                        let firstName = message["firstname"]
                        let lastName = message["lastname"]
                        let user_id = message["user_id"]
                        let userRole = message["user_role"]
                        let picture = message["picture"]
                        completetion()
                    } else {
                        print(status)
                        self.displayAlertDialog(with: "Login Failed", and: "Wrong Username or Password", dismiss: false)
                    }
                    
                }
        }
    }
    
    func displayAlertDialog(with title: String, and message: String, dismiss: Bool){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var okHandler = { (action: UIAlertAction) -> Void in}
        
        if dismiss {
            okHandler = { (action: UIAlertAction) -> Void in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
