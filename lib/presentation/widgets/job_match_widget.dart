import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class JobMatchWidget extends StatelessWidget {
  const JobMatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.2),
        hoverColor: Colors.white.withOpacity(0.1),
        onTap: () => context.go('/homepage'),
        child: Row(
          children: const [
            CircleAvatar(
              radius: kRadius20 + kRadius12,
              backgroundImage: AssetImage('assets/images/job_match.jpg'),
            ),
            SizedBox(width: 8),
            Text('Job Match', style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
