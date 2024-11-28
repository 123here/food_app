import 'package:flutter/material.dart';
import 'database_helper.dart';

// Stateful widget to display and query order plans
class QueryOrderPlanScreen extends StatefulWidget {
  const QueryOrderPlanScreen({super.key});

  @override
  _QueryOrderPlanScreenState createState() => _QueryOrderPlanScreenState();
}

class _QueryOrderPlanScreenState extends State<QueryOrderPlanScreen> {
  // TextEditingController for handling the input date
  final _dateController = TextEditingController();
    // List to store queried order plans
  List<Map<String, dynamic>> orderPlans = [];

  // Method to query order plans by date from the database
  Future<void> queryOrderPlan() async {
    // Check if the date field is empty
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a date.')),
      );
      return;
    }
    // Fetch data from the database based on the entered date
    final data = await DatabaseHelper.instance.getOrderPlanByDate(_dateController.text);
    setState(() {
      orderPlans = data; // Update the list of order plans
    });
    // Show a message if no data is found for the given date
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No order plans found for the selected date.')),
      );
    }
  }
   // Method to delete an order plan by ID
  Future<void> deleteOrderPlan(int id) async {
     // Delete the order plan using the database helper
    await DatabaseHelper.instance.deleteOrderPlan(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order plan deleted successfully.')), // Confirmation message
    );
    queryOrderPlan(); // Refresh the list
  }

  // Method to update an existing order plan by navigating to the update screen
  Future<void> updateOrderPlan(Map<String, dynamic> orderPlan) async {
    final updatedPlan = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateOrderPlanScreen(orderPlan: orderPlan),
      ),
    );
   // If the update is successful, refresh the list and show a success message
    if (updatedPlan != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order plan updated successfully.')),
      );
      queryOrderPlan(); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Order Plan'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Enter Date (YYYY-MM-DD)',
                        prefixIcon: const Icon(Icons.date_range, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: queryOrderPlan,
                      icon: const Icon(Icons.search),
                      label: const Text('Query'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: orderPlans.isNotEmpty
                  ? ListView.builder(
                itemCount: orderPlans.length,
                itemBuilder: (context, index) {
                  final plan = orderPlans[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(plan['date']!.substring(5, 7)), // Month as a number
                      ),
                      title: Text(
                        'Date: ${plan['date']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Items: ${plan['food_items']}\nTotal Cost: \$${plan['total_cost']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => updateOrderPlan(plan),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteOrderPlan(plan['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No order plans found. Please query a date.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 

// Screen for updating an existing order plan
class UpdateOrderPlanScreen extends StatefulWidget {
  final Map<String, dynamic> orderPlan;

  const UpdateOrderPlanScreen({super.key, required this.orderPlan});

  @override
  _UpdateOrderPlanScreenState createState() => _UpdateOrderPlanScreenState();
}

class _UpdateOrderPlanScreenState extends State<UpdateOrderPlanScreen> {
  final _dateController = TextEditingController();  // Controller for date
  final _foodItemsController = TextEditingController(); // Controller for food item
  final _totalCostController = TextEditingController(); // Controller for total cost

  @override
  void initState() {
     // Initialize text fields with current values
    super.initState();
    _dateController.text = widget.orderPlan['date'];
    _foodItemsController.text = widget.orderPlan['food_items'];
    _totalCostController.text = widget.orderPlan['total_cost'].toString();
  }
  
  // Method to update the order plan in the database
  Future<void> updateOrderPlan() async {
    await DatabaseHelper.instance.updateOrderPlan(
      widget.orderPlan['id'], // Updated ID
      _dateController.text, // Updated date
      _foodItemsController.text, // Updated food items
      double.parse(_totalCostController.text), // Updated food cost
    );

    Navigator.pop(context, true); // Return to the query screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Order Plan'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Enter Date (YYYY-MM-DD)',
                    prefixIcon: const Icon(Icons.date_range, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _foodItemsController,
                  decoration: InputDecoration(
                    labelText: 'Enter Food Items',
                    prefixIcon: const Icon(Icons.list_alt, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _totalCostController,
                  decoration: InputDecoration(
                    labelText: 'Enter Total Cost',
                    prefixIcon: const Icon(Icons.attach_money, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: updateOrderPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Update Order Plan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
