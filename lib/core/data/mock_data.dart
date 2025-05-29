// Mock courses for skill improvement
class MockCourses {
  static final List<Map<String, dynamic>> courses = [
    {
      'id': '1',
      'title': 'Storytelling Avanzado',
      'description':
          'Mejora tus habilidades narrativas para impactar a tu audiencia',
      'instructor': 'María Rodríguez',
      'duration': '2 horas',
      'level': 'Intermedio',
      'badge': 'StoryPro',
      'fitBoost': 3, // Percentage to add to fit score
      'quiz': [
        {
          'question':
              '¿Cuál es el elemento más importante en una historia convincente?',
          'options': [
            'Personajes memorables',
            'Conflicto',
            'Descripción detallada',
            'Vocabulario complejo',
          ],
          'correctAnswer': 'Conflicto',
        },
        {
          'question': '¿Qué técnica narrativa genera mayor conexión emocional?',
          'options': [
            'Estadísticas',
            'Testimonios personales',
            'Datos técnicos',
            'Referencias históricas',
          ],
          'correctAnswer': 'Testimonios personales',
        },
      ],
    },
  ];
}
