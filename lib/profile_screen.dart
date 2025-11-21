import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Perfil de Daniel Zamorano
            _buildProfileCard(),
            const SizedBox(height: 25),
            
            // Información de reconocimiento
            _buildRecognitionInfo(),
            const SizedBox(height: 25),
            
            // Configuración
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[100],
              border: Border.all(color: Colors.blue, width: 3),
            ),
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          
          // Nombre
          const Text(
            'Daniel Zamorano',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          
          // Rol
          const Text(
            'Usuario Principal',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          
          // Estadísticas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProfileStat('98%', 'Precisión'),
              _buildProfileStat('156', 'Reconocimientos'),
              _buildProfileStat('100%', 'Confianza'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRecognitionInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.face_retouching_natural, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Información de Reconocimiento',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            '• Perfil facial registrado y verificado\n'
            '• Alto nivel de confianza en detecciones\n'
            '• Sistema optimizado para tu rostro\n'
            '• Actualizaciones automáticas del modelo',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuración',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingsOption(Icons.notifications, 'Notificaciones', true),
          _buildSettingsOption(Icons.security, 'Modo seguro', false),
          _buildSettingsOption(Icons.history, 'Guardar historial', true),
          _buildSettingsOption(Icons.auto_awesome, 'Detección automática', true),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(IconData icon, String title, bool value) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.blue),
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        // Aquí manejarías el cambio de configuración
      },
    );
  }
}