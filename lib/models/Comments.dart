class Comments{
  final String _commentId;
  final String _comment;
  final String _userId;
  final String _userEmail;

  Comments(this._commentId, this._comment, this._userId, this._userEmail);

  String get userEmail => _userEmail;

  String get userId => _userId;

  String get comment => _comment;

  String get commentId => _commentId;


}