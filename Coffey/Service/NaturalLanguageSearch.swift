final class NaturalLanguageSearchService: ObservableObject {
  // Modelo de embeddings (singleton, se carga una sola vez)
  private let embedder = try! OnDeviceEmbeddingModel(configuration: .init())
  private let reranker = try? OnDeviceLLM(configuration: .init())
  @Published private(set) var contentVectors: [(content: Content, vector: [Float])] = []

  func index(contents: [Content]) async {
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
}