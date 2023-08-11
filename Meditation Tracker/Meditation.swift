//
//  Meditation.swift
//  Meditation Tracker
//
//  Created by Jim Lotruglio on 7/22/23.
//

import Foundation

// Describes a Meditation
struct Meditation: Identifiable{
    let id = UUID()
    var anxietyLevelPre: String
    var anxietyLevelPost: String
    var meditationType: String
    var meditationDuration: String
    
}

class MeditationList: ObservableObject{
    @Published var meditations = [Meditation]()
}


