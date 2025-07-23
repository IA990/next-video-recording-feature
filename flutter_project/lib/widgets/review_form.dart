import 'package:flutter/material.dart';

class ReviewForm extends StatefulWidget {
  final Function(int rating, String? comment) onSubmit;

  const ReviewForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 5;
  String? _comment;

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < _rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(_rating, _comment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => _buildStar(index)),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Comment (optional)',
            ),
            maxLines: 3,
            onSaved: (value) => _comment = value,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
