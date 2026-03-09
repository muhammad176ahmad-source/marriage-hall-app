// lib/data/app_data.dart
import '../models/agent_model.dart';
import '../models/item_model.dart';

class AppData {
  // ================== Agents ==================
  static List<AgentModel> agents = [
    AgentModel(
      name: "Ali Agent",
      email: "ali@agent.com",
      password: "123456",
      phone: "+923001234567",
      idNumber: "12345-1234567-1",
      experience: "5",
      bio: "Professional agent with 5 years of experience.",
      dob: "01/01/1990",
      city: "Karachi",
    ),
    AgentModel(
      name: "Sara Agent",
      email: "sara@agent.com",
      password: "123456",
      phone: "+923002345678",
      idNumber: "54321-7654321-2",
      experience: "3",
      bio: "Specialized in wedding events.",
      dob: "15/05/1992",
      city: "Lahore",
    ),
  ];

  // ================== Admin Items (direct booking) ==================
  static List<ItemModel> adminItems = [
    ItemModel(
      name: "Banquet Hall A",
      location: "Karachi",
      fee: 50000,
      phone: "+923001112233",
      website: "https://banquethalla.com",
      images: ["assets/images/hall1.jpg"],
    ),
    ItemModel(
      name: "Photography Package",
      location: "Lahore",
      fee: 25000,
      phone: "+923009998877",
      website: "",
      images: ["assets/images/photo1.jpg"],
    ),
  ];

  // ================== Owner Halls ==================
  static List<ItemModel> ownerHalls = [
    ItemModel(
      name: "Grand Wedding Hall",
      location: "Islamabad",
      fee: 75000,
      phone: "+923001234567",
      website: "https://grandwedding.com",
      images: ["assets/images/hall2.jpg"],
    ),
  ];

  // ================== Booking Requests ==================
  static List<Map<String, dynamic>> bookingRequests = [];
}