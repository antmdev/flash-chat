//
//  closures.swift
//  Flash Chat
//
//  Created by Ant Milner on 14/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class Firebase
{
    
    //takes 3 params including the completed function
    
    func createUser(username:String, password:String, completion: (Bool,Int) -> Void)
    {
        //does something quite time consuming
        
        var isSuccess = true
        var userID = 123
        
        completion(isSuccess, userID) //these two parameters can now be passed ito the function complete
    }
    
}

class MyApp
{
    
    func registerButtonPressed()
    {
        let firebase = Firebase()
        
        firebase.createUser(username: "Ant", password: "123456") {
            (isSuccess : Bool, userID: Int) in
            print("Registration is successful: \(isSuccess)")
            print("User ID is: \(userID)")
        }
    }
    

    
}

let myApp = MyApp()

//myApp.registerButtonPressed()

