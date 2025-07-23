import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/professional.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../widgets/review_card.dart';
import '../widgets/review_form.dart';

class ProfessionalDashboardScreen extends StatefulWidget {
  final Professional professional;

  const ProfessionalDashboardScreen({Key? key, required this.professional}) : super(key: key);

  @override
  State<ProfessionalDashboardScreen> createState() => _ProfessionalDashboardScreenState();
}

class _ProfessionalDashboardScreenState extends State<ProfessionalDashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _workingHoursController;

  late Future<List<Review>> _futureReviews;
  late List<String> _photoUrls;
  late List<Offer> _offers;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.professional.name);
    _descriptionController = TextEditingController(text: widget.professional.description ?? '');
    _phoneController = TextEditingController(text: widget.professional.phone);
    _emailController = TextEditingController(text: widget.professional.email ?? '');
    _workingHoursController = TextEditingController(text: widget.professional.workingHours ?? '');

    _photoUrls = widget.professional.photos.map((p) => p.url).toList();
    _offers = widget.professional.offers;

    _loadReviews();
  }

  void _loadReviews() {
    _futureReviews = ApiService.fetchReviews(widget.professional.id);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // TODO: Upload image to backend and update _photoUrls
      setState(() {
        _photoUrls.add(pickedFile.path);
      });
    }
  }

  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Call API to update professional profile
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  void _submitOffer(String title, String description) async {
    // TODO: Call API to add/update offer
    setState(() {
      _offers.add(Offer(title: title, description: description));
    });
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter name' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter phone' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter email' : null,
                  ),
                  TextFormField(
                    controller: _workingHoursController,
                    decoration: const InputDecoration(labelText: 'Working Hours'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitProfile,
                    child: const Text('Save Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photoUrls.length + 1,
                itemBuilder: (context, index) {
                  if (index == _photoUrls.length) {
                    return IconButton(
                      icon: const Icon(Icons.add_a_photo),
                      onPressed: _pickImage,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.network(_photoUrls[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Offers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // TODO: Add offers list and form
            const SizedBox(height: 20),
            const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  final avgRating = _calculateAverageRating(reviews);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Average Rating: \${avgRating.toStringAsFixed(1)} / 5'),
                      Text('Total Reviews: \${reviews.length}'),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return ReviewCard(review: reviews[index]);
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            ReviewForm(
              onSubmit: (rating, comment) {
                // TODO: Submit new review
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Offer {
  final String title;
  final String? description;

  Offer({required this.title, this.description});
}
