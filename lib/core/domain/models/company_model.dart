class Company {
  final int? id; // Primary key from the 'companies' table
  final String userId;
  final String? companyName;
  final String? description;
  final String? logo;
  final String? website;
  final String? phone;
  final String? address;
  final String? industry;

  Company({
    this.id, // Added id
    required this.userId,
    this.companyName,
    this.description,
    this.logo,
    this.website,
    this.phone,
    this.address,
    this.industry,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json['id'] as int?, // Added id parsing
    userId: json['user_id'] as String,
    companyName: json['company_name'] as String?,
    description: json['description'] as String?,
    logo: json['logo'] as String?,
    website: json['website'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    industry: json['industry'] as String?,
  );

  Map<String, dynamic> toJson() => {
    // id is typically not sent in toJson for updates, but user_id is used
    'user_id': userId,
    if (companyName != null) 'company_name': companyName,
    if (description != null) 'description': description,
    if (logo != null) 'logo': logo,
    if (website != null) 'website': website,
    if (phone != null) 'phone': phone,
    if (address != null) 'address': address,
    if (industry != null) 'industry': industry,
  };
}
