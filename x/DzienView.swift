//
//  View1.swift
//  x
//
//  Created by Jakub Górka on 23/10/2022.
//

import SwiftUI

struct DzienView: View {
    
    @ObservedObject var system: System
    
    var body: some View {
        VStack(spacing: 0){
            Spacer()                
                
            PickedDayView(day: system.returnDay(selectedId: system.pickedDay), user: system.user)
                      
            Picker("Wybrany dzień", selection: $system.pickedDay) {
                ForEach(system.days) { day in
                    Text(day.id)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.horizontal, 30)
        }
        .ignoresSafeArea()
    }
}

struct DzienView_Previews: PreviewProvider {
    static var previews: some View {
        DzienView(system: System())
    }
}
