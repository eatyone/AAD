/*************************************************************/
/*                         EATYone                           */
/*************************************************************/


import controlP5.*;                        // CP5 pour l'interface
//import java.io.File;                       // Pour l'Import export des fichiersimport java.util.Locale;
import diewald_CV_kit.libraryinfo.*; // Pour la détection de contour
import diewald_CV_kit.utility.*;
import diewald_CV_kit.blobdetection.*;
import geomerative.*;
import java.lang.reflect.Method;
import java.text.*;
import java.util.*;
import java.io.*;
import java.util.logging.*;
import javax.swing.*;
import processing.serial.*;
import java.awt.event.KeyEvent;
import java.awt.event.*;
import java.awt.Frame;
import java.awt.BorderLayout;


ControlP5 cp5;

File file;
PrintWriter output;                        // Output stream for SVG Export
PrintWriter output2;
float n;
String locImg;
String imageName;
PImage sourceImg;
PImage imageImg;
PImage filterImg;
float blurVal = 0;
float postVal = 2;
float k;                                   // current radius
float endRadius;                           // Largest value the spiral needs to cover the image
color mask = color (255, 255, 255);        // Couleur Masque pour Spiral
PShape outputSVG;                          // SVG shape to draw
Textarea feedbackText;
String outputSVGName;                      // Filename of the generated SVG
String outputSVGNameGeo;
String outputTXT;
String imagePath;                          // Path of the loaded image (not used yet)
float x, y, xa, ya, xb, yb;                // current X and y + jittered x and y
color c;                                   // Sampled color
float b;                                   // Sampled brightness
float dist = 5;                            // Distance between rings
float radius = dist/20;                     // Current radius
float aradius;                             // Radius with brighness applied up
float bradius;                             // Radius with brighness applied down
float alpha = 0;                           // Initial rotation
float density = 75;
int counter=0;                             // Counts the samples
float ampScale = 5;
int rayon = 2;
PImage sample_img;
int size_x, size_y;
int simplVal;
RShape shp;
RShape polyshp;
RPoint[][] pointPaths;
BlobDetector blob_detector;

static PImage liveImage = null;
static PImage processedLiveImage = null;
static PImage capturedImage = null;
static PImage processedCapturedImage = null;
static boolean drawingTraceShape = true;
static boolean retraceShape = true;
static boolean flipWebcamImage = false;
static boolean rotateWebcamImage = false;
static boolean confirmedDraw = false;
int sepKeyColour = color(0, 0, 255);
Map<Integer, PImage> colourSeparations = null;
RShape traceShape = null;
RShape captureShape = null;

String shapeSavePath = "../../savedcaptures/";
String shapeSavePrefix = "shape-";
String shapeSaveExtension = ".svg";

float MachineWidth = 700;
float yHome = 120;

