//
//  LoggedInViewController.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 4/12/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

import UIKit
import Parse

class LoggedInViewController: UIViewController {
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        appDelegate?.startPushNotifications()
    }

    @IBAction func sendPushToYourself(_ sender: UIButton) {
        let cloudParams : [AnyHashable:String] = [:]
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFCloud.callFunction(inBackground: "sendPushToYourself", withParameters: cloudParams, block: {
            (result: Any?, error: Error?) -> Void in
            UIViewController.removeSpinner(spinner: sv)
            if error != nil {
                if let descrip = error?.localizedDescription{
                    self.displayMessage(message: descrip)
                }else{
                    self.displayMessage(message: "error sending pushes to everyone")
                }
            }else{
                print(result as! String)
            }
        })
    }

    @IBAction func sendPushToEveryone(_ sender: UIButton) {
        let cloudParams : [AnyHashable:String] = [:]
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFCloud.callFunction(inBackground: "sendPushToAllUsers", withParameters: cloudParams, block: {
            (result: Any?, error: Error?) -> Void in
            UIViewController.removeSpinner(spinner: sv)
            if error != nil {
                if let descrip = error?.localizedDescription{
                    self.displayMessage(message: descrip)
                }else{
                    self.displayMessage(message: "error sending pushes to everyone")
                }
            }else{
                print(result as! String)
            }
        })
    }

    @IBAction func logoutOfApp(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logOutInBackground { (error: Error?) in
            UIViewController.removeSpinner(spinner: sv)
            if (error == nil){
                self.loadLoginScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayMessage(message: descrip)
                }else{
                    self.displayMessage(message: "error logging out")
                }

            }
        }
    }

    func displayMessage(message:String) {
        let alertView = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }

    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true, completion: nil)
    }


}
