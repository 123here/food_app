import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddOrderPlanScreen extends StatefulWidget {
  const AddOrderPlanScreen({super.key}); // Constructor for the AddOrderPlanScreen class

  @override
  _AddOrderPlanScreenState createState() => _AddOrderPlanScreenState(); // Create state for the screen
}

class _AddOrderPlanScreenState extends State<AddOrderPlanScreen> {
   // List of food items to be displayed
  List<Map<String, dynamic>> foodItems = [];
   // Map to store selected food items and their quantities
  Map<String, int> selectedItems = {};
  // Variable to store the total cost of selected items
  double totalCost = 0.0;
  // Controllers for managing the date and target cost input fields
  final _dateController = TextEditingController();
  final _targetCostController = TextEditingController();

  @override
  void initState() {
    super.initState();
     // Fetch food items from the database when the screen initializes
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    // Fetch food items from the database
    final data = await DatabaseHelper.instance.getFoodItems();
    setState(() {
      // Store the fetched food items in the state
      foodItems = data;
    });
  }

   // Update the quantity of a selected food item
  void updateQuantity(Map<String, dynamic> item, bool increment) {
    setState(() {
      int currentQuantity = selectedItems[item['name']] ?? 0; // Get current quantity of the item
      double itemCost = item['cost']; // Cost of the selected food item

      if (increment) {
        // If increment is true, try to add the item to the order
        if (totalCost + itemCost <= double.parse(_targetCostController.text)) {
          selectedItems[item['name']] = currentQuantity + 1;
          totalCost += itemCost;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Target cost exceeded!')),
          );
        }
      } else {
         // If decrement is true, decrease the quantity if it's greater than 0
        if (currentQuantity > 0) {
          selectedItems[item['name']] = currentQuantity - 1;
          totalCost -= itemCost;
        }
      }
    });
  }
   // Save the order plan to the database
  Future<void> saveOrderPlan() async {
    if (_dateController.text.isEmpty || selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and food items.')),
      );
      return;
    }
    // Prepare a string of food items with their quantities
    String foodNames = selectedItems.entries
        .map((e) => '${e.key} x${e.value}')
        .join(', ');
    //Save order plan in database
    await DatabaseHelper.instance.addOrderPlan(
      _dateController.text,
      foodNames,
      totalCost,
    );
     /// Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order plan saved successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  // padding and allignment for the text fields
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Order Plan'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Enter Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _targetCostController,
                decoration: InputDecoration(
                  labelText: 'Enter Target Cost',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Food Items',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Container(
                constraints: const BoxConstraints(maxHeight: 350),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final item = foodItems[index];
                    int currentQuantity = selectedItems[item['name']] ?? 0;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Cost: \$${item['cost']}'),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () => updateQuantity(item, false),
                                ),
                                Text(
                                  currentQuantity.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: () => updateQuantity(item, true),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Total Cost: \$${totalCost.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: saveOrderPlan,
                  child: const Text(
                    'Save Order Plan',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
