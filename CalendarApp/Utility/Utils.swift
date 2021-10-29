//
//  Utils.swift
//  CalendarApp
//
//  Created by Binod Mandal on 16/10/21.
//

import Foundation

class Utils {
   
    @discardableResult
    class func numberOfDaysIn(_ month:Int, AndYear yearValue: Int) -> Int {
        
        var rtnValue = 30
        
        if month == 1{
            //calculate feb month return count
            rtnValue = yearValue % 4 == 0 ? 29 : 28
        }
        else{
            
            if month < 7 {
                
                rtnValue = month % 2 == 0 ? 31 : 30
            }
            else{
                rtnValue = month % 2 == 0 ? 30 : 31
            }
        }
        return rtnValue
    }
    
   @discardableResult
   class func startDay(ofMonth monthValue: Int, Year yearValue: Int ) -> Int {
        
        let cal = Calendar.current
        var comps = DateComponents()
        comps.setValue(yearValue , for: .year)
        comps.setValue(monthValue , for: .month)
        comps.setValue(1 , for: .day)
        comps.setValue(cal.firstWeekday, for: .weekday)
        let date = cal.date(from: comps)!
        
        //TODO: -2 to make start day monday -> need reseach
        let rtnValue = cal.component(.weekday, from: date) - 2
        if rtnValue < 0{ return 6}
        
        return rtnValue
    }
    
    fileprivate enum Month : String{
        case JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEPT, OCT, NOV, DEC
    }
    
    @discardableResult
    class func monthText(for indexPath: IndexPath) -> String{
        
        switch indexPath.section {
        case 0:
            return Month.JAN.rawValue
        case 1:
            return Month.FEB.rawValue
        case 2:
            return Month.MAR.rawValue
            
        case 3:
            return Month.APR.rawValue
            
        case 4:
            return Month.MAY.rawValue
            
        case 5:
            return Month.JUN.rawValue
            
        case 6:
            return Month.JUL.rawValue
            
        case 7:
            return Month.AUG.rawValue
            
        case 8:
            return Month.SEPT.rawValue
            
        case 9:
            return Month.OCT.rawValue
            
        case 10:
            return Month.NOV.rawValue
            
        case 11:
            return Month.DEC.rawValue
            
        default:
            return ""
        }
    }
}

