class Command {
  const Command();
}

class Forward extends Command {
  final int distance;

  const Forward(this.distance);

  @override
  String toString() {
    return "Forward";
  }
}

class Rotate extends Command {
  final double rotation;

  const Rotate(this.rotation);

  @override
  String toString() {
    return "Rotate";
  }
}
