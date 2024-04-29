import 'package:gestion/homepage/HomePage.dart';
import 'package:gestion/sqlhelper/SqlHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UpdateProduct extends StatefulWidget {
  const UpdateProduct({Key? key, required this.p}) : super(key: key);
  final Product p;
  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Préremplir les contrôleurs avec les données existantes de 'widget.produit'
    _nameController.text = widget.p.name;
    _priceController.text = widget.p.price.toString();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 2,
        title: const Text(
          'Update Produit',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Form fields for name, age, and CNE (if applicable)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Libellé'),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer un nom' : null, // Basic validation
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer un prix' : null, // Basic validation
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedp = Product(
                      id: widget.p.id, // Maintain existing ID
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                      // Handle optional CNE
                    );
                    await SqlHelper.updateProduct(updatedp);
                    Get.to(HomePage(),
                        transition: Transition.fadeIn,
                        duration: Duration(milliseconds: 500));
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}