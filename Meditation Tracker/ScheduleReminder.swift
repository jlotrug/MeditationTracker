//
//  ScheduleReminder.swift
//  Meditation Tracker
//
//  Created by Jim Lotruglio on 8/11/23.
//

import SwiftUI

// View so user can choose time of day they will be reminded to meditate
struct ScheduleReminder: View {
    @State private var reminderTime = Date.now
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var meditationList: MeditationList
    
    var body: some View {
        NavigationView{
            VStack{
                // User can select time they want to be reminded
                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                // Schedules notification time
                Button("Select Time"){
                    scheduleNotifications(selectedDate: reminderTime)
                    dismiss()
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Schedule A Reminder")
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
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

struct ScheduleReminder_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleReminder()
    }
}
