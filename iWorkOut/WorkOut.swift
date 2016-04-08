//
//  WorkOut.swift
//  iWorkOut
//
//  Created by Yassin Aghani on 08/04/16.
//  Copyright © 2016 Yassin Aghani. All rights reserved.
//

import Foundation
import HealthKit

class WorkOut {
    var activities:[WorkOutActivity] = []
    
    init() {
    }
    
    init(pushUps: [PushUp]) {
        self.activities = pushUps
    }
    
    func addActivity(pushUp: WorkOutActivity) {
        self.activities.append(pushUp)
    }
    
    func startDate() -> NSDate? {
       return activities.first?.date
    }
    
    func endDate() -> NSDate? {
       return activities.last?.date
    }
    
    func duration() -> Double? {
        if let startDate = startDate(), let endDate = endDate() {
            let elapsedTime = endDate.timeIntervalSinceDate(startDate)
             return Double(elapsedTime)
        } else {
            return nil
        }
    }
    
    func totalEnergyBurned() -> HKQuantity? {
        if pushUps().count > 0 {
            //http://www.musculaction.com/faq/sports-calories.htm
            let energyBurned:Double = 0.42 * Double(pushUps().count)
            return HKQuantity(unit: HKUnit.kilocalorieUnit(),
                              doubleValue: energyBurned)
        } else {
            return nil
        }
    }
    
    func pushUps() -> [WorkOutActivity] {
        return activities.filter { ($0 as? PushUp) != nil }
    }
    
    func distance() -> HKQuantity {
        return HKQuantity(unit: HKUnit.mileUnit(), doubleValue: 0)
    }
    
    func storeInHealthKit() {
        let healthStore = HKHealthStore()
        let metadata = ["Push ups": pushUps().count] as [String : AnyObject]
        
        if let startDate = startDate(), let endDate = endDate(), let duration = duration(){
            let hkWorkOut = HKWorkout(activityType: HKWorkoutActivityType.FunctionalStrengthTraining, startDate: startDate, endDate: endDate, duration: duration, totalEnergyBurned: totalEnergyBurned(), totalDistance: distance(), metadata: metadata)
        
        healthStore.saveObject(hkWorkOut, withCompletion: { (succeeded, error) in
            if error == nil{
                print("Successfully saved workout")
            }else{
                print("Failed to save workout")
            }
        })
        }
    }
}