
//
//  UserFinancesView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI

struct UserLearningView: View {
    // The user whose learning content is displayed
    let user: User
    // Filters for content status
    let filters = ["Pendiente", "En Progreso", "Terminados"]
    @State private var selectedFilter: String = "Pendiente"

    var body: some View {
        ScrollView {
            VStack {
                // Segmented picker to filter content
                Picker("Filtrar Contenido", selection: $selectedFilter) {
                    ForEach(filters, id: \.self) { filter in
                        Text(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Grid of learning content
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(Content.mockContents) { content in
                        // Navigate to detailed content view on tap
                        NavigationLink(destination: DetailContentUserView(content: content)) {
                            MenuCellView(
                                systemName: content.resourceType == "video" ? "video.fill" : "book.fill",
                                title: content.name
                            )
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Contenidos de Aprendizaje")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Wrap in NavigationStack because view contains NavigationLinks
    NavigationStack {
        UserLearningView(user: User.mockUsers[0])
    }
}
