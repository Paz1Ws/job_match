import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/config/util/form_utils.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/cv_parsing.dart';
import 'package:job_match/core/data/google_sign_in.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/presentation/screens/auth/widgets/cv_lottie_dialog.dart';
import 'package:job_match/presentation/screens/auth/widgets/right_sing_up_image_information.dart';
import 'package:job_match/presentation/screens/auth/widgets/testimonial_carousel.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/presentation/screens/homepage/find_jobs_screen.dart';
import 'package:job_match/presentation/screens/dashboard/employer_dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String userType;

  const LoginScreen({super.key, this.userType = 'Candidato'});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final bool _termsAgreed = false;
  final bool _passwordVisible = false;
  bool _showLoginForm = true;
  bool _isLoading = false;

  // Text Editing Controllers
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  // Candidate signup fields
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _bioController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceResume = TextEditingController();
  final _countryController = TextEditingController();
  final _mainPositionController = TextEditingController(); // Added

  // Company signup fields
  final _companyNameController = TextEditingController();
  final _companyPhoneController = TextEditingController();
  final _companyLocationController = TextEditingController();
  final _companyDescriptionController = TextEditingController();

  String _companyIndustry = 'Tecnología';
  String _selectedUserType = 'Candidato';
  final _formKey = GlobalKey<FormState>();

  // File selection variables
  String? _selectedLogoPath;
  String? _selectedCandidatePhotoPath;
  Uint8List? _selectedCandidatePhotoBytes;

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
    _mainPositionController.dispose(); // Added
    _experienceResume.dispose();
    _companyNameController.dispose();
    _companyPhoneController.dispose();
    _companyLocationController.dispose();
    _companyDescriptionController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _setUserType(bool isCandidate) {
    ref.read(isCandidateProvider.notifier).state = isCandidate;
  }

  void _prefillForm(String? userType) {
    setState(() {
      _selectedUserType = userType ?? '';
      _emailController.clear();
      _passwordController.clear();
      _fullNameController.clear();
      _phoneController.clear();
      _locationController.clear();
      _countryController.clear();
      _skillsController.clear();
      _educationController.clear();
      _mainPositionController.clear(); // Added
      _experienceResume.clear();
      _bioController.clear();
      _companyNameController.clear();
      _companyPhoneController.clear();
      _companyLocationController.clear();
      _companyDescriptionController.clear();
      _selectedLogoPath = null;
      _selectedCandidatePhotoPath = null;
      _selectedCandidatePhotoBytes = null;
      _setUserType(_selectedUserType == 'Candidato');
    });
  }

  Future<void> _pickFile({
    required bool isLogo,
    required Function(String name, Uint8List bytes) onPicked,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final name = result.files.single.name;
        final bytes = result.files.single.bytes!;

        onPicked(name, bytes);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${isLogo ? 'Logo' : 'Foto'} seleccionado: $name'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error seleccionando ${isLogo ? 'logo' : 'foto'}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickCompanyLogo() async {
    return _pickFile(
      isLogo: true,
      onPicked: (name, _) {
        setState(() {
          _selectedLogoPath = name;
        });
      },
    );
  }

  Future<void> _pickCandidatePhoto() async {
    return _pickFile(
      isLogo: false,
      onPicked: (name, bytes) {
        setState(() {
          _selectedCandidatePhotoPath = name;
          _selectedCandidatePhotoBytes = bytes;
        });
      },
    );
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

  Widget _buildFileSelectionField({
    required String title,
    required String? selectedPath,
    required VoidCallback onSelect,
    IconData icon = Icons.upload_file,
  }) {
    return Container(
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
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onSelect,
            icon: Icon(
              selectedPath != null ? Icons.check_circle : Icons.upload_file,
            ),
            label: Text(
              selectedPath != null
                  ? 'Seleccionado: $selectedPath'
                  : 'Seleccionar',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedPath != null ? Colors.green[50] : null,
              foregroundColor: selectedPath != null ? Colors.green[700] : null,
            ),
          ),
          if (selectedPath != null) ...[
            const SizedBox(height: 8),
            Text(
              'Archivo seleccionado: $selectedPath',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCandidateSignupForm() {
    const educationLevels = [
      'Primaria',
      'Secundaria',
      'Técnico',
      'Universitario Incompleto',
      'Universitario Completo',
      'Maestría',
      'Doctorado',
      'Otro',
    ];

    const countries = [
      'Perú',
      'Argentina',
      'Colombia',
      'Chile',
      'México',
      'España',
      'Otro',
    ];

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
            'Número de teléfono',
            icon: Icons.phone_outlined,
          ),
          validator: FormUtils.validateCompanyPhone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _locationController,
          decoration: defaultIconDecoration(
            'Ciudad',
            icon: Icons.location_city,
          ),
          validator: FormUtils.validateCity,
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          decoration: defaultIconDecoration('País', icon: Icons.public),
          value:
              _countryController.text.isEmpty ? null : _countryController.text,
          items:
              countries.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: defaultTextStyle),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _countryController.text = newValue;
              });
            }
          },
          validator: FormUtils.validateCountry,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          // Added for Puesto Principal
          controller: _mainPositionController,
          decoration: defaultIconDecoration(
            'Puesto Principal (ej: Desarrollador Frontend)',
            icon: Icons.work_outline,
          ),
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          decoration: defaultIconDecoration(
            'Nivel Educativo',
            icon: Icons.school_outlined,
          ),
          value:
              _educationController.text.isEmpty
                  ? null
                  : _educationController.text,
          items:
              educationLevels.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: defaultTextStyle),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() => _educationController.text = newValue);
            }
          },
          validator: FormUtils.validateEducation,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _experienceResume,
          decoration: defaultIconDecoration(
            'Experiencia laboral (breve resumen, min. 50 caracteres)',
            icon: Icons.work_history_outlined,
          ),
          maxLines: 3,
          validator: FormUtils.validateWorkExperience,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _skillsController,
          decoration: defaultIconDecoration(
            'Habilidades principales (separadas por comas, al menos una)',
            icon: Icons.psychology_outlined,
          ),
          validator: FormUtils.validateSkillsSeparatedByCommas,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _bioController,
          decoration: defaultIconDecoration(
            'Biografía o descripción del perfil (min. 50 caracteres)',
            icon: Icons.description_outlined,
          ),
          maxLines: 4,
          validator: FormUtils.validateBio,
        ),
        const SizedBox(height: 16.0),
        _buildFileSelectionField(
          title: 'Foto de perfil',
          selectedPath: _selectedCandidatePhotoPath,
          onSelect: _pickCandidatePhoto,
          icon: Icons.person,
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
          validator:
              (value) => FormUtils.validateRequired(
                value,
                'La ubicación de la empresa',
              ),
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
              setState(() => _companyIndustry = newValue);
            }
          },
          validator: FormUtils.validateIndustrySelected,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _companyDescriptionController,
          decoration: defaultIconDecoration(
            'Descripción breve de la empresa (min. 20 caracteres)',
            icon: Icons.description_outlined,
          ),
          maxLines: 3,
          validator: FormUtils.validateCompanyDescription,
        ),
        const SizedBox(height: 16.0),
        _buildFileSelectionField(
          title: 'Logo de la empresa',
          selectedPath: _selectedLogoPath,
          onSelect: _pickCompanyLogo,
          icon: Icons.business,
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

                          if (_showLoginForm) ...[
                            TextFormField(
                              controller: _emailController,
                              decoration: defaultIconDecoration(
                                'Correo electrónico',
                              ),
                              style: defaultTextStyle,
                              validator: FormUtils.validateEmailLogin,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              decoration: defaultIconDecoration('Contraseña'),
                              obscureText: !_passwordVisible,
                              style: defaultTextStyle,
                              validator: FormUtils.validatePasswordLogin,
                            ),
                            const SizedBox(height: 24.0),
                          ] else if (_selectedUserType == 'Candidato') ...[
                            _buildCandidateSignupForm(),
                            const SizedBox(height: 24.0),
                          ] else ...[
                            _buildCompanySignupForm(),
                            const SizedBox(height: 24.0),
                          ],

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
                                disabledBackgroundColor: Colors.blueAccent
                                    .withOpacity(0.7),
                              ),
                              onPressed: _isLoading ? null : _handleFormSubmit,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child:
                                    _isLoading
                                        ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                        : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                          _signUpOptions(ref),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isMedium)
                  RightSingUpImageInformation(
                    isWide: isWide,
                    isMedium: isMedium,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        _setUserType(_selectedUserType == 'Candidato');
        if (_showLoginForm) {
          await _handleLogin();
        } else {
          if (_selectedUserType == 'Candidato') {
            await _handleCandidateSignup();
          } else {
            await _handleCompanySignup();
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (context.mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos.'),
        ),
      );
    }
  }

  Future<void> _handleLogin() async {
    await signOut();
    await login(_emailController.text, _passwordController.text);
    await fetchUserProfile(ref);

    final candidate = ref.read(candidateProfileProvider);
    final company = ref.read(companyProfileProvider);

    if (!context.mounted) return;

    if (_selectedUserType == 'Candidato' && candidate != null) {
      Navigator.of(
        context,
      ).pushReplacement(FadeThroughPageRoute(page: const FindJobsScreen()));
    } else if (_selectedUserType == 'Empresa' && company != null) {
      Navigator.of(context).pushReplacement(
        FadeThroughPageRoute(page: const EmployerDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró perfil asociado a este usuario.'),
        ),
      );
    }
  }

  Future<void> _handleCandidateSignup() async {
    await signOut();
    String? photoUrl; // Variable to store URL if needed locally after upload

    // Register candidate first without the photo URL
    final success = await registerCandidate(
      email: _emailController.text,
      password: _passwordController.text,
      name: _fullNameController.text,
      phone: _phoneController.text,
      location: '${_locationController.text}, ${_countryController.text}',
      mainPosition: _mainPositionController.text,
      experience: _experienceResume.text,
      skills:
          _skillsController.text
              .split(',')
              .map((s) => FormUtils.clearSpaces(s))
              .where((s) => s.isNotEmpty)
              .toList(),
      bio: _bioController.text,
      education: _educationController.text,
      photo: null, // Pass null initially, photo will be updated by the provider
    );

    if (!context.mounted) return;

    if (success) {
      // If registration is successful and a photo was selected, upload it
      if (_selectedCandidatePhotoBytes != null &&
          _selectedCandidatePhotoPath != null) {
        try {
          await _uploadFile(
            bytes: _selectedCandidatePhotoBytes!,
            filename: _selectedCandidatePhotoPath!,
            isCandidate: true,
            onUploaded:
                (url) => photoUrl = url, // The provider handles DB update
          );
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error al subir foto: $e')));
          }
          // Decide if you want to proceed without photo or halt
        }
      }

      await fetchUserProfile(ref);
      final candidate = ref.read(candidateProfileProvider);
      if (candidate != null) {
        Navigator.of(
          context,
        ).pushReplacement(FadeThroughPageRoute(page: const FindJobsScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se encontró perfil de candidato tras el registro.',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar el candidato')),
      );
    }
  }

  Future<void> _handleCompanySignup() async {
    await signOut(); // Ensure clean state if needed
    String? logoUrl; // Variable to store URL if needed locally after upload

    // Register company first without the logo URL
    // Assuming registerCompany throws on failure or returns a status
    bool registrationSuccess = false;
    try {
      await registerCompany(
        email: _emailController.text,
        password: _passwordController.text,
        companyName: _companyNameController.text,
        phone: _companyPhoneController.text,
        address: _companyLocationController.text,
        industry: _companyIndustry,
        description: _companyDescriptionController.text,
        website: null,
        logo: null, // Pass null initially, logo will be updated by the provider
      );
      registrationSuccess = true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar empresa: $e')),
        );
      }
      registrationSuccess = false;
    }

    if (!context.mounted) return;

    if (registrationSuccess) {
      // If registration is successful and a logo was selected, upload it
      if (_selectedLogoPath != null) {
        // The original logic re-picks the file here.
        // Ideally, _selectedLogoBytes should be stored like _selectedCandidatePhotoBytes.
        // For now, following the existing pattern of re-picking:
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: true,
        );

        if (result != null && result.files.single.bytes != null) {
          try {
            await _uploadFile(
              bytes: result.files.single.bytes!,
              filename: result.files.single.name,
              isCandidate: false,
              onUploaded:
                  (url) => logoUrl = url, // The provider handles DB update
            );
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al subir logo: $e')),
              );
            }
            // Decide if you want to proceed without logo or halt
          }
        }
      }

      await fetchUserProfile(ref);
      final company = ref.read(companyProfileProvider);

      if (company != null) {
        Navigator.of(context).pushReplacement(
          FadeThroughPageRoute(page: const EmployerDashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró perfil de empresa tras el registro.'),
          ),
        );
      }
    }
    // If registrationSuccess is false, an error message should have already been shown.
  }

  Future<void> _uploadFile({
    required Uint8List bytes,
    required String filename,
    required bool isCandidate,
    required Function(String url) onUploaded,
  }) async {
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      final uploadProvider =
          isCandidate
              ? ref.read(uploadCandidatePhotoProvider)
              : ref.read(uploadCompanyLogoProvider);

      final url = await uploadProvider(bytes, filename);
      onUploaded(url);
    } catch (e) {
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
      throw Exception('Error al subir ${isCandidate ? "foto" : "logo"}: $e');
    }

    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  void _showCVAnimationAndNavigate() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa el correo y contraseña para continuar con el CV.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final filename = result.files.single.name;

      showDialog(
        context: context,
        barrierColor: Colors.black.withAlpha(220),
        barrierDismissible: false,
        builder: (_) => const CVLottieDialog(),
      );

      try {
        final parser = ref.read(parseCandidateProvider);
        final candidate = await parser.parseAndSaveCandidate(
          bytes: bytes,
          filename: filename,
          email: _emailController.text,
          password: _passwordController.text,
        );

        final uploadCv = ref.read(uploadCvProvider);
        final url = await uploadCv(bytes, filename);
        if (mounted) Navigator.of(context, rootNavigator: true).pop();

        ref.read(candidateProfileProvider.notifier).state = candidate.copyWith(
          resumeUrl: url,
        );
        ref.read(isCandidateProvider.notifier).state = true;

        if (mounted) {
          Navigator.of(
            context,
          ).push(FadeThroughPageRoute(page: const UserProfile()));
        }
      } catch (e) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al procesar el CV: $e')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se seleccionó ningún CV')),
      );
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Column _signUpOptions(WidgetRef ref) {
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
              onPressed:
                  _isLoading ||
                          (_selectedUserType == 'Empresa' || !_showLoginForm)
                      ? null
                      : _showCVAnimationAndNavigate,
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        TestimonialCarousel(),
      ],
    );
  }
}
