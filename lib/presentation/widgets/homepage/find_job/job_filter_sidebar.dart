import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class JobFilterSidebar extends StatefulWidget {
  const JobFilterSidebar({super.key});

  @override
  State<JobFilterSidebar> createState() => _JobFilterSidebarState();
}

class _JobFilterSidebarState extends State<JobFilterSidebar> {
  RangeValues salaryRange = const RangeValues(0, 9999);

  Widget buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: FadeInLeft(
      duration: const Duration(milliseconds: 400),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );

  Widget buildCheckboxList(List<String> items) {
    return Column(
      children:
          items.asMap().entries.map((entry) {
            int idx = entry.key;
            String item = entry.value;
            return FadeInLeft(
              delay: Duration(milliseconds: 100 * idx),
              duration: const Duration(milliseconds: 400),
              child: CheckboxListTile(
                checkboxShape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                value: false,
                onChanged: (_) {},
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '10',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: Color(0xFFEBF5F4),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Buscar por título del trabajo'),
            FadeInLeft(
              duration: const Duration(milliseconds: 400),
              child: const TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Titulo del trabajo o compañia',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),
            buildSectionTitle('Ubicación'),
            FadeInLeft(
              duration: const Duration(milliseconds: 400),
              child: SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Selecciona la ciudad',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Lima', child: Text('Lima')),
                    DropdownMenuItem(
                      value: 'Arequipa',
                      child: Text('Arequipa'),
                    ),
                    DropdownMenuItem(value: 'Remoto', child: Text('Remoto')),
                  ],
                  onChanged: (value) {},
                ),
              ),
            ),
            buildSectionTitle('Categorías'),
            buildCheckboxList([
              'Comercio',
              'Telecomunicaciones',
              'Hoteles y Turismo',
              'Educación',
              'Servicios Financieros',
            ]),
            FadeInLeft(
              duration: const Duration(milliseconds: 400),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Mostrar más'),
              ),
            ),
            buildSectionTitle('Tipo de trabajo'),
            buildCheckboxList([
              'Tiempo Completo',
              'Medio tiempo',
              'Freelancer',
              'Independiente',
              'Precio Fijo',
            ]),
            buildSectionTitle('Nivel de experiencia'),
            buildCheckboxList([
              'Sin experiencia',
              'Novato',
              'Intermedio',
              'Experto',
            ]),
            buildSectionTitle('Fecha de publicación'),
            buildCheckboxList([
              'Todos',
              'Última hora',
              'Últimas 24 horas',
              'Últimos 7 días',
              'Úttimos 30 días',
            ]),
            buildSectionTitle('Salario'),
            FadeInLeft(
              duration: const Duration(milliseconds: 400),
              child: RangeSlider(
                activeColor: Colors.orange,
                values: salaryRange,
                min: 0,
                max: 9999,
                divisions: 100,
                labels: RangeLabels(
                  '\$${salaryRange.start.round()}',
                  '\$${salaryRange.end.round()}',
                ),
                onChanged: (values) {
                  setState(() {
                    salaryRange = values;
                  });
                },
              ),
            ),
            FadeInLeft(
              duration: const Duration(milliseconds: 400),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Salario: \$${salaryRange.start.round()} - \$${salaryRange.end.round()}',
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {},
                    child: const Text('Applicar'),
                  ),
                ],
              ),
            ),
            buildSectionTitle('Tags'),
            FadeInLeft(
              duration: const Duration(milliseconds: 400),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                          'ingenieria',
                          'diseño',
                          'ui/ux',
                          'marketing',
                          'administración',
                          'software',
                          'construcción',
                        ]
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: const Color(0xFFEFEFEF),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Banner
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/find_jobs_hiring_background.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'WE ARE HIRING',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Apply Today!',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 300),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
