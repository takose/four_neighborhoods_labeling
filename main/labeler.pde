class Labeler {
  int MAX= 1000;

  IntList lookup_table;
  PImage target;
  int target_width;
  int target_height;
  int [][] pixels_table;

  Labeler (String image_name) {
    target = loadImage(image_name);
    target_width = target.width;
    target_height = target.height;
    target.loadPixels();
    lookup_table = new IntList();
    pixels_table = new int[target_width+2][target_height+2];
    for (int y = 0; y < target_height+2; y++) {
      for (int x = 0; x < target_width+2; x++) {
        pixels_table[x][y] = MAX;
      }
    }
    set_luts();
  }

  void set_luts () {
    for (int y = 0; y < target.height; y++) {
      for (int x = 0; x < target.width; x++) {
        if (target.pixels[target_width * y + x] == #ffffff) {
          pixels_table[x+1][y+1] = search_lut(x+1, y+1);
        }
      }
    }
  }

  int search_lut (int x, int y) {
    int top_i = pixels_table[x][y-1];
    int left_i = pixels_table[x-1][y];
    int lut = MAX;
    if (top_i == MAX && left_i == MAX) {
      lut = lookup_table.size();
      lookup_table.append(lut);
    } else if (top_i != MAX && left_i != MAX) {
      int small_lut = lookup_table.get(top_i) < lookup_table.get(left_i) ? lookup_table.get(top_i) : lookup_table.get(left_i);
      int big_i = lookup_table.get(top_i) > lookup_table.get(left_i) ? top_i : left_i;
      update_lookup_table(lookup_table.get(big_i), small_lut);
      lookup_table.set(big_i, small_lut);
      lut = small_lut;
    } else {
      lut = top_i < left_i ? top_i : left_i;
    }
    return lut;
  }

  void update_lookup_table (int lut, int new_lut) {
    for (int i = 0; i < lookup_table.size(); i++) {
      if (lookup_table.get(i) == lut) {
        lookup_table.set(i, new_lut);
      }
    }
  }

  void draw () {
    color [] colors = new color[lookup_table.max()+1];
    for (int i = 0; i < colors.length; i++) {
      colors[i] = color(int(random(255)), int(random(255)), int(random(255)));
    }
    for (int y = 0; y < target.height; y++) {
      for (int x = 0; x < target.width; x++) {
        if (pixels_table[x+1][y+1] != MAX) {
          target.pixels[target_width*y+x] = colors[lookup_table.get(pixels_table[x+1][y+1])];
        }
      }
    }
    target.updatePixels();
    image(target, 0, 0);
  }

  void save () {
    String date_time = month()+","+day() + "_"+ hour() + ";" + minute();
    target.save(date_time + ".png");
  }
}