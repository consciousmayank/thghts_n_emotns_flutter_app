import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:thghts_n_emotns_flutter_app/models/Emotion.dart';
import 'package:thghts_n_emotns_flutter_app/models/LogedInUserDetails.dart';
import 'package:thghts_n_emotns_flutter_app/models/PostsData.dart';

class AppScopedModel extends Model {

  bool isLoading = false;

  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  void isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userSubject.add(prefs.getBool('isUserLoggedIn') != null
        ? prefs.getBool('isUserLoggedIn')
        : false);
    notifyListeners();
  }

  void setUserLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserLoggedIn', value);
    notifyListeners();
  }

  Future<bool> tryLogin(String email, String password) async {
    setIsLoading(true);
    bool result = false;
    try {
      final http.Response response = await http
          .get('https://thoughts-n-emotions.firebaseio.com/users.json');

      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        setIsLoading(false);
        return false;
      }

      final Map<String, dynamic> loggedInUserList = json.decode(response.body);
      print(loggedInUserList.toString());
      loggedInUserList.forEach((String key, dynamic userListData) {
        if (userListData['password'] == password &&
            userListData['userName'] == email) {
          LoggedInUserDetails user =
              LoggedInUserDetails(key, userListData['userName']);
          saveLoggedInUser(user);
          setUserLoggedIn(false);
          result = true;
        }
      });
      setIsLoading(false);
      return result;
    } catch (error) {
      setIsLoading(false);
      return false;
    }
  }

  void saveLoggedInUser(LoggedInUserDetails user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedInUser_email', user.userEmail);
    prefs.setString('loggedInUser_id', user.userId);
    notifyListeners();
  }

  Future<LoggedInUserDetails> getLoggedInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return new LoggedInUserDetails(
        prefs.getString('loggedInUser_id'),
        prefs.getString('loggedInUser_email')
    );
  }

  Future<List<String>> getTags() async {
    setIsLoading(true);
    final List<String> tags = [];

    try {
      http.Response response = await http
          .get('https://thoughts-n-emotions.firebaseio.com/tags.json');
      if (response.statusCode != 200 && response.statusCode != 201) {
        setIsLoading(false);
        return tags;
      }
      final Map<String, dynamic> tagsList = json.decode(response.body);
      tagsList.forEach((String key, dynamic tagName) {
        tags.add(tagName['tag_name']);
      });
      setIsLoading(false);
      return tags;
    } catch (error) {
      setIsLoading(false);
      return tags;
    }
  }

  Future<List<Emotions>> getEmotions() async {
    setIsLoading(true);
    final List<Emotions> emotions = [];

    try {
      http.Response response = await http
          .get('https://thoughts-n-emotions.firebaseio.com/emotions.json');
      if (response.statusCode != 200 && response.statusCode != 201) {
        setIsLoading(false);
        return emotions;
      }
      final Map<String, dynamic> emotionsList = json.decode(response.body);
      emotionsList.forEach((String key, dynamic emotionName) {
        emotions.add(Emotions(emotionName['color'], emotionName['name_english'],
            emotionName['name_hindi'], emotionName['text_color']));
      });
      setIsLoading(false);
      return emotions;
    } catch (error) {
      setIsLoading(false);
      return emotions;
    }
  }

  Future<bool> sendPost(String userEmail, String userId, String tag, String emotion,String emotionColor, String post) async {
    setIsLoading(true);
    try {

      final Map<String, dynamic> postData = {
        'email': userEmail,
        'userId': userId,
        'tag': tag,
        'emotion': emotion,
        'emotionColor': emotionColor,
        'post': post
      };

      http.Response response = await http.post(
          'https://thoughts-n-emotions.firebaseio.com/userPosts.json',
          body: json.encode(postData),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        setIsLoading(false);
        return false;
      }
      setIsLoading(false);
      return true;
    } catch (error) {
      print(error.toString());
      setIsLoading(false);
      return false;
    }
  }

  Future<List<PostData>> getPosts() async {
    final List<PostData> userPosts = [];

    try {
      http.Response response = await http
          .get('https://thoughts-n-emotions.firebaseio.com/userPosts.json');
      if (response.statusCode != 200 && response.statusCode != 201) {
        notifyListeners();
        return userPosts;
      }
      final Map<String, dynamic> userAddedPostsList = json.decode(response.body);
      userAddedPostsList.forEach((String key, dynamic userPostsData) {
        userPosts.add(
          PostData(
            emotion: userPostsData['emotion'],
            post: userPostsData['post'],
            tag: userPostsData['tag'],
            userId: userPostsData['userId'],
          )
        );
      });
      notifyListeners();
      return userPosts;
    } catch (error) {
      notifyListeners();
      return userPosts;
    }
  }

  void setIsLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

}
