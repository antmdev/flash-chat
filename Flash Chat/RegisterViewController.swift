//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import GoogleSignIn


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        //TODO: Set up a new user on our Firbase database
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            
            (user, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                //success
                print("Registration Succesful!")
                
            //inside a closure - i.e a method without a name
            //So need to specify where the method for performSegue occure
            //so we add self. to performSegue
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }

        
        
    } 
    
    
}
