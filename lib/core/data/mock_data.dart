import 'package:flutter/material.dart';

// Mock candidate data
class MockCandidate {
  static final Map<String, dynamic> julioCesarNima = {
    'name': 'Julio César Nima',
    'specialty': 'Estrategia Comunicacional',
    'skills': ['Comunicación corporativa', 'PR', 'Storytelling'],
    'education': 'Licenciado en Comunicaciones - Universidad de Lima (2018)',
    'experience': '4 años en comunicación estratégica',
    'location': 'Lima, Perú',
    'email': 'julio.nima@example.com',
    'phone': '+51 987 654 321',
    'profileCompleted': 85, // Percentage of profile completion
    'badges': [], // Will be filled during the simulation
    'transparencyScore': 85, // Initial transparency score
  };
}

// Mock company data
class MockCompany {
  static final Map<String, dynamic> jobMatch = {
    'name': 'JobMatch',
    'industry': 'Tech Recruiting',
    'description': 'Plataforma especializada en matching laboral con IA',
    'location': 'Lima, Perú',
    'website': 'www.jobmatch.com',
    'email': 'contact@jobmatch.com',
    'phone': '+51 123 456 789',
  };
}

// Mock job postings
class MockJobs {
  static final List<Map<String, dynamic>> jobs = [
    {
      'id': '1',
      'title': 'Especialista en Comunicaciones',
      'company': 'JobMatch',
      'description': 'Buscamos experto en PR y estrategia de marca.',
      'requirements': ['Comunicación corporativa', 'Storytelling'],
      'location': 'Lima, Perú',
      'salary': 'S/ 4,000 - S/ 6,000',
      'type': 'Full-time',
      'postedDate': DateTime.now().subtract(const Duration(hours: 2)),
      'fit': 92, // Match percentage for Julio
      'fitReasons': [
        '+50% por experiencia en PR',
        '+42% por Storytelling'
      ],
    },
    {
      'id': '2',
      'title': 'Content Manager',
      'company': 'Digital Solutions',
      'description': 'Gestión de contenidos y estrategia digital para marcas importantes.',
      'requirements': ['Copywriting', 'Social Media', 'SEO'],
      'location': 'Lima, Perú',
      'salary': 'S/ 3,500 - S/ 5,000',
      'type': 'Full-time',
      'postedDate': DateTime.now().subtract(const Duration(days: 2)),
      'fit': 78,
      'fitReasons': [
        '+50% por comunicación', 
        '+28% por estrategia'
      ],
    },
    {
      'id': '3',
      'title': 'Marketing Specialist',
      'company': 'Global Tech',
      'description': 'Desarrollo de estrategias de marketing y campañas publicitarias.',
      'requirements': ['Marketing Digital', 'Análisis de Datos', 'Publicidad'],
      'location': 'Remoto',
      'salary': 'S/ 4,500 - S/ 6,500',
      'type': 'Full-time',
      'postedDate': DateTime.now().subtract(const Duration(days: 5)),
      'fit': 65,
      'fitReasons': [
        '+45% por comunicación', 
        '+20% por estrategia'
      ],
    },
  ];
}

// Mock courses for skill improvement
class MockCourses {
  static final List<Map<String, dynamic>> courses = [
    {
      'id': '1',
      'title': 'Storytelling Avanzado',
      'description': 'Mejora tus habilidades narrativas para impactar a tu audiencia',
      'instructor': 'María Rodríguez',
      'duration': '2 horas',
      'level': 'Intermedio',
      'badge': 'StoryPro',
      'fitBoost': 3, // Percentage to add to fit score
      'quiz': [
        {
          'question': '¿Cuál es el elemento más importante en una historia convincente?',
          'options': ['Personajes memorables', 'Conflicto', 'Descripción detallada', 'Vocabulario complejo'],
          'correctAnswer': 'Conflicto'
        },
        {
          'question': '¿Qué técnica narrativa genera mayor conexión emocional?',
          'options': ['Estadísticas', 'Testimonios personales', 'Datos técnicos', 'Referencias históricas'],
          'correctAnswer': 'Testimonios personales'
        }
      ]
    },
  ];
}

// Mock notifications
class MockNotifications {
  static List<Map<String, dynamic>> notifications = [
    // This list will be populated during the simulation
  ];

  static void addJobNotification(String jobTitle, int fitPercentage) {
    notifications.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'job_match',
      'title': 'Nueva oferta de trabajo',
      'message': 'JobMatch publicó "$jobTitle" — $fitPercentage% Fit',
      'timestamp': DateTime.now(),
      'isRead': false,
      'fitPercentage': fitPercentage,
    });
  }

  static void addApplicationSuccessNotification() {
    notifications.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'application_sent',
      'title': 'Postulación enviada',
      'message': '¡Tu postulación ha sido enviada con éxito!',
      'timestamp': DateTime.now(),
      'isRead': false,
    });
  }

  static void addApplicationAcceptedNotification(String jobTitle) {
    notifications.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'application_accepted',
      'title': '¡Felicidades!',
      'message': 'Tu postulación para "$jobTitle" fue ACEPTADA',
      'timestamp': DateTime.now(),
      'isRead': false,
    });
  }
}

// Mock for applicants that the company sees
class MockApplicants {
  static final List<Map<String, dynamic>> applicants = [
    {
      'id': '1',
      'name': 'Julio César Nima',
      'role': 'Especialista en Comunicación',
      'transparencyScore': 95,
      'skills': ['PR', 'Storytelling', 'StoryPro Badge'],
      'appliedDate': DateTime.now(),
      'jobId': '1',
      'status': 'Pendiente',
      'fit': 92,
    },
    // Other applicants would be added here
  ];

  static void updateApplicantStatus(String applicantId, String newStatus) {
    final applicant = applicants.firstWhere((app) => app['id'] == applicantId);
    applicant['status'] = newStatus;
  }
}

