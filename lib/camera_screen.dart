import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/face_detection_service.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  final FaceDetectionService _detectionService = FaceDetectionService();
  bool _isDetecting = false;
  List<dynamic> _recognitions = [];
  late List<CameraDescription> _cameras;
  Timer? _detectionTimer;

  // Base de datos de rostros conocidos
  final Map<String, String> _faceDatabase = {
    'face_1': 'Daniel Zamorano',
  };

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkPermissions();
    await _detectionService.loadModel();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
    
    if (await Permission.camera.isGranted) {
      _initializeCamera();
    } else {
      _showPermissionDenied();
    }
  }

  void _showPermissionDenied() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso requerido'),
        content: const Text('La aplicación necesita acceso a la cámara para funcionar.'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(
        _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        ),
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize().then((_) {
        // Iniciar detección periódica
        _startPeriodicDetection();
      });

      setState(() {});
    } catch (e) {
      print('Error inicializando cámara: $e');
    }
  }

  void _startPeriodicDetection() {
    _detectionTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isDetecting) {
        _performDetection();
      }
    });
  }

  Future<void> _performDetection() async {
    if (_isDetecting) return;
    
    setState(() {
      _isDetecting = true;
    });

    try {
      final detections = await _detectionService.detectFaces();
      setState(() {
        _recognitions = detections;
      });
    } catch (e) {
      print('Error en detección: $e');
    } finally {
      setState(() {
        _isDetecting = false;
      });
    }
  }

  String _getPersonName(String faceId) {
    return _faceDatabase[faceId] ?? 'Desconocido';
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    _controller?.dispose();
    _detectionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconocimiento Facial - SIMULACIÓN'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && _controller != null) {
            return Stack(
              children: [
                CameraPreview(_controller!),
                _buildFaceOverlays(),
                _buildInfoPanel(),
              ],
            );
          } else {
            return _buildLoadingScreen();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _performDetection,
        backgroundColor: _isDetecting ? Colors.grey : Colors.blue,
        child: Icon(
          _isDetecting ? Icons.search_off : Icons.search,
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Inicializando cámara...'),
          Text('Modo simulación activado'),
        ],
      ),
    );
  }

  Widget _buildFaceOverlays() {
    return CustomPaint(
      painter: FaceDetectorPainter(_recognitions, _getPersonName),
      size: Size.infinite,
    );
  }

  Widget _buildInfoPanel() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: Colors.orange,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'MODO SIMULACIÓN - Detección automática cada 2 segundos',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Estado: ${_isDetecting ? 'Detectando...' : 'Listo'}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Rostros detectados: ${_recognitions.length}',
              style: const TextStyle(color: Colors.white),
            ),
            if (_recognitions.isNotEmpty) ...[
              const SizedBox(height: 8),
              ..._recognitions.map((recognition) => Text(
                '👤 ${_getPersonName(recognition['id'])} '
                '(${(recognition['confidence'] * 100).toStringAsFixed(1)}% confianza)',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  final List<dynamic> recognitions;
  final String Function(String) getPersonName;

  FaceDetectorPainter(this.recognitions, this.getPersonName);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (final recognition in recognitions) {
      final bbox = recognition['bbox'] as List<dynamic>;
      final confidence = recognition['confidence'] as double;
      
      // Convertir coordenadas normalizadas a píxeles
      final left = bbox[0] * size.width;
      final top = bbox[1] * size.height;
      final width = bbox[2] * size.width;
      final height = bbox[3] * size.height;

      // Elegir color basado en confianza
      if (confidence > 0.8) {
        paint.color = Colors.green;
      } else if (confidence > 0.6) {
        paint.color = Colors.orange;
      } else {
        paint.color = Colors.red;
      }

      // Dibujar rectángulo
      final rect = Rect.fromLTWH(left, top, width, height);
      canvas.drawRect(rect, paint);

      // Dibujar etiqueta
      _drawLabel(canvas, recognition, rect);
    }
  }

  void _drawLabel(Canvas canvas, dynamic recognition, Rect rect) {
    final text = getPersonName(recognition['id']);
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    // Fondo para la etiqueta
    final backgroundRect = Rect.fromLTWH(
      rect.left,
      rect.top - 25,
      textPainter.width + 8,
      20,
    );
    
    canvas.drawRect(
      backgroundRect,
      Paint()..color = Colors.black.withOpacity(0.7),
    );

    // Texto
    textPainter.paint(
      canvas,
      Offset(rect.left + 4, rect.top - 23),
    );
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.recognitions != recognitions;
  }
}