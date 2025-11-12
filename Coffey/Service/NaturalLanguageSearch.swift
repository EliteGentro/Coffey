import SwiftUI
import FoundationModels

final class NaturalLanguageSearchService: ObservableObject {
  // Modelo de embeddings (singleton, se carga una sola vez)
  private let embedder = try! OnDeviceEmbeddingModel(configuration: .init())
  private let reranker = try? OnDeviceLLM(configuration: .init())
  @Published private(set) var contentVectors: [(content: Content, vector: [Float])] = []

  func index(contents: [Content]) async { // Para indexar nuevos contenidos en la base de datos vectorial
    var vectors: [(Content, [Float])] = []

    for c in contents {
      let text = c.title + "\t" + c.body
      let emb = try? await embedder.embed(text: text)

      if let vec = emb?.values {
        vectors.append((c, vec))
      }
    }

    DispatchQueue.main.async {
      self.contentVectors = vectors
    }
  }

  func search(query: String, topK: Int = 5) async -> [Content] {
    guard let queryEmbedding = try? await embedder.embed(text: query)?.values else {
      return []
    }

    // Calcular similitud coseno entre la consulta y los vectores indexados
    let similarities = contentVectors.map { (content, vector) -> (Content, Float) in
      let sim = cosineSimilarity(vec1: queryEmbedding, vec2: vector)
      return (content, sim)
    }

    // Ordenar por similitud y obtener los top K resultados
    let topResults = similarities.sorted(by: { $0.1 > $1.1 }).prefix(topK).map { $0.0 }

    // Opcional: Re-rankear resultados usando LLM
    if let reranker = reranker {
      let rerankedResults = try? await reranker.rerank(query: query, contents: topResults)
      return rerankedResults ?? topResults
    } else {
      return topResults
    }
  }
}