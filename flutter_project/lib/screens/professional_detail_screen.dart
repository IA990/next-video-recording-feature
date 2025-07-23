import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/professional.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../widgets/review_card.dart';
import '../widgets/review_form.dart';

class ProfessionalDetailScreen extends StatefulWidget {
  final Professional professional;

  const ProfessionalDetailScreen({Key? key, required this.professional}) : super(key: key);

  @override
  State<ProfessionalDetailScreen> createState() => _ProfessionalDetailScreenState();
}

class _ProfessionalDetailScreenState extends State<ProfessionalDetailScreen> {
  late Future<List<Review>> _futureReviews;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    _futureReviews = ApiService.fetchReviews(widget.professional.id);
  }

  void _submitReview(int rating, String? comment) async {
    final review = Review(
      id: 0, // id will be assigned by backend
      professionalId: widget.professional.id,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    try {
      await ApiService.postReview(review);
      setState(() {
        _loadReviews();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: \$e')),
      );
    }
  }

  void _callPhoneNumber(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      debugPrint('Could not launch \$phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.professional.name),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(widget.professional.photoUrl),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.professional.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.professional.type,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.phone),
                const SizedBox(width: 10),
                Text(widget.professional.phone),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _callPhoneNumber(widget.professional.phone),
                  icon: const Icon(Icons.call),
                  label: const Text('Call'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Location: \${widget.professional.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<Review>>(
              future: _futureReviews,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: \${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reviews yet.'));
                } else {
                  final reviews = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return ReviewCard(review: reviews[index]);
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            ReviewForm(onSubmit: _submitReview),
          ],
        ),
      ),
    );
  }
}
