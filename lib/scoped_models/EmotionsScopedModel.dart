import 'package:scoped_model/scoped_model.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thghts_n_emotns_flutter_app/models/Emotion.dart';



class Emotion extends Model{

  bool isLoading = false;
  final List<Emotions> _emotions = [];

  List<Emotions> get allEmotions {
    return List.from(_emotions);
  }

  Future<List<Emotions>> getEmotions() async {
    setIsLoading(true);
    try {
      http.Response response = await http
          .get('https://thoughts-n-emotions.firebaseio.com/emotions.json');
      if (response.statusCode != 200 && response.statusCode != 201) {
        setIsLoading(false);
        return allEmotions;
      }
      final Map<String, dynamic> emotionsList = json.decode(response.body);
      emotionsList.forEach((String key, dynamic emotionName) {
        _emotions.add(Emotions(emotionName['color'], emotionName['name_english'],
            emotionName['name_hindi'], emotionName['text_color']));
      });
      setIsLoading(false);
      return allEmotions;
    } catch (error) {
      setIsLoading(false);
      return allEmotions;
    }
  }

  void setIsLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

}