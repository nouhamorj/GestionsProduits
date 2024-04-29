import 'package:flutter/material.dart';
import 'package:gestion/Widgets/CustomDrawer.dart';
import 'package:gestion/sqlhelper/SqlHelper.dart';
import 'package:gestion/updateProduit/UpdateProduct.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _getListeProducts();
  }

  Future<void> _getListeProducts() async {
    final newProducts = await SqlHelper.getAllProducts();
    setState(() {
      _products = newProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: const Text(
          'Liste des produits',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent),
        ),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Libellé')),
            DataColumn(label: Text('Prix')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _products.map((p) => _buildDataRow(p)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(Product p) {
    return DataRow(
      cells: [
        DataCell(Text(p.id.toString())),
        DataCell(Text(p.name)),
        DataCell(Text('${p.price.toString()}€')),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () {
                  Get.to(UpdateProduct(p: p),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 500));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirmation = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Supprimer le produit'),
                      content: const Text('Êtes-vous sûr de vouloir supprimer ce produit ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false), // Cancel
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true), // Confirm
                          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirmation == true && p.id != null) {
                    await SqlHelper.deleteProduct(p.id!); // Utilisez l'opérateur '!' pour déballer l'ID non nul
                    _getListeProducts();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}