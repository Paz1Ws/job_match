import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/presentation/screens/auth/widgets/info_card.dart';
import 'package:job_match/presentation/screens/auth/widgets/left_cut_trapezoid_clipper.dart';
import 'package:job_match/presentation/screens/profiles/user_profile.dart';
import 'package:job_match/presentation/screens/profiles/company_profile_screen.dart'; // For company profile navigation
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _termsAgreed = false;
  bool _passwordVisible = false;

  // Text Editing Controllers
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String? _selectedUserType = 'Candidato'; // Default to Candidato

  // Mock Data
  final Map<String, String> _candidateData = {
    'username': 'jnima',
    'email': 'julio.nima@email.com',
    'password': 'password123',
  };

  final Map<String, String> _companyData = {
    'username': 'jobmatch_admin',
    'email': 'admin@jobmatch.com',
    'password': 'companypassword',
  };

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _prefillForm(_selectedUserType); // Prefill as Candidato by default
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _prefillForm(String? userType) {
    setState(() {
      _selectedUserType = userType;
      if (userType == 'Candidato') {
        _usernameController.text = _candidateData['username']!;
        _emailController.text = _candidateData['email']!;
        _passwordController.text = _candidateData['password']!;
        _termsAgreed = true;
      } else if (userType == 'Empresa') {
        _usernameController.text = _companyData['username']!;
        _emailController.text = _companyData['email']!;
        _passwordController.text = _companyData['password']!;
        _termsAgreed = true;
      } else {
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _termsAgreed = false;
      }
    });
  }

  final defaultTextStyle = TextStyle(color: Colors.grey.shade900);
  InputDecoration defaultIconDecoration(
    String labelText, {
    Widget? suffixIcon,
  }) => InputDecoration(
    labelText: labelText,
    border: const OutlineInputBorder(),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    suffixIcon: suffixIcon,
  );

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 900;
    final isMedium = MediaQuery.sizeOf(context).width > 600;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Formulario (izquierda)
            Expanded(
              flex: isWide ? 1 : 2,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 64.0 : 24.0,
                  vertical: isWide ? 64.0 : 24.0,
                ),
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
                    const SizedBox(height: 32.0),
                    _loginFields(context),
                    const SizedBox(height: 24.0),
                    _signUpOptions(),
                  ],
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
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Más de 175,324 candidatos\nesperando buenas empresas.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 120),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                InfoCard(
                                  title: '97,354',
                                  subtitle: 'Empresas',
                                  icon: const Icon(
                                    Icons.location_city,
                                    color: Colors.white,
                                    size: 42,
                                  ),
                                ),
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
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Text("¿No tienes cuenta?"),
                      const SizedBox(width: 4.0),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(color: Colors.blue),
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

  Column _loginFields(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: defaultIconDecoration('Usuario'),
          style: defaultTextStyle,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _emailController,
          decoration: defaultIconDecoration('Correo electrónico'),
          style: defaultTextStyle,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _passwordController,
          obscureText: !_passwordVisible,
          decoration: defaultIconDecoration(
            'Contraseña',
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            onPressed: () {
              if (!_termsAgreed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor acepta los Términos de Servicio'),
                  ),
                );
              } else {
                // Navigate based on user type for demo
                if (_selectedUserType == 'Candidato') {
                  context.go('/user-profile');
                } else if (_selectedUserType == 'Empresa') {
                  context.go('/company-profile');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor selecciona un tipo de usuario'),
                    ),
                  );
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Crear Cuenta'),
                  SizedBox(width: 8.0),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCVAnimationAndNavigate() async {
    final userType = _selectedUserType;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _CVLottieDialog(),
    );
    // After animation, navigate
    if (userType == 'Candidato' && mounted) {
      context.go('/user-profile');
    } else if (userType == 'Empresa' && mounted) {
      context.go('/company-profile');      
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

// Lottie dialog widget
class _CVLottieDialog extends StatefulWidget {
  const _CVLottieDialog();

  @override
  State<_CVLottieDialog> createState() => _CVLottieDialogState();
}

class _CVLottieDialogState extends State<_CVLottieDialog> {
  @override
  void initState() {
    super.initState();
    // Close dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Lottie.asset(
          'assets/animations/cv_lottie.json',
          width: 200,
          height: 200,
          repeat: false,
        ),
      ),
    );
  }
}
