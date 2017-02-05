//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 2/1/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBAction func logOutUserMapViewButtonClicked(_ sender: Any) {
        logOutUser()
        self.performSegue(withIdentifier: "logOutSegue", sender: nil)
    }
    @IBAction func logOutUserTableViewButtonClicked(_ sender: Any) {
        logOutUser()
        self.performSegue(withIdentifier: "logOutSegue", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func presentLoginViewModally() {
//        let modalViewController = ViewController
//        modalViewController.modal
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
