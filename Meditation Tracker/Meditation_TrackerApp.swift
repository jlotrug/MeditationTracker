//
//  Meditation_TrackerApp.swift
//  Meditation Tracker
//
//  Created by Jim Lotruglio on 7/22/23.
//

import SwiftUI

@main
struct Meditation_TrackerApp: App {
    @StateObject private var meditationList = MeditationList()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(meditationList)
        }
    }
}