void setup() {
  
  // Mise en place de l'interface
  
  size (1200, 1024);
  background(235);
  noStroke();
  fill(245);
  rect(25, 25, 125, 950);
  fill(245);
  rect(175, 25, 950, 950);
  RG.init(this);
  // Boutons
  
  cp5 = new ControlP5(this);
  
  cp5.addButton("Ouvrir")
    .setLabel("Ouvrir")
    .setBroadcast(false)
    .setValue(0)
    .setPosition(37, 37)
    .setSize(100, 19)
    .setBroadcast(true)
    ;
  cp5.addButton("filtrer")
    .setLabel("Filtrer")
    .setBroadcast(false)
    .setValue(100)
    .setPosition(37, 62)
    .setSize(100, 19)
    .setBroadcast(true)
    ;
  cp5.addButton("vectorize")
    .setLabel("Vectoriser")
    .setBroadcast(false)
    .setValue(100)
    .setPosition(37, 165)
    .setSize(100, 19)
    .setBroadcast(true)
    ;


  cp5.addSlider("posterize")
    .setBroadcast(false)
    .setLabel("Posterize")
    .setRange(1, 32)
    .setValue(2)
    .setPosition(37, 97)
    .setSize(100, 19)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(1)
    .setBroadcast(true)
    ;
    
  cp5.getController("posterize").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setColor(color(128));
  
  cp5.addSlider("blur")
    .setBroadcast(false)
    .setLabel("Blur")
    .setRange(0, 8)
    .setValue(1)
    .setPosition(37, 135)
    .setSize(100, 19)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(1)
    .setBroadcast(true)
    ;
 cp5.getController("blur").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setColor(color(128));

 cp5.addButton("spiral")
    .setLabel("spiral")
    .setBroadcast(false)
    .setValue(100)
    .setPosition(37, 190)
    .setSize(100, 19)
    .setBroadcast(true)
    ;
 cp5.addSlider("Amplitude")
    .setBroadcast(false)
    .setLabel("Amplitude")
    .setRange(0, 20)
    .setValue(5)
    .setPosition(37, 225)
    .setSize(100, 19)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(1)
    .setBroadcast(true)
    ;
 cp5.getController("Amplitude").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setColor(color(128));
 
  cp5.addSlider("Distance")
    .setBroadcast(false)
    .setLabel("Distance")
    .setRange(5, 30)
    .setValue(5)
    .setPosition(37, 260)
    .setSize(100, 19)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(1)
    .setBroadcast(true)
    ;
 cp5.getController("Distance").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setColor(color(128));
 cp5.addSlider("Rayon")
    .setBroadcast(false)
    .setLabel("Rayon")
    .setRange(1, 16)
    .setValue(5)
    .setPosition(37, 295)
    .setSize(100, 19)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(1)
    .setBroadcast(true)
    ;
 cp5.getController("Rayon").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setColor(color(128));
  
 cp5.addButton("Geo")
    .setLabel("Geo")
    .setBroadcast(false)
    .setValue(100)
    .setPosition(37, 320)
    .setSize(100, 19)
    .setBroadcast(true)
    ;
 cp5.addSlider("Simplify")
    .setBroadcast(false)
    .setLabel("Simplify")
    .setRange(0, 100)
    .setValue(5)
    .setPosition(37, 355)
    .setSize(100, 19)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(1)
    .setBroadcast(true)
    ;
 cp5.getController("Simplify").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setColor(color(128));
 
 cp5.addButton("reset")
    .setLabel("Reset")
    .setBroadcast(false)
    .setValue(100)
    .setPosition(37, 380)
    .setSize(100, 19)
    .setBroadcast(true)
    ;
 cp5.addButton("Export")
    .setLabel("Export")
    .setBroadcast(false)
    .setValue(100)
    .setPosition(37, 405)
    .setSize(100, 19)
    .setBroadcast(true)
    ;
 cp5.addButton("Export2")
    .setLabel("Export2")
    .setBroadcast(false)
    .setValue(100)
    .setPosition(37, 430)
    .setSize(100, 19)
    .setBroadcast(true)
    ;
 cp5.addButton("rotateImg")
    .setLabel("Rotate")
    .setBroadcast(false)
    .setValue(100)
    .setPosition(37, 430)
    .setSize(100, 19)
    .setBroadcast(true)
    ;
}
public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  n = 0;
}


public void Ouvrir(float theValue) {
  locImg="";
  selectInput("Select a file to process:", "fileSelected");
  //displayImg.resize (512, 0);
}

void fileSelected(File selection) {
  
    locImg=selection.getAbsolutePath();
    file = new File(locImg);
    imageName = file.getName();
    imageName = imageName.substring(0, imageName.lastIndexOf("."));
    imageImg=loadImage(locImg);
    sourceImg=imageImg;
    filterImg = filtrage(imageImg);
    afficherImg();
    println (imageName);
  
}

