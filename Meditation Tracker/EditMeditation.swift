//
//  EditMeditation.swift
//  Meditation Tracker
//
//  Created by Jim Lotruglio on 7/23/23.
//

import Foundation
import SwiftUI

// View to edit a meditation
struct EditMeditation: View{
    @EnvironmentObject var meditationList: MeditationList
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    @Binding var meditation: Meditation
    @State var currentMeditationType: String
    @State var currentMeditationDuration: String
    @State var currentAnxietyLevelPre: String
    @State var currentAnxietyLevelPost: String
    
    // Data for Pickers
    let numOptions = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let durations = ["5", "10", "15", "20", "30+"]
    
    
    var body: some View{
        NavigationView{
            // Edit form for selected meditation
            VStack{
                VStack{
                    Text("Meditation Type: ")
                    TextField(meditation.meditationType, text: $currentMeditationType)
                        .multilineTextAlignment(.center)
                        .border(Color.black, width: 2)
                        .frame(width: 250)
                }
                VStack{
                    Text("Anxiety Level Pre (1-10): ")
                    Picker("", selection: $currentAnxietyLevelPre){
                        ForEach(numOptions, id:\.self){ num in
                            Text(num)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                VStack{
                    Text("Anxiety Level Post (1-10): ")
                    Picker("", selection: $currentAnxietyLevelPost){
                        ForEach(numOptions, id:\.self){ num in
                            Text(num)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                VStack{
                    Text("Meditation Duration (in min): ")
                    Picker("", selection: $currentMeditationDuration){
                        ForEach(durations, id:\.self){ num in
                            Text(num)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Meditation Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                // Cancel will not save user's changes
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                // Save will update user's changes
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save"){
                        meditation.meditationType = currentMeditationType
                        meditation.anxietyLevelPre = currentAnxietyLevelPre
                        meditation.anxietyLevelPost = currentAnxietyLevelPost
                        meditation.meditationDuration = currentMeditationDuration
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        // Write current list to database when closing 
        .onChange(of: scenePhase){ newPhase in
            if newPhase == .active {
                readDatabase(meditations: &meditationList.meditations)
            } else if newPhase == .inactive {
                writeDatabase(meditations: &meditationList.meditations)
            }
        }
    }
}


