//
//  ContentView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 16/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var resetID = UUID() // unique ID to rebuild NavigationStack
    @State var letterSizeMultiplier : CGFloat = 1.5
    @AppStorage("firstTime") var firstTime: Bool = true
    
    var body: some View {
        NavigationStack(path: $path) {
            
            if(firstTime){
                FirstWelcomeView()
            } else{
                SelectAdminView(path: $path, onReset: resetNavigation)
            }
            
            
        }
        .id(resetID) // key trick — rebuilds NavigationStack when resetID changes
    }
    
    private func resetNavigation() {
        resetID = UUID()       // force NavigationStack to rebuild
        path = NavigationPath() // reset any residual path state
    }
}
#Preview {
    ContentView()
    
}
