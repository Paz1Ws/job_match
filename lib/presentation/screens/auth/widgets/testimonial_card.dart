import 'package:flutter/material.dart';

class TestimonialData {
  final int stars;
  final String text;
  final String logo;
  final String name;

  const TestimonialData({
    required this.stars,
    required this.text,
    required this.logo,
    required this.name,
  });
}

class TestimonialCard extends StatelessWidget {
  final TestimonialData data;
  final double width;
  final double padding;
  final double fontSize;
  final double logoSize;
  final double nameFontSize;

  const TestimonialCard({
    super.key,
    required this.data,
    required this.width,
    required this.padding,
    required this.fontSize,
    required this.logoSize,
    required this.nameFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: width,
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            FittedBox(
              child: Row(
                children: List.generate(
                  data.stars,
                  (index) =>
                      Icon(Icons.star, color: Colors.amber, size: logoSize),
                ),
              ),
            ),
            Expanded(
              child: Text(
                data.text,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(color: const Color(0xFF5F6C7B)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Si el ancho es pequeño, apila logo y nombre
                  if (constraints.maxWidth < 180) {
                    Image.asset(data.logo, height: logoSize);
                  }
                  // Si hay espacio, muestra en fila
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Image.asset(data.logo, height: logoSize),
                      Flexible(
                        child: Text(
                          data.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: nameFontSize,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
