import 'dart:math';

class FaceDetectionService {
  bool _isLoaded = true;
  final Random _random = Random();

  Future<void> loadModel() async {
    // Simular carga de modelo
    await Future.delayed(const Duration(seconds: 1));
    print('Servicio de detección facial inicializado ');
  }

  Future<List<dynamic>> detectFaces() async {
    if (!_isLoaded) {
      throw Exception('Modelo no cargado');
    }

    // Simular procesamiento
    await Future.delayed(const Duration(milliseconds: 500));

    // Generar detecciones aleatorias
    return _generateRandomDetections();
  }

  List<dynamic> _generateRandomDetections() {
    final recognitions = <dynamic>[];
    
    // 60% de probabilidad de detectar rostros
    if (_random.nextDouble() > 0.4) {
      final faceCount = _random.nextInt(2) + 1; // 1-2 rostros
      
      for (int i = 0; i < faceCount; i++) {
        final faceId = 'face_${_random.nextInt(4) + 1}';
        final confidence = 0.7 + _random.nextDouble() * 0.3;
        
        recognitions.add({
          'id': faceId,
          'confidence': confidence,
          'bbox': [
            0.2 + _random.nextDouble() * 0.6, // x
            0.2 + _random.nextDouble() * 0.6, // y  
            0.1 + _random.nextDouble() * 0.2, // width
            0.1 + _random.nextDouble() * 0.2, // height
          ],
        });
      }
    }
    
    return recognitions;
  }

  void dispose() {
    print('Servicio de detección facial cerrado');
  }
}