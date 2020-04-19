class OptionItem {
  String key;
  dynamic value;

  OptionItem.kv(this.key, this.value);

  OptionItem.vk(this.value, this.key);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OptionItem &&
              runtimeType == other.runtimeType &&
              value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return this.key;
  }
}
