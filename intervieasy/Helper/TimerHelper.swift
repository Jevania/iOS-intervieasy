//
//  TimerHelper.swift
//  intervieasy
//
//  Created by jevania on 08/05/24.
//

import Foundation

class TimerHelper{
    func getTime(timerCounting:Int) -> String{
        let time = secondsToHoursMinutesSeconds(seconds: timerCounting)
        return makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        return String(format: "%02d : %02d : %02d", hours, minutes, seconds)
    }
    
    func getCurrentDate() -> String{
        return String("\(Date().timeFormatted())  |  \(Date().dateStamp())")
    }
}
