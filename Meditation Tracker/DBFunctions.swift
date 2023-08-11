//
//  DBFunctions.swift
//  Meditation Tracker
//
//  Created by Jim Lotruglio on 7/23/23.
//

import Foundation
import SQLite3

// Handles fetching meditations from the database
func readDatabase(meditations: inout[Meditation]){

    // Empty collection before fetching from database
    meditations.removeAll()
    var db: OpaquePointer?
    
    let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Meditation.sqlite")
    
    // Open database
    if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
        print("Error opening database")
        return
    }
    
    let createTableQuery = "CREATE TABLE IF NOT EXISTS Meditations (id " +
        "INTEGER PRIMARY KEY AUTOINCREMENT, anxietyLevelPre VARCHAR, anxietyLevelPost VARCHAR, meditationType VARCHAR, meditationDuration VARCHAR)"
    
    // Execute query to create the table
    if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
        print("Error creating table")
        return
    }
    
    let selectAll = "SELECT * FROM Meditations"
    
    var stmt:OpaquePointer?
    
    if sqlite3_prepare(db, selectAll, -1, &stmt, nil) != SQLITE_OK{
        print("Error creating table")
        return
    }
    // Iterate through table contents and add to meditations
    while(sqlite3_step(stmt)==SQLITE_ROW){
        meditations.append(Meditation(anxietyLevelPre: String(cString: sqlite3_column_text(stmt, 1)), anxietyLevelPost: String(cString: sqlite3_column_text(stmt, 2)), meditationType: String(cString: sqlite3_column_text(stmt, 3)), meditationDuration: String(cString: sqlite3_column_text(stmt, 4))))
    }
}

// Handles saving current list to the database
func writeDatabase(meditations: inout [Meditation]){
    // Deletes current table contents
    let deleteMeditations = "DELETE FROM Meditations"
    
    var db: OpaquePointer?
    let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Meditation.sqlite")
    
    // Open the database
    if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
        print("Error opening database")
        return
    }
    
    // Execute query to clear the table
    if sqlite3_exec(db, deleteMeditations, nil, nil, nil) != SQLITE_OK {
        print("Error deleting items")
        return
    }
    let insertString = "INSERT INTO Meditations (anxietyLevelPre, anxietyLevelPost, meditationType, meditationDuration) VALUES(?,?,?,?);"
    var stmt: OpaquePointer?

    if sqlite3_prepare(db, insertString, -1, &stmt, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db))
        print("Error preparing to insert: \(errmsg)")
        return
    }

    // Go through meditations and add them to the table
    for meditation in meditations {
        if sqlite3_bind_text(stmt, 1, (meditation.anxietyLevelPre as NSString).utf8String, -1, nil) != SQLITE_OK{
            print("Error binding 1")
        }
        if sqlite3_bind_text(stmt, 2, (meditation.anxietyLevelPost as NSString).utf8String, -1, nil) != SQLITE_OK{
            print("Error binding 2")
        }
        if sqlite3_bind_text(stmt, 3, (meditation.meditationType as NSString).utf8String, -1, nil) != SQLITE_OK{
            print("Error binding 3")
        }
        if sqlite3_bind_text(stmt, 4, (meditation.meditationDuration as NSString).utf8String, -1, nil) != SQLITE_OK{
            print("Error binding 4")
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            print("Error inserting")
        }
        sqlite3_reset(stmt)
    }
    sqlite3_finalize(stmt)
    sqlite3_close(db)
}

