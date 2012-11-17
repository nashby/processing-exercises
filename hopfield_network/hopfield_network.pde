class Hopfield {
  int eval_iterations;
  int active_value;
  int inactive_value;
  int threshold;
  
  int[] nodes;
  int[][] weights;
  int[][] data_set;
  
  Hopfield (int[][] data) {
    //defaults
    data_set = data;
    eval_iterations = 10000;
    active_value = 1;
    inactive_value = -1;
    threshold = 0;
    
    //initializers
    initializeNodes();
    initializeWeights();
  } 
  
  int eval(int[] input) {
    setInput(input);
    
    int found_index = -1;
    boolean matches;
    
    for(int i = 0; i < eval_iterations; i++) {
      matches = true;
      
      for(int j = 0; j < data_set.length; j++) {
        matches = true;
        propagate();
        
        for(int n = 0; n < data_set[j].length; n++) {
          if(data_set[j][n] != nodes[n]) {
            matches = false;
            break;
          }
        }
        
        if(matches) {
          found_index = j;
          break;
        }
      }
      
     if(matches) {
        break;
      }
    }
    return found_index;
  }
  
  void setInput(int[] input) {
    for(int i = 0; i < nodes.length; i++) {
      nodes[i] = input[i];
    }
  }
  
  void propagate() {
    int sum = 0;
    int i = int(random(nodes.length));

    for(int j = 0; j < nodes.length; j++) {
      sum = sum + getWeight(i, j) * nodes[j];
    }
    
    if(sum > threshold) {
      nodes[i] = active_value;  
    }
    else {
      nodes[i] = inactive_value;
    }
  }
  
  void initializeNodes() {
    nodes = new int[data_set[0].length];

    for(int i = 0; i < nodes.length; i++) {
      nodes[i] = inactive_value;   
    }
  }
  
  void initializeWeights() {
    weights = new int[nodes.length - 1][];
    
    for(int i = 0; i < weights.length; i++) {
      weights[i] = new int[i+1];
    }
    
    int sum = 0;
    for(int i = 0; i < nodes.length; i++) {
      for(int j = 0; j < i; j++) {
        sum = 0;
        
        for(int n = 0; n < data_set.length; n++) {
          sum = sum + data_set[n][i] * data_set[n][j];
        }

        weights[i - 1][j] = sum;
      }
    }
  }
  
  int getWeight(int i, int j) {
    if(i == j) {
      return 0;
    }
    
    if(j > i) {
      int tmp = i;
      i = j;
      j = tmp;
    }
    
    return weights[i - 1][j];
  }
}

void draw() { 
  int[][] data_set = new int[3][];
  
  data_set[0] = imageToDatasource("sample_sh.png");
  data_set[1] = imageToDatasource("sample_e.png");
  data_set[2] = imageToDatasource("sample_f.png");

  Hopfield hopfield = new Hopfield(data_set);
  println(hopfield.eval(imageToDatasource("noisy_sample_e.png")));
  
  noLoop();
}

int[] imageToDatasource(String imageName) {
  PImage img = loadImage(imageName);
  img.loadPixels();
  int[] data = new int[img.pixels.length];
  
  for(int i = 0; i < img.pixels.length; i++) {
    if(color(img.pixels[i]) == -1) {
      data[i] = -1;
    } 
    else {
      data[i] = 1;
    }
  }
  
  return data;
}
