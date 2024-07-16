class NavigationStack {
  final List<String> history;
  NavigationStack({required this.history});

  NavigationStack push(String route) {
    /// Add itemt o the route stack
    return NavigationStack(history: [...history, route]);
  }

  NavigationStack pop() {
    /// Remove item from rout stack
    return NavigationStack(history: history.sublist(0, history.length - 1));
  }

  NavigationStack clear() {
    return NavigationStack(history: []);
  }

  bool get canPop => history.length > 1;

  String get currentRoute => history.last;
}
