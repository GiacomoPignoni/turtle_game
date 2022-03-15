class Command {

}

class Forward extends Command {
  int distance;

  Forward(this.distance);
}

class Rotate extends Command {
  double rotation;

  Rotate(this.rotation);
}
