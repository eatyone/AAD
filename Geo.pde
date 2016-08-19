public void Geo(){
  
  //drawBackground ();
  
  shp = RG.loadShape(outputSVGName);
  outputSVGName=imageName+".svg";
  //outputSVGNameGeo=imageName+"Geo.svg";
  openSVG (outputSVGName);
  //openSVG (outputSVGNameGeo);
  //hp = RG.centerIn(shp, g, 100);
  float pointSeparation = simplVal;
  float xmag, ymag, newYmag, newXmag = 0;
  
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(pointSeparation);
  polyshp = RG.polygonize(shp);
  pointPaths = shp.getPointsInPaths();  
  effaceEcran();
  for(int i = 0; i<pointPaths.length; i++){
    
    println(i);
     
    if (pointPaths[i] != null) {
      stroke(0);
     
      //beginShape();
      openPolyline();
      for(int j = 0; j<pointPaths[i].length; j++){
        
        //vertex(pointPaths[i][j].x+185, pointPaths[i][j].y+87);
        vertexPolyline (pointPaths[i][j].x, pointPaths[i][j].y);
        
      }
      //endShape();
      closePolyline ();
      
      
    }
  }
  closeSVG ();
  displaySVG ();
}
