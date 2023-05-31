//
//  DBHelper+useTaskList.swift
//  JustDoIt
//
//  Created by apple on 31/05/23.
//

import Foundation
import SQLite3

extension DBHelper {
    
    func insertUserTask(_ userTasks : [TasklistCellModel]) {
        
        let insertStatementString = "INSERT INTO user_tasks (tasktitle, tasktime, taskchecked) VALUES (?, ?, ?);"
        
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            for (_, userTask) in userTasks.enumerated() {
                sqlite3_bind_text(insertStatement, 1, (userTask.taskTitle as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (userTask.taskstipulatedTime as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (userTask.taskStatusImage as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    #if DEBUG
                    print("Successfully inserted row.")
                    #endif
                } else {
                    #if DEBUG
                    print("Could not insert row.")
                    #endif
                }
                sqlite3_reset(insertStatement)
          
            }
        } else {
                    #if DEBUG
            print("INSERT statement could not be prepared.")
                    #endif
        }
        sqlite3_finalize(insertStatement)
    }
    
    func updateUserTasks(_ updatedcheckedState: String, tasktitle: String) {
        
        let updateStatementString = "UPDATE user_tasks SET taskchecked = '\(updatedcheckedState)' WHERE tasktitle = '\(tasktitle)';"
         var updateStatement: OpaquePointer? = nil
         if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                       print("Successfully updated row.")
                } else {
                       print("Could not update row.")
                }
              } else {
                    print("UPDATE statement could not be prepared")
              }
              sqlite3_finalize(updateStatement)
                
    }
     
    
     
     func deleteUserTask(_ tasktitle: String) {
     let deleteStatementStirng = "DELETE FROM user_tasks WHERE tasktitle = ?;"
     var deleteStatement: OpaquePointer? = nil
     if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
     sqlite3_bind_text(deleteStatement, 1, (tasktitle as NSString).utf8String, -1, nil)
     if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    #if DEBUG
     print("Successfully deleted groupState.")
                    #endif
     } else {
                    #if DEBUG
     print("Could not delete groupState.")
                    #endif
     }
     } else {
                    #if DEBUG
     print("DELETE groupState statement could not be prepared")
                    #endif
     }
     sqlite3_finalize(deleteStatement)
     }
     
    
    
    func getAllUserTasks() -> [TasklistCellModel] {
        let queryStatementString = "SELECT * FROM user_tasks;"
        var queryStatement: OpaquePointer? = nil
        var userTasks: [TasklistCellModel] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let tasktitle = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                
                let taskTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let taskStatusImage = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                var userTask = TasklistCellModel(taskStatusImage: "", taskTitle: "", taskStatus: true, taskstipulatedTime: "")
                userTask.taskStatusImage = taskStatusImage
                userTask.taskTitle = tasktitle
                userTask.taskstipulatedTime = taskTime
                userTasks.append(userTask)
            }
        } else {
                    #if DEBUG
            print("SELECT statement could not be prepared")
                    #endif
        }
        sqlite3_finalize(queryStatement)
        return userTasks
    }
    
    
    
    private func convertDictIntoJsonString(dict: Any) -> String? {
        
        if (!JSONSerialization.isValidJSONObject(dict)) {
             print("is not a valid json GroupState object")
             return ""
         }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let JsonString = String(decoding: jsonData, as: UTF8.self)
            return JsonString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
