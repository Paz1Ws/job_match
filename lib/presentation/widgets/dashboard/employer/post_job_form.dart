import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:intl/intl.dart';

class PostJobForm extends ConsumerStatefulWidget {
  final int companyId; // Assuming companyId is passed to the form

  const PostJobForm({super.key, required this.companyId});

  @override
  ConsumerState<PostJobForm> createState() => _PostJobFormState();
}

class _PostJobFormState extends ConsumerState<PostJobForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(
    text: 'Desarrollador Flutter Senior',
  );
  final _descriptionController = TextEditingController(
    text:
        'Buscamos un desarrollador Flutter con experiencia para unirse a nuestro equipo innovador. Responsable de crear aplicaciones móviles de alta calidad y rendimiento.',
  );
  final _locationController = TextEditingController(
    text: 'Lima, Perú (Remoto Opcional)',
  );
  final _jobTypeController = TextEditingController(
    text: 'Tiempo Completo',
  ); // Could be a Dropdown
  final _salaryMinController = TextEditingController(text: '7000');
  final _salaryMaxController = TextEditingController(text: '10000');
  final _applicationDeadlineController = TextEditingController(
    text: DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now().add(const Duration(days: 30))),
  );
  String _statusValue = 'open'; // Default status
  final _requiredSkillsController = TextEditingController(
    text: 'Flutter, Dart, Firebase, Git, API REST',
  );
  final _maxApplicationsController = TextEditingController(text: '100');

  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(_applicationDeadlineController.text) ??
          DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _applicationDeadlineController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(picked);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _jobTypeController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _applicationDeadlineController.dispose();
    _requiredSkillsController.dispose();
    _maxApplicationsController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final title = _titleController.text;
        final description = _descriptionController.text;
        final location = _locationController.text;
        final jobType =
            _jobTypeController
                .text; // Consider using a dropdown for fixed values
        final salaryMin = num.tryParse(_salaryMinController.text);
        final salaryMax = num.tryParse(_salaryMaxController.text);
        final applicationDeadline = DateTime.tryParse(
          _applicationDeadlineController.text,
        );
        final status = _statusValue;
        final requiredSkills =
            _requiredSkillsController.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
        final maxApplications = int.tryParse(_maxApplicationsController.text);

        final postedJob = await ref.read(createJobProvider)(
          widget.companyId,
          title,
          description,
          location,
          jobType,
          salaryMin,
          salaryMax,
          applicationDeadline,
          status,
          requiredSkills,
          maxApplications,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Empleo "${postedJob.title}" publicado con éxito! ID: ${postedJob.id}',
            ),
          ),
        );
        _formKey.currentState?.reset();
        // Optionally clear controllers or navigate
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al publicar empleo: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    bool isNumeric = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacing8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingrese $label';
          }
          if (isNumeric && num.tryParse(value) == null) {
            return 'Por favor, ingrese un número válido';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const Text(
              'Publicar Nueva Vacante',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: kSpacing20),
            _buildTextField(_titleController, 'Título del Puesto'),
            _buildTextField(
              _descriptionController,
              'Descripción del Puesto',
              maxLines: 5,
            ),
            _buildTextField(_locationController, 'Ubicación (ej: Lima, Perú)'),
            _buildTextField(
              _jobTypeController,
              'Tipo de Empleo (ej: Tiempo Completo, Medio Tiempo, Contrato)',
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _salaryMinController,
                    'Salario Mínimo (S/)',
                    keyboardType: TextInputType.number,
                    isNumeric: true,
                  ),
                ),
                const SizedBox(width: kSpacing12),
                Expanded(
                  child: _buildTextField(
                    _salaryMaxController,
                    'Salario Máximo (S/)',
                    keyboardType: TextInputType.number,
                    isNumeric: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kSpacing8),
              child: TextFormField(
                controller: _applicationDeadlineController,
                decoration: InputDecoration(
                  labelText: 'Fecha Límite de Postulación',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la fecha límite';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kSpacing8),
              child: DropdownButtonFormField<String>(
                value: _statusValue,
                decoration: const InputDecoration(
                  labelText: 'Estado de la Publicación',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['open', 'paused', 'closed'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value[0].toUpperCase() + value.substring(1),
                        ), // Capitalize
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _statusValue = newValue!;
                  });
                },
              ),
            ),
            _buildTextField(
              _requiredSkillsController,
              'Habilidades Requeridas (separadas por coma)',
            ),
            _buildTextField(
              _maxApplicationsController,
              'Máximo de Postulaciones (opcional)',
              keyboardType: TextInputType.number,
              isNumeric: true,
            ),
            const SizedBox(height: kSpacing20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.publish),
                  label: const Text('Publicar Empleo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: kPadding12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
