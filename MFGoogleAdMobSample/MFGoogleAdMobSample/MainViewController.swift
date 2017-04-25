//
//  MainViewController.swift
//  MFGoogleAdMobSample
//
//  Created by Ming Hui Ho on 2017/4/25.
//  Copyright © 2017年 dearhui.studio.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.childViewControllers.first as? MasterViewController) != nil {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject))
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    func insertNewObject() {
        if let vc = self.childViewControllers.first as? MasterViewController {
            vc.insertNewObject(self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAdMob.sharedInstance.showBannerView(location: .bottom, mainViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
