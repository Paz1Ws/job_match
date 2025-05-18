import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class ChatbotWidget extends StatefulWidget {
  final String initialMessage;
  
  const ChatbotWidget({super.key, required this.initialMessage});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> {
  bool _isExpanded = false;
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  
  @override
  void initState() {
    super.initState();
    // Add initial bot message after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text': widget.initialMessage,
            'time': DateTime.now(),
          });
        });
      }
    });
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
  
  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'sender': 'user',
        'text': _textController.text,
        'time': DateTime.now(),
      });
    });
    
    String botResponse = '¡Gracias por tu mensaje! Nuestro equipo revisará tu postulación pronto.';
    
    // Simulate bot response
    if (_textController.text.toLowerCase().contains('mejora')) {
      botResponse = 'Para mejorar tu perfil, considera añadir métricas específicas a tus logros y experiencias pasadas.';
    } else if (_textController.text.toLowerCase().contains('cuando')) {
      botResponse = 'El proceso de selección generalmente toma entre 1-2 semanas. ¡Te mantendremos informado!';
    }
    
    _textController.clear();
    
    // Delay bot response to simulate thinking
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text': botResponse,
            'time': DateTime.now(),
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isExpanded) 
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: 320,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: Icon(Icons.support_agent, size: 20, color: Colors.blue.shade700),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'JobBot Asistente',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _toggleExpand,
                          ),
                        ],
                      ),
                    ),
                    
                    // Messages area
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isBot = message['sender'] == 'bot';
                          
                          return Align(
                            alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isBot ? Colors.grey.shade100 : Colors.blue.shade700,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              constraints: const BoxConstraints(maxWidth: 250),
                              child: Text(
                                message['text'],
                                style: TextStyle(
                                  color: isBot ? Colors.black87 : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Input area
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText: 'Escribe un mensaje...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade700,
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white, size: 18),
                              onPressed: _sendMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Chatbot button
          const SizedBox(height: 16),
          InkWell(
            onTap: _toggleExpand,
            child: BounceInUp(
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade700,
                radius: 28,
                child: Icon(
                  _isExpanded ? Icons.close : Icons.support_agent,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
