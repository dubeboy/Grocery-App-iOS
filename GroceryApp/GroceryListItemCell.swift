//
//  GroceryListItemCell.swift
//  GroceryApp
//
//  Created by Divine.Dube on 2020/05/21.
//  Copyright © 2020 Divine.Dube. All rights reserved.
//

import UIKit

class GroceryListItemCell: UICollectionViewCell  {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var lastModifiedBy: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var stateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let background = UIView()
        selectedBackgroundView = background
    }
    
    var item: Grocery? {
        didSet {
           decorateCell(using: item)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                selectedBackgroundView?.backgroundColor = .systemGray5
            } else {
                selectedBackgroundView?.backgroundColor = .clear
            }
        }
    }

    private func decorateCell(using item: Grocery?) {
        guard let item = item else { return }
        
        title.text = item.name
        lastModifiedBy.text = "Last modified by Dad"
        updateAvailability(item.available)
    }
    
    func updateAvailability(_ availability: Bool) {
        state.text = availability ? "Available" : "Finished"
        stateView.backgroundColor = availability ? .systemBlue :  .systemRed
    }
}
