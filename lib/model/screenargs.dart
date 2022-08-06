enum Reason { editPart, newPart }

class ScreenArguments {
  final String title;
  final Reason purpose;

  ScreenArguments(this.title, this.purpose);
}
