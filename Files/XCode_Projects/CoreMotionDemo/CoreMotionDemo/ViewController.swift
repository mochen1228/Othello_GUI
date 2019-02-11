//
//  ViewController.swift
//  CoreMotionDemo
//
//  Created by ChenMo on 10/13/17.
//  Copyright © 2017 ChenMo. All rights reserved.
//

import UIKit
import CoreMotion

class thresholds {
    // Thresholds:
    // This is assuming the user is holding the phone on the right hand
    //      with screen facing forward
    
    // Indicates when the bicep curl is at top of the range of motion:
    static let bicepXAccelerometerTopThreshold = 0.5
    // Indicates when the bicep cul is at the bottom of the range of motion:
    static let bicepXAccelerometerBottomThreshold = -0.8
    
    static let latRaiseXAccelerometerTopThreshold = -0.2
    static let latRaiseXAccelerometerBottomThreshold = -0.8
}

class ViewController: UIViewController {
    // Gausian Kernel data and sum of all entries
    let gaussianKernel = [0.63144357279,0.721655552358,0.90889400542,1.2066359252,1.63467562934,2.21851051172,2.98835983239,3.96764693868,5.21537351096,6.74919479619,8.59869724217,10.7851825751,13.3179228174,16.1904766508,19.3774633599,22.8322316907,26.4858521241,30.2477925517,34.0085073099,37.6439860461,41.0220902549,44.0102784738,46.4841181139,48.3358348686,49.4820861599,49.8701789717,49.4820861599,48.3358348686,46.4841181139,44.0102784738,41.0220902549,37.6439860461,34.0085073099,30.2477925517,26.4858521241,22.8322316907,19.3774633599,16.1904766508,13.3179228174,10.7851825751,8.59869724217,6.74919479619,5.21537351096,3.96764693868,2.98835983239,2.21851051172,1.63467562934,1.2066359252,0.90889400542,0.721655552358,0.63144357279
        ]
    let sumOfFilter = 1000.0  // The total sum of the gaussian filter, should be 1000
    var count = 0  // Final rep count
    
    // Essential variables for reading IMU data, required by CoreMotion Framework
    let accMotion = CMMotionManager();
    let gyroMotion = CMMotionManager();
    var accTimer = Timer();
    var gyroTimer = Timer();
    
    // Recent data reading for accelerometer and gyroscope, type [Double]
    // A filteringData array acts like a first in first out queue
    var xAccfilteringData = Array(repeating: 0.0, count: 51);
    var yAccfilteringData = Array(repeating: 0.0, count: 51);
    var zAccfilteringData = Array(repeating: 0.0, count: 51);
    var xGyrofilteringData = Array(repeating: 0.0, count: 51);
    var yGyrofilteringData = Array(repeating: 0.0, count: 51);
    var zGyrofilteringData = Array(repeating: 0.0, count: 51);

    let readingInterval: Double = Double(100);  // Refresh rate
    
    // General thresholds
    let topThreshold = thresholds.latRaiseXAccelerometerTopThreshold
    let bottomThreshold = thresholds.latRaiseXAccelerometerBottomThreshold
    
    
    // motionState:
    // Describes the current state of motion of bicep curls
    //  1) Motion is at top range
    //  0) motion is at middle range
    // -1) motion is at bottom range
    // MmotionState is defined by the thresholds above
    var motionState = 0
    var lastMotionState = 0
    var upMotionFinished = 0
    var downMotionFinished = 0
    var stateToggles = [0, 0, 0]  // down - middle - up
    
    func startAccelerometers() {
        // Starting the IMU Accelerometer, required by CoreMotion
        if self.accMotion.isAccelerometerAvailable {
            self.accMotion.accelerometerUpdateInterval = 1.0 / self.readingInterval  // refresh rate
            self.accMotion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            self.accTimer = Timer(fire: Date(), interval: (1.0/self.readingInterval),  // refresh rate
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let data = self.accMotion.accelerometerData {
                                    let x = data.acceleration.x
                                    let y = data.acceleration.y
                                    let z = data.acceleration.z
                                    
                                    print(x)
                                    
                                    // Display data on screen
                                    self.xAccelerometerAxis.text! = String(x);
                                    self.yAcceleromrterAxis.text! = String(y);
                                    self.zAccelerometerAxis.text! = String(z);
                                    
                                    // Insert data to filteringArrays
                                    self.insertData(array: &self.xAccfilteringData, n: x)

                                    // Process sensor reading and determine motion state
                                    let filteredX = self.getAverageAfterFiltering(array: &self.xAccfilteringData)
                                    
                                    self.updateMotionState(filteredX: filteredX)
                                    self.detectUpDownMotion()
                                    self.updateRepCount()
                                }
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.accTimer, forMode: .defaultRunLoopMode)
        }
    }
    
