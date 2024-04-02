class AppState {
  final int counter;
  final String username;

  AppState({required this.counter, required this.username});

  factory AppState.initialState() {
    return AppState(counter: 0, username: "");
  }
}
