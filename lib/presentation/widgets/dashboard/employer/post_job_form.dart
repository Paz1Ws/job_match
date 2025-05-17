import 'package:flutter/material.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class PostJobForm extends StatefulWidget {
  const PostJobForm({super.key});

  @override
  State<PostJobForm> createState() => _PostJobFormState();
}

class _PostJobFormState extends State<PostJobForm> {
  final _jobTitleController = TextEditingController();
  final _tagsController = TextEditingController();
  String? _selectedJobRole;
  final _minSalaryController = TextEditingController();
  final _maxSalaryController = TextEditingController();
  String? _selectedSalaryType;
  String? _selectedEducation;
  String? _selectedExperience;
  String? _selectedJobType;
  String? _selectedVacancies;
  final _expirationDateController = TextEditingController();
  String? _selectedJobLevel;
  final _applyEmailController = TextEditingController();
  final _applyLinkController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _responsibilitiesController = TextEditingController();

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpacing8, top: kSpacing20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF222B45)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    Widget? suffix,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF4A4A4A))),
        const SizedBox(height: kSpacing4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText ?? 'Ingrese $labelText',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(kRadius8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: kPadding12, vertical: kPadding12),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String labelText,
    required String? currentValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF4A4A4A))),
        const SizedBox(height: kSpacing4),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(kRadius8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: kPadding12, vertical: kPadding12),
          ),
          value: currentValue,
          hint: Text(hintText ?? 'Seleccione...'),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCurrencySuffix() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding12),
      child: Text(
        'USD',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4),
      child: Container(
        padding: const EdgeInsets.all(kPadding20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kRadius12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            Row(
              children: [
                Icon(Icons.add_circle_outline, color: Colors.blue.shade700, size: 32),
                const SizedBox(width: kSpacing12),
                const Text(
                  'Publicar un Empleo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF222B45)),
                ),
              ],
            ),
            const SizedBox(height: kSpacing20),

            // Primera fila: Título, Etiquetas, Rol
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _jobTitleController,
                    labelText: 'Título del Empleo',
                    hintText: 'Ej: Diseñador UI/UX Senior',
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _tagsController,
                    labelText: 'Etiquetas',
                    hintText: 'Palabras clave, etiquetas...',
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(
                    labelText: 'Rol del Empleo',
                    currentValue: _selectedJobRole,
                    items: ['Desarrollador', 'Diseñador', 'Gerente', 'Analista'],
                    onChanged: (value) => setState(() => _selectedJobRole = value),
                  ),
                ),
              ],
            ),

            // Salario
            _buildSectionTitle('Salario'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _minSalaryController,
                    labelText: 'Salario Mínimo',
                    hintText: 'Ej: 2000',
                    suffix: _buildCurrencySuffix(),
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _maxSalaryController,
                    labelText: 'Salario Máximo',
                    hintText: 'Ej: 4000',
                    suffix: _buildCurrencySuffix(),
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(
                    labelText: 'Tipo de Salario',
                    currentValue: _selectedSalaryType,
                    items: ['Mensual', 'Anual', 'Por Hora'],
                    onChanged: (value) => setState(() => _selectedSalaryType = value),
                  ),
                ),
              ],
            ),

            // Información avanzada
            _buildSectionTitle('Información Avanzada'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(
                    labelText: 'Educación',
                    currentValue: _selectedEducation,
                    items: ['Secundaria', 'Técnico', 'Universitario', 'Postgrado'],
                    onChanged: (value) => setState(() => _selectedEducation = value),
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(
                    labelText: 'Experiencia',
                    currentValue: _selectedExperience,
                    items: ['Sin experiencia', '1-2 años', '3-5 años', '5+ años'],
                    onChanged: (value) => setState(() => _selectedExperience = value),
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(
                    labelText: 'Tipo de Empleo',
                    currentValue: _selectedJobType,
                    items: ['Tiempo Completo', 'Medio Tiempo', 'Contrato', 'Temporal', 'Pasantía'],
                    onChanged: (value) => setState(() => _selectedJobType = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacing20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(
                    labelText: 'Vacantes',
                    currentValue: _selectedVacancies,
                    items: ['1', '2', '3', '4', '5+'],
                    onChanged: (value) => setState(() => _selectedVacancies = value),
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _expirationDateController,
                    labelText: 'Fecha de Expiración',
                    hintText: 'DD/MM/YYYY',
                    suffix: Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(
                    labelText: 'Nivel del Empleo',
                    currentValue: _selectedJobLevel,
                    items: ['Junior', 'Semi-Senior', 'Senior', 'Lead'],
                    onChanged: (value) => setState(() => _selectedJobLevel = value),
                  ),
                ),
              ],
            ),

            // Sección: Aplicar trabajo en
            _buildSectionTitle('Aplicar trabajo en'),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _applyEmailController,
                    labelText: 'Correo para Aplicaciones',
                    hintText: 'ejemplo@empresa.com',
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _applyLinkController,
                    labelText: 'Enlace para Aplicaciones',
                    hintText: 'https://empresa.com/apply',
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(flex: 2, child: Container()),
              ],
            ),

            // Descripción del trabajo
            _buildSectionTitle('Descripción del Empleo'),
            _buildTextField(
              controller: _descriptionController,
              labelText: '',
              hintText: 'Describe el puesto, responsabilidades, requisitos, etc.',
              maxLines: 5,
            ),

            // Responsabilidades
            _buildSectionTitle('Responsabilidades'),
            _buildTextField(
              controller: _responsibilitiesController,
              labelText: '',
              hintText: 'Lista de responsabilidades principales...',
              maxLines: 3,
            ),

            // Botón publicar
            const SizedBox(height: kSpacing30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción de publicar empleo
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Publicar Empleo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
