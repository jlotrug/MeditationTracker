//
//  AddNewMeditation.swift
//  Meditation Tracker
//
//  Created by Jim Lotruglio on 8/7/23.
//

import SwiftUI

// View to create a new meditation
struct AddNewMeditation: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var meditationList: MeditationList
    @State var anxietyLevelPre = ""
    @State var anxietyLevelPost = ""
    @State var meditationType = ""
    @State var meditationDuration = ""
    
    // Data for Pickers
    let numOptions = ["1", "2", "3", "4", "5"]
    let durations = ["5", "10", "15", "20", "30+"]
    
    // Function that adds new meditation to list when saved
    func addToMeditations(newMeditation: Meditation){
        meditationList.meditations.append(newMeditation)
    }
    
    var body: some View {
        NavigationView{
            // Blank form for a new meditation
            VStack{
                VStack{
                    Text("Meditation Type: ")
                    TextField(meditationType, text: $meditationType)
                        .multilineTextAlignment(.center)
                        .border(Color.black, width: 2)
                        .frame(width: 250)
                }
                VStack{
                    Text("Anxiety Level Pre (1-5): ")
                    Picker("", selection: $anxietyLevelPre){
                        ForEach(numOptions, id:\.self){ num in
                            Text(num)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                VStack{
                    Text("Anxiety Level Post (1-5): ")
                    Picker("", selection: $anxietyLevelPost){
                        ForEach(numOptions, id:\.self){ num in
                            Text(num)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                VStack{
                    Text("Meditation Duration (in min): ")
                    Picker("", selection: $meditationDuration){
                        ForEach(durations, id:\.self){ num in
                            Text(num)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Add New Meditation")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar{
                // Cancel will not add new meditation to the collection
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                // Save will add new meditation to the collection
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save"){
                        let newMeditation = Meditation(anxietyLevelPre: anxietyLevelPre, anxietyLevelPost: anxietyLevelPost, meditationType: meditationType, meditationDuration: meditationDuration)
                        addToMeditations(newMeditation: newMeditation)
                        dismiss()
                    }
                }
            }
        }
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

struct AddNewMeditation_Previews: PreviewProvider {
    static var previews: some View {
        AddNewMeditation()
    }
}
