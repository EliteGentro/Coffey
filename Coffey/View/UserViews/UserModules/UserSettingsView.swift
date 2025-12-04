
//
//  UserFinancesView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct UserSettingsView: View {
    let user : User
    @Environment(\.modelContext) private var context
    @EnvironmentObject var fontSettings: FontSettings

    @Query private var preferences: [Preference]
    @State private var tempMultiplier: Double = 1.0
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""


    
    init(user: User) {
        self.user = user
        let user_uuid = user.id
        let user_id = user.user_id
        // Build the predicate *before* assigning it to the Query
        if user.user_id == 0 {
            // Offline user → filter by local UUID
            self._preferences = Query(filter: #Predicate<Preference> { pref in
                pref.local_user_reference == user_uuid
            })
        } else {
            // Synced user → filter by global user_id
            self._preferences = Query(filter: #Predicate<Preference> { pref in
                pref.user_id == user_id
            })
        }

    }
    
    
    
    var body: some View {
        ZStack{
            Color.beige.ignoresSafeArea()
        VStack(spacing: 24) {
            if let preference = preferences.first {
                Slider(
                    value: $tempMultiplier,
                    in: 1.0...3.0,
                    step: 0.5
                )
                .padding()

                Text("Font multiplier: \(tempMultiplier, specifier: "%.2f")")
                    .font(.system(size: 18 * fontSettings.multiplier))

                Button("Apply") {
                    preference.font_multiplier = tempMultiplier
                    preference.updatedAt = Date()
                    fontSettings.multiplier = CGFloat(tempMultiplier)
                    do {
                        try context.save()
                    } catch {
                        errorMessage = "Error al guardar: \(error.localizedDescription)"
                        showErrorAlert = true
                    }
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("Loading preferences...")
            }
        }
        .padding(40)
        .onAppear {
            // Initialize tempMultiplier from existing preference
            if let preference = preferences.first {
                tempMultiplier = preference.font_multiplier
            }
        }
        .padding(40)
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        
        }
    }
    
}

#Preview {
    UserSettingsView(user : User.mockUsers[0])
        .withPreviewSettings()
}
