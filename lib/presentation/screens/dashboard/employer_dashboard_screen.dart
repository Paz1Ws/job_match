import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/posted_job_model.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    // Get company data from provider
    final company = ref.watch(companyProfileProvider);
    // Get company jobs from provider
    final jobsAsync = ref.watch(jobsByCompanyIdProvider(company?.userId ?? ''));
    final applicationsAsync = ref.watch(applicationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: 70),
          Expanded(
            child: Row(
              children: <Widget>[
                // Left Sidebar
                FadeInLeft(
                  child: Container(
                    width: 250,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              company?.logo != null
                                  ? NetworkImage(company!.logo!)
                                  : const AssetImage(
                                        'assets/images/job_match.jpg',
                                      )
                                      as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          company?.companyName ?? 'Mi Empresa',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          company?.industry ?? 'Industria no especificada',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ...[
                          _buildMenuItem(
                            icon: Icons.dashboard_outlined,
                            title: 'Dashboard',
                            isSelected: _selectedMenu == 'Overview',
                            onTap:
                                () =>
                                    setState(() => _selectedMenu = 'Overview'),
                          ),
                          _buildMenuItem(
                            icon: Icons.work_outline,
                            title: 'Publicar Empleo',
                            isSelected: _selectedMenu == 'Post a Job',
                            onTap:
                                () => setState(
                                  () => _selectedMenu = 'Post a Job',
                                ),
                          ),
                          _buildMenuItem(
                            icon: Icons.people_outline,
                            title: 'Aplicaciones',
                            isSelected: _selectedMenu == 'Applications',
                            onTap:
                                () => setState(
                                  () => _selectedMenu = 'Applications',
                                ),
                          ),
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
                // Main Content Area
                Expanded(
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    child:
                        _selectedMenu == 'Overview'
                            ? jobsAsync.when(
                              loading:
                                  () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              error:
                                  (error, _) =>
                                      Center(child: Text('Error: $error')),
                              data:
                                  (jobs) => _buildPostedJobsContent(
                                    jobs,
                                    company?.companyName ?? 'Mi Empresa',
                                  ),
                            )
                            : _selectedMenu == 'Post a Job'
                            ? PostJobForm(companyId: company?.userId ?? '')
                            : _selectedMenu == 'Applications'
                            ? _buildJobApplicationsContent(
                              applicationsAsync.value ?? [],
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: itemColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostedJobsContent(
    List<Map<String, dynamic>> jobs,
    String companyName,
  ) {
    // Solo muestra la cantidad de empleos, no uses providers que no existen
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  count: '${jobs.length}',
                  label: 'Empleos Publicados',
                  icon: Icons.work_outline,
                  iconColor: Colors.white,
                  backgroundColor: Colors.blue.shade50,
                  iconBackgroundColor: Colors.blue.shade500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  count:
                      '${jobs.where((job) => job['status'] == 'open').length}',
                  label: 'Empleos Activos',
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.white,
                  backgroundColor: Colors.green.shade50,
                  iconBackgroundColor: Colors.green.shade500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  count: '25', // This would be actual applications count
                  label: 'Nuevas Aplicaciones',
                  icon: Icons.people_outline,
                  iconColor: Colors.white,
                  backgroundColor: Colors.amber.shade50,
                  iconBackgroundColor: Colors.amber.shade500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          const Text(
            'Empleos Publicados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Jobs list
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPostedJobsTableHeader(),
                  const Divider(),
                  if (jobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'Aún no has publicado empleos',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: jobs.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return _buildPostedJobRow(job, companyName);
                      },
                    ),
                ],
              ),
            ),
          ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostedJobsTableHeader() {
    TextStyle headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: Colors.grey.shade700,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Título', style: headerStyle)),
          Expanded(flex: 2, child: Text('Ubicación', style: headerStyle)),
          Expanded(flex: 1, child: Text('Tipo', style: headerStyle)),
          Expanded(flex: 1, child: Text('Estado', style: headerStyle)),
          Expanded(flex: 1, child: Text('Vistas', style: headerStyle)),
          SizedBox(width: 100, child: Text('Acciones', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildPostedJobRow(Map<String, dynamic> job, String companyName) {
    TextStyle jobTitleStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
    TextStyle detailStyle = TextStyle(
      fontSize: 13,
      color: Colors.grey.shade700,
    );
    Color statusColor =
        job['status'] == 'open'
            ? Colors.green
            : job['status'] == 'paused'
            ? Colors.orange
            : Colors.red;
    IconData statusIcon =
        job['status'] == 'open'
            ? Icons.play_circle_outline
            : job['status'] == 'paused'
            ? Icons.pause_circle_outline
            : Icons.stop_circle_outlined;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job['title'] ?? 'Sin título', style: jobTitleStyle),
                const SizedBox(height: 2),
                Text(companyName, style: detailStyle),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              job['location'] ?? 'No especificada',
              style: detailStyle,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              job['job_type'] ?? 'No especificado',
              style: detailStyle,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  job['status'] == 'open'
                      ? 'Activo'
                      : job['status'] == 'paused'
                      ? 'Pausado'
                      : 'Cerrado',
                  style: TextStyle(color: statusColor, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('${job['views_count'] ?? 0}', style: detailStyle),
          ),
          SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () {
                    // Editar lógica
                  },
                  tooltip: 'Editar',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.people_alt_outlined, size: 18),
                  onPressed: () {
                    // Ver postulantes lógica
                  },
                  tooltip: 'Ver Postulantes',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobApplicationsContent(List<Map<String, dynamic>> applications) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aplicaciones',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (applications.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  'No hay aplicaciones para mostrar',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          else
            const Text(
              'Lista de aplicaciones aquí',
            ), // Placeholder for actual applications list
        ],
      ),
    );
  }
}
