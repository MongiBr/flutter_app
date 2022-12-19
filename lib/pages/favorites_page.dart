import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../controllers/firestore_controller.dart';
import '../models/dish_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<DishModel>?> favorites;

  getFavorites() async {
    setState(() {
      favorites = Firestore.getFavorites();
    });
  }

  removeFavorite(String id) {
    Firestore.removeFavorite(id);
    getFavorites();
  }

  @override
  void initState() {
    getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dishes"),
        actions: [
          IconButton(
              onPressed: () {
                Auth().signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<List<DishModel>?>(
          future: favorites,
          builder: (context, dishes) {
            return dishes.hasData
                ? ListView.builder(
                    itemCount: dishes.data!.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        title: Text(dishes.data![index].name),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.heart_broken,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              removeFavorite(dishes.data![index].id!);

                              getFavorites();
                            }),
                      );
                    }),
                  )
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
