import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/core/data/jobs_listener.dart';
import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/presentation/widgets/dashboard/employer/post_job_form.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card_list_view.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/widgets/company/company_job_card.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:intl/intl.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';

class CompanyJobDetailScreen extends ConsumerStatefulWidget {
  final Job job;
  final Company? company;

  const CompanyJobDetailScreen({super.key, required this.job, this.company});

  @override
  ConsumerState<CompanyJobDetailScreen> createState() =>
      _CompanyJobDetailScreenState();
}

class _CompanyJobDetailScreenState extends ConsumerState<CompanyJobDetailScreen>
    with JobRealtimeUpdatesMixin {
  late Job currentJob;

  @override
  void initState() {
    super.initState();
    currentJob = widget.job;

    // Initialize the Jobs Listener for real-time updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeJobsListener(
        onJobUpdated: (updatedJob, oldJob) {
          // Only update if this is the same job we're viewing
          if (updatedJob.id == currentJob.id) {
            setState(() {
              currentJob = updatedJob;
            });

            // Also invalidate the specific job provider if it exists
            ref.invalidate(jobByIdProvider(updatedJob.id));
          }
        },
        onJobDeleted: (deletedJob) {
          if (deletedJob.id == currentJob.id) {
            // Job was deleted, navigate back
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Este trabajo ha sido eliminado'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    });
  }

  @override
  void dispose() {
    disposeJobsListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use currentJob instead of widget.job for the most up-to-date data
    final job = currentJob;
    final String jobTitle =
        job.title.isNotEmpty ? job.title : 'Puesto sin título';
    final String companyName =
        job.companyName.isNotEmpty ? job.companyName : 'Empresa';
    final String jobLocation =
        job.location.isNotEmpty ? job.location : 'Lima, Perú';
    final String jobType = job.type.isNotEmpty ? job.type : 'Tiempo Completo';
    final String jobSalary =
        job.salaryMin.isNotEmpty && job.salaryMax.isNotEmpty
            ? 'S/${job.salaryMin} - ${job.salaryMax}'
            : 'Salario no especificado';
    final String jobDescription =
        job.description.isNotEmpty
            ? job.description
            : 'Descripción no disponible';
    final company = ref.watch(companyProfileProvider);
    final companyJobsAsync = ref.watch(
      jobsByCompanyIdProvider(company?.userId ?? ''),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FadeInLeft(
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company Logo and Title Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left part: Logo and Company Info
                              Expanded(
                                flex: 3,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: job.logoBackgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:
                                          company?.logo != null &&
                                                  company!.logo!.isNotEmpty
                                              ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  company.logo!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Icon(
                                                        Icons.business,
                                                        color: Colors.white,
                                                        size: 40,
                                                      ),
                                                ),
                                              )
                                              : Icon(
                                                Icons.business,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            companyName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  jobLocation,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Status badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    job.status,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _getStatusColor(
                                      job.status,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  _getDisplayStatus(job.status),
                                  style: TextStyle(
                                    color: _getStatusColor(job.status),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Job Title
                          Text(
                            jobTitle,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Job Tags
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _buildTag(jobType),
                              _buildTag('Salario ofrecido: $jobSalary'),
                              _buildTag(
                                'Publicado hace ${_getPublishedDays()} días',
                                color: Colors.blue.withOpacity(0.1),
                                textColor: Colors.blue,
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Edit Job Button
                          ElevatedButton(
                            onPressed:
                                () => _showEditJobDialog(
                                  context,
                                  job,
                                ), // Pass current job
                            child: const Text('Editar trabajo'),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // Job Tabs Section
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text: 'Descripción'),
                              Tab(text: 'Candidatos'),
                              Tab(text: 'Detalles'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 300,
                            child: TabBarView(
                              children: [
                                // Description Tab - Use real job data
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Descripción del Empleo',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          jobDescription,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Información Principal',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        _buildDetailItem('Título', job.title),
                                        _buildDetailItem('Tipo', job.type),
                                        _buildDetailItem(
                                          'Modalidad',
                                          job.modality,
                                        ),
                                        _buildDetailItem(
                                          'Ubicación',
                                          job.location,
                                        ),
                                        _buildDetailItem(
                                          'Rango salarial',
                                          '${job.salaryMin} - ${job.salaryMax}',
                                        ),
                                        if (job.requiredSkills != null &&
                                            job.requiredSkills!.isNotEmpty) ...[
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Habilidades requeridas',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children:
                                                job.requiredSkills!
                                                    .map(
                                                      (skill) => Chip(
                                                        label: Text(skill),
                                                        backgroundColor:
                                                            Colors.blue.shade50,
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),

                                // Candidates Tab - Use real applications data
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Candidatos que han aplicado',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Consumer(
                                          builder: (context, ref, _) {
                                            final applicationsAsync = ref.watch(
                                              applicationsByJobIdProvider(
                                                job.id,
                                              ),
                                            );
                                            return applicationsAsync.when(
                                              loading:
                                                  () => const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                              error:
                                                  (error, stack) => Center(
                                                    child: Text(
                                                      'Error: $error',
                                                    ),
                                                  ),
                                              data: (applications) {
                                                if (applications.isEmpty) {
                                                  return const Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 30.0,
                                                          ),
                                                      child: Text(
                                                        'Aún no hay candidatos para este trabajo',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                // Replace the ListTile in the applications ListView.builder with this clickable version
                                                return ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      applications.length,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    final app =
                                                        applications[index];
                                                    final userId =
                                                        app['user_id']
                                                            ?.toString() ??
                                                        '';

                                                    // Create a provider to fetch candidate data
                                                    final candidateAsync = ref
                                                        .watch(
                                                          candidateByUserIdProvider(
                                                            userId,
                                                          ),
                                                        );

                                                    return Card(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 8.0,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        side: BorderSide(
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade200,
                                                        ),
                                                      ),
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        onTap: () {
                                                          candidateAsync.whenData((
                                                            candidate,
                                                          ) {
                                                            if (candidate !=
                                                                null) {
                                                              Navigator.of(
                                                                context,
                                                              ).push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) =>
                                                                          UserProfile(),
                                                                ),
                                                              );
                                                            } else {
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                    'No se pudo cargar el perfil del candidato',
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: ListTile(
                                                          contentPadding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 8,
                                                              ),
                                                          leading: candidateAsync.when(
                                                            data: (candidate) {
                                                              return CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .blue
                                                                        .shade100,
                                                                backgroundImage:
                                                                    candidate?.photo !=
                                                                            null
                                                                        ? NetworkImage(
                                                                          candidate!
                                                                              .photo!,
                                                                        )
                                                                        : null,
                                                                child:
                                                                    candidate?.photo ==
                                                                            null
                                                                        ? Text(
                                                                          userId.isNotEmpty
                                                                              ? userId
                                                                                  .substring(
                                                                                    0,
                                                                                    1,
                                                                                  )
                                                                                  .toUpperCase()
                                                                              : '?',
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.blue.shade800,
                                                                          ),
                                                                        )
                                                                        : null,
                                                              );
                                                            },
                                                            loading:
                                                                () => CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue
                                                                          .shade100,
                                                                  child: const SizedBox(
                                                                    width: 15,
                                                                    height: 15,
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                            error:
                                                                (
                                                                  _,
                                                                  __,
                                                                ) => CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue
                                                                          .shade100,
                                                                  child: Text(
                                                                    userId.isNotEmpty
                                                                        ? userId
                                                                            .substring(
                                                                              0,
                                                                              1,
                                                                            )
                                                                            .toUpperCase()
                                                                        : '?',
                                                                    style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .blue
                                                                              .shade800,
                                                                    ),
                                                                  ),
                                                                ),
                                                          ),
                                                          title: candidateAsync.when(
                                                            data:
                                                                (
                                                                  candidate,
                                                                ) => Text(
                                                                  candidate
                                                                          ?.name ??
                                                                      'Candidato: $userId',
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                            loading:
                                                                () => Text(
                                                                  'Candidato: $userId',
                                                                ),
                                                            error:
                                                                (_, __) => Text(
                                                                  'Candidato: $userId',
                                                                ),
                                                          ),
                                                          subtitle: Text(
                                                            'Estado: ${app['status'] ?? 'pendiente'}',
                                                          ),
                                                          trailing: Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors
                                                                      .green
                                                                      .shade50,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                              border: Border.all(
                                                                color:
                                                                    Colors
                                                                        .green
                                                                        .shade200,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              app['applied_at'] !=
                                                                      null
                                                                  ? DateFormat(
                                                                    'dd MMM yyyy',
                                                                  ).format(
                                                                    DateTime.parse(
                                                                      app['applied_at'],
                                                                    ),
                                                                  )
                                                                  : '',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .green
                                                                        .shade700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Details Tab - Use real job data
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Detalles del Trabajo',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        _buildDetailItem('Título', job.title),
                                        _buildDetailItem(
                                          'Empresa',
                                          job.companyName,
                                        ),
                                        _buildDetailItem(
                                          'Ubicación',
                                          job.location,
                                        ),
                                        _buildDetailItem('Tipo', job.type),
                                        _buildDetailItem(
                                          'Modalidad',
                                          job.modality,
                                        ),
                                        _buildDetailItem(
                                          'Salario Mínimo',
                                          job.salaryMin,
                                        ),
                                        _buildDetailItem(
                                          'Salario Máximo',
                                          job.salaryMax,
                                        ),
                                        _buildDetailItem(
                                          'Estado',

                                          _getDisplayStatus(job.status),
                                        ),

                                        _buildDetailItem(
                                          'Fecha de Publicación',
                                          job.createdAt != null
                                              ? DateFormat(
                                                'dd MMM yyyy',
                                              ).format(job.createdAt!)
                                              : 'No disponible',
                                        ),
                                        _buildDetailItem(
                                          'Fecha límite',
                                          job.applicationDeadline != null
                                              ? DateFormat(
                                                'dd MMM yyyy',
                                              ).format(job.applicationDeadline!)
                                              : 'No disponible',
                                        ),
                                        _buildDetailItem(
                                          'Máx. postulaciones',
                                          job.maxApplications?.toString() ??
                                              'Sin límite',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // My Other Postings Section (replacing Related Jobs)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mis Otras Publicaciones',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),

                        companyJobsAsync.when(
                          loading:
                              () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          error:
                              (error, stack) =>
                                  Center(child: Text('Error: $error')),
                          data: (jobs) {
                            // Filter out current job
                            final otherJobs =
                                jobs
                                    .where(
                                      (j) =>
                                          j.title != job.title &&
                                          j.id != job.id,
                                    )
                                    .take(3)
                                    .toList();

                            if (otherJobs.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No hay más trabajos publicados por tu empresa',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: otherJobs.length,
                              itemBuilder: (context, index) {
                                final otherJob = otherJobs[index];
                                return FadeInUp(
                                  delay: Duration(milliseconds: 200 * index),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 15.0,
                                    ),
                                    child: CompanyJobCard(
                                      job: Job(
                                        id: otherJob.id ?? '',

                                        description:
                                            job.description ??
                                            'Sin descripción',
                                        companyName:
                                            company?.companyName ?? 'Empresa',
                                        location:
                                            otherJob.location ?? 'Lima, Perú',
                                        title:
                                            otherJob.title ??
                                            'Puesto sin título',
                                        type:
                                            otherJob.type ?? 'Tiempo Completo',
                                        matchPercentage: 0,
                                        salaryMin: otherJob.salaryMin,

                                        salaryMax: otherJob.salaryMax,
                                        logoBackgroundColor:
                                            Colors.blue.shade100,
                                        modality: otherJob.modality,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Widget _buildTag(String text, {Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (textColor ?? Colors.blue.shade800).withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.blue.shade800,
          fontSize: 13,
        ),
      ),
    );
  }

  void _showEditJobDialog(BuildContext context, Job jobToEdit) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Editar Trabajo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PostJobForm(
                      isEditing: true,
                      existingJob: jobToEdit, // Pass the current job data
                      onJobUpdated: (updatedJob) {
                        // Update the current job immediately when form is submitted
                        setState(() {
                          currentJob = updatedJob;
                        });

                        // Invalidate relevant providers to refresh data elsewhere
                        final company = ref.read(companyProfileProvider);
                        if (company != null) {
                          ref.invalidate(
                            jobsByCompanyIdProvider(company.userId),
                          );
                        }
                        ref.invalidate(jobsProviderWithCompanyName);

                        // Close the dialog
                        Navigator.of(dialogContext).pop();

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Trabajo actualizado exitosamente'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que quieres eliminar "${currentJob.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop(); // Close dialog

                  // Show loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16),
                          Text('Eliminando trabajo...'),
                        ],
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Delete job using the provider
                  final company = ref.read(companyProfileProvider);
                  final result = await ref.read(
                    deleteJobProvider(currentJob.id).future,
                  );

                  if (context.mounted) {
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Trabajo eliminado exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Refresh jobs list if needed
                      if (company != null) {
                        ref.invalidate(jobsByCompanyIdProvider(company.userId));
                      }

                      // Navigate back to previous screen
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al eliminar el trabajo'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  // Helper method to translate status to Spanish for display
  String _getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Abierto';
      case 'closed':
        return 'Cerrado';
      case 'paused':
        return 'Pausado';
      default:
        return status; // Return original if unknown
    }
  }

  int _getPublishedDays() {
    // In a real app, this would be calculated from the job's publication date
    return 3;
  }

  // Helper method to determine color based on job status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green.shade700;
      case 'closed':
        return Colors.red.shade700;
      case 'paused':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
