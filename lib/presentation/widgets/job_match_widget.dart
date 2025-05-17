import 'package:flutter/material.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class JobMatchWidget extends StatelessWidget {
  const JobMatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        CircleAvatar(
          radius: kRadius20 + kRadius12,
          backgroundImage: AssetImage('assets/images/job_match.jpg'),
        ),
        SizedBox(width: 8),
        Text('Job Match', style: TextStyle(color: Colors.white, fontSize: 20)),
      ],
    );
  }
}
