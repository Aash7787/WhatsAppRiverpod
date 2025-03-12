enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageEnum(this.type);
  final String type;

  // Helper method to convert a string to MessageEnum
  static MessageEnum fromString(String type) {
    return MessageEnum.values.firstWhere(
      (e) => e.type == type,
      orElse: () => MessageEnum.text, // Default to text if not found
    );
  }
}