//
//  Updater.swift
//  weather
//
//  Created by Vladimir Psyukalov on 20.06.2019.
//  Copyright © 2019 Vladimir Psyukalov. All rights reserved.
//

import Foundation
import Alamofire

protocol UpdaterProtocol {
    
    func didUpdate(data: [[String : Any]]?)
    
}

class Updater {
    
    static let shared = Updater()
    
    var observers = [UpdaterProtocol]()
    
    var data: [[String : Any]]?
    
    func update(_ lat: Double, _ long: Double) {
        let string = NSString(format: "http://api.openweathermap.org/data/2.5/find?lat=%0.4f&lon=%0.4f&cnt=20&units=metric&language=%@&appid=2de95dfce0431ba4df238ef44986eaef", lat, long, NSLocalizedString("lang", comment: "")) as String
        Alamofire.request(string) .responseJSON { responce in
            if let dictionary = responce.result.value as? [String : Any], let list = dictionary["list"] as? [[String : Any]] {
                self.data = list
            }
            self.send(self.data)
        }
    }
    
    func send(_ data: [[String : Any]]?) {
        for observer in observers {
            observer.didUpdate(data: data)
        }
    }
    
}
