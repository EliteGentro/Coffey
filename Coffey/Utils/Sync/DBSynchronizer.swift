//
//  DBSynchronize.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 18/11/25.
//

import Foundation
import Combine
import SwiftData

final class DBSynchronizer: ObservableObject {
    @Published var syncProgress : Int = 0
    @Published var isSynchronizing: Bool = false
    @Published var isSynchronized: Bool = false
    
    func fullSynchronization(context: ModelContext) async throws {
        // Start sync
        await MainActor.run {
            self.isSynchronizing = true
            self.syncProgress = 0
            self.isSynchronized = false
        }
        
        // ALWAYS runs — even if an error is thrown before finishing
        defer {
            Task { @MainActor in
                self.isSynchronizing = false
            }
        }
        
        // Declare VMs
        let adminVM = AdminViewModel()
        let contentVM = ContentViewModel()
        let cooperativaVM = CooperativaViewModel()
        let financeVM = FinanceViewModel()
        let preferenceVM = PreferenceViewModel()
        let progressVM = ProgressViewModel()
        let userVM = UserViewModel()
        
        // First sync (no references)
        print("Admin")
        try await adminVM.syncAdmins(using: context)
        await MainActor.run { syncProgress += 14 }
        print("Content")
        try await contentVM.syncContents(using: context)
        await MainActor.run { syncProgress += 14 }
        print("Cooperativa")
        try await cooperativaVM.syncCooperativas(using: context)
        await MainActor.run { syncProgress += 14 }
        print("User")
        try await userVM.syncUsers(using: context)
        await MainActor.run { syncProgress += 14 }
        print("Finance")
        // Dependent objects
        try await financeVM.syncFinances(using: context)
        await MainActor.run { syncProgress += 14 }
        print("Preference")
        try await preferenceVM.syncPreferences(using: context)
        await MainActor.run { syncProgress += 14 }
        print("Progress")
        try await progressVM.syncProgresses(using: context)
        await MainActor.run { syncProgress = 100 }
        
        // If we reach here, sync was successful
        await MainActor.run { self.isSynchronized = true }
    }
}

