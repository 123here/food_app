import 'package:flutter/material.dart';
import 'add_order_plan.dart';
import 'query_order_plan.dart';
import 'add_food_item.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  // title on the top
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food App'),
      ),

      //padding and alloignemnt
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            // button for add order plan
            _buildGridButton(
              context,
              title: 'Add Order Plan',
              icon: Icons.add_shopping_cart,
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddOrderPlanScreen()),
                );
              },
            ),
            // button to go to query plan
            _buildGridButton(
              context,
              title: 'Query Order Plan',
              icon: Icons.search,
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QueryOrderPlanScreen()),
                );
              },
            ),
            //button to go to add food item section
            _buildGridButton(
              context,
              title: 'Add Food Item',
              icon: Icons.fastfood,
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFoodItemScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
  // color and allignment for button
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
