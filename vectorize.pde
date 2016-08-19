public void initTrace(){
 String image_path = sketchPath+"/data/";

  sample_img = imageImg;

  size_x = sample_img.width;
  size_y = sample_img.height;
  //size(size_x, size_y);

  sample_img.loadPixels();

  blob_detector = new BlobDetector( size_x, size_y);
  blob_detector.setResolution(0);
  blob_detector.computeContours(true);
  blob_detector.computeBlobPixels(true);
  blob_detector.setMinMaxPixels(10*10, size_x*size_y);
  blob_detector.setBLOBable(new BLOBable_Hands(this, sample_img));

  //font = createFont("Calibri", 14);
  //textFont(font);
  //frameRate(200); 
}

public void findContour(){
  outputSVGName=imageName+".svg";
  openSVG (outputSVGName);
  background(255);
  //    blob_detector.takeEveryNthPixel((int) map(mouseX, 0, width, 0, 20));
  //image(sample_img, 0, 0);

  blob_detector.setResolution(1);

  //update the blob_detector with the new pixelvalues
  blob_detector.update();

  // get a list of all the blobs
  ArrayList<Blob> blob_list = blob_detector.getBlobs();


  // iterate through the blob_list
  for (int blob_idx = 0; blob_idx < blob_list.size(); blob_idx++ ) {

    // get the current blob from the blob-list
    Blob blob = blob_list.get(blob_idx);
    //      System.out.println("number of pixels = " +blob.getNumberOfPixels() );
    // get the list of all the contours from the current blob
    ArrayList<Contour> contour_list = blob.getContours();

    // iterate through the contour_list
    for (int contour_idx = 0; contour_idx < contour_list.size(); contour_idx++ ) {

      // get the current contour from the contour-list
      Contour contour = contour_list.get(contour_idx);

      // get the current boundingbox from the current contour
      BoundingBox bb = contour.getBoundingBox();


      // handle the first contour (outer contour = contour_idx == 0) different to the inner contours
      if ( contour_idx == 0) {

        // draw the boundingbox
        //drawBoundingBox(bb, color(0), 1);
        // draw the blob-id
        fill(0);
        //text("blob["+blob_idx+"]", bb.xMin(), bb.yMin()- textDescent()*2);


        // draw the contour
        //drawContour(contour.getPixels(), color(255, 0, 0), color(0, 255, 0, 50), !true, 1); 




        // example how to simplify a contour
        int repeat_simplifying = 2;
        // can improve speed, if the contour is needed for further work
        ArrayList<Pixel> contour_simple = Polyline.SIMPLIFY(contour, 2, 1);
        // repeat the simplifying process a view more times
        for (int simple_cnt = 0; simple_cnt < repeat_simplifying; simple_cnt++) {
          contour_simple= Polyline.SIMPLIFY(contour_simple, 2, simple_cnt);
        }
        // draw the simplified contour
        drawContour(contour_simple, color(0, 0, 0), color(0, 0, 200, 50), false, 1);
        //drawPoints(contour_simple, color(0, 200, 200), 1);




        // generate a convex hull object
        ConvexHullDiwi convex_hull = new ConvexHullDiwi();
        // calculate the convex hull, based on the contour-list
        convex_hull.update(contour_simple);
        //draw the convex hull
        //drawConvexHull(convex_hull, color(0, 255, 0), 2);
        //drawConvexHullPoints(convex_hull, color(0, 255, 0), 25);
      } 
      else {
        // we don't handle inner contours here
        int repeat_simplifying = 1;
        ArrayList<Pixel> contour_simple2 = Polyline.SIMPLIFY(contour, 2, 1);
        for (int simple_cnt = 0; simple_cnt < repeat_simplifying; simple_cnt++) {
          contour_simple2= Polyline.SIMPLIFY(contour_simple2, 2, simple_cnt);
        }
        // draw the simplified contour
        drawContour(contour_simple2, color(0, 0, 0), color(0, 0, 200, 50), false, 1);
        //drawPoints(contour_simple, color(0, 200, 200), 1);
      }
    }

  }
closeSVG();
}
public void drawContour(ArrayList<Pixel> pixel_list, int stroke_color, int fill_color, boolean fill, float stroke_weight) {
  
  
  if ( !fill)
    noFill();
  else
    fill(fill_color);
  stroke(stroke_color);
  strokeWeight(stroke_weight);
  openPolyline();
  beginShape();
  for (int idx = 0; idx < pixel_list.size(); idx++) {
    Pixel p = pixel_list.get(idx);
    vertexPolyline (p.x_, p.y_);
    vertex(p.x_+187, p.y_+85);
  }
  endShape();
  closePolyline();
  
  //println(locImg+" was processed and saved as "+outputSVGName);
}
public void drawPoints(ArrayList<Pixel> pixel_list, int stroke_color, float stroke_weight) {
  stroke(stroke_color);
  strokeWeight(stroke_weight);

  for (int idx = 0; idx < pixel_list.size(); idx++) {
    Pixel p = pixel_list.get(idx);
    point(p.x_, p.y_);
  }
}
// draw convex-hull - as polyline
public void drawConvexHull(ConvexHullDiwi convex_hull, int stroke_color, float stroke_weight) {
  noFill();
  stroke(stroke_color); 
  strokeWeight(stroke_weight);
  DoubleLinkedList<Pixel> convex_hull_list = convex_hull.get();
  convex_hull_list.gotoFirst();
  beginShape();
  for (int cvh_idx = 0; cvh_idx < convex_hull_list.size()+1; cvh_idx++, convex_hull_list.gotoNext() ) {
    Pixel p = convex_hull_list.getCurrentNode().get();
    vertex(p.x_+187, p.y_+85);
  }
  endShape();
}
// draw convex-hull-points - only points
public void drawConvexHullPoints(ConvexHullDiwi convex_hull, int stroke_color, float stroke_weight) {
  noFill();
  stroke(stroke_color); 
  strokeWeight(stroke_weight);
  DoubleLinkedList<Pixel> convex_hull_list = convex_hull.get();
  convex_hull_list.gotoFirst();

  for (int cvh_idx = 0; cvh_idx < convex_hull_list.size(); cvh_idx++, convex_hull_list.gotoNext() ) {
    Pixel p = convex_hull_list.getCurrentNode().get();
    point(p.x_, p.y_);
  }
} 
