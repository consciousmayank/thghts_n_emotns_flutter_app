class PostData {
  final String emotion;
  final String post;
  final String tag;
  final String userId;
  final String emotionColor;
  final String textColor;
  final String id;
  final Map<String, dynamic> commentsMap;

  PostData(
      {this.id,
      this.emotion,
      this.post,
      this.tag,
      this.userId,
      this.emotionColor,
      this.textColor,
      this.commentsMap});
}
