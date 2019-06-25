import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;



class Tags extends Model{

  bool isLoading = false;
  final List<String> _tags = [];

  List<String> get allTags {
    return List.from(_tags);
  }

//  List<ProduStringct> get displayedProducts {
//    if (_showFavorites) {
//      return _products.where((Product product) => product.isFavorite).toList();
//    }
//    return List.from(_products);
//  }

  Future<List<String>> getTags() async {
    setIsLoading(true);

    try {
      http.Response response = await http
          .get('https://thoughts-n-emotions.firebaseio.com/tags.json');
      if (response.statusCode != 200 && response.statusCode != 201) {
        setIsLoading(false);
        return allTags;
      }
      final Map<String, dynamic> tagsList = json.decode(response.body);
      tagsList.forEach((String key, dynamic tagName) {
        _tags.add(tagName['tag_name']);
      });
      setIsLoading(false);
      return allTags;
    } catch (error) {
      setIsLoading(false);
      return allTags;
    }
  }

  void setIsLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

}