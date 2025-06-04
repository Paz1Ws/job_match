import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/util/animations.dart';
import 'package:job_match/presentation/screens/auth/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? accessToken;
  final String? email; // Add email parameter

  const ResetPasswordScreen({
    super.key,
    required this.accessToken,
    this.email, // Accept email from calling screen
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  // Controllers for form fields
  late final TextEditingController _emailController;
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;
  bool _passwordVisible = false;

  // Step tracking
  bool _otpVerified = false;

  @override
  void initState() {
    super.initState();
    // Initialize email controller with provided email if available
    _emailController = TextEditingController(text: widget.email ?? '');

    // If access token is provided, we can skip the OTP verification step
    if (widget.accessToken != null) {
      _otpVerified = true;
    }
  }

  InputDecoration _defaultInputDecoration(String labelText, {IconData? icon}) {
    return InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      suffixIcon:
          icon != null
              ? InkWell(
                onTap: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                child: Icon(
                  _passwordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              )
              : null,
    );
  }

  Future<void> _verifyOTP() async {
    // Validate OTP fields
    if (_emailController.text.isEmpty || _otpController.text.isEmpty) {
      setState(() {
        _message = 'Por favor completa todos los campos';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      // Verify OTP using Supabase
      final AuthResponse res = await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.recovery,
        token: _otpController.text, // Código OTP ingresado por usuario
        email: _emailController.text, // Email del usuario
      );

      if (res.session != null) {
        // OTP verification successful
        setState(() {
          _otpVerified = true;
          _message =
              'Código verificado. Ahora puedes establecer tu nueva contraseña.';
          _isSuccess = true;
        });
      } else {
        setState(() {
          _message =
              'No se pudo verificar el código. Por favor, intenta nuevamente.';
          _isSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitNewPassword() async {
    // First validate inputs
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _message = 'Por favor completa ambos campos';
        _isSuccess = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _message = 'Las contraseñas no coinciden';
        _isSuccess = false;
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _message = 'La contraseña debe tener al menos 6 caracteres';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      // Update password using Supabase
      final res = await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );

      // Check if successful
      if (res.user != null) {
        // Success! Navigate directly to login with the email pre-filled
        if (mounted) {
          Navigator.of(context).pushReplacement(
            FadeThroughPageRoute(
              page: LoginScreen(prefillEmail: _emailController.text),
            ),
          );
        }
      } else {
        setState(() {
          _message =
              'No se pudo actualizar la contraseña. Por favor, intenta nuevamente.';
          _isSuccess = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
        _isSuccess = false;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperación de contraseña'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Show different content based on OTP verification status
                  if (!_otpVerified)
                    ..._buildOTPVerificationFields()
                  else
                    ..._buildPasswordResetFields(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOTPVerificationFields() {
    return [
      const Text(
        'Verificar código',
        style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      const Text(
        'Ingresa el código de verificación que recibiste para recuperar tu contraseña',
        style: TextStyle(fontSize: 16.0, color: Colors.grey),
      ),
      const SizedBox(height: 32),

      // Email field - only show if we don't have it
      if (_emailController.text.isEmpty) ...[
        TextFormField(
          controller: _emailController,
          decoration: _defaultInputDecoration('Correo electrónico'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16.0),
      ],

      // OTP code field
      TextFormField(
        controller: _otpController,
        decoration: _defaultInputDecoration(
          'Código de verificación (6 dígitos)',
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
      ),

      const SizedBox(height: 8.0),

      // Message area
      if (_message != null) ...[
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isSuccess ? Colors.green.shade200 : Colors.red.shade200,
            ),
          ),
          child: Text(
            _message!,
            style: TextStyle(
              color: _isSuccess ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ),
      ],

      const SizedBox(height: 24.0),

      // Verify button
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            disabledBackgroundColor: Colors.blueAccent.withOpacity(0.7),
          ),
          onPressed: _isLoading ? null : _verifyOTP,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
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
                    : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Verificar código'),
                        SizedBox(width: 8.0),
                        Icon(Icons.verified_outlined, color: Colors.white),
                      ],
                    ),
          ),
        ),
      ),

      const SizedBox(height: 16.0),
      // Back to login
      TextButton(
        onPressed: () {
          Navigator.of(
            context,
          ).pushReplacement(FadeThroughPageRoute(page: const LoginScreen()));
        },
        child: const Text('Volver a inicio de sesión'),
      ),
    ];
  }

  List<Widget> _buildPasswordResetFields() {
    return [
      const Text(
        'Crear nueva contraseña',
        style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      const Text(
        'Ingresa y confirma tu nueva contraseña para completar el proceso',
        style: TextStyle(fontSize: 16.0, color: Colors.grey),
      ),
      const SizedBox(height: 32),

      // Password field
      TextFormField(
        controller: _passwordController,
        decoration: _defaultInputDecoration(
          'Nueva contraseña',
          icon: Icons.visibility,
        ),
        obscureText: !_passwordVisible,
      ),
      const SizedBox(height: 16.0),

      // Confirm password field
      TextFormField(
        controller: _confirmPasswordController,
        decoration: _defaultInputDecoration(
          'Confirmar nueva contraseña',
          icon: Icons.visibility,
        ),
        obscureText: !_passwordVisible,
      ),

      // Message area
      if (_message != null) ...[
        const SizedBox(height: 24.0),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isSuccess ? Colors.green.shade200 : Colors.red.shade200,
            ),
          ),
          child: Text(
            _message!,
            style: TextStyle(
              color: _isSuccess ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ),
      ],

      const SizedBox(height: 24.0),

      // Submit button
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            disabledBackgroundColor: Colors.blueAccent.withOpacity(0.7),
          ),
          onPressed: _isLoading ? null : _submitNewPassword,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
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
                    : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Cambiar contraseña'),
                        SizedBox(width: 8.0),
                        Icon(Icons.check_circle, color: Colors.white),
                      ],
                    ),
          ),
        ),
      ),

      // Back to login button if success
      if (_isSuccess) ...[
        const SizedBox(height: 16.0),
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pushReplacement(FadeThroughPageRoute(page: const LoginScreen()));
          },
          child: const Text('Volver a inicio de sesión'),
        ),
      ],
    ];
  }
}
