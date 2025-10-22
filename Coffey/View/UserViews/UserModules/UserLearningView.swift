
//
//  UserFinancesView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI
import SwiftData

struct UserLearningView: View {
    @Environment(\.modelContext) var context
    
    let user: User
    let contents : [Content]
    @Query var progresses: [Progress]


    
    init(user:User){
        self.user = user
        self.contents = Content.mockContents.filter({$0.isDownloaded})
    }
    
    private var filteredContents: [Content] {
        contents.filter { content in
            if let contentProgress = progresses.first(where: {
                $0.user_id == user.user_id && $0.content_id == content.content_id
            }) {
                return contentProgress.status == selectedProgressStatus
            } else {
                return selectedProgressStatus == .notStarted
            }
        }
    }
    
    let filters = ["Pendiente", "En Progreso", "Terminados"]
    @State private var selectedFilter: String = "Pendiente"
    
    
    
    private var selectedProgressStatus: ProgressStatus {
        switch selectedFilter {
        case "Pendiente": return .notStarted
        case "En Progreso": return .inProgress
        case "Terminados": return .completed
        default: return .notStarted
        }
    }
    
    
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
                    ForEach(filteredContents) { content in
                        // Navigate to detailed content view on tap
                        
                        NavigationLink(destination: DetailContentUserView(content: content, user: user)) {
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
