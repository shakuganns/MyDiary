//
//  DateUtil.swift
//  MyDiary
//
//  Created by 钟圣麟 on 2016/12/11.
//  Copyright © 2016年 shakugan. All rights reserved.
//

import Foundation

class DateUtil {
    
    public static func formatDate(date:Date) -> DateComponents {
        let calendar: Calendar = Calendar(identifier: .gregorian)
//        let comps: DateComponents = DateComponents()
        let comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: date)
        return comps
    }
    
    public static func formatHourMinute(hour:Int,minute:Int) -> String {
        return "\(hour):\(minute<10 ? "0\(minute)" : "\(minute)")"
    }
    
    
    public static func weekdayInt2String(day:Int,isAbbreviated:Bool) -> String {
//        print("weekday:\(day)")
        if isAbbreviated {
            switch day {
            case 1:
                return "Sun."
            case 2:
                return "Mon."
            case 3:
                return "Tue."
            case 4:
                return "Wed."
            case 5:
                return "Thu."
            case 6:
                return "Fri."
            case 7:
                return "Sat."
            default:
                return "Error."
            }
        } else {
            switch day {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                return "Error."
            }
        }
    }
    
    public static func monthInt2String(month:Int) -> String {
        switch month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return "Error."
        }
    }
}
