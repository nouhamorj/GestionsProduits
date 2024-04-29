import 'package:flutter/material.dart';
import 'package:gestion/homepage/HomePage.dart';
import 'package:gestion/sqlhelper/SqlHelper.dart';
import 'package:get/get.dart';

class AjouterProduit extends StatefulWidget {
  const AjouterProduit({Key? key}) : super(key: key);

  @override
  State<AjouterProduit> createState() => _AjouterProduitState();
}

class _Produit {
  String name = '';
  double price = 0.0;
}

class _AjouterProduitState extends State<AjouterProduit> {
  final _formKey = GlobalKey<FormState>();
  final _produit = _Produit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text('Ajouter Produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Set the form key
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                  contentPadding: const EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey, // Border color
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) => _produit.name = value!,
              ),

              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Prix',
                  contentPadding: const EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  return null;
                },
                onSaved: (value) => _produit.price = double.parse(value!),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save(); // Save form data

                    // Create a Product object from _produit data
                    final newProduct = Product(
                      name: _produit.name,
                      price: _produit.price,
                    );
                    await SqlHelper.insertProduct(newProduct);

                    // Show a success message (optional)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Produit ajouté avec succès!'),),
                    );

                    // Clear the form (optional)
                    _formKey.currentState!.reset();
                    _produit.name = '';
                    _produit.price = 0.0;

                    // Navigate to HomeScreen and potentially refresh data
                    Get.to(
                          () => HomePage(),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 500),
                    );
                  }
                },
                child: const Text('Ajouter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
