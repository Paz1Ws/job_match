import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/data/auth_request.dart';
import 'package:job_match/core/data/supabase_http_requests.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:flutter/services.dart';
import 'package:job_match/config/util/form_utils.dart'; // Import FormUtils
import 'package:intl/intl.dart';

class PostJobForm extends ConsumerStatefulWidget {
  final bool isEditing;
  final Job? existingJob;
  final Function(Job)? onJobUpdated; // Add callback for when job is updated

  const PostJobForm({
    super.key,
    this.isEditing = false,
    this.existingJob,
    this.onJobUpdated, // Add this parameter
  });

  @override
  ConsumerState<PostJobForm> createState() => _PostJobFormState();
}

class _PostJobFormState extends ConsumerState<PostJobForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _salaryMinController;
  late final TextEditingController _salaryMaxController;
  late final TextEditingController _skillsController;
  late final TextEditingController _maxApplicationsController;

  String _jobType = 'Full-Time';
  String _jobModality = 'Presencial';
  String _status = 'open';
  DateTime? _applicationDeadline;
  bool _isLoading = false;

  final List<String> _jobTypeOptions = [
    'Full-Time',
    'Part-Time',
    'Contract',
    'Freelance',
  ];

  final List<String> _jobModalityOptions = ['Presencial', 'Remoto', 'Híbrido'];

  final List<String> _statusOptions = ['open', 'closed', 'paused'];

  final Map<String, String> _statusDisplayNames = {
    'open': 'Abierto',
    'closed': 'Cerrado',
    'paused': 'Pausado',
  };

  @override
  void initState() {
    super.initState();
    
    // Initialize all controllers first
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _salaryMinController = TextEditingController();
    _salaryMaxController = TextEditingController();
    _skillsController = TextEditingController();
    _maxApplicationsController = TextEditingController();

    // Pre-fill form with existing job data if editing
    if (widget.isEditing && widget.existingJob != null) {
      _prefillFormWithJobData(widget.existingJob!);
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _skillsController.dispose();
    _maxApplicationsController.dispose();
    super.dispose();
  }

  void _prefillFormWithJobData(Job job) {
    // Set text values after controllers are initialized
    _titleController.text = job.title;
    _descriptionController.text = job.description;
    _locationController.text = job.location;
    _salaryMinController.text = job.salaryMin;
    _salaryMaxController.text = job.salaryMax;
    
    // Set values for dropdown and other fields
    _jobType = job.type;
    _jobModality = job.modality;
    _status = job.status;
    _applicationDeadline = job.applicationDeadline;
    
    // Handle list and optional fields
    if (job.requiredSkills != null) {
      _skillsController.text = job.requiredSkills!.join(', ');
    }
    
    if (job.maxApplications != null) {
      _maxApplicationsController.text = job.maxApplications.toString();
    }
    
    // Force a rebuild to show the pre-filled values
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submitForm() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor corrige los errores en el formulario'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if application deadline is set
    if (_applicationDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una fecha límite de aplicación'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final company = ref.read(companyProfileProvider);
      if (company == null) {
        throw Exception('No hay información de la empresa disponible');
      }

      // Convert skills string to list
      List<String> skills = [];
      if (_skillsController.text.isNotEmpty) {
        skills =
            _skillsController.text
                .split(',')
                .map((s) => FormUtils.clearSpaces(s))
                .where((s) => s.isNotEmpty)
                .toList();
      }

      // Create job data
      final jobData = {
        'company_id': company.userId,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'job_type': _jobType,
        'salary_min': _salaryMinController.text.trim(),
        'salary_max': _salaryMaxController.text.trim(),
        'modality': _jobModality,
        'status': _status,
        'application_deadline': _applicationDeadline!.toIso8601String(),
        'required_skills': skills,
        'max_applications':
            _maxApplicationsController.text.isNotEmpty
                ? int.parse(_maxApplicationsController.text)
                : null,
      };

      // Add or update job
      if (widget.isEditing && widget.existingJob != null) {
        await ref.read(
          updateJobProvider(
            UpdateJobParams(jobId: widget.existingJob!.id, jobData: jobData),
          ).future,
        );

        // Create updated job object with new data
        final updatedJob = widget.existingJob!.copyWith(
          title: jobData['title'] as String,
          description: jobData['description'] as String,
          location: jobData['location'] as String,
          type: jobData['job_type'] as String,
          salaryMin: jobData['salary_min'] as String,
          salaryMax: jobData['salary_max'] as String,
          modality: jobData['modality'] as String,
          status: jobData['status'] as String,
          requiredSkills: jobData['required_skills'] as List<String>?,
          maxApplications: jobData['max_applications'] as int?,
          applicationDeadline: _applicationDeadline,
          createdAt: DateTime.now(),
        );

        // Call the callback to notify parent widget
        widget.onJobUpdated?.call(updatedJob);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Trabajo actualizado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Create new job
        jobData['created_at'] = DateTime.now().toIso8601String();

        await ref.read(createJobProvider)(jobData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Trabajo publicado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );

          // Clear form for new job creation
          _clearForm();
        }
      }

      // Invalidate relevant providers to refresh data
      ref.invalidate(jobsByCompanyIdProvider(company.userId));
      ref.invalidate(jobsProviderWithCompanyName);
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _salaryMinController.clear();
    _salaryMaxController.clear();
    _skillsController.clear();
    _maxApplicationsController.clear();
    setState(() {
      _jobType = 'Full-Time';
      _jobModality = 'Presencial';
      _status = 'open';
      _applicationDeadline = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _applicationDeadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Seleccionar fecha límite de aplicación',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (picked != null && picked != _applicationDeadline) {
      setState(() {
        _applicationDeadline = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isEditing
                  ? 'Editar Oferta Laboral'
                  : 'Publicar Oferta Laboral',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Job Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título del puesto *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.work_outline),
              ),
              validator:
                  (value) =>
                      FormUtils.validateRequired(value, 'El título del puesto'),
            ),
            const SizedBox(height: 16),

            // Job Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Descripción del puesto *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción del puesto es requerida';
                }
                if (value.length < 20) {
                  return 'La descripción debe tener al menos 20 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Ubicación *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
              validator: (value) => FormUtils.validateCity(value),
            ),
            const SizedBox(height: 16),

            // Job Type Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Tipo de trabajo *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              value: _jobType,
              items:
                  _jobTypeOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _jobType = newValue;
                  });
                }
              },
              validator:
                  (value) =>
                      FormUtils.validateRequired(value, 'El tipo de trabajo'),
            ),
            const SizedBox(height: 16),

            // Job Modality Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Modalidad de trabajo *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.home_work_outlined),
              ),
              value: _jobModality,
              items:
                  _jobModalityOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _jobModality = newValue;
                  });
                }
              },
              validator:
                  (value) => FormUtils.validateRequired(
                    value,
                    'La modalidad de trabajo',
                  ),
            ),
            const SizedBox(height: 16),

            // Status Dropdown (only for editing)
            if (widget.isEditing)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Estado del trabajo *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.flag_outlined),
                ),
                value: _status,
                items:
                    _statusOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(_statusDisplayNames[value] ?? value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _status = newValue;
                    });
                  }
                },
                validator:
                    (value) => FormUtils.validateRequired(
                      value,
                      'El estado del trabajo',
                    ),
              ),

            if (widget.isEditing) const SizedBox(height: 16),

            // Salary Range (Min and Max)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _salaryMinController,
                    decoration: InputDecoration(
                      labelText: 'Salario mínimo (S/) *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese salario mínimo';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Solo números';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _salaryMaxController,
                    decoration: InputDecoration(
                      labelText: 'Salario máximo (S/) *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese salario máximo';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Solo números';
                      }

                      // Validate max >= min
                      final minValue =
                          int.tryParse(_salaryMinController.text) ?? 0;
                      final maxValue = int.tryParse(value) ?? 0;
                      if (maxValue < minValue) {
                        return 'Debe ser ≥ mínimo';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Required Skills
            TextFormField(
              controller: _skillsController,
              decoration: InputDecoration(
                labelText: 'Habilidades requeridas (separadas por comas) *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.psychology_outlined),
                hintText: 'Ej: React, JavaScript, UI Design',
              ),
              validator:
                  (value) => FormUtils.validateSkillsSeparatedByCommas(value),
            ),
            const SizedBox(height: 16),

            // Application Deadline (Date Picker)
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Fecha límite de aplicación *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                  ),
                  controller: TextEditingController(
                    text:
                        _applicationDeadline != null
                            ? DateFormat(
                              'dd/MM/yyyy',
                            ).format(_applicationDeadline!)
                            : '',
                  ),
                  validator: (value) {
                    if (_applicationDeadline == null) {
                      return 'Seleccione una fecha límite';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Max Applications (optional)
            TextFormField(
              controller: _maxApplicationsController,
              decoration: InputDecoration(
                labelText: 'Número máximo de aplicaciones (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.people_outline),
                hintText: 'Dejar en blanco para no establecer límite',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Ingrese un número mayor a 0';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.isEditing ? Colors.orange : Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          widget.isEditing
                              ? 'ACTUALIZAR TRABAJO'
                              : 'PUBLICAR TRABAJO',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