void afficherImg(){
  effaceEcran();
  redim();
  //tint(GRAY);
  //translate (imageImg.width, imageImg.height);
  //rotate (PI/2.0);
  set(187, 85, imageImg);
  //image(imageImg,187,85);
}
void rotateImg(){
  effaceEcran();
  redim();
  rotate (PI/3.0);
  translate (imageImg.width, imageImg.height);
  
  //tint(GRAY);
  set(187, 85, imageImg);
}
void redim(){
  if ( imageImg.width > imageImg.height) {
    imageImg.resize (800, 0);
  } else {
    imageImg.resize (0, 800);
  }
  
}
void effaceEcran(){
  background(235);
  drawBackground();

}
void drawBackground () {
  noStroke();
  background(235);
  fill(245);
  rect(25, 25, 125, 950);
  fill(245);
  rect(175, 25, 950, 950);
}

void filtrer(){
  imageImg = filtrage(sourceImg);
  afficherImg();
  
}
void Export(){

  outputTXT = imageName+".txt";
  openTXT(outputTXT);
  translateShapeToCMD();
  closeCMD();
  closeTXT ();
}
void Export2(){

  outputTXT = imageName+"2.txt";
  openTXT(outputTXT);
  norvegian();
  closeCMD();
  closeTXT ();
  effaceEcran();
  displaySVG();
}
void spiral(){
  outputTXT = imageName+"2.txt";
  openTXT(outputTXT);
  effaceEcran();
  norvegian();
  closeCMD();
  closeTXT ();
  displaySVG();
}

/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/

void vectorize(){

  effaceEcran();
  sample_img = filterImg;
  //drawTracePage();
  initTrace();
  findContour();
//drawBackground ();
//filtrage (filterImg);
//afficherImg();
//Draw();
}

public void posterize(float theValue) {
  postVal = theValue;
  println(postVal);  
  //imageImg = filtrage(sourceImg);
}

public void blur(int theValue) {
  blurVal = theValue;
  println(blurVal);
  //imageImg = filtrage(sourceImg);
  //effaceEcran();
  //sample_img = filterImg;
  //initTrace();
  //findContour();
  
  //Geo();  
  //imageImg = filtrage(sourceImg);
}

public void Amplitude(int theValue) {
  ampScale = theValue;
  println(ampScale);  
  //imageImg = filtrage(sourceImg);
}

public void Distance(int theValue) {
  dist = theValue;
  println(dist);  
  //imageImg = filtrage(sourceImg);
}
public void Rayon(int theValue) {
  rayon = theValue;
  println(rayon);  
  imageImg = filtrage(sourceImg);
}

public PImage filtrage (PImage in){
   PImage out = createImage(in.width, in.height, RGB);
  out.loadPixels();
  for (int i = 0; i<in.pixels.length; i++) {
    out.pixels[i] = in.pixels[i];
  }
  tint(0, 0, 0);
  out.filter(BLUR, blurVal);
  out.filter(GRAY);
  out.filter(POSTERIZE, postVal);
  out.updatePixels();
  return out;
}

void reset(){
  
  System.gc();
  effaceEcran();
  imageImg = sourceImg;
  drawBackground ();
  afficherImg();
}




void displaySVG () {
  effaceEcran();
  drawBackground();
  //dist = 5;  // Distance between rings
  radius = dist/2;                     // Current radius
  alpha = 0;                           // Initial rotation
  density = 75;
  counter=0;                             // Counts the samples
  ampScale = 2.4;
  String svgLocation = outputSVGName;
  outputSVG = loadShape(svgLocation);
  //println("loaded SVG: "+ outputSVGName);
  shape(outputSVG, 187, 85, outputSVG.width/1, outputSVG.height/1);
  //feedbackText.setText(locImg+" was processed and saved as "+outputSVGName);
  //feedbackText.update();
}


void Simplify(int theValue){
   simplVal = theValue;
  //Geo(); 
}


void draw() {
  System.gc();
  x=0;
  y=0;
}
