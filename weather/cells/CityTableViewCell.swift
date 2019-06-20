//
//  CityTableViewCell.swift
//  weather
//
//  Created by Vladimir Psyukalov on 20.06.2019.
//  Copyright © 2019 Vladimir Psyukalov. All rights reserved.
//

import UIKit

class CityTableViewCell: AccordionTableViewCell {
    
    static let reuseIdentifier = "CityTableViewCell"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func setExpanded(_ expanded: Bool, animated: Bool) {
        super.setExpanded(expanded, animated: animated)
        if (animated) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.toggle()
            }, completion: nil)
        } else {
            toggle()
        }
    }
    
    private func toggle() {
        temperatureLabel.transform = expanded ? .identity : CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        temperatureLabel.alpha = expanded ? 1.0 : 0.0
    }
    
}
