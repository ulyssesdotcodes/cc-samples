void setup ()
{
  size (700, 700);
  smooth();

  noLoop();
}

void drawLSystem(String s) {
  background(#333333);
  noFill();
  strokeWeight(1);
  stroke(255, 0, 0);

  float lineLength = 10;

  Point p = new Point(700 * 0.5, 700 * 0.9);

  float theta = -HALF_PI;
  float pi = PI;

  PointStack ps = new PointStack();

  for(int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);

    switch(c) {
      case "F":
        Point p2 = new Point(p.x + cos(theta) * 10, p.y + sin(theta) * 10);

        line(p.x, p.y, p2.x, p2.y);
        p = p2;
        break;
      case "+":
        theta += pi * 0.3
        break;
      case "-":
        theta -= pi * 0.3
        break;
      case "[":
        ps.push(p);
        break;
      case "]":
        p = ps.pop();
        break;
    }
  }
}

class Point {
  float x, y;

  Point(float xin, float yin) {
    x = xin;
    y = yin;
  }
}

class PointStack {
  ArrayList points;
  PointStack(){
    points = new ArrayList();
  }

  void push(Point p) {
    points.add(p);
  }

  Point pop() {
    Point p = points.get(points.size() - 1);
    points.remove(points.size() - 1);
    return p;
  }
}