PImage img;

void setup() {
  size(1100, 450);
  img = loadImage("image.jpg");
}

PImage inverseImageColors(PImage img) {
  PImage inverse_img = createImage(img.width, img.height, RGB);

  for(int y = 0; y <= img.height; y = y + 1) {
    for (int x = 0; x <= img.width;  x = x + 1) {
      color old_clr = img.get(x, y);
      color new_clr = color(255 - red(old_clr), 255 - green(old_clr), 255 - blue(old_clr));
      inverse_img.set(x, y, new_clr);
    }
  }

  return inverse_img;
}

PImage whiteNoise(PImage img) {
  PImage noised_img = createImage(img.width, img.height, RGB);

  for(int y = 0; y <= img.height; y = y + 1) {
    for (int x = 0; x <= img.width;  x = x + 1) {
      if(int(random(10)) == 2) {
        noised_img.set(x, y, color(255, 255, 255));
      } else {
        noised_img.set(x, y, img.get(x, y));
      }
    }
  }

  return noised_img;
}

PImage harmonicMean(PImage img) {
  PImage filtered_img = createImage(img.width, img.height, RGB);

  for(int y = 0; y <= img.height; y = y + 1) {
    for (int x = 0; x <= img.width;  x = x + 1) {
      PImage tmp = img.get(x, y, 3, 3);
      float sum_red = 0;
      float sum_green = 0;
      float sum_blue = 0;
      
      for(int i = 0; i < 3; i = i + 1) {
        for (int j = 0; j < 3;  j = j + 1) {
          color old_clr = tmp.get(i, j);
          sum_red += 1.0 / red(old_clr);
          sum_green += 1.0 / green(old_clr);
          sum_blue += 1.0 / blue(old_clr);
        }
      }
      
      filtered_img.set(x, y, color(9.0 / sum_red, 9.0 / sum_green, 9.0 / sum_blue));
    }
  }

  return filtered_img;
}

PImage medianFilter(PImage img, int mask_size) {
  PImage filtered_img = createImage(img.width, img.height, RGB);
  int sqrt_size = int(sqrt(mask_size));
  
  for(int y = 0; y <= img.height; y = y + 1) {
    for (int x = 0; x <= img.width;  x = x + 1) {
      PImage tmp = img.get(x, y, sqrt_size, sqrt_size);
      float[] reds = new float[mask_size];
      float[] greens = new float[mask_size];
      float[] blues = new float[mask_size];
      int n = 0;
      
      for(int i = 0; i < sqrt_size; i = i + 1) {
        for (int j = 0; j < sqrt_size;  j = j + 1) {
          color old_clr = tmp.get(i, j);
          reds[n] = red(old_clr);
          greens[n] = green(old_clr);
          blues[n] = blue(old_clr);
          n += 1;
        }
      }
      filtered_img.set(x, y, color(sort(reds)[reds.length/2], sort(greens)[greens.length/2], sort(blues)[blues.length/2]));
    }
  }

  return filtered_img;
}

void histogram(PImage img, int histX, int histY) {
  PImage histogram_img = createImage(img.width, img.height, RGB);
  int[] reds = new int[256];
  int[] greens = new int[256];
  int[] blues = new int[256];
  
  for(int y = 0; y <= img.height; y = y + 1) {
    for (int x = 0; x <= img.width;  x = x + 1) {
      color clr = img.get(x, y);
      
      reds[int(red(clr))]++;
      greens[int(green(clr))]++;
      blues[int(blue(clr))]++;
    }
  }
  
  int redMax = max(reds);
  int greenMax = max(greens);
  int blueMax = max(blues);
  
  for(int i = histX + 1; i < histX + img.width; i++) {
    int which = int(map(i, histX, img.width + histX, 0, 255));
    
    int y = int(map(reds[which], 0, redMax, img.height, 0));
    stroke(255, 0, 0);
    line(i, img.height + histY, i, y + histY);

    y = int(map(greens[which], 0, greenMax, img.height, 0));
    stroke(0, 255, 0);
    line(i, img.height + histY, i, y + histY);
    
    y = int(map(blues[which], 0, blueMax, img.height, 0));
    stroke(0, 0, 255);
    line(i, img.height + histY, i, y + histY);
  }
}

void draw() {
  image(img, 10, 10);
  image(inverseImageColors(img), 220, 10);
  image(harmonicMean(img), 430, 10);
  image(whiteNoise(img), 640, 10);
  image(medianFilter(whiteNoise(img), 16), 860, 10);
  
  histogram(img, 10, 210);
  histogram(inverseImageColors(img), 220, 210);
  histogram(harmonicMean(img), 430, 210);
  histogram(medianFilter(whiteNoise(img), 16), 860, 210);
  noLoop();
}
