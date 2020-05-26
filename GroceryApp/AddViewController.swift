//
//  CornerViewController.swift
//  GroceryApp
//
//  Created by Divine.Dube on 2020/05/26.
//  Copyright © 2020 Divine.Dube. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    let client = HTTPClient()
    @IBOutlet weak var groceryItem: UITextField!
    @IBOutlet weak var itemState: UISegmentedControl!
    
    var successClousure: ((_ item: Grocery) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func saveButtonEvent(_ sender: Any) {
        let item = Grocery(name: groceryItem.text!,
                           available: itemState.selectedSegmentIndex == 0 ? true : false)
        
        client.$addGroceryItem(query: ["someOtherQuery": "qqqq"], body: item) { [weak self] response in
            switch response {
                case .success(let success):
                    let responseEntity = success.body.entity
                    self?.successClousure?(responseEntity)
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
