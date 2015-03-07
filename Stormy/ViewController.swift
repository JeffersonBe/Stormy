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

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currenTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = false
        getCurrentWeatherData()
    }
    
    func getCurrentWeatherData() -> Void {
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "52.474096,-1.908412?units=si", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                dispatch_async(dispatch_get_main_queue(),{ () -> Void in
                    self.iconView.image = currentWeather.icon!
                    self.currenTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    
                    // Stop refreshing the button
                    self.refreshActivityIndicator.startAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
                
            } else {
                
                // Create AlertView when receiving fromg etCurrentWeatherData()
                
                let networkIssueController = UIAlertController(title: "", message: "Seems like you don't have internet", preferredStyle: .Alert)
                let okButtonOnNetworkIssue = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButtonOnNetworkIssue)
                
                let cancelButtonNetworkIssue = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButtonNetworkIssue)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Stop refreshing the button
                    self.refreshActivityIndicator.startAnimating()
                    self.refreshActivityIndicator.hidden = false
                    self.refreshButton.hidden = false
                })
            }
        })
        
        downloadTask.resume()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        getCurrentWeatherData()
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

