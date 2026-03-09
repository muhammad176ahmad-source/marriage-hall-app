// lib/models/agent_model.dart
import 'dart:io';

class AgentModel {
  final String name;
  final String email;
  final String phone;
  final String idNumber; // mandatory
  final String password;
  final String experience;
  final String bio;
  final String dob;
  final String city;

  File? profileImage; // optional
  File? idFront; // optional
  File? idBack;  // optional

  AgentModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.idNumber,
    required this.password,
    this.profileImage,
    this.idFront,
    this.idBack,
    this.experience = '',
    this.bio = '',
    this.dob = '',
    this.city = '',
  });

  // Factory for empty agent
  factory AgentModel.empty() {
    return AgentModel(
      name: '',
      email: '',
      phone: '',
      idNumber: '',
      password: '',
    );
  }

  // Helper to check if agent is empty
  bool get isEmpty => idNumber.isEmpty && name.isEmpty && email.isEmpty;
}