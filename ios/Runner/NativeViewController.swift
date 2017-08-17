//  NativeViewController.swift
//

import Foundation
import UIKit


class NativeViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

        
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    func sayHello(_ personName: String) -> String {
        let greeting = "Hello, " + personName + "!"
        return greeting
    }
    
    func pushView(){
        print("native view");
    }

    
    /**
     *    dismiss this view controller
     */
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
