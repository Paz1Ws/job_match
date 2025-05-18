import 'package:flutter/material.dart';
import 'package:job_match/models/simple_job_view_model.dart';
import 'package:job_match/presentation/widgets/homepage/find_job/simple_job_card.dart';

class SimpleJobCardListView extends StatelessWidget {
  const SimpleJobCardListView({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsMockup = [
      SimpleJobView(
        timeAgo: "hace 10 min",
        title: "Director de Seguridad Avanzada",
        company: "Bauch, Schuppe and Schulist Co",
        category: "Hoteles y Turismo",
        type: "Tiempo completo",
        salary: "\$40000-\$42000",
        location: "Nueva York, EE.UU.",
      ),
      SimpleJobView(
        timeAgo: "hace 12 min",
        title: "Facilitador Creativo Regional",
        company: "Wisozk - Becker Co",
        category: "Medios",
        type: "Medio tiempo",
        salary: "\$28000-\$32000",
        location: "Los Ángeles, EE.UU.",
      ),
      SimpleJobView(
        timeAgo: "hace 15 min",
        title: "Planificador de Integración Interna",
        company: "Mraz, Quigley and Feest Inc.",
        category: "Construcción",
        type: "Tiempo completo",
        salary: "\$48000-\$50000",
        location: "Texas, EE.UU.",
      ),
      SimpleJobView(
        timeAgo: "hace 24 min",
        title: "Director de Intranet Distrital",
        company: "VonRueden - Weber Co",
        category: "Comercio",
        type: "Tiempo completo",
        salary: "\$42000-\$48000",
        location: "Florida, EE.UU.",
      ),
      SimpleJobView(
        timeAgo: "hace 26 min",
        title: "Facilitador de Tácticas Corporativas",
        company: "Cormier, Turner and Flatley Inc",
        category: "Comercio",
        type: "Tiempo completo",
        salary: "\$38000-\$40000",
        location: "Boston, EE.UU.",
      ),
      SimpleJobView(
        timeAgo: "hace 30 min",
        title: "Consultor de Cuentas Avanzadas",
        company: "Miller Group",
        category: "Servicios Financieros",
        type: "Tiempo completo",
        salary: "\$45000-\$48000",
        location: "Boston, EE.UU.",
      ),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mostrando 6-6 de 10 resultados', style: TextStyle(color: Colors.black54)),
            DropdownMenu(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder()
              ),
              label: const Text('Ordenar'),
              selectedTrailingIcon: const Icon(Icons.keyboard_arrow_down),
              trailingIcon: const Icon(Icons.keyboard_arrow_down),
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 0, label: 'Por nombre'),
                DropdownMenuEntry(value: 1, label: 'Por recientes'),
              ]
            )
          ],
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: jobsMockup.length,
          itemBuilder: (context, index) {
            final job = jobsMockup[index];
            return SimpleJobCard(
              timeAgo: job.timeAgo,
              title: job.title,
              company: job.company,
              category: job.category,
              jobType: job.type,
              salary: job.salary,
              location: job.salary,
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {},
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: const CircleBorder(),
              ),
              child: const Text("1"),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: const CircleBorder(),
              ),
              child: const Text("2"),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}