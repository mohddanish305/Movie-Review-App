import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const key = "favorites";

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(key) ?? [];

    if (favs.contains(id)) {
      favs.remove(id);
    } else {
      favs.add(id);
    }

    await prefs.setStringList(key, favs);
  }

  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(key) ?? [];
    return favs.contains(id);
  }
}