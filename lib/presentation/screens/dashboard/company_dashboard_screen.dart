import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/company_model.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/widgets/dashboard/employer/post_job_form.dart';
import 'package:job_match/presentation/screens/employer/find_employees_screen.dart';
import 'package:job_match/presentation/screens/employer/company_jobs_screen.dart';
import 'package:job_match/presentation/widgets/common/profile_photo_picker.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: isMobile ? screenSize.width * 0.9 : screenSize.width * 0.7,
            height:
                isMobile ? screenSize.height * 0.85 : screenSize.height * 0.8,
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
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: 70),
          Expanded(
            child: Center(
              child: FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? kPadding16 : kPadding20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfilePhotoPicker(
                        currentPhotoUrl: company?.logo,
                        isCompany: true,
                        onPhotoUpdated: () {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Bienvenido, ${company?.companyName ?? 'Mi Empresa'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 22 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        company?.industry ?? 'Industria no especificada',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (_showPublishButton)
                        _buildActionButtons(isMobile, company),
                      if (!_showPublishButton) _buildSuccessView(isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile, Company? company) {
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 32,
        vertical: isMobile ? 12 : 16,
      ),
      textStyle: TextStyle(fontSize: isMobile ? 14 : 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius8),
      ),
    );

    final secondaryButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 10 : 12,
      ),
      textStyle: TextStyle(fontSize: isMobile ? 13 : 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius8),
      ),
    );

    Widget mainButtons = Column(
      children: [
        FadeInUp(
          delay: const Duration(milliseconds: 300),
          child: ElevatedButton.icon(
            onPressed: _showJobPostingDialog,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Publicar Empleo'),
            style: buttonStyle.copyWith(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        if (isMobile) ...[
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FindEmployeesScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Buscar Empleados'),
              style: secondaryButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: ElevatedButton.icon(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => CompanyJobsScreen(
                            company: company!,
                            companyId: company.userId ?? '',
                          ),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.work_outline),
              label: const Text('Ver Empleos Publicados'),
              style: secondaryButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.orange),
              ),
            ),
          ),
        ] else
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FindEmployeesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar Empleados'),
                  style: secondaryButtonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(Colors.green),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => CompanyJobsScreen(
                                company: company!,
                                companyId: company.userId ?? '',
                              ),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.work_outline),
                  label: const Text('Ver Empleos Publicados'),
                  style: secondaryButtonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(Colors.orange),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    return mainButtons;
  }

  Widget _buildSuccessView(bool isMobile) {
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 32,
        vertical: isMobile ? 12 : 16,
      ),
      textStyle: TextStyle(fontSize: isMobile ? 14 : 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius8),
      ),
    );
    final secondaryButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 10 : 12,
      ),
      textStyle: TextStyle(fontSize: isMobile ? 13 : 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius8),
      ),
    );

    return FadeInUp(
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: isMobile ? 48 : 64,
          ),
          const SizedBox(height: 16),
          Text(
            '¡Empleo publicado exitosamente!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showJobPostingDialog,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Publicar Otro Empleo'),
            style: buttonStyle.copyWith(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          if (isMobile) ...[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FindEmployeesScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Buscar Empleados'),
              style: secondaryButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.green),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                final company = ref.read(companyProfileProvider);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => CompanyJobsScreen(
                            company: company!,
                            companyId: company.userId ?? '',
                          ),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.work_outline),
              label: const Text('Ver Empleos Publicados'),
              style: secondaryButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.orange),
              ),
            ),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FindEmployeesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar Empleados'),
                  style: secondaryButtonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(Colors.green),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final company = ref.read(companyProfileProvider);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => CompanyJobsScreen(
                                company: company!,
                                companyId: company.userId ?? '',
                              ),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.work_outline),
                  label: const Text('Ver Empleos Publicados'),
                  style: secondaryButtonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(Colors.orange),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
