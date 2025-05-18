import 'package:flutter/material.dart';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/domain/models/applied_job_model.dart';
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/data/mock_data.dart';
import 'package:job_match/presentation/widgets/simulation/notification_overlay.dart';
import 'package:job_match/presentation/widgets/simulation/job_card_with_fit.dart';
import 'package:job_match/presentation/widgets/simulation/chatbot_widget.dart';
import 'package:job_match/presentation/screens/simulation/micro_course_screen.dart';

class CandidateDashboardScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? candidateData;

  const CandidateDashboardScreen({super.key, this.candidateData});

  @override
  ConsumerState<CandidateDashboardScreen> createState() =>
      _CandidateDashboardScreenState();
}

class _CandidateDashboardScreenState
    extends ConsumerState<CandidateDashboardScreen> {
  String _selectedMenu = 'Overview';
  int _currentPage = 1;
  final int _totalPages = 5;
  bool _showNotification = false;
  String _notificationMessage = '';
  int _notificationFitPercentage = 0;
  bool _showChatbot = false;
  bool _applicationAccepted = false;

  @override
  void initState() {
    super.initState();
    // Simulate receiving notification after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showNotification = true;
          _notificationMessage =
              'JobMatch publicó "Especialista en Comunicaciones"';
          _notificationFitPercentage = 92;
        });

        // Hide notification after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _showNotification = false;
            });
          }
        });
      }
    });

    // Show chatbot after a delay
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showChatbot = true;
        });
      }
    });
  }

  void _showApplicationSuccessMessage() {
    setState(() {
      _showNotification = true;
      _notificationMessage = '¡Postulación enviada con éxito!';
      _notificationFitPercentage = 100;
    });

    // Hide notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showNotification = false;
        });
      }
    });

    // Show chatbot with specific message after application
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showChatbot = true;
        });
      }
    });
  }

  void _showAcceptedDialog() {
    setState(() {
      _applicationAccepted = true;
    });

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                const Text('¡Felicitaciones!'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tu postulación fue ACEPTADA.'),
                SizedBox(height: 16),
                Text(
                  'El equipo de JobMatch se pondrá en contacto contigo para coordinar los siguientes pasos.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Here you would navigate to a details screen about the job
                },
                child: const Text('Ver Detalles'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Solo usa providers existentes de supabase_http_requests.dart
    final applicationsAsync = ref.watch(applicationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              // AppIdentityBar con botón de atrás
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.blue),
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'Atrás',
                    ),
                    Expanded(child: AppIdentityBar(height: 80)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    // Left side: Selector Menu
                    FadeInLeft(
                      duration: const Duration(milliseconds: 700),
                      child: Container(
                        width: 260,
                        color: Colors.white,
                        padding: const EdgeInsets.only(top: kPadding20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kPadding16,
                                vertical: kPadding8,
                              ),
                              child: Text(
                                'PANEL DEL CANDIDATO',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: kSpacing8),
                            ...[
                              _buildMenuItem(
                                icon: Icons.layers_outlined,
                                title: 'Resumen',
                                isSelected: _selectedMenu == 'Overview',
                                onTap:
                                    () => setState(
                                      () => _selectedMenu = 'Overview',
                                    ),
                              ),
                              _buildMenuItem(
                                icon: Icons.work_outline,
                                title: 'Trabajos Aplicados',
                                isSelected: _selectedMenu == 'Applied Jobs',
                                onTap:
                                    () => setState(
                                      () => _selectedMenu = 'Applied Jobs',
                                    ),
                              ),
                              _buildMenuItem(
                                icon: Icons.bookmark_border,
                                title: 'Trabajos Favoritos',
                                isSelected: _selectedMenu == 'Favorite Jobs',
                                onTap:
                                    () => setState(
                                      () => _selectedMenu = 'Favorite Jobs',
                                    ),
                              ),
                              _buildMenuItem(
                                icon: Icons.notifications_none_outlined,
                                title: 'Alerta de Trabajo',
                                badgeCount: '01',
                                isSelected: _selectedMenu == 'Job Alert',
                                onTap:
                                    () => setState(
                                      () => _selectedMenu = 'Job Alert',
                                    ),
                              ),
                              _buildMenuItem(
                                icon: Icons.settings_outlined,
                                title: 'Configuración',
                                isSelected: _selectedMenu == 'Settings',
                                onTap:
                                    () => setState(
                                      () => _selectedMenu = 'Settings',
                                    ),
                              ),
                            ].asMap().entries.map((entry) {
                              // Animate each menu item with a slight delay
                              return FadeInLeft(
                                delay: Duration(milliseconds: 80 * entry.key),
                                duration: const Duration(milliseconds: 400),
                                child: entry.value,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    // Right side: Main content area
                    Expanded(
                      flex: 3,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        child:
                            _selectedMenu == 'Overview'
                                ? _buildOverviewContent()
                                : _selectedMenu == 'Applied Jobs'
                                ? applicationsAsync.when(
                                  loading:
                                      () => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  error:
                                      (error, stack) =>
                                          Center(child: Text('Error: $error')),
                                  data:
                                      (applications) =>
                                          _buildAppliedJobsContent(
                                            applications,
                                          ),
                                )
                                : Center(
                                  child: Text(
                                    'Contenido para $_selectedMenu',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Show notification if enabled
          if (_showNotification)
            NotificationOverlay(
              message: _notificationMessage,
              fitPercentage: _notificationFitPercentage,
              onDismiss: () => setState(() => _showNotification = false),
            ),
          // Show chatbot if enabled
          if (_showChatbot)
            ChatbotWidget(
              initialMessage:
                  _applicationAccepted
                      ? '¡Felicidades por tu aceptación en JobMatch! Añade métricas de alcance en tus campañas para brillar en tu nuevo rol.'
                      : '¡Hola Julio! Tu postulación fue registrada. Tip: añade métricas de alcance en tus campañas para brillar.',
            ),
        ],
      ),
    );
  }

  Widget _buildOverviewContent() {
    // Use simulated component for course recommendation
    final course = MockCourses.courses.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: const Text(
              'Hola, Julio César Nima',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222B45),
              ),
            ),
          ),
          const SizedBox(height: kSpacing8),
          FadeIn(
            duration: const Duration(milliseconds: 700),
            child: Text(
              'Aquí están tus actividades diarias y alertas de trabajo.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: kSpacing20 + kSpacing4),
          Row(
            children: <Widget>[
              FadeInLeft(
                duration: const Duration(milliseconds: 700),
                child: Expanded(
                  child: _buildSummaryCard(
                    count: '1',
                    label: 'Trabajos Aplicados',
                    icon: Icons.work_outline,
                    iconColor: Colors.blue.shade700,
                    backgroundColor: Colors.blue.shade50.withOpacity(0.5),
                    iconBackgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: kSpacing20),
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Expanded(
                  child: _buildSummaryCard(
                    count: '2',
                    label: 'Trabajos Favoritos',
                    icon: Icons.bookmark_border,
                    iconColor: Colors.orange.shade700,
                    backgroundColor: Colors.orange.shade50.withOpacity(0.5),
                    iconBackgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: kSpacing20),
              FadeInRight(
                duration: const Duration(milliseconds: 700),
                child: Expanded(
                  child: _buildSummaryCard(
                    count: '1',
                    label: 'Alertas de Trabajo',
                    icon: Icons.notifications_none_outlined,
                    iconColor: Colors.green.shade700,
                    backgroundColor: Colors.green.shade50.withOpacity(0.5),
                    iconBackgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing20 + kSpacing4),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 700),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.purple.shade100,
                        child: Icon(
                          Icons.school,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mejora tu Fit: Storytelling Avanzado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Incrementa tu match en un ${course['fitBoost']}% completando este curso',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Aprende técnicas avanzadas de storytelling para destacar tus habilidades de comunicación en el entorno laboral.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Duración: ${course['duration']}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      MicroCourseScreen(course: course),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Comenzar Ahora'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kSpacing20),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 700),
            child: const Text(
              'Trabajos Recomendados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222B45),
              ),
            ),
          ),
          const SizedBox(height: kSpacing12),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 700),
            child: JobCardWithFit(
              title: 'Especialista en Comunicaciones',
              company: 'JobMatch Recruiting',
              location: 'Lima, Perú',
              timeAgo: 'hace 2 horas',
              fitPercentage: 92,
              fitReasons: [
                '+50% por experiencia en PR',
                '+42% por Storytelling',
              ],
            ),
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 700),
            child: JobCardWithFit(
              title: 'Content Manager',
              company: 'Digital Solutions',
              location: 'Lima, Perú',
              timeAgo: 'hace 1 día',
              fitPercentage: 78,
              fitReasons: ['+50% por comunicación', '+28% por estrategia'],
            ),
          ),
          const SizedBox(height: kSpacing30 + kSpacing4),
        ],
      ),
    );
  }

  Widget _buildAppliedJobsContent(List<Map<String, dynamic>> applications) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trabajos Aplicados',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222B45),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Descargar PDF'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Aplicaciones exportadas a PDF'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kSpacing20),
          // "Especialista en Comunicaciones" job application with accepted status
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      _applicationAccepted
                          ? Colors.green.shade200
                          : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'JM',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Especialista en Comunicaciones',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'JobMatch Recruiting • Lima, Perú',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _applicationAccepted
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _applicationAccepted ? 'Aceptado' : 'Pendiente',
                          style: TextStyle(
                            color:
                                _applicationAccepted
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aplicado:',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const Text(
                              '14 Junio, 2024',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Match:',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.analytics_outlined,
                                  size: 16,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '92%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!_applicationAccepted)
                        ElevatedButton(
                          onPressed: _showAcceptedDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Simular Aceptación'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kSpacing20 + kSpacing4),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: _buildPaginationControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? badgeCount,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    final Color selectedColor = Colors.blue.shade700;
    final Color unselectedColor = Colors.grey.shade600;
    final Color itemColor = isSelected ? selectedColor : unselectedColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: kPadding12,
          horizontal: kPadding16,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.blue.withOpacity(0.08) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? selectedColor : Colors.transparent,
              width: kStroke3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: kIconSize20),
            const SizedBox(width: kSpacing12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: itemColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
            if (badgeCount != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding8,
                  vertical: kSpacing4 / 2,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? selectedColor
                          : Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(kRadius12),
                ),
                child: Text(
                  badgeCount,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String count,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color iconBackgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(kPadding20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kRadius12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: iconColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: kSpacing4),
              Text(
                label,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
          Container(
            padding: kPaddingAll12,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(kRadius8),
            ),
            child: Icon(icon, color: iconColor, size: kIconSize24),
          ),
        ],
      ),
    );
  }

  // Pagination controls for applied jobs
  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color:
                _currentPage > 1 ? Colors.blue.shade700 : Colors.grey.shade400,
            size: kIconSize16,
          ),
          onPressed:
              _currentPage > 1
                  ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                  : null,
        ),
        for (int i = 1; i <= _totalPages; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: kSpacing4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    i == _currentPage ? Colors.blue.shade700 : Colors.white,
                foregroundColor:
                    i == _currentPage ? Colors.white : Colors.grey.shade700,
                padding: EdgeInsets.zero,
                minimumSize: const Size(36, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kRadius4),
                  side: BorderSide(
                    color:
                        i == _currentPage
                            ? Colors.blue.shade700
                            : Colors.grey.shade300,
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  _currentPage = i;
                });
              },
              child: Text('$i'),
            ),
          ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            color:
                _currentPage < _totalPages
                    ? Colors.blue.shade700
                    : Colors.grey.shade400,
            size: kIconSize16,
          ),
          onPressed:
              _currentPage < _totalPages
                  ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                  : null,
        ),
      ],
    );
  }
}
