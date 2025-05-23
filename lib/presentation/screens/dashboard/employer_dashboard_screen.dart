import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/dashboard/employer/post_job_form.dart';
import 'package:job_match/presentation/screens/employer/find_employees_screen.dart';
import 'package:job_match/presentation/screens/employer/company_jobs_screen.dart';

class EmployerDashboardScreen extends ConsumerStatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  ConsumerState<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState
    extends ConsumerState<EmployerDashboardScreen> {
  bool _showPublishButton = true;

  void _showJobPostingDialog() {
    final company = ref.read(companyProfileProvider);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: MediaQuery.of(dialogContext).size.width * 0.8,
            height: MediaQuery.of(dialogContext).size.height * 0.9,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Publicar Nueva Vacante',
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
                ),
                Expanded(
                  child: PostJobForm(
                    companyId: company?.userId ?? '',
                    onJobPosted: () async {
                      // Close dialog immediately
                      Navigator.of(dialogContext).pop();

                      // Schedule state updates for next frame
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _showPublishButton = false; // Show success UI
                          });

                          // Invalidate provider after state update
                          if (company?.userId != null) {
                            ref.invalidate(
                              jobsByCompanyIdProvider(company!.userId),
                            );
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Empleo publicado exitosamente!'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // After a delay, revert to the initial UI to allow the success message to show again on next post
                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) {
                              setState(() {
                                _showPublishButton =
                                    true; // Revert to "Publicar Empleo" button UI
                              });
                            }
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final company = ref.watch(companyProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: 70),
          Expanded(
            child: Center(
              child: FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueGrey,
                      backgroundImage: company?.logo != null
                          ? NetworkImage(company!.logo!)
                          : null,
                      child: company?.logo != null
                          ? null
                          : const Icon(
                              Icons.business,
                              size: 60,
                              color: Colors.white,
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenido, ${company?.companyName ?? 'Mi Empresa'}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      company?.industry ?? 'Industria no especificada',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_showPublishButton)
                      Column(
                        children: [
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            child: ElevatedButton.icon(
                              onPressed: _showJobPostingDialog,
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Publicar Empleo'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FadeInUp(
                            delay: const Duration(milliseconds: 400),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const FindEmployeesScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.search),
                                  label: const Text('Buscar Empleados'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Use addPostFrameCallback to avoid setState during build
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      CompanyJobsScreen(
                                                        companyId:
                                                            company?.userId ??
                                                            '',
                                                      ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.work_outline),
                                  label: const Text('Ver Empleos Publicados'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (!_showPublishButton)
                      FadeInUp(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '¡Empleo publicado exitosamente!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _showJobPostingDialog,
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Publicar Otro Empleo'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const FindEmployeesScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.search),
                                  label: const Text('Buscar Empleados'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Use addPostFrameCallback to avoid setState during build
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      CompanyJobsScreen(
                                                        companyId:
                                                            company?.userId ??
                                                            '',
                                                      ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.work_outline),
                                  label: const Text('Ver Empleos Publicados'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
