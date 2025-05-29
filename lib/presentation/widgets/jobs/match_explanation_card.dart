import 'package:flutter/material.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/domain/models/match_result_model.dart';
import 'package:animate_do/animate_do.dart';

class MatchExplanationCard extends StatefulWidget {
  final MatchResult? matchResult;
  final int fitScore;
  final bool isLoading;

  const MatchExplanationCard({
    super.key,
    required this.fitScore,
    this.matchResult,
    this.isLoading = false,
  });

  @override
  State<MatchExplanationCard> createState() => _MatchExplanationCardState();
}

class _MatchExplanationCardState extends State<MatchExplanationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final Color fitColor =
        widget.fitScore >= 75
            ? Colors.green.shade700
            : widget.fitScore >= 50
            ? Colors.orange.shade700
            : Colors.red.shade700;

    if (widget.isLoading || widget.matchResult == null) {
      return _buildSimpleCard(fitColor);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: kSpacing8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: kPadding16,
            vertical: kSpacing8,
          ),
          childrenPadding: const EdgeInsets.only(
            left: kPadding16,
            right: kPadding16,
            bottom: kPadding16,
          ),
          leading: CircleAvatar(
            backgroundColor: fitColor.withOpacity(0.1),
            child: Text(
              "${widget.fitScore}%", // Fit score percentage
              style: TextStyle(
                color: fitColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          title: Text(
            "Análisis de Match",
            style: TextStyle(
              fontWeight: FontWeight.w600, // Semi-bold title
              fontSize: 16,
              color: _isExpanded ? fitColor : Colors.grey.shade800,
            ),
          ),
          subtitle: Text(
            "Toca para ${_isExpanded ? 'ocultar' : 'ver'} detalles de compatibilidad",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: fitColor,
          ),
          children: [
            const Divider(),
            _buildAnalysisSection(
              "Áreas de Coincidencia",
              widget.matchResult!.explanation.matchAreas,
              Icons.check_circle_outline,
              Colors.green.shade700,
            ),
            const SizedBox(height: kSpacing12),
            _buildAnalysisSection(
              "Áreas de Mejora",
              widget.matchResult!.explanation.mismatches,
              Icons.info_outline,
              Colors.orange.shade700,
            ),
            if (widget.matchResult!.explanation.summary.isNotEmpty) ...[
              const SizedBox(height: kSpacing12),
              _buildSummarySection(widget.matchResult!.explanation.summary),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleCard(Color fitColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: kSpacing8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kPadding16,
          vertical: kSpacing8,
        ),
        leading:
            widget.isLoading
                ? SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(fitColor),
                  ),
                )
                : CircleAvatar(
                  backgroundColor: fitColor.withOpacity(0.1),
                  child: Text(
                    "${widget.fitScore}%", // Fit score percentage
                    style: TextStyle(
                      color: fitColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
        title:
            widget.isLoading
                ? const Text("Analizando match...")
                : Text(
                  "Puntaje de Match: ${widget.fitScore}%",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
        subtitle:
            widget.isLoading
                ? const Text("Calculando tu compatibilidad...")
                : Text(
                  "Análisis de IA no disponible",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
      ),
    );
  }

  Widget _buildAnalysisSection(
    String title,
    List<String> items,
    IconData iconData,
    Color iconColor,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: kSpacing8),
        ...items.asMap().entries.map((entry) {
          return FadeInLeft(
            delay: Duration(milliseconds: 100 * entry.key),
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: kSpacing8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(iconData, color: iconColor, size: 18),
                  const SizedBox(width: kSpacing8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSummarySection(String summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Resumen",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: kSpacing8),
        FadeIn(
          duration: const Duration(milliseconds: 500),
          child: Container(
            padding: const EdgeInsets.all(kPadding12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(kRadius8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              summary,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
