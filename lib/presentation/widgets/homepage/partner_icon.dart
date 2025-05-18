import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PartnerType { spotify, slack, adobe, asana, linear }

class PartnerIcon extends StatelessWidget {
  final PartnerType partnerType;

  const PartnerIcon({super.key, required this.partnerType});

  @override
  Widget build(BuildContext context) {
    const String pathSvgAsset = 'assets/custom_icons/';
    return SvgPicture.asset(height: 60, switch (partnerType) {
      PartnerType.spotify => '${pathSvgAsset}spotify.svg',
      PartnerType.slack => '${pathSvgAsset}slack.svg',
      PartnerType.adobe => '${pathSvgAsset}adobe.svg',
      PartnerType.asana => '${pathSvgAsset}asana.svg',
      PartnerType.linear => '${pathSvgAsset}linear.svg',
    }, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn));
  }
}