    func startGyros() {
        if gyroMotion.isGyroAvailable {
            self.gyroMotion.gyroUpdateInterval = 1.0 / readingInterval
            self.gyroMotion.startGyroUpdates()
            
            // Configure a timer to fetch the accelerometer data.
            self.gyroTimer = Timer(fire: Date(), interval: (1.0/self.readingInterval),
                               repeats: true, block: { (timer) in
                                // Get the gyro data.
                                if let data = self.gyroMotion.gyroData {
                                    let x = data.rotationRate.x
                                    let y = data.rotationRate.y
                                    let z = data.rotationRate.z
                                    
                                    // Use the gyroscope data in your app.
                                    self.xGyroAxis.text! = String(x);
                                    self.yGyroAxis.text! = String(y);
                                    self.zGyroAxis.text! = String(z);
                                    
                                    // Insert data to filteringArrays
                                    self.insertData(array: &self.yGyrofilteringData, n: y)
                                    
                                }
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.gyroTimer, forMode: .defaultRunLoopMode)
        }
    }
    
    func insertData(array: inout Array<Double>, n: Double) {
        // Add n into filteringData arrays
        array.removeFirst();
        array.append(n);
    }
    
    func getAverageAfterFiltering(array: inout Array<Double>) -> Double{
        // Apply gaussian kernel to filtering array, return average of the array
        var total = 0.0
        for i in 0...array.count - 1 {
            total += (array[i] * gaussianKernel[i])
        }
        return total/sumOfFilter
    }
    
    func updateMotionState(filteredX: Double) {
        // Determine motion state of the current session
        if (filteredX >= self.topThreshold) {
            self.motionState = 1
        } else if (filteredX <= self.bottomThreshold) {
            self.motionState = -1
        } else {
            self.motionState = 0
        }
    }
    
    func detectUpDownMotion() {
        if (self.upMotionFinished == 0) {
            // When the up motion is not finished,
            // indicating we need to detect up motion first
            if (self.motionState) == -1 {
                self.stateToggles[1] = 0
                self.stateToggles[0] = 1
            }
            if (self.motionState) == 0 {
                self.stateToggles[1] = 1
            }
            if (self.motionState) == 1 {
                self.upMotionFinished = 1
            }
        }
        if (self.upMotionFinished == 1) {
            // When up motion is finished,
            // indicating we need to detect down motion now
            if (self.motionState) == 1 {
                self.stateToggles[1] = 0
                self.stateToggles[2] = 1
            }
            if (self.motionState) == 0 {
                self.stateToggles[1] = 1
            }
            if (self.motionState) == -1 {
                self.downMotionFinished = 1
            }
        }
    }
    
    func updateRepCount() {
        if (self.upMotionFinished == 1 && self.downMotionFinished == 1) {
            self.count += 1
            self.upMotionFinished = 0
            self.downMotionFinished = 0
            self.stateToggles = [0, 0, 0]
            self.countLabel.text! = String(self.count)
            // print("Current reps: ", self.count)
        }
    }
    // ===============================================================================
    // This part is for general funtioning methods of the application
    // i.e. displaying data on screen, switching on/off of the reading
    // Nothing to do with motion sensing algorithm
    func stopAccelerometers() {
        self.accTimer.invalidate();
        self.gyroTimer.invalidate();
    }
    
    func clearAllLabel() {
        xAccelerometerAxis.text! = "";
        yAcceleromrterAxis.text! = "";
        zAccelerometerAxis.text! = "";
        xGyroAxis.text! = "";
        yGyroAxis.text! = "";
        zGyroAxis.text! = "";
        countLabel.text! = "";
    }
    
    @IBOutlet weak var xAccelerometerAxis: UILabel!
    @IBOutlet weak var yAcceleromrterAxis: UILabel!
    @IBOutlet weak var zAccelerometerAxis: UILabel!
    
    @IBOutlet weak var xGyroAxis: UILabel!
    @IBOutlet weak var yGyroAxis: UILabel!
    @IBOutlet weak var zGyroAxis: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func switchOnOff(_ sender: UIButton) {
        if sender.currentTitle == "Start" {
            startAccelerometers();
            startGyros();
            sender.setTitle("Stop", for: .normal);
        } else {
            stopAccelerometers();
            sender.setTitle("Start", for: .normal);
            clearAllLabel();
        }
    }
}
