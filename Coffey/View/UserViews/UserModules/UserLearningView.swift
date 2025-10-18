
//
//  UserFinancesView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct UserLearningView: View {
    let user : User
    let filters = ["Pendiente","En Progreso","Terminados"]
    @State private var selectedFilter : String = "Pendiente"
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Picker("Filtrar Contenido", selection: $selectedFilter){
                        ForEach(filters, id:\.self){filter in
                            Text(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                        ForEach(Content.mockContents){content in
                            NavigationLink(destination: DetailContentUserView(content: content)) {
                                MenuCellView(systemName: content.resourceType == "video" ? "video.fill" : "book.fill", title: content.name)
                            }
                        }
                        
                    }
                    
                }
                .padding(20)
            }
        }
            .navigationTitle("Contenidos de Aprendizaje")
            .navigationBarTitleDisplayMode( .inline )
        
    }
}

#Preview {
    UserLearningView(user : User.mockUsers[0])
}
