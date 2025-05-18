import 'package:flutter/material.dart';

class JobFilterSidebar extends StatefulWidget {
  const JobFilterSidebar({super.key});

  @override
  State<JobFilterSidebar> createState() => _JobFilterSidebarState();
}

class _JobFilterSidebarState extends State<JobFilterSidebar> {
  RangeValues salaryRange = const RangeValues(0, 9999);

  Widget buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  );

  Widget buildCheckboxList(List<String> items) {
    return Column(
      children: items.map((item) => CheckboxListTile(
        checkboxShape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        value: false,
        onChanged: (_) {},
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item, style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text('10', style: TextStyle(color: Colors.black54)),
              )
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
      )).toList(),
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
            const TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none
                ),
                hintText: 'Titulo del trabajo o compañia',
                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 16),

            buildSectionTitle('Ubicación'),
            DropdownButtonFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none
                ),
                hintText: 'Selecciona la ciudad',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              items: [],
              onChanged: null,
            ),

            buildSectionTitle('Categorías'),
            buildCheckboxList([
              'Comercio',
              'Telecomunicaciones',
              'Hoteles y Turismo',
              'Educación',
              'Servicios Financieros',
            ]),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mostrar más'),
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
            RangeSlider(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Salario: \$${salaryRange.start.round()} - \$${salaryRange.end.round()}'),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {},
                  child: const Text('Applicar'),
                ),
              ],
            ),
            buildSectionTitle('Tags'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'ingenieria', 'diseño', 'ui/ux', 'marketing',
                'administración', 'software', 'construcción'
              ]
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: const Color(0xFFEFEFEF),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            // Banner
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/find_jobs_hiring_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text('WE ARE HIRING',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                  SizedBox(height: 5),
                  Text('Apply Today!',style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 300)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}