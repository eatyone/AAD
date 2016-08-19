

void norvegian(){
  
  
  outputSVGName=imageName+".svg";
  k = density/radius ;
  println(k);
  
  alpha += k;
  radius += dist/(360/k);
  x =  aradius*cos(radians(alpha))+imageImg.width/2;
  y = -aradius*sin(radians(alpha))+imageImg.height/2;
  endRadius = sqrt(pow((imageImg.width/2), 2)+pow((imageImg.height/2), 2));
  shapeOn = false;
  
  openSVG (outputSVGName);
  
  while (radius < endRadius) {
    k = (density/2)/radius ;
    alpha += k;
    radius += dist/(360/k);
    x =  radius*cos(radians(alpha))+imageImg.width/2;
    y = -radius*sin(radians(alpha))+imageImg.height/2;

    // Are we within the the image?
    // If so check if the shape is open. If not, open it
    if ((x>=0) && (x<imageImg.width) && (y>00) && (y<imageImg.height)) {

      // Get the color and brightness of the sampled pixel
      c = imageImg.get (int(x), int(y));
      b = brightness(c);
      b = map (b, 0, 255, dist*ampScale, 0);

      // Move up according to sampled brightness
      aradius = radius+(b/dist);
      xa =  aradius*cos(radians(alpha))+imageImg.width/2;
      ya = -aradius*sin(radians(alpha))+imageImg.height/2;

      // Move down according to sampled brightness
      k = (density/2)/radius ;
      alpha += k;
      radius += dist/(360/k);
      bradius = radius-(b/dist);
      xb =  bradius*cos(radians(alpha))+imageImg.width/2;
      yb = -bradius*sin(radians(alpha))+imageImg.height/2;

      // If the sampled color is the mask color do not write to the shape
      if (mask == c) {
        if (shapeOn) {
          closePolyline ();
          output.println("<!-- Mask -->");
        }
        shapeOn = false;
      } else {
        // Add vertices to shape
        if (shapeOn == false) {
          openPolyline ();
          //stroke(0);
          //beginShape();
          
          shapeOn = true;
        }
        
        vertexPolyline (xa, ya);
        vertexPolyline (xb, yb);
        vertex (xa, ya);
        vertex (xb, yb);
        exportSpiral( xa, ya, xb, yb);
      }

    } 
    
    else {

      // We are outside of the image so close the shape if it is open
      if (shapeOn == true) {
        closePolyline ();
        endShape();
        output.println("<!-- Out of bounds -->");
        shapeOn = false;
      }
    }
  }
  if (shapeOn) closePolyline();
  //endShape();
  //endRecord();
  closeSVG ();
  println(locImg+" was processed and saved as "+outputSVGName);
  //feedbackText.setText(locImg+" was processed and saved as "+outputSVGName);
  //feedbackText.update();
  //System.gc();

}
void exportSpiral(float xa2, float ya2, float xb2, float yb2){
  
  float xaa, yaa, xbb, ybb;
  float l1,l2; // length of coord
  int l1pg,l2pg; // Length for txt fil INT needed
  
  
  //DEBUG
  print("XA:");
  print(xa2);
  print(" ");
  print("YA:");
  println(ya2);
  vertex (xa2+185,ya2+87);
  vertex (xb2+185,yb2+87);
  //Wrinting File
  xa2 = (map(xa2,0,800,0,300)+100);
  ya2 = (map(ya2,0,800,0,300)+200);
  xb2 = (map(xb2,0,800,0,300)+100);
  yb2 = (map(yb2,0,800,0,300)+200);
  
  l1 = sqrt((pow(xa2,2)+pow(ya2,2)));
  l2 = sqrt((pow((500-xa2),2)+pow(ya2,2)));
  l1 = map (l1,0,500,0,1000);
  l2 = map (l2,0,500,0,1000);
  l1pg = int (l1);
  l2pg = int (l2);
  
  
  
  output2.print("C17");
  output2.print(",");
  output2.print(l1pg);
  output2.print(",");
  output2.print(l2pg);
  output2.println(",2,END");
  
  l1 = sqrt((pow(xb2,2)+pow(yb2,2)));
  l2 = sqrt((pow((500-xb2),2)+pow(yb2,2)));
  l1 = map (l1,0,500,0,1000);
  l2 = map (l2,0,500,0,1000);
  l1pg = int (l1);
  l2pg = int (l2);
  
  
  
  output2.print("C17");
  output2.print(",");
  output2.print(l1pg);
  output2.print(",");
  output2.print(l2pg);
  output2.println(",2,END");
  
  
  
  
  
  
  
}

/*

void translateShapeToCMD(){
  drawBackground ();
  
  shp = RG.loadShape(outputSVGName);
  
  float pointSeparation = simplVal;
  float xa,ya,xb,yb; // Native coordinates
  float l1,l2; // length of coord
  int l1pg,l2pg; // Length for txt fil INT needed
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(pointSeparation);
  polyshp = RG.polygonize(shp);
  pointPaths = shp.getPointsInPaths();
  
  effaceEcran();
  
  print ("nombre de points :");
  println (pointPaths.length);
  output.println("C09,581,580,END");
  for (int i = 0; i<pointPaths.length; i=i+1){
    stroke(0);
    beginShape ();
    output.println("C14,END");
    for (int j=0; j<pointPaths[i].length; j=j+1){
      
      
      xa = pointPaths[i][j].x;
      ya = pointPaths[i][j].y;
      xb = (map(xa,0,800,0,300)+100);
      yb = (map(ya,0,800,0,300)+250);
      
      l1 = sqrt((pow(xb,2)+pow(yb,2)));
      l2 = sqrt((pow((500-xb),2)+pow(yb,2)));
      l1 = map (l1,0,500,0,1000);
      l2 = map (l2,0,500,0,1000);
      l1pg = int (l1);
      l2pg = int (l2);
         
      output.print("C17");
      output.print(",");
      output.print(l1pg);
      output.print(",");
      output.print(l2pg);
      output.println(",2,END");
         
      vertex (xa+185,ya+87);
    }
   output.println("C13,END");
   endShape ();
  }
}*/
