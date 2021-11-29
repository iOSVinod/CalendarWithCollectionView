//
//  AppLogs.swift
//  CalendarApp
//
//  Created by Binod Mandal on 30/11/21.
//

import Foundation

enum Log {
    
    enum LogType: String {
        case info = "INFO ✓"
        case warning = "WARNING ⚠️"
        case error = "ERROR ❌"
    }
    
    struct LogComponent {
        let type : LogType
        let fileName: String
        let lineNumber: Int
        let functionName: String
        var description: String {
            return "\(type.rawValue) : In file \((fileName as NSString).lastPathComponent),  line #\(lineNumber) of function \(functionName),"
        }
        
        fileprivate func showLog(message: String) {
            let logMessage =  self.description + " \(message)"
            
            #if DEBUG
             print(logMessage)
            #endif
        }
    }
    
    static func showInfo(message : String, fileName: String = #filePath, lineNumber: Int = #line, functionName: String = #function) {
    
        let content = LogComponent(type: .info ,fileName: fileName , lineNumber:lineNumber , functionName: functionName)
        content.showLog(message: message)
    }
    
    static func showWarning(message : String, fileName: String = #filePath, lineNumber: Int = #line, functionName: String = #function) {
        
        let content = LogComponent(type: .warning ,fileName: fileName , lineNumber:lineNumber , functionName: functionName)
        content.showLog(message: message)
    }
    
    static func showError(message : String, fileName: String = #filePath, lineNumber: Int = #line, functionName: String = #function) {

        let content = LogComponent(type: .error ,fileName: fileName , lineNumber:lineNumber , functionName: functionName)
        content.showLog(message: message)
    }
}
