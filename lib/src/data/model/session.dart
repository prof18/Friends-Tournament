class Session {
  String id;
  String name;
  // 0 inactive, 1 active
  int isActive;

  Session(this.id, this.name, this.isActive);
}