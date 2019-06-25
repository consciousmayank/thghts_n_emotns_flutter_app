class Emotions{
  final String _colorHex;
  final String _englishName;
  final String _hindiName;
  final String _textColor;

  Emotions(this._colorHex, this._englishName, this._hindiName, this._textColor);

  String get hindiName => _hindiName;

  String get englishName => _englishName;

  String get colorHex => _colorHex;

  String get textColor => _textColor;


}