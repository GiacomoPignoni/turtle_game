class Command {

}

class Forward extends Command {
  int value;

  Forward(this.value);
}

class Rotate extends Command {
  double rotationValue;

  Rotate(this.rotationValue);
}
