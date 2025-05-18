import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/data/mock_data.dart';

class MicroCourseScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  const MicroCourseScreen({super.key, required this.course});

  @override
  State<MicroCourseScreen> createState() => _MicroCourseScreenState();
}

class _MicroCourseScreenState extends State<MicroCourseScreen> {
  int _currentStep = 0;
  int _correctAnswers = 0;
  final List<String> _selectedAnswers = [];

  void _goToNextStep() {
    if (_currentStep < widget.course['quiz'].length) {
      setState(() {
        _currentStep++;
      });
    } else {
      _finishCourse();
    }
  }

  void _selectAnswer(String answer, int questionIndex) {
    setState(() {
      if (_selectedAnswers.length <= questionIndex) {
        _selectedAnswers.add(answer);
      } else {
        _selectedAnswers[questionIndex] = answer;
      }

      // Check if answer is correct
      if (answer == widget.course['quiz'][questionIndex]['correctAnswer']) {
        _correctAnswers++;
      }
    });
  }

  void _finishCourse() {
    // Calculate score
    final double percentageCorrect =
        (_correctAnswers / widget.course['quiz'].length) * 100;
    final bool passed = percentageCorrect >= 70;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              passed ? '¡Felicidades!' : 'Sigue intentando',
              style: TextStyle(
                color: passed ? Colors.green.shade700 : Colors.orange.shade700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  passed
                      ? 'Has completado el curso "${widget.course['title']}" con éxito.'
                      : 'No has aprobado el curso. Puedes volver a intentarlo.',
                ),
                const SizedBox(height: 16),
                Text(
                  'Tu puntuación: ${percentageCorrect.toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (passed) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.purple.shade100,
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Badge desbloqueado: ${widget.course["badge"]}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Tu Fit score aumentó en ${widget.course["fitBoost"]}%',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to previous screen
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isContentScreen = _currentStep == 0;
    final bool isQuizQuestionScreen =
        _currentStep > 0 && _currentStep <= widget.course['quiz'].length;
    final bool isQuizFinishedScreen =
        _currentStep > widget.course['quiz'].length;

    Widget screenContent;

    if (isContentScreen) {
      screenContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Contenido del curso',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            'En este micro-curso aprenderás técnicas avanzadas de narración que te permitirán crear conexiones más profundas con tu audiencia y transmitir mensajes de manera más efectiva.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Principales técnicas de Storytelling Avanzado:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint('Estructura narrativa de 3 actos'),
          _buildBulletPoint('Uso de conflicto como elemento central'),
          _buildBulletPoint('Creación de personajes memorables'),
          _buildBulletPoint('Testimonios y casos de éxito'),
          _buildBulletPoint('Conexión emocional con la audiencia'),
        ],
      );
    } else if (isQuizQuestionScreen) {
      final questionIndex = _currentStep - 1;
      final question = widget.course['quiz'][questionIndex];
      screenContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Pregunta ${questionIndex + 1}/${widget.course['quiz'].length}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question['question'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...question['options'].map<Widget>((option) {
            final bool isSelected =
                _selectedAnswers.length > questionIndex &&
                _selectedAnswers[questionIndex] == option;
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue:
                  _selectedAnswers.length > questionIndex
                      ? _selectedAnswers[questionIndex]
                      : null,
              onChanged: (_) => _selectAnswer(option, questionIndex),
              activeColor: Colors.purple.shade700,
              selected: isSelected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color:
                      isSelected
                          ? Colors.purple.shade700
                          : Colors.grey.shade300,
                ),
              ),
            );
          }).toList(),
        ],
      );
    } else {
      // isQuizFinishedScreen
      // This state is typically handled by the dialog from _finishCourse.
      // If the dialog is dismissed and we return here, show a placeholder.
      screenContent = const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Quiz completado. Los resultados se mostraron en el diálogo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course['title']),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: FadeIn(
            duration: const Duration(milliseconds: 500),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.purple.shade100,
                            radius: 28,
                            child: Icon(
                              Icons.school,
                              color: Colors.purple.shade700,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.course['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Instructor: ${widget.course['instructor']} • Duración: ${widget.course['duration']}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Flexible(
                        child: SingleChildScrollView(child: screenContent),
                      ),

                      const SizedBox(height: 32),

                      // Navigation buttons
                      if (!isQuizFinishedScreen) // Hide button if quiz is truly finished and placeholder is shown
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            // Corrected onPressed logic:
                            onPressed:
                                isContentScreen
                                    ? _goToNextStep
                                    : (isQuizQuestionScreen
                                        ? (_selectedAnswers.length >
                                                (_currentStep - 1)
                                            ? _goToNextStep
                                            : null) // Disabled if no answer
                                        : _goToNextStep), // For "Finalizar Quiz" if button were shown
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              isContentScreen
                                  ? 'Comenzar Quiz'
                                  : (isQuizQuestionScreen &&
                                          _currentStep <=
                                              widget.course['quiz'].length
                                      ? 'Siguiente Pregunta'
                                      : 'Finalizar Quiz'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
