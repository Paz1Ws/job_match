import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';

class JobApplyDialog extends StatefulWidget {
  final String jobTitle;
  final String jobId;

  const JobApplyDialog({super.key, required this.jobTitle, required this.jobId});

  @override
  State<JobApplyDialog> createState() => _JobApplyDialogState();
}

class _JobApplyDialogState extends State<JobApplyDialog> {
  String? selectedResume;
  final TextEditingController coverLetterController = TextEditingController();

  @override
  void dispose() {
    coverLetterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Aplicar a: ${widget.jobTitle}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Selecciona tu CV',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                value: selectedResume,
                hint: const Text('Selecciona...'),
                items: [
                  'CV_Julio_Nima.pdf',
                  'CV_2024.pdf',
                  'CV_Experiencia.pdf',
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => selectedResume = value),
              ),
              const SizedBox(height: 24),
              const Text(
                'Carta de Presentación',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: coverLetterController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Escribe aquí tu biografía. Hazle saber a los empleadores quién eres...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),
              // Barra simple de iconos (sin funcionalidad real)
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.format_bold), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.format_italic), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.format_underline), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.link), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.format_list_bulleted), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.format_list_numbered), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer(
                    builder: (_, ref, __) {
                      return ElevatedButton.icon(
                        onPressed: () async {
                          final applyJob = ref.read(applyToJobProvider);
                          await applyJob(widget.jobId);
                          
                          if(!context.mounted) return;
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('¡Aplicación enviada!')),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        label: const Text('Aplicar Ahora'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}