import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/cv_parsing.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/screens/auth/widgets/info_card.dart';
import 'package:job_match/presentation/screens/auth/widgets/left_cut_trapezoid_clipper.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';
import 'package:job_match/presentation/screens/profiles/company_profile_screen.dart'; // For company profile navigation
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _termsAgreed = false;
  final bool _passwordVisible = false;
  bool _showLoginForm = true;

  // Text Editing Controllers
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  // Text controllers for signup fields (candidate)
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _resumeUrlController = TextEditingController();
  final TextEditingController _experienceResume = TextEditingController();

  // Text controllers for signup fields (company)
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyLocationController =
      TextEditingController();
  final TextEditingController _companyDescriptionController =
      TextEditingController();
  String _companyIndustry = 'Tecnología';

  String _selectedUserType = 'Candidato';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
      _termsAgreed = false;
      // Actualiza el provider global según selección
      _setUserType(_selectedUserType == 'Candidato');
    });
  }

  final defaultTextStyle = TextStyle(color: Colors.grey.shade900);
  InputDecoration defaultIconDecoration(String labelText, {IconData? icon}) =>
      InputDecoration(
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
        Row(
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
                      Text(
                        _showLoginForm
                            ? "¿No tienes cuenta?"
                            : "¿Ya tienes cuenta?",
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
            SizedBox(
              width: 180,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu correo electrónico';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _passwordController,
          decoration: defaultIconDecoration(
            'Contraseña',
            icon: Icons.lock_outline,
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu contraseña';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _fullNameController,
          decoration: defaultIconDecoration(
            'Nombre completo',
            icon: Icons.person_outline,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu nombre completo';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _phoneController,
          decoration: defaultIconDecoration(
            'Número de teléfono (opcional)',
            icon: Icons.phone_outlined,
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _locationController,
          decoration: defaultIconDecoration(
            'Ubicación (ciudad/país)',
            icon: Icons.location_on_outlined,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu ubicación';
            }
            return null;
          },
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
              ['Sin experiencia', 'Junior', 'Mid', 'Senior'].map((
                String value,
              ) {
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
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _educationController,
          decoration: defaultIconDecoration(
            'Educación (ej: Licenciatura en X, Universidad Y)',
            icon: Icons.school_outlined,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu educación';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _experienceResume,
          decoration: defaultIconDecoration(
            'Experiencia laboral (breve resumen)',
            icon: Icons.work_history_outlined,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor describe tu experiencia';
            }
            return null;
          },
        ),

        const SizedBox(height: 16.0),
        TextFormField(
          controller: _resumeUrlController,
          decoration: defaultIconDecoration(
            'URL de tu CV (opcional)',
            icon: Icons.link,
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _skillsController,
          decoration: defaultIconDecoration(
            'Habilidades principales (separadas por comas)',
            icon: Icons.psychology_outlined,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa al menos una habilidad';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _bioController,
          decoration: defaultIconDecoration(
            'Biografía o descripción del perfil',
            icon: Icons.description_outlined,
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa una breve biografía o descripción';
            }
            return null;
          },
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un correo electrónico';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _passwordController,
          decoration: defaultIconDecoration(
            'Contraseña',
            icon: Icons.lock_outline,
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa una contraseña';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyNameController,
          decoration: defaultIconDecoration(
            'Nombre de la empresa',
            icon: Icons.business_outlined,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el nombre de la empresa';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyPhoneController,
          decoration: defaultIconDecoration(
            'Teléfono de contacto',
            icon: Icons.phone_outlined,
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un teléfono de contacto';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyLocationController,
          decoration: defaultIconDecoration(
            'Ubicación o dirección (ciudad/país)',
            icon: Icons.location_on_outlined,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa la ubicación';
            }
            return null;
          },
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
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyDescriptionController,
          decoration: defaultIconDecoration(
            'Descripción breve de la empresa',
            icon: Icons.description_outlined,
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa una descripción';
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Image picker logic would go here
          },
          child: const Text('Subir logo o imagen representativa'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 900;
    final isMedium = MediaQuery.sizeOf(context).width > 600;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 64.0 : 24.0,
                  vertical: isWide ? 64.0 : 24.0,
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
                          decoration: defaultIconDecoration(
                            'Correo electrónico',
                          ),
                          style: defaultTextStyle,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: defaultIconDecoration('Contraseña'),
                          obscureText: !_passwordVisible,
                          style: defaultTextStyle,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Checkbox(
                              value: _termsAgreed,
                              onChanged: (bool? value) {
                                setState(() {
                                  _termsAgreed = value!;
                                });
                              },
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
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _setUserType(_selectedUserType == 'Candidato');
                              if (_showLoginForm) {
                                // LOGIN
                                try {
                                  await signOut(); // Cierra sesión antes de login
                                  final user = await login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  // Verifica perfil
                                  await fetchUserProfile(ref);
                                  final candidate = ref.read(
                                    candidateProfileProvider,
                                  );
                                  final company = ref.read(
                                    companyProfileProvider,
                                  );
                                  if (_selectedUserType == 'Candidato' &&
                                      candidate != null) {
                                    Navigator.of(context).push(
                                      FadeThroughPageRoute(
                                        page: const UserProfile(),
                                      ),
                                    );
                                  } else if (_selectedUserType == 'Empresa' &&
                                      company != null) {
                                    Navigator.of(context).push(
                                      FadeThroughPageRoute(
                                        page: const CompanyProfileScreen(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'No se encontró perfil asociado a este usuario.',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              } else {
                                if (_selectedUserType == 'Candidato') {
                                  // REGISTRO CANDIDATO
                                  try {
                                    await signOut(); // Cierra sesión antes de sign up
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
                                          _resumeUrlController.text.isNotEmpty
                                              ? _resumeUrlController.text
                                              : null,
                                      education: _educationController.text,
                                    );
                                    if (success) {
                                      await fetchUserProfile(ref);
                                      final candidate = ref.read(
                                        candidateProfileProvider,
                                      );
                                      if (candidate != null) {
                                        // Navega solo si el perfil existe
                                        Navigator.of(context).push(
                                          FadeThroughPageRoute(
                                            page: const UserProfile(),
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
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                } else {
                                  // REGISTRO EMPRESA
                                  try {
                                    await signOut(); // Cierra sesión antes de sign up
                                    await registerCompany(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      companyName: _companyNameController.text,
                                      phone: _companyPhoneController.text,
                                      address: _companyLocationController.text,
                                      industry: _companyIndustry,
                                      description:
                                          _companyDescriptionController.text,
                                      website: null,
                                      logo: null,
                                    );
                                    await fetchUserProfile(ref);
                                    final company = ref.read(
                                      companyProfileProvider,
                                    );
                                    if (company != null) {
                                      Navigator.of(context).push(
                                        FadeThroughPageRoute(
                                          page: const CompanyProfileScreen(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'No se encontró perfil de empresa tras el registro.',
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Por favor selecciona un tipo de usuario',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
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
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: double.infinity,
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: LeftCutTrapezoidClipper(),
                        child: Image.asset(
                          'assets/images/login_background.png',

                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(60.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),

                            const Text(
                              'Más de 175,324 candidatos\nesperando buenas empresas.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 20,
                                children: [
                                  InfoCard(
                                    title: '175,324',
                                    subtitle: 'Empleos Activos',
                                    icon: const Icon(
                                      Icons.work_outline,
                                      color: Colors.white,
                                      size: 42,
                                    ),
                                  ),
                                  Spacer(),

                                  InfoCard(
                                    title: '97,354',
                                    subtitle: 'Empresas',
                                    icon: const Icon(
                                      Icons.location_city,
                                      color: Colors.white,
                                      size: 42,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Spacer(),

                                  InfoCard(
                                    title: '7,532',
                                    subtitle: 'Nuevos Empleos',
                                    icon: const Icon(
                                      Icons.work_outline,
                                      color: Colors.white,
                                      size: 42,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  void _showCVAnimationAndNavigate() async {
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
        builder: (_) => const _CVLottieDialog(),
      );

      try {
        final tempUserId = const Uuid().v4();
        final parser = ref.read(parseCandidateProvider);
        // Parse CV and create new user (esto puede demorar)
        final candidate = await parser.parseAndSaveCandidate(
          bytes: bytes,
          filename: filename,
          userId: tempUserId,
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
        Navigator.of(
          context,
        ).push(FadeThroughPageRoute(page: const UserProfile()));
      } catch (e) {
        // Cierra el diálogo si ocurre error
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al procesar el CV: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se seleccionó ningún CV')),
      );
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
              icon: const Icon(Icons.facebook, color: Colors.blue),
              label: const Text(
                'Iniciar con Facebook',
                style: TextStyle(color: Colors.black87),
              ),
              onPressed: () {},
            ),
            OutlinedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              icon: const Icon(Icons.mail_outline, color: Colors.red),
              label: const Text(
                'Iniciar con Google',
                style: TextStyle(color: Colors.black87),
              ),
              onPressed: () {},
            ),
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
              onPressed: _showCVAnimationAndNavigate,
            ),
          ],
        ),
      ],
    );
  }
}

class _CVLottieDialog extends StatefulWidget {
  const _CVLottieDialog();

  @override
  State<_CVLottieDialog> createState() => _CVLottieDialogState();
}

class _CVLottieDialogState extends State<_CVLottieDialog> {
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                'assets/animations/cv_lottie.json',
                width: 250,
                height: 250,
                repeat: true, // Keep repeating until dialog is closed
              ),
            ),
            const Text(
              'Leyendo Datos...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
