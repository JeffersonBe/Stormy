//
//  ViewController.swift
//  Stormy
//
//  Created by Jefferson Bonnaire on 06/03/15.
//  Copyright (c) 2015 Jefferson Bonnaire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiKey = valueForAPIKey(keyname:"API_SECRET")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "52.474096, -1.908412", relativeToURL: baseURL)
        
        let weatherData = NSData(contentsOfURL: forecastURL!, options: nil, error: nil)
        println(weatherData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

