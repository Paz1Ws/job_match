import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/domain/models/posted_job_model.dart';
import 'package:job_match/presentation/widgets/dashboard/employer/post_job_form.dart';

class EmployerDashboardScreen extends ConsumerStatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  ConsumerState<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState
    extends ConsumerState<EmployerDashboardScreen> {
  String _selectedMenu = 'Overview';
  final int _companyId = 1;
  @override
  Widget build(BuildContext context) {
    // Cargar el perfil si aún no está cargado

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                FadeInLeft(
                  child: Container(
                    // ...existing code...
                    child: Column(
                      children: <Widget>[
                        ...[
                          _buildMenuItem(
                            icon: Icons.groups_outlined,
                            title: 'Todas las Empresas',
                            isSelected: _selectedMenu == 'All Companies',
                            onTap:
                                () => setState(
                                  () => _selectedMenu = 'All Companies',
                                ),
                          ),
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Configuración',
                            isSelected: _selectedMenu == 'Settings',
                            onTap:
                                () =>
                                    setState(() => _selectedMenu = 'Settings'),
                          ),
                        ].asMap().entries.map((entry) {
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
                Expanded(
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    child:
                        _selectedMenu == 'Overview'
                            ? _buildPostedJobsContent()
                            : _selectedMenu == 'Post a Job'
                            ? PostJobForm(companyId: _companyId)
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

  Widget _buildPostedJobsContent() {
    // Aquí deberías usar un provider real para obtener los jobs de la empresa
    // Por ejemplo: final jobsAsync = ref.watch(postedJobsByCompanyProvider(_companyId));
    // Aquí se usa mock para ejemplo:
    final List<PostedJob> mockJobs = [
      PostedJob(
        id: '1',
        companyId: _companyId.toString(),
        title: 'Ingeniero de Software Sr.',
        description: 'Desarrollar y mantener aplicaciones Flutter.',
        status: 'open',
        viewsCount: 120,
        location: 'Lima, Perú',
        jobType: 'Tiempo Completo',
        salaryMin: 8000,
        salaryMax: 12000,
        applicationDeadline: DateTime.now().add(const Duration(days: 15)),
        requiredSkills: ['Flutter', 'Dart', 'Firebase'],
      ),
      PostedJob(
        id: '2',
        companyId: _companyId.toString(),
        title: 'Diseñador UX/UI',
        description: 'Diseñar interfaces atractivas y funcionales.',
        status: 'paused',
        viewsCount: 75,
        location: 'Remoto',
        jobType: 'Medio Tiempo',
        salaryMin: 4000,
        salaryMax: 6000,
        applicationDeadline: DateTime.now().add(const Duration(days: 10)),
        requiredSkills: ['Figma', 'Adobe XD', 'User Research'],
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: mockJobs.length,
      itemBuilder: (context, index) {
        final job = mockJobs[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FIX: Remove Flexible/Expanded from Row, use IntrinsicWidth to bound width
                IntrinsicWidth(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        avatar: Icon(
                          job.status == 'open'
                              ? Icons.play_circle_outline
                              : job.status == 'paused'
                                  ? Icons.pause_circle_outline
                                  : Icons.check_circle_outline,
                          color: job.status == 'open'
                              ? Colors.green.shade600
                              : job.status == 'paused'
                                  ? Colors.orange.shade600
                                  : Colors.red.shade600,
                          size: 18,
                        ),
                        label: Text(
                          job.status[0].toUpperCase() + job.status.substring(1),
                          style: TextStyle(
                            color: job.status == 'open'
                                ? Colors.green.shade600
                                : job.status == 'paused'
                                    ? Colors.orange.shade600
                                    : Colors.red.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: job.status == 'open'
                            ? Colors.green.shade50
                            : job.status == 'paused'
                                ? Colors.orange.shade50
                                : Colors.red.shade50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                IntrinsicWidth(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        job.location ?? 'N/A',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.work_outline,
                        size: 14,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        job.jobType ?? 'N/A',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (job.salaryMin != null || job.salaryMax != null)
                  IntrinsicWidth(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money_outlined,
                          size: 14,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'S/${job.salaryMin ?? 'N/A'} - S/${job.salaryMax ?? 'N/A'}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                if (job.applicationDeadline != null) ...[
                  const SizedBox(height: 8),
                  IntrinsicWidth(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Vence: ${job.applicationDeadline!.day}/${job.applicationDeadline!.month}/${job.applicationDeadline!.year}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${job.viewsCount} vistas',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Editar'),
                          onPressed: () {
                            // TODO: Implement edit job functionality
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.people_alt_outlined, size: 18),
                          label: const Text('Ver Postulantes'),
                          onPressed: () {
                            // TODO: Implement view applicants functionality
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
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
          ],
        ),
      ),
    );
  }
}
