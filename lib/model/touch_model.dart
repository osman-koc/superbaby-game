class TouchModel {
  bool isPressed;
  double positionX;

  TouchModel(this.isPressed, this.positionX);

  void setPress(bool isPressed) => this.isPressed = isPressed;
}
