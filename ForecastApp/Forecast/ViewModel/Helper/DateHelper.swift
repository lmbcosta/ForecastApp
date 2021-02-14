//
//  DateHelper.swift
//  ForecastApp
//
//  Created by Luis Costa on 13/02/2021.
//

import Foundation

extension Date {
    enum WeekDay: Int {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        
        func text() -> String {
            switch self {
            case .monday: return  "Monday"
            case .tuesday: return "Tuesday"
            case .wednesday: return "Wednesday"
            case .thursday: return "Thursday"
            case .friday: return "Friday"
            case .saturday: return "Saturday"
            case .sunday: return "Sunday"
            }
        }
    }
    
    enum Month: Int {
        case january = 1
        case february
        case march
        case april
        case may
        case june
        case july
        case august
        case september
        case october
        case november
        case december
        
        func text() -> String {
            switch self {
            case .january: return "January"
            case .february: return "February"
            case .march: return "March"
            case .april: return "April"
            case .may: return "May"
            case .june: return "June"
            case .july: return "July"
            case .august: return "August"
            case .september: return "September"
            case .october: return "October"
            case .november: return "November"
            case .december: return "December"
            }
        }
    }
}

extension Date {
    var calendar: Calendar { Calendar.current }
    
    var weekday: WeekDay {
        let weakdayInt = (calendar.component(.weekday, from: self) - calendar.firstWeekday + 7) % 7 + 1
        return (WeekDay(rawValue: weakdayInt) ?? .sunday)
    }
    
    var month: Month {
        let monthInt = calendar.component(.month, from: self)
        return (Month(rawValue: monthInt) ?? .january)
    }
    
    var day: Int {
        return calendar.component(.day, from: self)
    }
}

extension Date {
    var formattedDate: String {
        var stringDate = ""
        
        if calendar.isDateInTomorrow(self) {
            stringDate.append("Tomorow, ")
        } else {
            stringDate.append(self.weekday.text() + ", ")
        }
        
        stringDate.append(self.month.text())
        stringDate.append(" \(self.day)")
        return stringDate
    }
    
    func nextDay(increment: Int) -> Date {
        guard let morning = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) else {
            return self
        }
        return calendar.date(byAdding: .day, value: increment, to: morning) ?? self
        
    }
}
