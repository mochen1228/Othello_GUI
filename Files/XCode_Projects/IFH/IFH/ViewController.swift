//
//  ViewController.swift
//  IFH
//
//  Created by ChenMo on 11/7/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import CoreMotion
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {
    var placesClient: GMSPlacesClient!
    
    var locationManager = CLLocationManager()
    var healthStore = HKHealthStore()
    var motionAvtivityManager = CMMotionActivityManager()
    
    var histActivities = [String]()       // Past x minutes of activities
    var activitiesInterval = [Int]()      // Intervals of past x minutes of activites
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        locationManager.requestAlwaysAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    // ==================================================================================
    // Getting system time ==============================================================
    func getCurrentDate() {
        // Getting current time components
//        let hour = Calendar.current.component(.hour, from: Date())
//        let minute = Calendar.current.component(.minute, from: Date())
//        let second = Calendar.current.component(.second, from: Date())
//        let week = Calendar.current.component(.weekOfMonth, from: Date())
//        let epochTime = Int(Date().timeIntervalSince1970)
//
//        print(hour)
//        print(minute)
//        print(second)
//        print(week)
//        print(epochTime)
    }
    
    // ==================================================================================
    // Getting activity data ============================================================
    func getActivityHistory(_ since: Int) {
        // Query activity history in the past
        // 'since' refers to the number of minutes back, -5 will be three minutes ago
        motionAvtivityManager.queryActivityStarting(from: getPreviousDate(since),
                                                    to: Date(),
                                                    to: OperationQueue.main,
                                                    withHandler: activityCompletionHandler)
    }
    
    func activityCompletionHandler(retrieved: [CMMotionActivity]?, error: Error?) -> Void {
        // Completion handler for activity
        var hist = [Int: String]()  // A dictionary of timeSinceNow and activity names
        
        for activity in retrieved! {
            print(activity)
            hist[Int(activity.startDate.timeIntervalSinceNow)] = determineActivity(activity)
        }
        
        var currentInterval = 0
        var lastActivity = ""    // Current activity name of the loop
        var lastTimestamp = 0
        
        let histTimestamps = Array(Array(hist.keys).sorted().reversed())
        for timestamp in histTimestamps {
            var activity = hist[timestamp]
            histActivities.append(activity!)
            let timestampInterval = lastTimestamp - timestamp
            activitiesInterval.append(timestampInterval)
            lastTimestamp = timestamp
        }

        // Below version is attempt to assume unknown activities, currently i'm registering unknown as is
        //
        //        let histTimestamps = Array(Array(hist.keys).sorted().reversed())
        //        for timestamp in histTimestamps {
        //            var activity = hist[timestamp]
        //            if activity == "unknown" {
        //                let index = histTimestamps.index(of: timestamp)!
        //                if (index == histTimestamps.count - 1) {
        //                    activity = lastActivity
        //                }
        //                continue
        //            }
        //            if activity != lastActivity {
        //                histActivities.append(activity!)
        //                let timestampInterval = lastTimestamp - timestamp
        //                activitiesInterval.append(timestampInterval)
        //                lastActivity = activity!
        //                lastTimestamp = timestamp
        print(self.histActivities)
        print(self.activitiesInterval)
    }

    func determineActivity(_ input: CMMotionActivity) -> String {
        if input.stationary {
            return "still"
        } else
        if input.walking {
            return "walking"
        } else
        if input.stationary {
            return "running"
        } else
        if input.stationary {
            return "cycling"
        } else
        if input.stationary {
            return "car"
        } else {
            return "unknown"
        }
    }
    func getPreviousDate(_ before: Int) -> Date {
        // 'before' refers to minutes before
        let calendar = Calendar.current
        let daysAgo = calendar.date(byAdding: .minute, value: before, to:Date())
        return daysAgo!
    }
    
    // ==================================================================================
    // Getting location =================================================================
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            // locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // The problem for this function is it prints the data twice everytime logData is pressed
        let userLocation:CLLocation = locations[0] as CLLocation
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        print("Latitude: \(userLocation.coordinate.latitude)")
        print("Longitude: \(userLocation.coordinate.longitude)")
        manager.stopUpdatingLocation()
    }
    
    
    // ==================================================================================
    // Getting step count ===============================================================
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        // This is the prototype function for getting today's step count
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let readDataTypes: Set<HKObjectType> =  [stepsQuantityType]

        let now = Date()
        print(now)
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { (success, error) -> Void in
            if success == false {
                print("yo")
            }
        }
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }

    func completionHandler(_ steps: Double) -> Void {
        // Step count completion handler
        print("Step count: ", Int(steps))
    }

    // ==================================================================================
    // Handling data ====================================================================
    @IBAction func logData(_ sender: UIButton) {
        // The button that does the final data collection
        
        getLocation()  // fetch location data
//        getTodaysSteps(completion: completionHandler(_:))  // fetch step count for the day
        getActivityHistory(-60)  // fetch activity history in the past 5 minutes
        getCurrentDate()
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    if likelihood.likelihood >= 0.1 {
                        let place = likelihood.place
                        print("Name: \(place.name). Likelihood: \(likelihood.likelihood)")
                        // print("Current Place address \(place.formattedAddress)")
                        // print("Current Place attributions \(place.attributions)")
                        // print("Current PlaceID \(place.placeID)")
                    }
                }
            }
            }
        )
    }

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
}

