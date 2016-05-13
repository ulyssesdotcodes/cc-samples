void setup() {
  size(400,  400);
 
}

void draw() {
  background(50);

  ellipse(cos(millis() / 1000) * 100 + 200, sin(millis() / 1000) * 100 + 200, 80, 80);
}