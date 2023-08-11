//
//  ContentView.swift
//  Meditation Tracker
//
//  Created by Jim Lotruglio on 7/22/23.
//

import SwiftUI

struct ContentView: View {
    // Request user permissions the first time app loads
    init(){
        requestPermission()
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var meditationList: MeditationList
    @State private var showForm = false
    @State private var showScheduler = false
    
    var body: some View {
            NavigationView{
                VStack{
                    Text("Meditations")
                        .font(.title)
                        .bold()
                    // List all meditations currently in the database
                List{
                    let meditationIndices = meditationList.meditations.indices
                    let meditationIndexPairs = Array(zip(meditationList.meditations, meditationIndices))
                    ForEach(meditationIndexPairs, id:\.0.id, content: {
                        meditation, meditationIndex in
                        let bindingMeditation = $meditationList.meditations[meditationIndex]
                        NavigationLink(destination: EditMeditation(meditation: bindingMeditation, currentMeditationType: meditation.meditationType, currentMeditationDuration: meditation.meditationDuration, currentAnxietyLevelPre: meditation.anxietyLevelPre, currentAnxietyLevelPost: meditation.anxietyLevelPost)){
                            HStack{
                                Text(meditation.meditationType + ":")
                                Text(meditation.meditationDuration + " min")
                            }
                        }
                    }).onDelete(perform: {
                        IndexSet in meditationList.meditations.remove(atOffsets: IndexSet)
                    })
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("Schedule Reminder"){
                            showScheduler = true
                        }
                        .fullScreenCover(isPresented: $showScheduler){
                            ScheduleReminder()
                        }
                        .accessibilityAddTraits(.isHeader)
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button("Add"){
                            showForm = true
                        }
                        .fullScreenCover(isPresented: $showForm){
                            AddNewMeditation()
                        }
                    }
                }
            }
        }
        // Fetches data when app is started
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let meditationList = MeditationList()
        ContentView()
            .environmentObject(meditationList)
    }
}
