import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/config/util/form_utils.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/cv_parsing.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/screens/auth/widgets/cv_lottie_dialog.dart';
import 'package:job_match/presentation/screens/auth/widgets/right_sing_up_image_information.dart';
import 'package:job_match/presentation/screens/auth/widgets/testimonial_carousel.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/screens/homepage/find_jobs_screen.dart';
import 'package:job_match/presentation/screens/dashboard/employer_dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String userType;

  const LoginScreen({super.key, this.userType = 'Candidato'});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _termsAgreed = false;
  final bool _passwordVisible = false;
  bool _showLoginForm = true;
  bool _isLoading = false; // Added for loading state

  // Text Editing Controllers
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  // Text controllers for signup fields (candidate)
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _bioController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _resumeUrlController = TextEditingController();
  final _experienceResume = TextEditingController();

  // Text controllers for signup fields (company)
  final _companyNameController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _companyLocationController = TextEditingController();
  final _companyDescriptionController = TextEditingController();

  String _companyIndustry = 'Tecnología';

  String _selectedUserType = 'Candidato';
  final _formKey = GlobalKey<FormState>();
  String? _selectedLogoPath; // Add this to track selected logo

  @override
  void initState() {
    super.initState();
    _selectedUserType = widget.userType;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _skillsController.dispose();
    _bioController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _resumeUrlController.dispose();
    _companyNameController.dispose();
    _experienceResume.dispose();
    _companyPhoneController.dispose();
    _companyLocationController.dispose();
    _companyDescriptionController.dispose();
    super.dispose();
  }

  // Cambia el tipo de usuario globalmente usando Riverpod
  void _setUserType(bool isCandidate) {
    ref.read(isCandidateProvider.notifier).state = isCandidate;
  }

  void _prefillForm(String? userType) {
    setState(() {
      _selectedUserType = userType ?? '';
      // No mock data, just clear fields
      _emailController.clear();
      _passwordController.clear();
      _fullNameController.clear();
      _phoneController.clear();
      _locationController.clear();
      _skillsController.clear();
      _companyNameController.clear();
      _companyPhoneController.clear();
      _companyLocationController.clear();
      _companyDescriptionController.clear();
      _selectedLogoPath = null; // Clear logo selection
      // Actualiza el provider global según selección
      _setUserType(_selectedUserType == 'Candidato');
    });
  }

  Future<void> _pickCompanyLogo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedLogoPath = result.files.single.name;
        });

        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logo seleccionado: ${result.files.single.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error seleccionando logo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final defaultTextStyle = TextStyle(color: Colors.grey.shade900);
  
  InputDecoration defaultIconDecoration(String labelText, {IconData? icon}) {
    return InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
    );
  }

  void _toggleForm() {
    setState(() {
      _showLoginForm = !_showLoginForm;
      _prefillForm(_selectedUserType);
    });
  }

  Column _loginHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _showLoginForm ? 'Iniciar Sesión' : 'Registrarse',
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              _showLoginForm
                                  ? "¿No tienes cuenta?"
                                  : "¿Ya tienes cuenta?",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          GestureDetector(
                            onTap: _toggleForm,
                            child: Text(
                              _showLoginForm ? 'Regístrate' : 'Iniciar Sesión',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24.0),
                // Fix: Wrap DropdownButtonFormField in Flexible to avoid overflow
                Flexible(
                  child: DropdownButtonFormField<String>(
                    decoration: defaultIconDecoration('Tipo de usuario'),
                    value: _selectedUserType,
                    items:
                        ['Candidato', 'Empresa'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: defaultTextStyle),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      _prefillForm(newValue);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCandidateSignupForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          decoration: defaultIconDecoration(
            'Correo electrónico',
            icon: Icons.email_outlined,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: FormUtils.validateEmailForSingUp,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _passwordController,
          decoration: defaultIconDecoration(
            'Contraseña',
            icon: Icons.lock_outline,
          ),
          obscureText: true,
          validator: FormUtils.validatePasswordForSingUp,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _fullNameController,
          decoration: defaultIconDecoration(
            'Nombre completo',
            icon: Icons.person_outline,
          ),
          validator: FormUtils.validateName,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _phoneController,
          decoration: defaultIconDecoration(
            'Número de teléfono (opcional)',
            icon: Icons.phone_outlined,
          ),
          validator: FormUtils.validatePhone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _locationController,
          decoration: defaultIconDecoration(
            'Ubicación (ciudad/país)',
            icon: Icons.location_on_outlined,
          ),
          validator: FormUtils.validateAddress,
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          decoration: defaultIconDecoration(
            'Nivel de experiencia',
            icon: Icons.work_outline,
          ),
          value:
              ['Junior', 'Mid', 'Senior'].contains(_experienceController.text)
                  ? _experienceController.text
                  : null,
          items:
              ['Junior', 'Mid', 'Senior'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: defaultTextStyle),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _experienceController.text = newValue;
              });
            }
          },
          validator: FormUtils.validateExperience,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _educationController,
          decoration: defaultIconDecoration(
            'Educación (ej: Licenciatura en X, Universidad Y)',
            icon: Icons.school_outlined,
          ),
          validator: FormUtils.validateEducation,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _experienceResume,
          decoration: defaultIconDecoration(
            'Experiencia laboral (breve resumen)',
            icon: Icons.work_history_outlined,
          ),
          validator: FormUtils.validateWorkExperience,
        ),

        const SizedBox(height: 16.0),
        TextFormField(
          controller: _resumeUrlController,
          decoration: defaultIconDecoration(
            'URL de tu CV (opcional)',
            icon: Icons.link,
          ),
          validator: FormUtils.validateUrlCv,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _skillsController,
          decoration: defaultIconDecoration(
            'Habilidades principales (separadas por comas)',
            icon: Icons.psychology_outlined,
          ),
          validator: FormUtils.validateSkillsSeparatedByCommas,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _bioController,
          decoration: defaultIconDecoration(
            'Biografía o descripción del perfil',
            icon: Icons.description_outlined,
          ),
          maxLines: 4,
          validator: FormUtils.validateBio,
        ),
      ],
    );
  }

  Widget _buildCompanySignupForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          decoration: defaultIconDecoration(
            'Correo electrónico',
            icon: Icons.email_outlined,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: FormUtils.validateEmailForSingUp
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _passwordController,
          decoration: defaultIconDecoration(
            'Contraseña',
            icon: Icons.lock_outline,
          ),
          obscureText: true,
          validator: FormUtils.validatePasswordForSingUp,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyNameController,
          decoration: defaultIconDecoration(
            'Nombre de la empresa',
            icon: Icons.business_outlined,
          ),
          validator: FormUtils.validateCompanyName,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyPhoneController,
          decoration: defaultIconDecoration(
            'Teléfono de contacto',
            icon: Icons.phone_outlined,
          ),
          keyboardType: TextInputType.phone,
          validator: FormUtils.validateCompanyPhone,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyLocationController,
          decoration: defaultIconDecoration(
            'Ubicación o dirección (ciudad/país)',
            icon: Icons.location_on_outlined,
          ),
          validator: FormUtils.validateAddress,
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          decoration: defaultIconDecoration(
            'Industria',
            icon: Icons.category_outlined,
          ),
          value: _companyIndustry,
          items:
              [
                'Tecnología',
                'Educación',
                'Finanzas',
                'Salud',
                'Comercio',
                'Servicios',
                'Manufactura',
                'Otro',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: defaultTextStyle),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _companyIndustry = newValue;
              });
            }
          },
          validator: FormUtils.validateIndustrySelected,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyDescriptionController,
          decoration: defaultIconDecoration(
            'Descripción breve de la empresa',
            icon: Icons.description_outlined,
          ),
          maxLines: 3,
          validator: FormUtils.validateCompanyDescription,
        ),
        const SizedBox(height: 16.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Logo de la empresa',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickCompanyLogo,
                icon: Icon(
                  _selectedLogoPath != null
                      ? Icons.check_circle
                      : Icons.upload_file,
                ),
                label: Text(
                  _selectedLogoPath != null
                      ? 'Logo seleccionado: $_selectedLogoPath'
                      : 'Seleccionar logo de empresa',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedLogoPath != null ? Colors.green[50] : null,
                  foregroundColor:
                      _selectedLogoPath != null ? Colors.green[700] : null,
                ),
              ),
              if (_selectedLogoPath != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Archivo seleccionado: $_selectedLogoPath',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.sizeOf(context);
        final width = size.width;
        final isMedium = width > 600;
        final isWide = width > 900;

        // Responsive paddings
        final horizontalPadding = isWide ? 64.0 : 24.0;
        final verticalPadding = isWide ? 64.0 : 24.0;

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Botón atrás
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black87,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              tooltip: 'Atrás',
                            ),
                          ),
                          const SizedBox(height: 16),
                          _loginHeader(),
                          const SizedBox(height: 30.0),

                          // Conditional form content based on login or signup
                          if (_showLoginForm) ...[
                            TextFormField(
                              controller: _emailController,
                              decoration: defaultIconDecoration('Correo electrónico'),
                              style: defaultTextStyle,
                              validator: FormUtils.validateEmailLogin
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              decoration: defaultIconDecoration('Contraseña'),
                              obscureText: !_passwordVisible,
                              style: defaultTextStyle,
                              validator: FormUtils.validatePasswordLogin,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Checkbox(
                                  value: _termsAgreed,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _termsAgreed = value ?? false;
                                    });
                                  },
                                  tristate: false,
                                ),
                                const Text('He leído y acepto los '),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Términos de Servicio',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                          ] else if (_selectedUserType == 'Candidato') ...[
                            _buildCandidateSignupForm(),
                            const SizedBox(height: 24.0),
                          ] else ...[
                            _buildCompanySignupForm(),
                            const SizedBox(height: 24.0),
                          ],

                          // Single main button for login or signup
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                // Disable button when loading
                                disabledBackgroundColor: Colors.blueAccent.withOpacity(0.7),
                              ),
                              onPressed: _isLoading ? null : () async {

                                if (_formKey.currentState!.validate()) {
                                  if (!_termsAgreed) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Acepta los términos de servicio para continuar.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isLoading = true; // Start loading
                                  });
                                  try {
                                    _setUserType(
                                      _selectedUserType == 'Candidato',
                                    );
                                    if (_showLoginForm) {
                                      // LOGIN
                                      await signOut();
                                      await login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                      await fetchUserProfile(ref);
                                      final candidate = ref.read(
                                        candidateProfileProvider,
                                      );
                                      final company = ref.read(
                                        companyProfileProvider,
                                      );
                                      if (!context.mounted) return;
                                      if (_selectedUserType == 'Candidato' &&
                                          candidate != null) {
                                        Navigator.of(context).pushReplacement(
                                          FadeThroughPageRoute(
                                            page: const FindJobsScreen(),
                                          ),
                                        );
                                      } else if (_selectedUserType ==
                                              'Empresa' &&
                                          company != null) {
                                        Navigator.of(context).pushReplacement(
                                          FadeThroughPageRoute(
                                            page:
                                                const EmployerDashboardScreen(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'No se encontró perfil asociado a este usuario.',
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (_selectedUserType == 'Candidato') {
                                        // REGISTRO CANDIDATO
                                        await signOut();
                                        final success = await registerCandidate(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          name: _fullNameController.text,
                                          phone: _phoneController.text,
                                          location: _locationController.text,
                                          experienceLevel:
                                              _experienceController.text,
                                          experience: _experienceResume.text,
                                          skills:
                                              _skillsController.text
                                                  .split(',')
                                                  .map((e) => e.trim())
                                                  .where((e) => e.isNotEmpty)
                                                  .toList(),
                                          bio: _bioController.text,
                                          resumeUrl:
                                              _resumeUrlController
                                                      .text
                                                      .isNotEmpty
                                                  ? _resumeUrlController.text
                                                  : null,
                                          education: _educationController.text,
                                        );
                                        if (!context.mounted) return;
                                        if (success) {
                                          await fetchUserProfile(ref);
                                          final candidate = ref.read(
                                            candidateProfileProvider,
                                          );
                                          if (candidate != null) {
                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              FadeThroughPageRoute(
                                                page: const FindJobsScreen(),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'No se encontró perfil de candidato tras el registro.',
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Error al registrar el candidato',
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        // REGISTRO EMPRESA
                                        String? logoUrl;
                                        FilePickerResult? result;

                                        if (_selectedLogoPath != null) {
                                          // Attempt to get the previously picked file's bytes
                                          // This assumes _pickCompanyLogo stored the result or path
                                          // For simplicity, we re-pick if path is just a name.
                                          // A more robust solution would cache the FileBytes.
                                          result = await FilePicker.platform.pickFiles(
                                            type: FileType.image,
                                            allowMultiple: false,
                                            withData: true,
                                          );

                                          if (result != null && result.files.single.bytes != null) {
                                            // Show dialog while uploading logo
                                            if (context.mounted) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) => const Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              );
                                            }
                                            final uploadLogo = ref.read(uploadCompanyLogoProvider);
                                            try {
                                              logoUrl = await uploadLogo(
                                                result.files.single.bytes!,
                                                result.files.single.name,
                                              );
                                            } catch (e) {
                                              if (context.mounted) Navigator.of(context, rootNavigator: true).pop(); // Close dialog
                                              throw Exception('Error al subir logo: $e');
                                            }
                                            if (context.mounted) Navigator.of(context, rootNavigator: true).pop(); // Close dialog
                                          }
                                        }

                                        await registerCompany(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          companyName: _companyNameController.text,
                                          phone: _companyPhoneController.text,
                                          address: _companyLocationController.text,
                                          industry: _companyIndustry,
                                          description: _companyDescriptionController.text,
                                          website: null,
                                          logo: logoUrl,
                                        );

                                        if (!context.mounted) return;
                                        await fetchUserProfile(ref);
                                        final company = ref.read(companyProfileProvider);

                                        if (company != null) {
                                          Navigator.of(context).pushReplacement(
                                            FadeThroughPageRoute(
                                              page: const EmployerDashboardScreen(),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'No se encontró perfil de empresa tras el registro.',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  } finally {
                                    if (context.mounted) {
                                      setState(() {
                                        _isLoading = false; // Stop loading
                                      });
                                    }
                                  }
                                } else {
                                  // Form is not valid, or user type not selected
                                  // (The user type dropdown has its own validation implicitly)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Por favor completa todos los campos requeridos.',
                                      ),
                                    ),
                                  );

                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.0,
                                        ),
                                      )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _showLoginForm
                                          ? 'Iniciar Sesión'
                                          : 'Registrarse',
                                    ),
                                    const SizedBox(width: 8.0),
                                    Icon(
                                      _showLoginForm
                                          ? Icons.login
                                          : Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          _signUpOptions(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Imagen (derecha)
                if (isMedium)
                  RightSingUpImageInformation(isWide: isWide, isMedium: isMedium),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCVAnimationAndNavigate() async {
    // Check if email and password are filled
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa el correo y contraseña para continuar con el CV',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading for CV upload
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final filename = result.files.single.name;

      // Muestra el diálogo de animación y espera el parsing real
      showDialog(
        context: context,
        barrierColor: Colors.black.withAlpha(220),
        barrierDismissible: false,
        builder: (_) => const CVLottieDialog(),
      );

      try {
        final parser = ref.read(parseCandidateProvider);
        // Parse CV using the provided email and password
        final candidate = await parser.parseAndSaveCandidate(
          bytes: bytes,
          filename: filename,
          email: _emailController.text,
          password: _passwordController.text,
        );

        final uploadCv = ref.read(uploadCvProvider);
        final url = await uploadCv(bytes, filename);
        if (mounted) Navigator.of(context, rootNavigator: true).pop();

        // Set the candidate as current user in provider
        ref.read(candidateProfileProvider.notifier).state = candidate.copyWith(
          resumeUrl: url,
        );
        ref.read(isCandidateProvider.notifier).state = true;

        // Navega al perfil
        if (mounted) {
          Navigator.of(
            context,
          ).push(FadeThroughPageRoute(page: const UserProfile()));
        }
      } catch (e) {
        // Cierra el diálogo si ocurre error
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al procesar el CV: $e')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Stop loading
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se seleccionó ningún CV')),
      );
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading if no CV selected
        });
      }
    }
  }

  Column _signUpOptions() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('o'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16.0),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 42,
          runSpacing: 12.0,
          children: [
            OutlinedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              icon: const Icon(Icons.upload_file, color: Colors.green),
              label: const Text(
                'Iniciar con CV',
                style: TextStyle(color: Colors.black87),
              ),
              // Only enable CV upload when:
              // 1. In login mode (not signup mode)
              // 2. User type is Candidate
              // 3. Not currently loading
              onPressed: _isLoading || (_selectedUserType == 'Empresa' || !_showLoginForm)
                  ? null
                  : _showCVAnimationAndNavigate,
              // Note: We maintain the disabled logic for company user type
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        TestimonialCarousel(),
      ],
    );
  }
}