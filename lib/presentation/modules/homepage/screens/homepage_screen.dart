import 'package:flutter/material.dart';
import 'package:job_match/presentation/general_widgets/job_match_widget.dart';
import 'package:job_match/presentation/modules/homepage/widgets/partner_icon.dart';
import 'package:job_match/presentation/modules/homepage/widgets/stat_item.dart';
import 'package:job_match/presentation/modules/login/screens/login_screen.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          //* Image background
          Positioned.fill(
            child: Image.asset(
              'assets/images/homepage_background.png',
              fit: BoxFit.cover,
            )
          ),
    
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),
    
          //* content
          SingleChildScrollView(
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 40),
                _buildHeroSection(context),
                const SizedBox(height: 60),
                _buildStatsSection(),
                const SizedBox(height: 90),
                _buildPartnersSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          JobMatchWidget(),
          Row(
            children: [
              _buildTopBarButton('Home', selected: true),
              _buildTopBarButton('Jobs'),
              _buildTopBarButton('About Us'),
              _buildTopBarButton('Contact Us'),
            ],
          ),

          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen())),
                child: const Text('Login', style: TextStyle(color: Colors.white))
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0)
                ),
                onPressed: () {},
                child: const Text('Register'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopBarButton(String title, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(title, style: TextStyle(color: selected ? Colors.white : Colors.white38)),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Find Your Dream Job Today!',
          style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        const Text(
          'Connecting Talent with Opportunity: Your Gateway to Career Success',
          style: TextStyle(fontSize: 14, color: Colors.white70),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdownField('Job Title or Company', showDivider: true),
              _buildDropdownField('Select Location', showDivider: true),
              _buildDropdownField('Select Category', showDivider: false),

              _buildFindJobButton()
            ],
          ),
        ),
      ],
    );
  }

  ElevatedButton _buildFindJobButton() {
    return ElevatedButton(
      onPressed: () { },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 75),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10)
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 10),
          Text('Search Job', style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  Widget _buildDropdownField(String hint, {bool showDivider = false}) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: showDivider ?
          const Border(right: BorderSide(color: Colors.black12, width: 1)):
          null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Colors.black54)),
          items: const [],
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        StatItem(icon: Icons.work_outline, count: '25,850', label: 'Jobs'),
        SizedBox(width: 60),
        StatItem(icon: Icons.people_outline, count: '10,250', label: 'Candidates'),
        SizedBox(width: 60),
        StatItem(icon: Icons.business, count: '18,400', label: 'Companies'),
      ],
    );
  }

  Widget _buildPartnersSection() {
    final logos = {
      PartnerIcon(partnerType: PartnerType.spotify): 'Spotify',
      PartnerIcon(partnerType: PartnerType.slack): 'slack',
      PartnerIcon(partnerType: PartnerType.adobe): 'Adobe',
      PartnerIcon(partnerType: PartnerType.asana): 'asana',
      PartnerIcon(partnerType: PartnerType.linear): 'Linear'
    };
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 40,
        children: logos.entries.map((e) => Row(
          children: [
            e.key,
            const SizedBox(width: 5),
            Text(e.value, style: const TextStyle(color: Colors.white))
          ]
        )).toList(),
      ),
    );
  }
}