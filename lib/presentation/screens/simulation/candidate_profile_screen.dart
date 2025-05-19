import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/screens/dashboard/candidate_dashboard_screen.dart';

import 'package:job_match/presentation/widgets/simulation/transparency_meter.dart';
import 'package:job_match/presentation/widgets/simulation/profile_completion_card.dart';

class CandidateProfileScreen extends StatefulWidget {
  final Map<String, dynamic> candidateData;

  const CandidateProfileScreen({super.key, required this.candidateData});

  @override
  State<CandidateProfileScreen> createState() => _CandidateProfileScreenState();
}

class _CandidateProfileScreenState extends State<CandidateProfileScreen> {
  late Map<String, dynamic> _candidateData;
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _educationController;
  late TextEditingController _experienceController;
  late TextEditingController _locationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final TextEditingController _newProjectController = TextEditingController();
  final TextEditingController _newCertificateController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _candidateData = Map<String, dynamic>.from(widget.candidateData);
    _nameController = TextEditingController(
      text: _candidateData['name'] as String,
    );
    _specialtyController = TextEditingController(
      text: _candidateData['specialty'] as String,
    );
    _educationController = TextEditingController(
      text: _candidateData['education'] as String,
    );
    _experienceController = TextEditingController(
      text: _candidateData['experience'] as String,
    );
    _locationController = TextEditingController(
      text: _candidateData['location'] as String,
    );
    _emailController = TextEditingController(
      text: _candidateData['email'] as String,
    );
    _phoneController = TextEditingController(
      text: _candidateData['phone'] as String,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _newProjectController.dispose();
    _newCertificateController.dispose();
    super.dispose();
  }

  void _updateTransparencyScore() {
    // Simulated logic to update transparency score based on profile completeness
    setState(() {
      if (_candidateData['transparencyScore'] < 100) {
        _candidateData['transparencyScore'] += 15;
        if (_candidateData['transparencyScore'] > 100) {
          _candidateData['transparencyScore'] = 100;
        }
      }
    });
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Añadir Proyecto'),
            content: TextField(
              controller: _newProjectController,
              decoration: const InputDecoration(
                labelText: 'Descripción del proyecto',
                hintText:
                    'Ej: Campaña de comunicación para lanzamiento de producto',
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_newProjectController.text.isNotEmpty) {
                    setState(() {
                      if (_candidateData['projects'] == null) {
                        _candidateData['projects'] = [];
                      }
                      (_candidateData['projects'] as List).add(
                        _newProjectController.text,
                      );
                      _updateTransparencyScore();
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Proyecto añadido con éxito'),
                      ),
                    );
                  }
                },
                child: const Text('Añadir'),
              ),
            ],
          ),
    );
  }

  void _showAddCertificateDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Añadir Certificado'),
            content: TextField(
              controller: _newCertificateController,
              decoration: const InputDecoration(
                labelText: 'Nombre del certificado',
                hintText: 'Ej: Certificado en Comunicación Estratégica',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_newCertificateController.text.isNotEmpty) {
                    setState(() {
                      if (_candidateData['certificates'] == null) {
                        _candidateData['certificates'] = [];
                      }
                      (_candidateData['certificates'] as List).add(
                        _newCertificateController.text,
                      );
                      _updateTransparencyScore();
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Certificado añadido con éxito'),
                      ),
                    );
                  }
                },
                child: const Text('Añadir'),
              ),
            ],
          ),
    );
  }

  void _navigateToDashboard() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                CandidateDashboardScreen(candidateData: _candidateData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: _navigateToDashboard,
            tooltip: 'Ir al Dashboard',
          ),
        ],
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Container(
          color: Colors.grey.shade50,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildProfileForm()),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        TransparencyMeter(
                          score: _candidateData['transparencyScore'],
                        ),
                        const SizedBox(height: 20),
                        ProfileCompletionCard(
                          completionPercentage:
                              _candidateData['transparencyScore'],
                          onAddProject: _showAddProjectDialog,
                          onAddCertificate: _showAddCertificateDialog,
                        ),
                        const SizedBox(height: 20),
                        _buildSkillsSection(),
                        if (_candidateData['projects'] != null &&
                            (_candidateData['projects'] as List)
                                .isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _buildProjectsSection(),
                        ],
                        if (_candidateData['certificates'] != null &&
                            (_candidateData['certificates'] as List)
                                .isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _buildCertificatesSection(),
                        ],
                        const SizedBox(height: 20),
                        _buildBadgesSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToDashboard,
        icon: const Icon(Icons.search),
        label: const Text('Explorar Trabajos'),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                _nameController.text.isNotEmpty
                    ? _nameController.text.substring(0, 1)
                    : 'J',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _specialtyController.text,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _locationController.text,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('CV descargado: CV_Julio_Cesar_Nima.pdf'),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Descargar CV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Personal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _specialtyController,
              decoration: const InputDecoration(
                labelText: 'Especialidad',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _educationController,
              decoration: const InputDecoration(
                labelText: 'Educación',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _experienceController,
              decoration: const InputDecoration(
                labelText: 'Experiencia',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.history),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _candidateData['name'] = _nameController.text;
                    _candidateData['specialty'] = _specialtyController.text;
                    _candidateData['education'] = _educationController.text;
                    _candidateData['experience'] = _experienceController.text;
                    _candidateData['location'] = _locationController.text;
                    _candidateData['email'] = _emailController.text;
                    _candidateData['phone'] = _phoneController.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil actualizado con éxito'),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Guardar Cambios'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Habilidades',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    // Skill adding functionality would go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidad de añadir habilidad'),
                      ),
                    );
                  },
                  tooltip: 'Añadir habilidad',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  (_candidateData['skills'] as List).map<Widget>((skill) {
                    return Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blue.shade100,
                      labelStyle: TextStyle(color: Colors.blue.shade800),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        // Skill removal functionality would go here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$skill eliminado')),
                        );
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Proyectos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _showAddProjectDialog,
                  tooltip: 'Añadir proyecto',
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...(_candidateData['projects'] as List).map<Widget>((project) {
              return ListTile(
                leading: Icon(Icons.folder, color: Colors.amber.shade700),
                title: Text(project),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() {
                      (_candidateData['projects'] as List).remove(project);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proyecto eliminado')),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificatesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Certificados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _showAddCertificateDialog,
                  tooltip: 'Añadir certificado',
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...(_candidateData['certificates'] as List).map<Widget>((
              certificate,
            ) {
              return ListTile(
                leading: Icon(Icons.verified, color: Colors.green.shade700),
                title: Text(certificate),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() {
                      (_candidateData['certificates'] as List).remove(
                        certificate,
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Certificado eliminado')),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection() {
    final List badges = _candidateData['badges'] ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insignias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (badges.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Aún no tienes insignias',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completa cursos y desafíos para ganar insignias',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children:
                    badges.map<Widget>((badge) {
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.purple.shade100,
                          child: Icon(
                            Icons.emoji_events,
                            size: 16,
                            color: Colors.purple.shade700,
                          ),
                        ),
                        label: Text(badge),
                        backgroundColor: Colors.purple.shade50,
                        labelStyle: TextStyle(color: Colors.purple.shade700),
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
