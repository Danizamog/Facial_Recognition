import 'dart:math' as Math;

class FaceRecognitionModel {
  final String id;
  final String name;
  final double confidence;
  final List<double> embedding;
  final DateTime timestamp;

  FaceRecognitionModel({
    required this.id,
    required this.name,
    required this.confidence,
    required this.embedding,
    required this.timestamp,
  });

  factory FaceRecognitionModel.fromJson(Map<String, dynamic> json) {
    return FaceRecognitionModel(
      id: json['id'],
      name: json['name'],
      confidence: json['confidence']?.toDouble() ?? 0.0,
      embedding: List<double>.from(json['embedding'] ?? []),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'confidence': confidence,
      'embedding': embedding,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class FaceDatabase {
  final Map<String, FaceRecognitionModel> _faces = {};

  void addFace(FaceRecognitionModel face) {
    _faces[face.id] = face;
  }

  String? identifyFace(List<double> embedding, {double threshold = 0.8}) {
    for (final face in _faces.values) {
      final similarity = _calculateSimilarity(embedding, face.embedding);
      if (similarity >= threshold) {
        return face.name;
      }
    }
    return null;
  }

  double _calculateSimilarity(List<double> emb1, List<double> emb2) {
    // Calcular similitud coseno entre embeddings
    if (emb1.length != emb2.length) return 0.0;

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < emb1.length; i++) {
      dotProduct += emb1[i] * emb2[i];
      norm1 += emb1[i] * emb1[i];
      norm2 += emb2[i] * emb2[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) return 0.0;

    return dotProduct / (Math.sqrt(norm1) * Math.sqrt(norm2));
  }
}