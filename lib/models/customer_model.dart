import 'package:uuid/uuid.dart';

class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String idType;
  final String idNumber;
  final String passportPhotoPath;
  final String idCardPhotoPath;
  final String signaturePath;
  final DateTime enrollmentDate;
  final String agentId;
  final String status;

  Customer({
    String? id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.idType,
    required this.idNumber,
    this.passportPhotoPath = '',
    this.idCardPhotoPath = '',
    this.signaturePath = '',
    DateTime? enrollmentDate,
    required this.agentId,
    this.status = 'pending',
  })  : id = id ?? const Uuid().v4(),
        enrollmentDate = enrollmentDate ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'dateOfBirth': dateOfBirth,
        'address': address,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'country': country,
        'idType': idType,
        'idNumber': idNumber,
        'passportPhotoPath': passportPhotoPath,
        'idCardPhotoPath': idCardPhotoPath,
        'signaturePath': signaturePath,
        'enrollmentDate': enrollmentDate.toIso8601String(),
        'agentId': agentId,
        'status': status,
      };

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phone: json['phone'],
        dateOfBirth: json['dateOfBirth'],
        address: json['address'],
        city: json['city'],
        state: json['state'],
        zipCode: json['zipCode'],
        country: json['country'],
        idType: json['idType'],
        idNumber: json['idNumber'],
        passportPhotoPath: json['passportPhotoPath'] ?? '',
        idCardPhotoPath: json['idCardPhotoPath'] ?? '',
        signaturePath: json['signaturePath'] ?? '',
        enrollmentDate: DateTime.parse(json['enrollmentDate']),
        agentId: json['agentId'],
        status: json['status'] ?? 'pending',
      );

  Customer copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? idType,
    String? idNumber,
    String? passportPhotoPath,
    String? idCardPhotoPath,
    String? signaturePath,
    String? status,
  }) =>
      Customer(
        id: id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        zipCode: zipCode ?? this.zipCode,
        country: country ?? this.country,
        idType: idType ?? this.idType,
        idNumber: idNumber ?? this.idNumber,
        passportPhotoPath: passportPhotoPath ?? this.passportPhotoPath,
        idCardPhotoPath: idCardPhotoPath ?? this.idCardPhotoPath,
        signaturePath: signaturePath ?? this.signaturePath,
        enrollmentDate: enrollmentDate,
        agentId: agentId,
        status: status ?? this.status,
      );
}
