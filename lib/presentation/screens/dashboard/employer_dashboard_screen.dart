import 'package:flutter/material.dart';
import 'package:job_match/presentation/widgets/auth/app_identity_bar.dart';
import 'package:job_match/config/constants/layer_constants.dart';
import 'package:job_match/core/domain/models/posted_job_model.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/screens/jobs/job_detail_screen.dart';
import 'package:job_match/presentation/widgets/dashboard/employer/post_job_form.dart';
import 'package:job_match/presentation/widgets/dashboard/employer/applicant_card.dart'; // Import ApplicantCard
import 'dart:math';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  State<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen> {
  String _selectedMenu = 'Overview';
  late List<PostedJob> _postedJobs;
  final Random _random = Random();

  // Mock data for applicants
  late List<Applicant> _allApplicants;
  late List<Applicant> _shortlistedApplicants;

  String _sortApplicationBy = 'Newest';

  @override
  void initState() {
    super.initState();
    // Mock data for posted jobs
    _postedJobs = [
      PostedJob(
        id: '1',
        title: 'UI/UX Designer',
        jobType: 'Full Time',
        remainingTime: '27 days remaining',
        status: JobStatus.Active,
        applicationsCount: 798,
        jobDetails: Job(
          logoAsset: 'assets/images/job_match.jpg',
          companyName: 'Instagram',
          location: 'Remote',
          title: 'UI/UX Designer',
          type: 'Full Time',
          salary: 'Competitive',
          logoBackgroundColor: Colors.pink.shade300,
          matchPercentage: 0,
        ),
      ),
      PostedJob(
        id: '2',
        title: 'Senior UX Designer',
        jobType: 'Internship',
        remainingTime: '8 days remaining',
        status: JobStatus.Active,
        applicationsCount: 185,
        jobDetails: Job(
          logoAsset: 'assets/images/job_match.jpg',
          companyName: 'Instagram',
          location: 'Remote',
          title: 'Senior UX Designer',
          type: 'Internship',
          salary: 'Competitive',
          logoBackgroundColor: Colors.blue.shade300,
          matchPercentage: 0,
        ),
      ),
      PostedJob(
        id: '3',
        title: 'Technical Support Specialist',
        jobType: 'Part Time',
        remainingTime: '4 days remaining',
        status: JobStatus.Active,
        applicationsCount: 556,
        isSelectedRow: true, // To match the image highlight
        jobDetails: Job(
          logoAsset: 'assets/images/job_match.jpg',
          companyName: 'Instagram',
          location: 'Remote',
          title: 'Technical Support Specialist',
          type: 'Part Time',
          salary: 'Competitive',
          logoBackgroundColor: Colors.green.shade400,
          matchPercentage: 0,
        ),
      ),
      PostedJob(
        id: '4',
        title: 'Junior Graphic Designer',
        jobType: 'Full Time',
        remainingTime: '24 days remaining',
        status: JobStatus.Active,
        applicationsCount: 583,
        jobDetails: Job(
          logoAsset: 'assets/images/job_match.jpg',
          companyName: 'Instagram',
          location: 'Remote',
          title: 'Junior Graphic Designer',
          type: 'Full Time',
          salary: 'Competitive',
          logoBackgroundColor: Colors.orange.shade300,
          matchPercentage: 0,
        ),
      ),
      PostedJob(
        id: '5',
        title: 'Front End Developer',
        jobType: 'Full Time',
        remainingTime: 'Dec 7, 2019',
        status: JobStatus.Expired,
        applicationsCount: 740,
        jobDetails: Job(
          logoAsset: 'assets/images/job_match.jpg',
          companyName: 'Instagram',
          location: 'Remote',
          title: 'Front End Developer',
          type: 'Full Time',
          salary: 'Competitive',
          logoBackgroundColor: Colors.red.shade300,
          matchPercentage: 0,
        ),
      ),
    ];

    _allApplicants = [
      Applicant(
        name: 'Ronald Richards', // Male
        role: 'UI/UX Designer',
        avatarUrl: 'assets/images/users/user1.png', // Male
        experience: '7 Years Experience',
        education: 'Master Degree',
        appliedDate: 'Jan 23, 2022',
        cvUrl: 'cv_ronald.pdf',
        email: 'ronald.richards@example.com',
        phone: '+1-202-555-0104',
        address: '123 Innovation Drive, Tech City',
        age: 32,
        currentSalary: '\$65k - \$75k',
        expectedSalary: '\$80k - \$90k',
        biography: 'Seasoned UI/UX designer with a passion for creating user-centric digital experiences. Proven ability to lead design projects from concept to launch. Eager to contribute to a dynamic team and innovative products.',
        skills: ['Figma', 'Adobe XD', 'User Research', 'Prototyping', 'Wireframing', 'Usability Testing', 'HTML/CSS'],
        educationHistory: [
          EducationEntry(degree: 'Master of Science in HCI', institution: 'Tech University', period: '2014 - 2016', description: 'Focused on advanced user interface design and research methodologies.'),
          EducationEntry(degree: 'Bachelor of Arts in Graphic Design', institution: 'Art College', period: '2010 - 2014'),
        ],
        workExperience: [
          ExperienceEntry(jobTitle: 'Senior UI/UX Designer', companyName: 'Innovate Solutions', period: 'Jan 2019 - Present', description: 'Led design for key product features, mentored junior designers, and improved user satisfaction scores by 15%.'),
          ExperienceEntry(jobTitle: 'UI/UX Designer', companyName: 'Creative Apps LLC', period: 'Jun 2016 - Dec 2018', description: 'Developed wireframes, prototypes, and high-fidelity mockups for mobile and web applications.'),
        ],
      ),
      Applicant(
        name: 'Theresa Webb', // Female
        role: 'Product Designer',
        avatarUrl: 'assets/images/users/user3.webp', // Female
        experience: '5 Years Experience',
        education: 'Bachelor Degree',
        appliedDate: 'Jan 23, 2022',
        cvUrl: 'cv_theresa.pdf',
        email: 'theresa.webb@example.com',
        phone: '+1-303-555-0121',
        address: '456 Design Avenue, Creative Town',
        age: 28,
        currentSalary: '\$55k - \$65k',
        expectedSalary: '\$70k - \$75k',
        biography: 'A creative Product Designer with a strong background in user research and visual design. Passionate about solving complex problems with intuitive and beautiful solutions. Collaborative team player.',
        skills: ['Sketch', 'InVision', 'User Flows', 'Visual Design', 'Branding', 'Agile Methodologies'],
        educationHistory: [
          EducationEntry(degree: 'Bachelor of Fine Arts in Product Design', institution: 'Design Institute', period: '2015 - 2019'),
        ],
        workExperience: [
          ExperienceEntry(jobTitle: 'Product Designer', companyName: 'NextGen Products', period: 'Jul 2019 - Present', description: 'Responsible for the end-to-end design process of new product initiatives, from ideation to final handoff.'),
        ],
      ),
      Applicant(
        name: 'Devon Lane', // Female (assuming for variety)
        role: 'User Experience Designer',
        avatarUrl: 'assets/images/users/user4.webp', // Female
        experience: '6 Years Experience',
        education: 'Master Degree',
        appliedDate: 'Jan 23, 2022',
        cvUrl: 'cv_devon.pdf',
        email: 'devon.lane@example.com',
        phone: '+1-404-555-0158',
        address: '789 User St, UX Valley',
        age: 30,
        currentSalary: '\$60k - \$70k',
        expectedSalary: '\$75k - \$85k',
        biography: 'Detail-oriented UX Designer with expertise in creating seamless user journeys and interactive prototypes. Strong analytical skills and a data-driven approach to design decisions.',
        skills: ['Axure RP', 'User Journey Mapping', 'Information Architecture', 'A/B Testing', 'Analytics'],
        educationHistory: [
          EducationEntry(degree: 'Master of Design in Interaction Design', institution: 'State University of Design', period: '2016 - 2018'),
          EducationEntry(degree: 'Bachelor of Science in Psychology', institution: 'City College', period: '2012 - 2016'),
        ],
        workExperience: [
          ExperienceEntry(jobTitle: 'UX Designer', companyName: 'UserFirst Corp', period: 'Mar 2018 - Present', description: 'Conducted user research, created personas, and designed intuitive interfaces for enterprise software.'),
        ],
      ),
      Applicant(
        name: 'Kathryn Murphy', // Female
        role: 'Interaction Designer',
        avatarUrl: 'assets/images/users/user2.png', // Male (using available distinct asset)
        experience: '4 Years Experience',
        education: 'Bachelor Degree',
        appliedDate: 'Jan 22, 2022',
        cvUrl: 'cv_kathryn.pdf',
        email: 'kathryn.murphy@example.com',
        phone: '+1-505-555-0199',
        address: '101 Interface Rd, Pixelburg',
        age: 26,
        currentSalary: '\$50k - \$60k',
        expectedSalary: '\$65k - \$70k',
        biography: 'Dynamic Interaction Designer focused on crafting engaging and intuitive digital interactions. Proficient in motion design and microinteractions to enhance user experience.',
        skills: ['Principle', 'Framer', 'Motion Design', 'Microinteractions', 'Accessibility'],
        educationHistory: [
          EducationEntry(degree: 'Bachelor of Science in Interaction Design', institution: 'Interactive Arts School', period: '2016 - 2020'),
        ],
        workExperience: [
          ExperienceEntry(jobTitle: 'Interaction Designer', companyName: 'Engage Digital', period: 'Aug 2020 - Present', description: 'Designed and prototyped interactive elements for various digital platforms, focusing on usability and delight.'),
        ],
      ),
    ];
    _shortlistedApplicants = [
      Applicant(
        name: 'Darrell Steward', // Male
        role: 'UI/UX Designer',
        avatarUrl: 'assets/images/users/user5.png', // Male
        experience: '8 Years Experience',
        education: 'Master Degree', 
        appliedDate: 'Jan 23, 2022',
        cvUrl: 'cv_darrell.pdf',
        email: 'darrell.steward@example.com',
        phone: '+1-606-555-0133',
        address: '222 Visionary Way, Future City',
        age: 35,
        currentSalary: '\$70k - \$80k',
        expectedSalary: '\$85k - \$95k',
        biography: 'Highly experienced UI/UX Lead with a track record of delivering impactful design solutions for global brands. Strategic thinker with strong leadership and communication skills.',
        skills: ['Leadership', 'Design Systems', 'Strategy', 'Figma', 'Adobe Creative Suite', 'Client Management'],
        educationHistory: [
          EducationEntry(degree: 'Master of Business Administration (MBA)', institution: 'Premier Business School', period: '2012-2014'),
          EducationEntry(degree: 'Bachelor of Design', institution: 'National Institute of Design', period: '2008 - 2012'),
        ],
        workExperience: [
          ExperienceEntry(jobTitle: 'Lead UI/UX Designer', companyName: 'Global Tech Inc.', period: 'May 2017 - Present', description: 'Oversee the design team, define design strategy, and ensure high-quality output for all digital products.'),
          ExperienceEntry(jobTitle: 'Senior UI Designer', companyName: 'Digital Dreams Co.', period: 'Apr 2014 - Apr 2017', description: 'Designed interfaces for award-winning mobile applications and websites.'),
        ],
      ),
      Applicant(
        name: 'Jenny Wilson', // Female
        role: 'UI Designer',
        avatarUrl: 'assets/images/users/user3.webp', // Female (reused user3.webp as user6.png is not available and to maintain gender)
        experience: '3 Years Experience',
        education: 'Bachelor Degree',
        appliedDate: 'Jan 23, 2022',
        cvUrl: 'cv_jenny.pdf',
        email: 'jenny.wilson@example.com',
        phone: '+1-707-555-0177',
        address: '333 Pixel Perfect Pl, Designville',
        age: 25,
        currentSalary: '\$45k - \$55k',
        expectedSalary: '\$60k - \$65k',
        biography: 'Enthusiastic UI Designer with a keen eye for detail and a love for clean, modern aesthetics. Proficient in creating visually appealing and functional user interfaces.',
        skills: ['Adobe Illustrator', 'Photoshop', 'Visual Hierarchy', 'Typography', 'Color Theory'],
        educationHistory: [
          EducationEntry(degree: 'Bachelor of Arts in Visual Communication', institution: 'Art & Design Academy', period: '2017 - 2021'),
        ],
        workExperience: [
          ExperienceEntry(jobTitle: 'UI Designer', companyName: 'Pixel Perfect Studios', period: 'Jun 2021 - Present', description: 'Create visual designs, style guides, and asset libraries for various client projects.'),
        ],
      ),
    ];
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    final Color selectedColor = Colors.blue.shade700;
    final Color unselectedColor = Colors.grey.shade600;
    final Color itemColor = isSelected ? selectedColor : unselectedColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: kPadding12,
          horizontal: kPadding16,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.blue.withOpacity(0.08) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? selectedColor : Colors.transparent,
              width: kStroke3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: kIconSize20),
            const SizedBox(width: kSpacing12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: itemColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hola, Instagram',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222B45),
            ),
          ),
          const SizedBox(height: kSpacing8),
          Text(
            'Aquí están tus actividades diarias y aplicaciones',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: kSpacing20 + kSpacing4),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  count: '589',
                  label: 'Empleos Abiertos',
                  icon: Icons.work_outline,
                  iconColor: Colors.blue.shade700,
                  backgroundColor: Colors.blue.shade50,
                  iconBackgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: kSpacing20),
              Expanded(
                child: _buildSummaryCard(
                  count: '2,517',
                  label: 'Candidatos Guardados',
                  icon: Icons.person_outline,
                  iconColor: Colors.orange.shade700,
                  backgroundColor: Colors.orange.shade50,
                  iconBackgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing30 + kSpacing4),
          _buildPostedJobsTableSection(
            title: 'Empleos Publicados Recientemente',
            jobs: _postedJobs,
            showViewAllButton: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String count,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color iconBackgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(kPadding20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kRadius12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: iconColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: kSpacing4),
              Text(
                label,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
          Container(
            padding: kPaddingAll12,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(kRadius8),
            ),
            child: Icon(icon, color: iconColor, size: kIconSize24),
          ),
        ],
      ),
    );
  }

  Widget _buildPostedJobsTableSection({
    required String title,
    required List<PostedJob> jobs,
    bool showViewAllButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(kPadding20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kRadius12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222B45),
                ),
              ),
              if (showViewAllButton)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedMenu = 'My Jobs';
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ver todo',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: kSpacing4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.blue.shade700,
                        size: kIconSize18,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: kSpacing12),
          _buildPostedJobsTableHeader(),
          const Divider(
            height: kSpacing20,
            thickness: 1,
            color: Color(0xFFEDF1F7),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return _buildPostedJobRow(jobs[index]);
            },
            separatorBuilder:
                (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEDF1F7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostedJobsTableHeader() {
    TextStyle headerStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kPadding8,
        horizontal: kPadding12,
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text('EMPLEOS', style: headerStyle)),
          Expanded(
            flex: 2,
            child: Text(
              'ESTADO',
              style: headerStyle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'APLICACIONES',
              style: headerStyle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'ACCIONES',
              style: headerStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostedJobRow(PostedJob job) {
    TextStyle jobTitleStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFF222B45),
    );
    TextStyle detailStyle = TextStyle(
      fontSize: 12,
      color: Colors.grey.shade600,
    );
    Color statusColor =
        job.status == JobStatus.Active ? Colors.green : Colors.red;
    IconData statusIcon =
        job.status == JobStatus.Active
            ? Icons.check_circle_outline
            : Icons.cancel_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kPadding12 + kSpacing4,
        horizontal: kPadding12,
      ),
      decoration: BoxDecoration(
        border:
            job.isSelectedRow
                ? Border(
                  left: BorderSide(
                    color: Colors.blue.shade600,
                    width: kStroke3,
                  ),
                )
                : null,
        color:
            job.isSelectedRow
                ? Colors.blue.withOpacity(0.03)
                : Colors.transparent,
      ),
      child: Row(
        children: [
          // Job Info
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: jobTitleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: kSpacing4),
                Row(
                  children: [
                    Text(job.jobType, style: detailStyle),
                    Text(' • ', style: detailStyle),
                    Text(job.remainingTime, style: detailStyle),
                  ],
                ),
              ],
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: kIconSize16),
                const SizedBox(width: kSpacing4),
                Text(
                  job.status == JobStatus.Active ? 'Activo' : 'Expirado',
                  style: TextStyle(
                    fontSize: 13,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Applications
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  color: Colors.grey.shade600,
                  size: kIconSize16,
                ),
                const SizedBox(width: kSpacing4),
                Text(
                  '${job.applicationsCount} Aplicaciones',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          // Actions
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logic for viewing applications
                    // For now, let's switch to the Job Applications view
                    setState(() => _selectedMenu = 'Job Applications');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        job.isSelectedRow
                            ? Colors.blue.shade700
                            : const Color(0xFFF0F4FF),
                    foregroundColor:
                        job.isSelectedRow ? Colors.white : Colors.blue.shade700,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPadding12,
                      vertical: kPadding12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadius8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Ver Aplicaciones'),
                ),
                const SizedBox(width: kSpacing4),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                  onSelected: (value) {
                    if (value == 'view_detail') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => JobDetailScreen(job: job.jobDetails),
                        ),
                      );
                    }
                    // Handle other actions
                  },
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'promote_job',
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_outline,
                                color: Colors.orange,
                                size: kIconSize20,
                              ),
                              SizedBox(width: kSpacing8),
                              Text('Promocionar Empleo'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'view_detail',
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                color: Colors.blue,
                                size: kIconSize20,
                              ),
                              SizedBox(width: kSpacing8),
                              Text('Ver Detalle'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'mark_expired',
                          child: Row(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                                size: kIconSize20,
                              ),
                              SizedBox(width: kSpacing8),
                              Text('Marcar como Expirado'),
                            ],
                          ),
                        ),
                      ],
                  tooltip: "Más opciones",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobApplicationsContent() {
    // Sort applicants based on _sortApplicationBy
    // For simplicity, this is not implemented here, assume lists are pre-sorted or sort them before passing.

    return Padding(
      padding: const EdgeInsets.all(kPadding20 + kSpacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Job Applications',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222B45),
                ),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      /* Filter logic */
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.grey.shade700,
                      size: kIconSize20,
                    ),
                    label: Text(
                      'Filter',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRadius8),
                      ),
                    ),
                  ),
                  const SizedBox(width: kSpacing12),
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        _sortApplicationBy = value;
                        // Add logic to re-sort applicant lists here
                      });
                    },
                    itemBuilder:
                        (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Newest',
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'Newest',
                                  groupValue: _sortApplicationBy,
                                  onChanged: (v) {},
                                  activeColor: Colors.blue.shade700,
                                ),
                                const Text('Newest'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Oldest',
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: 'Oldest',
                                  groupValue: _sortApplicationBy,
                                  onChanged: (v) {},
                                  activeColor: Colors.blue.shade700,
                                ),
                                const Text('Oldest'),
                              ],
                            ),
                          ),
                        ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPadding12,
                        vertical: kPadding8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(kRadius8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sort,
                            color: Colors.white,
                            size: kIconSize20,
                          ),
                          const SizedBox(width: kSpacing4),
                          Text('Sort', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: kSpacing12),
                  ElevatedButton.icon(
                    onPressed: () {
                      /* Create new column logic */
                    },
                    icon: const Icon(Icons.add, size: kIconSize20),
                    label: const Text('Create New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRadius8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPadding16,
                        vertical: kPadding12 + kSpacing4 / 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: kSpacing20 + kSpacing4),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildApplicantColumnWidget(
                    title: 'All Application',
                    count: _allApplicants.length,
                    applicants: _allApplicants,
                    onColumnOptionsSelected: (value) {
                      /* Handle options */
                    },
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  child: _buildApplicantColumnWidget(
                    title: 'Shortlisted',
                    count: _shortlistedApplicants.length,
                    applicants: _shortlistedApplicants,
                    onColumnOptionsSelected: (value) {
                      /* Handle options */
                    },
                  ),
                ),
                // Add more columns as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantColumnWidget({
    required String title,
    required int count,
    required List<Applicant> applicants,
    required Function(String) onColumnOptionsSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(kPadding12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Light grey background for the column
        borderRadius: BorderRadius.circular(kRadius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: kPadding12,
              left: kSpacing4,
              right: kSpacing4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(width: kSpacing8),
                    Text(
                      '($count)',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz, color: Colors.grey.shade600),
                  onSelected: onColumnOptionsSelected,
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit_column',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: kIconSize20),
                              SizedBox(width: kSpacing8),
                              Text('Edit Column'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete_column',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: kIconSize20,
                              ),
                              SizedBox(width: kSpacing8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                  tooltip: "Column Options",
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                return ApplicantCard(applicant: applicants[index]);
              },
              separatorBuilder:
                  (context, index) => const SizedBox(height: kPadding12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double appIdentityBarHeight = 70.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: <Widget>[
          AppIdentityBar(height: appIdentityBarHeight),
          Expanded(
            child: Row(
              children: <Widget>[
                // Sidebar
                Container(
                  width: 260,
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: kPadding20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kPadding16,
                          vertical: kPadding8,
                        ),
                        child: Text(
                          'PANEL DE EMPRESA',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: kSpacing8),
                      _buildMenuItem(
                        icon: Icons.layers_outlined,
                        title: 'Resumen',
                        isSelected: _selectedMenu == 'Overview',
                        onTap: () => setState(() => _selectedMenu = 'Overview'),
                      ),
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Perfil de Empresa',
                        isSelected: _selectedMenu == 'Employers Profile',
                        onTap:
                            () => setState(
                              () => _selectedMenu = 'Employers Profile',
                            ),
                      ),
                      _buildMenuItem(
                        icon: Icons.add_circle_outline,
                        title: 'Publicar Empleo',
                        isSelected: _selectedMenu == 'Post a Job',
                        onTap:
                            () => setState(() => _selectedMenu = 'Post a Job'),
                      ),
                      _buildMenuItem(
                        icon: Icons.work_outline,
                        title: 'Mis Empleos',
                        isSelected: _selectedMenu == 'My Jobs',
                        onTap: () => setState(() => _selectedMenu = 'My Jobs'),
                      ),
                      _buildMenuItem(
                        // New Menu Item for Job Applications
                        icon: Icons.people_alt_outlined,
                        title: 'Aplicaciones',
                        isSelected: _selectedMenu == 'Job Applications',
                        onTap:
                            () => setState(
                              () => _selectedMenu = 'Job Applications',
                            ),
                      ),
                      _buildMenuItem(
                        icon: Icons.bookmark_border,
                        title: 'Candidatos Guardados',
                        isSelected: _selectedMenu == 'Saved Candidate',
                        onTap:
                            () => setState(
                              () => _selectedMenu = 'Saved Candidate',
                            ),
                      ),
                      _buildMenuItem(
                        icon: Icons.receipt_long_outlined,
                        title: 'Planes y Facturación',
                        isSelected: _selectedMenu == 'Plans & Billing',
                        onTap:
                            () => setState(
                              () => _selectedMenu = 'Plans & Billing',
                            ),
                      ),
                      _buildMenuItem(
                        icon: Icons.groups_outlined,
                        title: 'Todas las Empresas',
                        isSelected: _selectedMenu == 'All Companies',
                        onTap:
                            () =>
                                setState(() => _selectedMenu = 'All Companies'),
                      ),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Configuración',
                        isSelected: _selectedMenu == 'Settings',
                        onTap: () => setState(() => _selectedMenu = 'Settings'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      _selectedMenu == 'Overview'
                          ? _buildOverviewContent()
                          : _selectedMenu == 'Post a Job'
                          ? const PostJobForm()
                          : _selectedMenu == 'Job Applications'
                          ? _buildJobApplicationsContent()
                          : Center(
                            child: Text(
                              'Contenido para $_selectedMenu',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
