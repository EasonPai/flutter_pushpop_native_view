//  NativeViewController.swift
//

import Foundation
import UIKit


class NativeViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    

        
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
