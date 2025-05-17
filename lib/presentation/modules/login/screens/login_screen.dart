import 'package:flutter/material.dart';
import 'package:job_match/presentation/modules/login/widgets/info_card.dart';
import 'package:job_match/presentation/modules/login/widgets/left_cut_trapezoid_clipper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ super.key });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _termsAgreed = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final defaultTextStyle = TextStyle(color: Colors.grey.shade900);
  InputDecoration defaultIconDecoration(String labelText, {Widget? suffixIcon}) => InputDecoration(
    labelText: labelText,
    border: const OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    suffixIcon: suffixIcon
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(64.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _loginHeader(),
                      const SizedBox(height: 16.0),
                      _loginFields(context),
                      const SizedBox(height: 24.0),
                      _signUpOptions(),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: LeftCutTrapezoidClipper(),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.orange.withValues(alpha: 0.6), Colors.transparent],
                          stops: const [0.7, 1.0]
                        ).createShader(bounds),
                        blendMode: BlendMode.srcOver,
                        child: Image.asset(
                          'assets/images/login_background.png',
                          width: double.infinity,
                          fit: BoxFit.fitWidth
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Over 1,75,324 candidates\nwaiting for good employees.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 50),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InfoCard(title: '1,75,324', subtitle: 'Live Job', icon: Icon(Icons.work_outline, color: Colors.white, size: 32.0)),
                              InfoCard(title: '97,354', subtitle: 'Companies', icon: Icon(Icons.location_city, color: Colors.white, size: 32.0)),
                              InfoCard(title: '7,532', subtitle: 'New Jobs', icon: Icon(Icons.work_outline, color: Colors.white, size: 32.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      // bottomNavigationBar: SizedBox(
      //   height: 150.0,
      //   child: Container(
      //     color: const Color(0xFF4A3B31),
      //     child: Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           const Text(
      //             'Over 1,75,324 candidates\nwaiting for good employees.',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 18.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
                
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             children: [
      //               InfoCard(title: '1,75,324', subtitle: 'Live Job'),
      //               InfoCard(title: '97,354', subtitle: 'Companies'),
      //               InfoCard(title: '7,532', subtitle: 'New Jobs'),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Column _loginHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Log In',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 8.0),
                
                Row(
                  children: [
                    const Text("Don't have account?"),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: () { },
                      child: const Text('Sign up', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24.0),
            
            SizedBox(
              width: 160,
              child: DropdownButtonFormField(
                decoration: defaultIconDecoration('Employers'),
                items: ['Employers', 'Candidates'].map((String value) {
                  return DropdownMenuItem(value: value, child: Text(value, style: defaultTextStyle));
                }
                ).toList(),
                onChanged: (String? newValue) { },
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
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: defaultIconDecoration('Full Name'),
                style: defaultTextStyle
              ),
            ),

            const SizedBox(width: 8.0),

            Expanded(
              child: TextFormField(decoration: defaultIconDecoration('Username')),
            ),
          ],
        ),

        const SizedBox(height: 16.0),

        TextFormField(decoration: defaultIconDecoration('Email address')),

        const SizedBox(height: 16.0),

        TextFormField(
          obscureText: !_passwordVisible,
          decoration: defaultIconDecoration('Password',
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() { _passwordVisible = !_passwordVisible; });
              },
            )
          )
        ),

        const SizedBox(height: 16.0),

        TextFormField(
          obscureText: !_confirmPasswordVisible,
          decoration: defaultIconDecoration('Confirm password',
            suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() { _confirmPasswordVisible = !_confirmPasswordVisible; });
              },
            )
          )
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

            const Text('I\'ve read and agree with your '),

            GestureDetector(
              onTap: () { },
              child: const Text(
                'Terms of Services',
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
                borderRadius: BorderRadius.all(Radius.circular(5))
              )
            ),
            onPressed: () {
              if (!_termsAgreed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please agree to the Terms of Services')),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Create Account'),
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

  Column _signUpOptions() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('or'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        
        const SizedBox(height: 16.0),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                ),
                icon: const Icon(Icons.facebook, color: Colors.blue),
                label: const Text('Sign up with Facebook', style: TextStyle(color: Colors.black87)),
                onPressed: () {},
              ),
            ),
            
            const SizedBox(width: 32.0),
            
            SizedBox(
              child: OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                ),                
                icon: const Icon(Icons.mail_outline, color: Colors.red),
                label: const Text('Sign up with Google', style: TextStyle(color: Colors.black87)),
                onPressed: () { },
              ),
            ),
          ],
        ),
      ],
    );
  }
}