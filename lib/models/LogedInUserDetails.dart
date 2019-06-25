

class LoggedInUserDetails{
  final String _userId;
  final String _userEmail;


  LoggedInUserDetails(this._userId, this._userEmail);

  String get userId => _userId;

  String get userEmail => _userEmail;

  LoggedInUserDetails.fromJson(Map<String, dynamic> json)
      : _userEmail = json['userEmail'],
        _userId = json['userId'];

  Map<String, dynamic> toJson() =>
      {
        'userEmail': _userEmail,
        'userId': _userId,
      };

}