//PrintWriter output2;                        // Output stream for SVG Export


void openTXT (String outputTXT) {
  output2 = createWriter(outputTXT); 
  output2.println("C14,END");
  
}

void openCMD () {
  output.println("C14,END");
}

void closeCMD () {
  output2.println("C14,END");
  shapeCount = 1;
}

void closeTXT () {
  output2.flush();             // Writes the remaining data to the file
  output2.close();
  System.gc();            // Closes the file
}
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
  output2.println("C09,581,580,END");
  for (int i = 0; i<pointPaths.length; i=i+1){
    stroke(0);
    beginShape ();
    output2.println("C14,END");
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
         
      output2.print("C17");
      output2.print(",");
      output2.print(l1pg);
      output2.print(",");
      output2.print(l2pg);
      output2.println(",2,END");
         
      vertex (xa+185,ya+87);
    }
   output2.println("C13,END");
   endShape ();
  }
}

