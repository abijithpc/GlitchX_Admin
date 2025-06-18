abstract class UserEvent {}

class FetchUsers extends UserEvent {}

class BlockUser extends UserEvent {
  final String uid;
  BlockUser(this.uid);
}

class UnblockUser extends UserEvent {
  final String uid;
  UnblockUser(this.uid);
}
