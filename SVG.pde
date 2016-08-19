
int shapeLen = 1000;                       // Maximum number of vertices per shape
int shapeCount = 1;
boolean shapeOn = false;                   // Keeps track of a shape is open or closed

void openSVG (String outputSVG) {
  output = createWriter(outputSVG); 
  output.println("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
  output.println("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">");
  output.println("<svg width=\"800 px\" height=\"800 px\" viewBox=\"0 0 800 800\" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">");
}

void openPolyline () {
  output.print("  <polyline fill=\"none\" stroke=\"#010101\" points=\"");
}

void vertexPolyline (float x, float y) {
  // If the shape has gotten too long close it and open a new one
  if (shapeCount%shapeLen == 0 && shapeOn) {
    endShape ();
    closePolyline ();
    output.println("<!-- Maximum Shape Length -->");
    beginShape ();
    openPolyline ();
  }
  output.print("    ");
  //String ix = nf(x, 3, 3);
  //ix = ix.replaceAll(",",".");
  //String igrec = nf(y, 3, 3);
  //igrec = igrec.replaceAll(",",".");
  output.print(abs(x));
  output.print(",");
  output.println(abs(y));
  output.print(" ");
  shapeCount++;
}

void closePolyline () {
  output.println("\"/>");
  shapeCount = 1;
}

void closeSVG () {
  output.println("</svg>");
  output.flush();             // Writes the remaining data to the file
  output.close();
  //System.gc();            // Closes the file
}
