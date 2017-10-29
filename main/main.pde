Labeler l;

void settings () {
  l = new Labeler("target.png");
  size(l.target_width, l.target_height);
}

void setup() {
  l.draw();
  l.save();
  noLoop();
}