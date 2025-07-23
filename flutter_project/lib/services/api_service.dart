import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/professional.dart';
import '../models/review.dart';

class ApiService {
  // Base URL of the FastAPI backend
  static const String baseUrl = 'http://10.0.2.2:8000'; // Adjust for emulator or device

  // Fetch all professionals from backend
  static Future<List<Professional>> fetchProfessionals() async {
    final response = await http.get(Uri.parse('\$baseUrl/professionals'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Professional(
        name: json['name'],
        type: json['type'],
        phone: json['phone'],
        location: json['location'] ?? '',
        photoUrl: json['photo_url'] ?? '',
      )).toList();
    } else {
      throw Exception('Failed to load professionals');
    }
  }

  // Fetch reviews for a professional
  static Future<List<Review>> fetchReviews(int professionalId) async {
    final response = await http.get(Uri.parse('\$baseUrl/reviews/professional/\$professionalId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  // Post a new review
  static Future<void> postReview(Review review) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/reviews/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'professional_id': review.professionalId,
        'rating': review.rating,
        'comment': review.comment,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to post review');
    }
  }
}
