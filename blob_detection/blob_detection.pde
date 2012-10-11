import blobDetection.*;

PImage img;

void setup() {
  img = loadImage("P0001460.jpg");
  size(img.width, img.height);
}

int perimeter(Blob blob) {
  float perimeter = 0;
  EdgeVertex eA, eB;
  
  for (int m = 0; m < blob.getEdgeNb(); m++)
  {
    eA = blob.getEdgeVertexA(m);
    eB = blob.getEdgeVertexB(m);

    if (eA != null && eB != null)
      perimeter += sqrt(pow((eB.x * width - eA.x * width), 2) + pow((eB.y * height - eA.y * height), 2));
  }
  
  return round(perimeter);
}

void printPerimeter(Blob blob) {
  fill(255, 0, 0);      
  text(perimeter(blob), (blob.xMin + blob.xMax) * width / 2, (blob.yMin + blob.yMax) * height / 2); 
}

int area(Blob blob) {
  float area = 0;
  EdgeVertex eA, eB;
  
  for (int m = 0; m < blob.getEdgeNb(); m++)
  {
    eA = blob.getEdgeVertexA(m);
    eB = blob.getEdgeVertexB(m);

    if (eA != null && eB != null)
      area += (eB.y * height + eA.y * height) / 2 * (eB.x * width - eA.x * width) / 2;
  }
  
  return round(area);
}

void printArea(Blob blob) {
  fill(255, 0, 0);  
  text(area(blob), (blob.xMin + blob.xMax) * width / 2 - 10, (blob.yMin + blob.yMax) * height / 2 + 20); 
}

int compact(Blob blob) {
  return round(pow(perimeter(blob), 2) / area(blob));
}

void printCompact(Blob blob) {
  fill(255, 0, 0); 
  text(compact(blob), (blob.xMin + blob.xMax) * width / 2 - 10, (blob.yMin + blob.yMax) * height / 2 + 40); 
}

void draw() {
  image(img, 0, 0);
  
  BlobDetection detector = new BlobDetection(img.width, img.height);
  
  loadPixels();
  
  detector.setThreshold(0.9f);
  detector.computeBlobs(pixels);
  Blob blob;
  
  noFill();

  EdgeVertex eA, eB;
  
  color[] colors = new color[5];
  colors[0] = #A32638;
  colors[1] = #FFBF00;
  colors[2] = #9966CC;
  colors[3] = #00FFFF;
  colors[4] = #2E5894;
  
  for (int n = 0 ; n < detector.getBlobNb(); n++)
  {
    blob = detector.getBlob(n);
    if(perimeter(blob) > 100) 
    { 
      if (blob != null)
      {
          strokeWeight(2);
          println(perimeter(blob));
          stroke(colors[perimeter(blob) / 95]);
          
          for (int m = 0; m < blob.getEdgeNb(); m++)
          {
            eA = blob.getEdgeVertexA(m);
            eB = blob.getEdgeVertexB(m);
            if (eA != null && eB != null)
              line(eA.x * width, eA.y * height, eB.x * width, eB.y * height);
          }
      }
    }
  }
  noLoop();
}
