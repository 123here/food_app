import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddFoodItemScreen extends StatelessWidget {
  const AddFoodItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();
    final _costController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food Item'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Food Name',
                        prefixIcon: const Icon(Icons.fastfood, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _costController,
                      decoration: InputDecoration(
                        labelText: 'Cost',
                        prefixIcon: const Icon(Icons.attach_money, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () async {
                final name = _nameController.text.trim();
                final cost = double.tryParse(_costController.text.trim());

                if (name.isEmpty || cost == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid details.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                await DatabaseHelper.instance.addFoodItem(name, cost);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Food item added successfully.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text(
                'Add Food Item',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
