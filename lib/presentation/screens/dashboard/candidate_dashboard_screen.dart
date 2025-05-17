import 'package:flutter/material.dart';
import 'dart:math'; // Para generar números aleatorios
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/models/applied_job_model.dart';

class CandidateDashboardScreen extends StatefulWidget {
  const CandidateDashboardScreen({super.key});

  @override
  State<CandidateDashboardScreen> createState() =>
      _CandidateDashboardScreenState();
}

class _CandidateDashboardScreenState extends State<CandidateDashboardScreen> {
  String _selectedMenu = 'Overview';
  final Random _random = Random();
  int _currentPage = 1;
  final int _totalPages = 5; // Ejemplo de total de páginas

  // Mock data for recently applied jobs - Communications field
  // Esta lista se usará tanto para Overview como para Applied Jobs por ahora
  late List<AppliedJob> _allAppliedJobs;

  @override
  void initState() {
    super.initState();
    _allAppliedJobs = [
      AppliedJob(
        companyLogoAsset: 'assets/images/job_match.jpg',
        jobTitle: 'Especialista en Comunicación Corporativa',
        jobType: 'Remoto',
        companyName: 'Soluciones Creativas SA',
        location: 'Lima, Perú',
        salary: 'S/5k-7k/mes',
        dateApplied: 'Feb 2, 2024 10:30',
        status: 'Activo',
        logoBackgroundColor: Colors.green.shade400,
        matchPercentage: _random.nextInt(41) + 60, // 60-100%
      ),
      AppliedJob(
        companyLogoAsset: 'assets/images/job_match.jpg',
        jobTitle: 'Content Manager Jr.',
        jobType: 'Tiempo Completo',
        companyName: 'Media Pro Network',
        location: 'Arequipa, Perú',
        salary: 'S/3k-4k/mes',
        dateApplied: 'Ene 15, 2024 14:20',
        status: 'Activo',
        logoBackgroundColor: Colors.pink.shade300,
        matchPercentage: _random.nextInt(41) + 60,
      ),
      AppliedJob(
        companyLogoAsset: 'assets/images/job_match.jpg',
        jobTitle: 'Analista de Redes Sociales',
        jobType: 'Temporal',
        companyName: 'Digital Impact Agency',
        location: 'Trujillo, Perú',
        salary: 'S/2.5k-3.5k/mes',
        dateApplied: 'Ene 5, 2024 09:00',
        status: 'Activo',
        logoBackgroundColor: Colors.grey.shade700,
        matchPercentage: _random.nextInt(41) + 60,
      ),
      AppliedJob(
        companyLogoAsset: 'assets/images/job_match.jpg',
        jobTitle: 'Redactor Creativo Publicitario',
        jobType: 'Por Contrato',
        companyName: 'Ideas Frescas Co.',
        location: 'Cusco, Perú',
        salary: 'S/4k-6k/mes',
        dateApplied: 'Dic 20, 2023 18:00',
        status: 'Activo',
        logoBackgroundColor: Colors.lightBlue.shade300,
        isHighlighted: true,
        matchPercentage: _random.nextInt(41) + 60,
      ),
      // Añadir más trabajos para simular paginación si es necesario
      AppliedJob(
        companyLogoAsset: 'assets/images/job_match.jpg',
        jobTitle: 'Coordinador de Eventos y RRPP',
        jobType: 'Tiempo Completo',
        companyName: 'Global Connect',
        location: 'Lima, Perú',
        salary: 'S/4.5k-6.5k/mes',
        dateApplied: 'Nov 10, 2023 11:00',
        status: 'Activo',
        logoBackgroundColor: Colors.purple.shade300,
        matchPercentage: _random.nextInt(41) + 60,
      ),
    ];
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
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(kRadius4),
                ),
                child: Text(
                  badgeCount,
                  style: TextStyle(
                    color: selectedColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4), // kPadding24
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Hola, Julio Cesar Nima',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222B45),
            ),
          ),
          const SizedBox(height: kSpacing8),
          Text(
            'Aquí están tus actividades diarias y alertas de trabajo.', // Traducción
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: kSpacing20 + kSpacing4), // kSpacing24
          Row(
            children: <Widget>[
              Expanded(
                child: _buildSummaryCard(
                  count: '589',
                  label: 'Trabajos Aplicados', // Traducción
                  icon: Icons.work_outline,
                  iconColor: Colors.blue.shade700,
                  backgroundColor: Colors.blue.shade50.withOpacity(0.5),
                  iconBackgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: kSpacing20),
              Expanded(
                child: _buildSummaryCard(
                  count: '238',
                  label: 'Trabajos Favoritos', // Traducción
                  icon: Icons.bookmark_border,
                  iconColor: Colors.orange.shade700,
                  backgroundColor: Colors.orange.shade50.withOpacity(0.5),
                  iconBackgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: kSpacing20),
              Expanded(
                child: _buildSummaryCard(
                  count: '574',
                  label: 'Alertas de Trabajo', // Traducción
                  icon: Icons.notifications_none_outlined,
                  iconColor: Colors.green.shade700,
                  backgroundColor: Colors.green.shade50.withOpacity(0.5),
                  iconBackgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing20 + kSpacing4), // kSpacing24
          _buildRecommendedCourseSection(),
          const SizedBox(height: kSpacing30 + kSpacing4),
          _buildJobsTableSection(
            title: 'Aplicaciones Recientes',
            jobs: _allAppliedJobs.take(4).toList(), // Mostrar solo algunos en overview
            showViewAllButton: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAppliedJobsContent() {
    // Simular paginación: aquí podrías tener lógica para cargar diferentes trabajos por página
    // Por ahora, mostramos todos los trabajos de la lista _allAppliedJobs
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4), // kPadding24
      child: Column(
        children: [
          _buildJobsTableSection(
            title: 'Trabajos Aplicados (${_allAppliedJobs.length})',
            jobs: _allAppliedJobs,
            showViewAllButton: false, // No necesitamos "Ver todo" aquí
          ),
          const SizedBox(height: kSpacing20 + kSpacing4), // kSpacing24
          _buildPaginationControls(),
        ],
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                count,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: iconColor.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: kSpacing4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Container(
            padding: kPaddingAll12,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(kRadius8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            child: Icon(icon, color: iconColor, size: kIconSize24),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCourseSection() {
    String habilidad = "Storytelling Digital"; // Habilidad de ejemplo
    String empleo = "Gestor de Contenidos"; // Empleo de ejemplo
    return Container(
      padding: const EdgeInsets.all(kPadding20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(kRadius12),
        border: Border.all(color: Colors.blue.shade200, width: kStroke1),
      ),
      child: Row(
        children: [
          Icon(Icons.school_outlined, color: Colors.blue.shade700, size: kIconSize48 - kSpacing4), // kIconSize44
          const SizedBox(width: kSpacing12 + kSpacing4), // kSpacing16
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Curso Recomendado',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: kSpacing4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                    children: <TextSpan>[
                      const TextSpan(text: 'Mejora tu habilidad en '),
                      TextSpan(text: habilidad, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                      const TextSpan(text: ', que aumenta tu match en un '),
                      const TextSpan(text: '18% ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      const TextSpan(text: 'en empleos de '),
                      TextSpan(text: empleo, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: kSpacing12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: kPadding16, vertical: kPadding12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius8)),
            ),
            child: const Text('Ver Curso'),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsTableSection({
    required String title,
    required List<AppliedJob> jobs,
    bool showViewAllButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(kPadding20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadius12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222B45),
                ),
              ),
              if (showViewAllButton)
                TextButton(
                  onPressed: () {
                     setState(() {
                      _selectedMenu = 'Applied Jobs'; // Navegar a la sección de trabajos aplicados
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ver todo',
                        style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
                      ),
                      const SizedBox(width: kSpacing4),
                      Icon(Icons.arrow_forward, color: Colors.blue.shade700, size: kIconSize18),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: kSpacing12),
          _buildAppliedJobsTableHeader(),
          const Divider(height: kSpacing20, thickness: 1, color: Color(0xFFEDF1F7)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return _buildAppliedJobRow(jobs[index]);
            },
            separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1, color: Color(0xFFEDF1F7)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppliedJobsTableHeader() {
    TextStyle headerStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    // El padding horizontal se maneja en _buildAppliedJobRow para alineación
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPadding8, horizontal: kPadding12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('PUESTOS', style: headerStyle)),
          Expanded(flex: 2, child: Text('FECHA DE APLICACIÓN', style: headerStyle, textAlign: TextAlign.start)),
          Expanded(flex: 1, child: Text('ESTADO', style: headerStyle, textAlign: TextAlign.start)),
          Expanded(flex: 2, child: Text('ACCIÓN', style: headerStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildAppliedJobRow(AppliedJob job) {
    TextStyle jobTitleStyle = const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF222B45));
    TextStyle detailStyle = TextStyle(fontSize: 12, color: Colors.grey.shade600);
    TextStyle dateStyle = TextStyle(fontSize: 13, color: Colors.grey.shade700);
    TextStyle statusStyle = const TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.w500);
    TextStyle matchStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: job.matchPercentage > 80 ? Colors.green.shade700 : (job.matchPercentage > 70 ? Colors.orange.shade700 : Colors.red.shade700));


    return Container(
      padding: const EdgeInsets.symmetric(vertical: kPadding12 + kSpacing4, horizontal: kPadding12), // Aumentar padding vertical
      decoration: BoxDecoration(
        border: job.isHighlighted ? Border(
          left: BorderSide(color: Colors.blue.shade600, width: kStroke3),
          // bottom: BorderSide(color: Colors.grey.shade200, width: 0.5) // Optional bottom border for all rows
        ) : null, // No special border for non-highlighted
        color: job.isHighlighted ? Colors.blue.withOpacity(0.03) : Colors.transparent,
      ),
      child: Row(
        children: [
          // Job Info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: kRadius40 + kSpacing4, // 44
                  height: kRadius40 + kSpacing4, // 44
                  padding: kPaddingAll8,
                  decoration: BoxDecoration(
                    color: job.logoBackgroundColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(kRadius8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(job.companyLogoAsset, fit: BoxFit.contain),
                      // El match percentage se muestra abajo ahora
                    ],
                  ),
                ),
                const SizedBox(width: kSpacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(job.jobTitle, style: jobTitleStyle, overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: kSpacing8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: kPadding8, vertical: kSpacing4/2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(kRadius4),
                            ),
                            child: Text(job.jobType, style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpacing4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: kIconSize14, color: Colors.grey.shade500),
                          const SizedBox(width: kSpacing4),
                          Text(job.location, style: detailStyle),
                          const SizedBox(width: kSpacing8),
                          Icon(Icons.attach_money, size: kIconSize14, color: Colors.grey.shade500),
                          const SizedBox(width: kSpacing4),
                          Text(job.salary, style: detailStyle),
                          // Quitado el match percentage de aquí para evitar redundancia
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Date Applied
          Expanded(flex: 2, child: Text(job.dateApplied, style: dateStyle, textAlign: TextAlign.start)),
          // Status
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: kIconSize16),
                const SizedBox(width: kSpacing4),
                Text(job.status, style: statusStyle),
              ],
            ),
          ),
          // Action
          Expanded(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: job.isHighlighted ? Colors.blue.shade700 : const Color(0xFFF0F4FF), // Color de fondo como en la imagen
                  foregroundColor: job.isHighlighted ? Colors.white : Colors.blue.shade700, // Color de texto
                  elevation: 0, // Sin elevación para un look más plano
                  padding: const EdgeInsets.symmetric(horizontal: kPadding16, vertical: kPadding12), // Ajustar padding
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius8)),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)
                ),
                child: const Text('Ver Detalles'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back, color: _currentPage > 1 ? Colors.blue.shade700 : Colors.grey),
          onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
        ),
        for (int i = 1; i <= _totalPages; i++)
          InkWell(
            onTap: () => setState(() => _currentPage = i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: kSpacing4),
              padding: const EdgeInsets.symmetric(horizontal: kPadding12, vertical: kPadding8),
              decoration: BoxDecoration(
                color: _currentPage == i ? Colors.blue.shade700 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(kRadius4),
              ),
              child: Text(
                i.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: _currentPage == i ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        IconButton(
          icon: Icon(Icons.arrow_forward, color: _currentPage < _totalPages ? Colors.blue.shade700 : Colors.grey),
          onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    const double appIdentityBarHeight = 70.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: appIdentityBarHeight),
          Expanded(
            child: Row(
              children: <Widget>[
                // Left side: Selector Menu
                Container(
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
                          'PANEL DEL CANDIDATO', // Traducción
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: kSpacing8),
                      _buildMenuItem(
                        icon: Icons.layers_outlined,
                        title: 'Resumen', // Traducción
                        isSelected: _selectedMenu == 'Overview',
                        onTap: () => setState(() => _selectedMenu = 'Overview'),
                      ),
                      _buildMenuItem(
                        icon: Icons.work_outline,
                        title: 'Trabajos Aplicados', // Traducción
                        isSelected: _selectedMenu == 'Applied Jobs',
                        onTap: () => setState(() => _selectedMenu = 'Applied Jobs'),
                      ),
                      _buildMenuItem(
                        icon: Icons.bookmark_border,
                        title: 'Trabajos Favoritos', // Traducción
                        isSelected: _selectedMenu == 'Favorite Jobs',
                        onTap: () => setState(() => _selectedMenu = 'Favorite Jobs'),
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications_none_outlined,
                        title: 'Alerta de Trabajo', // Traducción
                        badgeCount: '09',
                        isSelected: _selectedMenu == 'Job Alert',
                        onTap: () => setState(() => _selectedMenu = 'Job Alert'),
                      ),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Configuración', // Traducción
                        isSelected: _selectedMenu == 'Settings',
                        onTap: () => setState(() => _selectedMenu = 'Settings'),
                      ),
                    ],
                  ),
                ),
                // Right side: Main content area
                Expanded(
                  flex: 3,
                  child: Container(
                    child: _selectedMenu == 'Overview'
                        ? _buildOverviewContent()
                        : _selectedMenu == 'Applied Jobs'
                            ? _buildAppliedJobsContent()
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
    );
  }
}
