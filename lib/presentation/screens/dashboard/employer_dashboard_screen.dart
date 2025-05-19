import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/candidate_model.dart';
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
  String _sortApplicationBy = 'Newest';

  @override
  Widget build(BuildContext context) {
    // Solo usa providers existentes de supabase_http_requests.dart
    final jobsAsync = ref.watch(jobsProvider);
    final applicationsAsync = ref.watch(applicationsProvider);
    
    // Cargar el perfil si aún no está cargado
    final candidate = ref.watch(candidateProfileProvider);
    if (candidate == null) {
      // Intentar cargar el perfil si no está en memoria
      Future.microtask(() => fetchUserProfile(ref));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
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
                // Sidebar
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
                            'PANEL DE EMPRESA',
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
                            onTap: () => setState(() => _selectedMenu = 'Overview'),
                          ),
                          _buildMenuItem(
                            icon: Icons.person_outline,
                            title: 'Perfil de Empresa',
                            isSelected: _selectedMenu == 'Employers Profile',
                            onTap: () => setState(() => _selectedMenu = 'Employers Profile'),
                          ),
                          _buildMenuItem(
                            icon: Icons.add_circle_outline,
                            title: 'Publicar Empleo',
                            isSelected: _selectedMenu == 'Post a Job',
                            onTap: () => setState(() => _selectedMenu = 'Post a Job'),
                          ),
                          _buildMenuItem(
                            icon: Icons.work_outline,
                            title: 'Mis Empleos',
                            isSelected: _selectedMenu == 'My Jobs',
                            onTap: () => setState(() => _selectedMenu = 'My Jobs'),
                          ),
                          _buildMenuItem(
                            icon: Icons.people_alt_outlined,
                            title: 'Aplicaciones',
                            isSelected: _selectedMenu == 'Job Applications',
                            onTap: () => setState(() => _selectedMenu = 'Job Applications'),
                          ),
                          _buildMenuItem(
                            icon: Icons.bookmark_border,
                            title: 'Candidatos Guardados',
                            isSelected: _selectedMenu == 'Saved Candidate',
                            onTap: () => setState(() => _selectedMenu = 'Saved Candidate'),
                          ),
                          _buildMenuItem(
                            icon: Icons.receipt_long_outlined,
                            title: 'Planes y Facturación',
                            isSelected: _selectedMenu == 'Plans & Billing',
                            onTap: () => setState(() => _selectedMenu = 'Plans & Billing'),
                          ),
                          _buildMenuItem(
                            icon: Icons.groups_outlined,
                            title: 'Todas las Empresas',
                            isSelected: _selectedMenu == 'All Companies',
                            onTap: () => setState(() => _selectedMenu = 'All Companies'),
                          ),
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Configuración',
                            isSelected: _selectedMenu == 'Settings',
                            onTap: () => setState(() => _selectedMenu = 'Settings'),
                          ),
                        ].asMap().entries.map((entry) {
                          return FadeInLeft(
                            delay: Duration(milliseconds: 80 * entry.key),
                            duration: const Duration(milliseconds: 400),
                            child: entry.value,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 700),
                    child: _selectedMenu == 'Overview'
                        ? jobsAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, stack) => Center(child: Text('Error: $error')),
                            data: (jobs) => _buildOverviewContent(jobs, candidate),
                          )
                        : _selectedMenu == 'Post a Job'
                            ? const PostJobForm()
                            : _selectedMenu == 'Job Applications'
                                ? applicationsAsync.when(
                                    loading: () => const Center(child: CircularProgressIndicator()),
                                    error: (error, stack) => Center(child: Text('Error: $error')),
                                    data: (applications) => _buildJobApplicationsContent(applications),
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

  Widget _buildOverviewContent(List<Map<String, dynamic>> jobs, Candidate candidate) {
    // Solo muestra la cantidad de empleos, no uses providers que no existen
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Text(
              'Hola, ${candidate.name}',
              style: const TextStyle(
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
              'Aquí están tus actividades diarias y aplicaciones',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: kSpacing20 + kSpacing4),
          Row(
            children: [
              FadeInLeft(
                duration: const Duration(milliseconds: 700),
                child: Expanded(
                  child: _buildSummaryCard(
                    count: jobs.length.toString(),
                    label: 'Empleos Abiertos',
                    icon: Icons.work_outline,
                    iconColor: Colors.blue.shade700,
                    backgroundColor: Colors.blue.shade50,
                    iconBackgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: kSpacing20),
              FadeInRight(
                duration: const Duration(milliseconds: 700),
                child: Expanded(
                  child: _buildSummaryCard(
                    count: '0',
                    label: 'Candidatos Guardados',
                    icon: Icons.person_outline,
                    iconColor: Colors.orange.shade700,
                    backgroundColor: Colors.orange.shade50,
                    iconBackgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                leading: Transform.scale(
                  scale: 1.2,
                  child: ClipOval(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'assets/images/users/user1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: const Text(
                  'Tu perfil aún no esta completo',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Completa tu edición del perfil y redacta tu Resume',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {},
                  child: const Text(
                    'Editar perfil',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: kSpacing30 + kSpacing4),
          // recentPostedJobsAsync.when(
          //   loading: () => const Center(child: CircularProgressIndicator()),
          //   error: (error, stack) => Center(child: Text('Error: $error')),
          //   data:
          //       (postedJobs) => _buildPostedJobsTableSection(
          //         title: 'Empleos Publicados Recientemente',
          //         jobs: postedJobs,
          //         showViewAllButton: true,
          //       ),
          // ),
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

  Widget _buildPostedJobsTableSection({
    required String title,
    required List<PostedJob> jobs,
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
          ),
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
                      _selectedMenu = 'My Jobs';
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ver todo',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: kSpacing4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.blue.shade700,
                        size: kIconSize18,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: kSpacing12),
          _buildPostedJobsTableHeader(),
          const Divider(
            height: kSpacing20,
            thickness: 1,
            color: Color(0xFFEDF1F7),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return _buildPostedJobRow(jobs[index]);
            },
            separatorBuilder:
                (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEDF1F7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostedJobsTableHeader() {
    TextStyle headerStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kPadding8,
        horizontal: kPadding12,
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text('EMPLEOS', style: headerStyle)),
          Expanded(
            flex: 2,
            child: Text(
              'ESTADO',
              style: headerStyle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'APLICACIONES',
              style: headerStyle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'ACCIONES',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostedJobRow(PostedJob job) {
    TextStyle jobTitleStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFF222B45),
    );
    TextStyle detailStyle = TextStyle(
      fontSize: 12,
      color: Colors.grey.shade600,
    );
    Color statusColor =
        job.status == JobStatus.Active ? Colors.green : Colors.red;
    IconData statusIcon =
        job.status == JobStatus.Active
            ? Icons.check_circle_outline
            : Icons.cancel_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kPadding12 + kSpacing4,
        horizontal: kPadding12,
      ),
      decoration: BoxDecoration(
        border:
            job.isSelectedRow
                ? Border(
                  left: BorderSide(
                    color: Colors.blue.shade600,
                    width: kStroke3,
                  ),
                )
                : null,
        color:
            job.isSelectedRow
                ? Colors.blue.withOpacity(0.03)
                : Colors.transparent,
      ),
      child: Row(
        children: [
          // Job Info
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: jobTitleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: kSpacing4),
                Row(
                  children: [
                    Text(job.jobType, style: detailStyle),
                    Text(' • ', style: detailStyle),
                    Text(job.remainingTime, style: detailStyle),
                  ],
                ),
              ],
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: kIconSize16),
                const SizedBox(width: kSpacing4),
                Text(
                  job.status == JobStatus.Active ? 'Activo' : 'Expirado',
                  style: TextStyle(
                    fontSize: 13,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Applications
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  color: Colors.grey.shade600,
                  size: kIconSize16,
                ),
                const SizedBox(width: kSpacing4),
                Text(
                  '${job.applicationsCount} Aplicaciones',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          // Actions
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logic for viewing applications
                    // For now, let's switch to the Job Applications view
                    setState(() => _selectedMenu = 'Solicitante de empleo');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        job.isSelectedRow
                            ? Colors.blue.shade700
                            : const Color(0xFFF0F4FF),
                    foregroundColor:
                        job.isSelectedRow ? Colors.white : Colors.blue.shade700,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPadding12,
                      vertical: kPadding12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadius8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Ver Aplicaciones'),
                ),
                const SizedBox(width: kSpacing4),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                  onSelected: (value) {
                    if (value == 'view_detail') {
                      // context.go('/job-details', extra: job.jobDetails);
                    }
                    // Handle other actions
                  },
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'promote_job',
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_outline,
                                color: Colors.orange,
                                size: kIconSize20,
                              ),
                              SizedBox(width: kSpacing8),
                              Text('Promocionar Empleo'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'view_detail',
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                color: Colors.blue,
                                size: kIconSize20,
                              ),
                              SizedBox(width: kSpacing8),
                              Text('Ver Detalle'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'mark_expired',
                          child: Row(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                                size: kIconSize20,
                              ),
                              SizedBox(width: kSpacing8),
                              Text('Marcar como Expirado'),
                            ],
                          ),
                        ),
                      ],
                  tooltip: "Más opciones",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobApplicationsContent(List<Map<String, dynamic>> applications) {
    // Solo muestra la cantidad de aplicaciones, no uses providers que no existen
    return Padding(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4),
      child: FadeInUp(
        duration: const Duration(milliseconds: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Solicitantes de empleo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222B45),
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        /* Filter logic */
                      },
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.grey.shade700,
                        size: kIconSize20,
                      ),
                      label: Text(
                        'Filtro',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kRadius8),
                        ),
                      ),
                    ),
                    const SizedBox(width: kSpacing12),
                    PopupMenuButton<String>(
                      onSelected: (String value) {
                        setState(() {
                          _sortApplicationBy = value;
                          // Add logic to re-sort applicant lists here
                        });
                      },
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Newest',
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'Newest',
                                    groupValue: _sortApplicationBy,
                                    onChanged: (v) {},
                                    activeColor: Colors.blue.shade700,
                                  ),
                                  const Text('Reciente'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Oldest',
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'Oldest',
                                    groupValue: _sortApplicationBy,
                                    onChanged: (v) {},
                                    activeColor: Colors.blue.shade700,
                                  ),
                                  const Text('Antiguo'),
                                ],
                              ),
                            ),
                          ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kPadding12,
                          vertical: kPadding8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(kRadius8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sort,
                              color: Colors.white,
                              size: kIconSize20,
                            ),
                            const SizedBox(width: kSpacing4),
                            Text(
                              'Ordenar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: kSpacing12),
                    ElevatedButton.icon(
                      onPressed: () {
                        /* Create new column logic */
                      },
                      icon: const Icon(
                        Icons.add,
                        size: kIconSize20,
                        color: Colors.white,
                      ),
                      label: const Text('Crear nuevo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kRadius8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: kPadding16,
                          vertical: kPadding12 + kSpacing4 / 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: kSpacing20 + kSpacing4),
            Expanded(
              child: ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  final app = applications[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 80 * index),
                    child: ListTile(
                      title: Text('Aplicación ID: ${app['id']}'),
                      subtitle: Text('Estado: ${app['status']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fallback widgets para estados de carga
  Widget _buildSummaryCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(kPadding20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(kRadius12),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSummaryCardError() {
    return Container(
      padding: const EdgeInsets.all(kPadding20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(kRadius12),
      ),
      child: const Center(child: Text('Error cargando datos')),
    );
  }
}
