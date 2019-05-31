//Declarations and Imports
import controlP5.*;

ControlP5 cp5;
PImage redImg, greenImg, blueImg;
PImage cyanImg, yellowImg, magentaImg;
PImage compositeImg;
int redIntensity = 255;
int greenIntensity = 255;
int blueIntensity = 255;
float brightnessMultiplier = 1.0;

void setup() {
  size(1000, 750);
  
  // Images
  redImg = loadImage("red.JPG");
  greenImg = loadImage("green.JPG");
  blueImg = loadImage("blue.JPG");

  // Controls
  cp5 = new ControlP5(this);
  cp5.addSlider("redIntensity")
    .setPosition(25,575)
    .setRange(0,255)
    .setColorForeground(0xff880000) // dark red
    .setColorBackground(0xff222222) // dark off-white
    .setWidth(200)
    .setHeight(20)
    ;
  cp5.addSlider("greenIntensity")
    .setPosition(25,600)
    .setRange(0,255)
    .setColorForeground(0xff008800) // green
    .setColorBackground(0xff222222) // dark off-white
    .setWidth(200)
    .setHeight(20)
    ;
  cp5.addSlider("blueIntensity")
    .setPosition(25,625)
    .setRange(0,255)
    .setColorForeground(0xff000088) // blue
    .setColorBackground(0xff222222) // dark off-white
    .setWidth(200)
    .setHeight(20)
    ;
cp5.addSlider("brightnessMultiplier")
    .setPosition(25, 650)
    .setRange(0, 5)
    .setColorForeground(0xff888888) // off-white
    .setColorBackground(0xff222222) // dark off-white
    .setWidth(200)
    .setHeight(20)
    ;
  cp5.addButton("reset")
    .setColorForeground(0xff888888) // off-white
    .setColorBackground(0xff222222) // dark off-white
    .setPosition(850, 575)
    .setSize(125, 75)
    ;
  cp5.addButton("save_image")
    .setColorForeground(0xff888888) // off-white
    .setColorBackground(0xff222222) // dark off-white
    .setPosition(700, 575)
    .setSize(125, 75)
    ;
}

void draw() {
  
  background(0);
  /* Duplicating images so originals with proper dimensions exist
   * priot to resizing */
  compositeImg = combine(redImg, greenImg, blueImg);
  compositeImg = toneMap(compositeImg);
  compositeImg.resize(725, 0);
  redImg.resize(725, 0);
  greenImg.resize(725, 0);
  blueImg.resize(725, 0);
  
  /* Displaying images with a 25px margin*/
  image(compositeImg, 250, 25);
  image(redImg, 25, 25, 200, 133);
  image(greenImg, 25, 200, 200, 133);
  image(blueImg, 25, 375, 200, 133);
}

PImage combine(PImage r, PImage g, PImage b) {
  PImage temp = new PImage();
  loadPixels();
  temp = createImage(r.width, r.height, RGB);
  for (int i = 0; i < r.pixels.length; i++) {
    float rVal = red(r.pixels[i]) * redIntensity / 255;
    float gVal = green(g.pixels[i]) * greenIntensity / 255;
    float bVal = blue(b.pixels[i]) * blueIntensity / 255;
    temp.pixels[i] = color(rVal, gVal, bVal);
  }
  updatePixels();
  return temp;
}

public PImage toneMap(PImage orig) {
  float rMin = 255;
  float rMax = 0;
  float gMin = 255;
  float gMax = 0;
  float bMin = 255;
  float bMax = 0;
  PImage temp = new PImage();
  temp = createImage(orig.width, orig.height, RGB);
  loadPixels();
  for (int pixel = 0; pixel < orig.pixels.length; pixel++) {
    rMin = min(red(orig.pixels[pixel]), rMin);
    rMax = max(red(orig.pixels[pixel]), rMax);
    gMin = min(green(orig.pixels[pixel]), gMin);
    gMax = max(green(orig.pixels[pixel]), gMax);
    bMin = min(blue(orig.pixels[pixel]), bMin);
    bMax = max(blue(orig.pixels[pixel]), bMax);
  }
  float rDiff = 1.0*rMax - rMin;
  float gDiff = 1.0*gMax - gMin;
  float bDiff = 1.0*bMax - bMin;
  for (int pixel = 0; pixel < orig.pixels.length; pixel++) {
    float rVal = brightnessMultiplier*(redIntensity/rDiff)*(red(orig.pixels[pixel])-rMin);
    float gVal = brightnessMultiplier*(greenIntensity/gDiff)*(green(orig.pixels[pixel])-gMin);
    float bVal = brightnessMultiplier*(blueIntensity/bDiff)*(blue(orig.pixels[pixel])-bMin);
    temp.pixels[pixel] = color(rVal, gVal, bVal);
  }
  return temp;
}

public void reset() {
  redIntensity = 255;
  greenIntensity = 255;
  blueIntensity = 255;
}

public void save_image() {
  String t = "Image_" +             //generate a filename
                  second() + "-" +
                  minute() + "-" +
                  hour() + "_" +
                  day() + "-" +
                  month() + "-" +
                  year() + ".jpg";
  compositeImg.save(t);
  println("saved " + t + "!");
}
