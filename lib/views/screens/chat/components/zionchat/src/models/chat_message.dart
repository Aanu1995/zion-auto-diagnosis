part of zion_chat;

/// A message data structure used by dash chat to handle messages
/// and also to handle quick replies
class ChatMessage {
  /// Id of the message if no id is supplied a new id is assigned
  /// using a [UUID v4] this behaviour could be overriden by provind
  /// and [optional] paramter called [messageIdGenerator].
  /// [messageIdGenerator] take a function with this
  /// signature [String Function()]
  String id;

  /// Actual text message.
  String text;

  /// It's a [non-optional] pararmter which specifies the time the
  /// message was delivered takes a [DateTime] object.
  DateTime createdAt;

  /// Takes a [ChatUser] object which is used to distinguish between
  /// users and also provide avaatar URLs and name.
  ChatUser user;

  /// A [non-optional] parameter which is used to display images
  /// takes a [Sring] as a url
  String image;

  /// A [non-optional] parameter which is used to display vedio
  /// takes a [Sring] as a url
  String video;

  File imageFile;
  // 0 sent,
  // 1 delivered,
  // 2 seen,
  // -1  not sent
  int messageStatus;
  String documentId;

  ChatMessage({
    String id,
    @required this.text,
    @required this.user,
    this.image,
    this.video,
    String Function() messageIdGenerator,
    this.imageFile,
    DateTime createdAt,
    this.messageStatus,
    this.documentId,
  }) {
    this.createdAt = createdAt != null ? createdAt : DateTime.now();
    this.id = id != null
        ? id
        : messageIdGenerator != null
            ? messageIdGenerator()
            : Uuid().v4().toString();
  }

  ChatMessage.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    text = json['text'];
    image = json['image'];
    video = json['video'] ?? json['vedio'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']);
    user = ChatUser.fromJson(json['user']);
    messageStatus = json['messageStatus'] ?? 0;
    documentId = json['createdAt'].toString();
  }

  Map<String, dynamic> toJson(int createdAt) {
    final Map<String, dynamic> data = Map<String, dynamic>();

    try {
      data['id'] = this.id;
      data['text'] = this.text;
      data['image'] = this.image;
      data['video'] = this.video;
      data['createdAt'] = createdAt ?? this.createdAt.millisecondsSinceEpoch;
      data['messageStatus'] = this.messageStatus ?? 0;
      data['user'] = user.toJson();
    } catch (e, stack) {
      print('ERROR caught when trying to convert ChatMessage to JSON:');
      print(e);
      print(stack);
    }
    return data;
  }
}
