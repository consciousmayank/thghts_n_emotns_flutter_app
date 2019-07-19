import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:thghts_n_emotns_flutter_app/models/Comments.dart';
import 'package:thghts_n_emotns_flutter_app/models/Emotion.dart';
import 'package:thghts_n_emotns_flutter_app/models/LogedInUserDetails.dart';
import 'package:thghts_n_emotns_flutter_app/models/PostsData.dart';

class AppScopedModel extends Model {
  bool isLoading = false;

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isUserLoggedIn') != null
        ? prefs.getBool('isUserLoggedIn')
        : false;
  }

  void setUserLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserLoggedIn', value);
    print("Saving userLoggedIn : $value");
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
          setUserLoggedIn(true);
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
    return new LoggedInUserDetails(prefs.getString('loggedInUser_id'),
        prefs.getString('loggedInUser_email'));
  }

  Future<bool> sendPost(
      String userEmail,
      String userId,
      String tag,
      String emotion,
      String emotionColor,
      String textColor,
      String post,
      Map<String, dynamic> comments) async {
    setIsLoading(true);
    try {
      final Map<String, dynamic> postData = {
        'email': userEmail,
        'userId': userId,
        'tag': tag,
        'emotion': emotion,
        'emotionColor': emotionColor,
        'textColor': textColor,
        'post': post,
        'comment': comments
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
      final Map<String, dynamic> userAddedPostsList =
          json.decode(response.body);
      userAddedPostsList.forEach((String key, dynamic userPostsData) {
        userPosts.add(PostData(
            id: key,
            emotion: userPostsData['emotion'],
            post: userPostsData['post'],
            tag: userPostsData['tag'],
            userId: userPostsData['userId'],
            emotionColor: userPostsData['emotionColor'],
            textColor: userPostsData['textColor'],
            commentsMap: userPostsData['comment']));
      });
      notifyListeners();
      return userPosts;
    } catch (error) {
      notifyListeners();
      return userPosts;
    }
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<String> sendComments(
      String postId, String comment, String userId, String userEmail) async {
    setIsLoading(true);
    String returningString = '';
    try {
      final Map<String, dynamic> postData = {
        'email': userEmail,
        'userId': userId,
        'comment': comment
      };

      http.Response response = await http.post(
          'https://thoughts-n-emotions.firebaseio.com/userPosts/$postId/comment.json',
          body: json.encode(postData),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        setIsLoading(false);
        return returningString;
      } else {
        returningString = comment;
      }
      setIsLoading(false);
      return returningString;
    } catch (error) {
      print(error.toString());
      setIsLoading(false);
      return returningString;
    }
  }

  Future<List<Comments>> getComments(
    String postId,
  ) async {
    List<Comments> completeCommentsList = [];

    setIsLoading(true);
    try {
      http.Response response = await http.get(
          'https://thoughts-n-emotions.firebaseio.com/userPosts/$postId/comment.json',
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        setIsLoading(false);
        return completeCommentsList;
      }

      final Map<String, dynamic> commentsList = json.decode(response.body);
      commentsList.forEach((String key, dynamic comments) {
        completeCommentsList.add(Comments(
            key, comments['comment'], comments['userId'], comments['email']));
      });

      setIsLoading(false);
      return completeCommentsList;
    } catch (error) {
      print(error.toString());
      setIsLoading(false);
      return completeCommentsList;
    }
  }
}
