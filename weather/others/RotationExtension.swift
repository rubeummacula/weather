//
//  Extensions.swift
//  weather
//
//  Created by Vladimir Psyukalov on 19.06.2019.
//  Copyright © 2019 Vladimir Psyukalov. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        return (self.visibleViewController?.shouldAutorotate)!
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.visibleViewController?.supportedInterfaceOrientations)!
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return (self.visibleViewController?.preferredInterfaceOrientationForPresentation)!
    }
    
}

extension UITabBarController {
    
    override open var shouldAutorotate: Bool {
        return (self.selectedViewController?.shouldAutorotate)!
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.selectedViewController?.supportedInterfaceOrientations)!
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return (self.selectedViewController?.preferredInterfaceOrientationForPresentation)!
    }
    
}
