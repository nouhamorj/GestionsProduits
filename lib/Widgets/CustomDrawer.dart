import 'package:gestion/ajouterProduit/AjouterProduit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            child: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/img.png'),
              ),
            ),
          ),

          ListTile(
            title: Text(
              'Liste des produits',
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(Icons.list, color: Colors.redAccent,),
            onTap: () {
              // Gérer le clic sur l'élément
            },
          ),
          Divider(color: Colors.grey, thickness: 0.5),

          ListTile(
            title: Text(
              'Ajouter un nouveau produit',
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(Icons.add,color:Colors.redAccent),
            onTap: () {
              Get.to(
                    () => AjouterProduit(),
                transition: Transition.fadeIn,
                duration: Duration(milliseconds: 500),
              );
            },
          ),
        ],
      ),
    );
  }
}
