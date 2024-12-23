import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddFoodItemScreen extends StatelessWidget {
  const AddFoodItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // controller for adding and manging input fields
    final _nameController = TextEditingController();
    final _costController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food Item'), // Title Screen
        backgroundColor: Colors.teal, // background Color
      ),
      body: Padding(
        // Allging the padding and allgiment to the box
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
                // Get the food name and cost from the input fields
                final name = _nameController.text.trim();
                final cost = double.tryParse(_costController.text.trim());

                
                // Validate inputs: Check if name is empty or cost is invalid
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
                 // Add the food item to the database
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
