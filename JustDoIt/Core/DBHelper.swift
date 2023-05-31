//
//  DBHelper.swift
//  JustDoIt
//
//  Created by apple on 29/05/23.
//

import Foundation
import SQLite3

class DBHelper {
    
    static let shared = DBHelper()
    
    init() {
        db = openDatabase()
    }
    
    func setUpDB() {
        createTaskListTable()
    }

    let dbPath: String = "IOTDb.sqlite"
    var db:OpaquePointer?

    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
      //  if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
        let flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX;
        if sqlite3_open_v2(fileURL.path, &db, flags, nil) != SQLITE_OK {
            #if DEBUG
            print("error opening database")
            #endif
            return nil
        } else {
            #if DEBUG
            print("Successfully opened connection to database at \(dbPath)")
            #endif
            return db
        }
    }
    
    private func createTaskListTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user_tasks (tasktitle text PRIMARY KEY NOT NULL, tasktime text, taskchecked text);"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                #if DEBUG
                print("user tasks table created.")
                #endif
            } else {
                #if DEBUG
                print("user tasks table could not be created.")
                #endif
            }
        } else {
                #if DEBUG
            print("user tasks TABLE statement could not be prepared.")
                #endif
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    private func deleteAllTasks() {
        let deleteString = "DELETE FROM user_tasks;"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                #if DEBUG
                print("user tasks all rows deleted.")
                #endif
            } else {
                #if DEBUG
                print("user tasks all rows could not deleted.")
                #endif
            }
        } else {
                #if DEBUG
            print("user tasks all rows query could not be prepared.")
                #endif
        }
        sqlite3_finalize(createTableStatement)
    }
    
    private func deleteTaskListTable() {
        let deleteString = "DROP TABLE IF EXISTS user_tasks;"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                #if DEBUG
                print("user tasks deleted.")
                #endif
            } else {
                #if DEBUG
                print("user tasks not deleted.")
                #endif
            }
        } else {
                #if DEBUG
            print("user tasks not deleted.")
                #endif
        }
        sqlite3_finalize(createTableStatement)
    }

    
    func deleteAllTables() {
        deleteTaskListTable()
    }
    
    func deleteAllData() {
        deleteAllTasks()
    }
}
