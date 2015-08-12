/*

A quick Processing sketch to evaluate and interact with InterPro data, 
for example generated using the EMBL REST interface http://ebi.edu.au/content/interproscan-rest
Save the raw FASTA files in data/FASTA/ and the InterPro XML files in data/xmldir
The currenct data folder contains a set of FASTA and XML files to play around with

Eric van der Helm, 2013
*/


XML xml;
import java.util.regex.*;
import java.io.File;
import java.io.FilenameFilter;
import java.io.OutputStream;
import java.io.*;


int keyValue;
int y;

boolean showConnections;
boolean showClassification;
boolean selected;
String matchID;
String ipID;
String IPRid;
StringList descriptions;
StringList rel_ref;
int counter;

int SPLIT=10;
String proteinName;
int proteinLength;

int scrollX=5;

ArrayList<Location> locations;
ArrayList<Match> tempMatches;
ArrayList<Location> tempLocations;
ArrayList<Interpro> tempInterpros;
ArrayList<Interpro> interproList;
ArrayList<Protein> proteins;


FloatList boundBegin;
FloatList boundEnd;
StringList proteinNameList;



String DIR;
String SEQDIR;

int selIndex;

void setMono()
{
  // PFont font = loadFont("Calibri.vlw");
  PFont fontMono = loadFont("Monospaced-10.vlw");

  textFont(fontMono); 
  textSize(10);
}
void setAno()
{

  PFont fontAno = loadFont("AnonymousPro-Bold-14.vlw");

  textFont(fontAno); 
  textSize(14);
}
int matchCounter;
void setup() {

  frameRate(15);
DIR = dataPath("") + "/xmldir/";
println("Set Dir to: " + DIR);
SEQDIR = dataPath("") + "/FASTA/";
  showConnections=true;
  selected=false;
  setAno();

  matchID = "";
  ipID = "";
  IPRid = "";

  tempLocations = new ArrayList<Location>();  // Create an empty ArrayList
  tempMatches = new ArrayList<Match>();
  tempInterpros = new ArrayList<Interpro>();

  interproList = new ArrayList<Interpro>();
  proteins = new ArrayList<Protein>();
  descriptions = new StringList();
  rel_ref = new StringList();

  boundBegin = new FloatList();
  boundEnd = new FloatList();
  proteinNameList = new StringList();

  counter=0;

  y=0;
  background(0);
  size (2000, 800);
  matchCounter=0;
  initData();
  countType();
  sortList();
}


void draw()
{
  background(0);
  fill(50);
  text("Press P for screenshot", 20,height-40);
  
  text("Press X to toggle classifications", 20,height-30);
  text("Press C to toggle connections", 20,height-20);
  //println(boundBegin.size());


  /*
  for (int i=0;i<boundBegin.size();i++)
   {
   if (boundBegin.get(i)<mouseX && boundEnd.get(i)>mouseX && mouseY<SPLIT)
   {
   println(proteinNameList.get(i));
   fill(255, 255, 255, 100);
   noStroke();
   rect(boundBegin.get(i), 26, boundEnd.get(i)-boundBegin.get(i), SPLIT-26);
   
   viewDetail(i);
   }
   }
   
   
   */





  viewVert(); //=vertical view
  float newX = (mouseX-400);//(width/2));
  float newY = (mouseY-(height/2));

  float theta = atan2(newY, newX);

  if (theta<0)theta=theta+TWO_PI;

  //println(theta);
  boolean foundFocus=false;
  for (int i=0;i<boundBegin.size();i++)
  {
    //println(boundBegin.get(i));
    if (boundBegin.get(i)<theta && boundEnd.get(i)>theta&&mouseX<700)
    {
      //println(proteinNameList.get(i));
      fill(255, 255, 255, 100);
      noStroke();
      //rect(boundBegin.get(i), 26, boundEnd.get(i)-boundBegin.get(i), SPLIT-26);
      //quad(x1, y1, x2, y2, x3, y3, x4, y4)
      quad(cos(boundBegin.get(i))*a, sin(boundBegin.get(i))*a, 
      cos(boundEnd.get(i))*a, sin(boundEnd.get(i))*a, 
      cos(boundEnd.get(i))*(a+170), sin(boundEnd.get(i))*(a+170), 
      cos(boundBegin.get(i))*(a+170), sin(boundBegin.get(i))*(a+170)


      );
      foundFocus=true;
      //  println("Quad from x" + cos(boundBegin.get(i))*a +" y" + sin(boundBegin.get(i))*a);
      viewDetail(i);
    }
  }
  if (foundFocus==true) selected=true;
  else  selected=false;

  foundFocus=false;

 
}






void initData()
{

println("Wat is dir? " + DIR);
  File files[]  = finder(DIR);

  for (int i=0;i<files.length;i++)
  {

   
    println(files[i].getName());




    xml = loadXML(DIR + (String)files[i].getName());

    tempLocations.clear();
    tempMatches.clear();
    tempInterpros.clear();
    IPRid = "";
    ipID = "";
    matchID = "";

    search(xml, 1, "root", "root");

    //We need this to put the last stuff in the objects, since we use after-saving instead of 
    //pre saving
    tempMatches.add( new Match(matchID, "LAST", tempLocations));
    tempInterpros.add( new Interpro(IPRid, ipID, descriptions, tempMatches));
    //println(getSequence(files[i].getName()));
    //println(rel_ref);

    //
    // !!!! USE THIS ONE FOR SUFFELING THE DNA SEQUENCE FOR PRESENTATION PURPUSES
    //
    //proteins.add( new Protein(proteinName, shuffleString((String)files[i].getName()), proteinLength, shuffleString(getSequence(files[i].getName())), tempInterpros, rel_ref));


    proteins.add( new Protein(proteinName, files[i].getName(), proteinLength, getSequence(files[i].getName()), tempInterpros, rel_ref));


    // view();
    tempLocations.clear();
    tempMatches.clear();
    tempInterpros.clear();
    //println(rel_ref);
    rel_ref.clear();

    proteinName = "";
    proteinLength = 0;
  }
}


///
///loop through the objects and visualize it
///


int a = 200;
void viewVert() {
  int index=0;

  boundBegin.clear();
  boundEnd.clear();
  proteinNameList.clear();


  fill(000, 200, 200);

  int ys=10; //keeps track of the y position

  //proteins.get(index).drawName(ys);


  //background(0);

  //2 pi r
  strokeWeight(1);
  smooth();
  translate(400, height/2);

  float t=0;

  //stroke(color(random(100,255),random(100,255),0));  


  //println(t);





  String prevType="";
  float startP = 0;
  float endP = 0;
  testCounter=0;

  for (int h=0; h<proteins.size();h++)
  {
    startP = t;
    if (proteins.get(h).type != prevType)
    { 
      ys=ys+50;
      // startP = startP + 1;
      //text(proteins.get(h).type, ys-scrollX, 20);
      //  stroke(155);

      if (showClassification==true) {
        stroke(color(255, 255, 255, 100));
        line(   cos(t), 
        sin(t), 
        (a)*cos(t), 
        (a)*sin(t)
          ); //Draws the "pie chart"

        pushMatrix();
        fill(color(255, 255, 255, 100));
        rotate(t);
        translate(a/3, 20);
        text(proteins.get(h).type, 0, 0); //Puts the text on the area
        ;
        popMatrix();
      }
    }
    prevType = proteins.get(h).type;

    // ys = 20;
    interproList = proteins.get(h).interpros; //Load a protein with id into the interproList instance
    ys=ys+5;
    //stroke(255);
    //line(10,ys,400,ys);
    for (int k=0; k<interproList.size();k++) {  
      //interproList.get(k).drawName(ys);
      ys=ys+1; 

      for (int j=0; j<interproList.get(k).matches.size();j++) {
        Match match_object = interproList.get(k).matches.get(j);
        //interproList.get(k).matches.get(j).drawName(ys);

        t=map(testCounter, 0, proteins.size()*5+matchCounter, 0, 2*PI);
        //println(t);
        //println(proteins.size()*5+matchCounter);
        for (int i=0; i<interproList.get(k).matches.get(j).locations.size();i++) {

          stroke(interproList.get(k).matches.get(j).locations.get(i).getColor());
          line(   (a+interproList.get(k).matches.get(j).locations.get(i).start/2.5)*cos(t), 
          (a+interproList.get(k).matches.get(j).locations.get(i).start/2.5)*sin(t), 
          (a+interproList.get(k).matches.get(j).locations.get(i).end/2.5)*cos(t), 
          (a+interproList.get(k).matches.get(j).locations.get(i).end/2.5)*sin(t)
            );
        }
        testCounter++;
        ys=ys+2;
      }
    }
    endP = t;
    testCounter=testCounter+5;
    t=map(testCounter, 0, proteins.size()*5+matchCounter, 0,  2*PI);

    //stroke(0, 0, 150);
    //line(startP-12-scrollX, 25, endP-12-scrollX, 25);
    //line(startP-12-scrollX, SPLIT, endP-12-scrollX, SPLIT);
    boundBegin.append(startP);
    boundEnd.append(endP);

    proteinNameList.append(proteins.get(h).name);

    startP = t;

    // println("Wrote " + proteins.get(h).name + " with startp " + startP + " and endP " + endP);
    ys=ys+10;
  }
  // println("final ys: " + ys);
  //println("testCounter :" + testCounter);

  if (selected==false && showConnections==true)
  {
    for (int indexwalker=0;indexwalker<proteins.size();indexwalker++)
    {
      for (int walker=0;walker<proteins.size();walker++) //Walk through all the proteins
      {
        int foundProtein=0;
        for (int walker2=0;walker2<proteins.get(walker).rel_refs.size();walker2++) //Walk thourhg all the connected IPR's
        {

          if (proteins.get(indexwalker).rel_refs.hasValue(proteins.get(walker).rel_refs.get(walker2))) //Check if the current protein contains IPRS which are also found in the walked protein.
          {
            // stroke(255);
            if (indexwalker!=walker) foundProtein++; // we dont like self contamination ;)
            //println("To " + walker + " x: " +cos(boundBegin.get(walker))*a + " y: " + sin(boundBegin.get(walker))*a);
            //println("Found a hit in " + proteins.get(walker).name);
          }
        }

        if (foundProtein>0) {
          //translate(-300, +300);
          //line(cos(boundBegin.get(index))*a,sin(boundBegin.get(index))*a,cos(boundBegin.get(walker))*a,sin(boundBegin.get(walker))*a);
          int factor=5;
          stroke(color(10, 100, 100, 100));
          //if (foundProtein>10) foundProtein=10;
          strokeWeight(log(foundProtein)+1);
          //println("Found : " + foundProtein + " so log is " + (log(foundProtein)+1));
          noFill();
          bezier(
          cos(boundBegin.get(indexwalker))*a, sin(boundBegin.get(indexwalker))*a, 
          cos(boundBegin.get(indexwalker))*a/factor, sin(boundBegin.get(indexwalker))*a/factor, 
          cos(boundBegin.get(walker))*a/factor, sin(boundBegin.get(walker))*a/factor, 
          cos(boundBegin.get(walker))*a, sin(boundBegin.get(walker))*a
            );
          strokeWeight(1);
          foundProtein=0;

          // translate(300, -300);
        }
      }
    }
  }
}
void view(int index) {

  interproList = proteins.get(index).interpros; //Load a protein with id into the interproList instance

  fill(200, 200, 200);
  text(" " + index + "/" + proteins.size(), 5, 15);
  int ys=40; //keeps track of the y position

  proteins.get(index).drawName(ys);
  ys=ys+20;

  for (int k=0; k<interproList.size();k++) {  
    interproList.get(k).drawName(ys);
    ys=ys+20; 

    for (int j=0; j<interproList.get(k).matches.size();j++) {
      Match match_object = interproList.get(k).matches.get(j);
      interproList.get(k).matches.get(j).drawName(ys);
      ys=ys+20;

      for (int i=0; i<interproList.get(k).matches.get(j).locations.size();i++) {
        Location location_object = match_object.locations.get(i);
        interproList.get(k).matches.get(j).locations.get(i).drawLine(ys-15);
      }
    }
  }
}

int testCounter;

void viewDetail(int index) {
  translate(300, -300);
  selIndex = index;
  interproList = proteins.get(index).interpros; //Load a protein with id into the interproList instance
  int ys=10;
  fill(200, 200, 200);
  text(" " + index + "/" + proteins.size(), 5, 15);
  //int ys=SPLIT+15; //keeps track of the y position
  ys=ys+15;
  proteins.get(index).drawName(ys);
  //println("YS" + ys);
  ys=ys+5;
  proteins.get(index).drawSequence(ys+8);
  //println(proteins.get(index).rel_refs);
  ys=ys+3;
  // proteins.get(index).drawSequence(ys);
  ys=ys+20;
  //println("Start the walk");



  //Show connections

  if (selected==true && showConnections==true) {
    for (int walker=0;walker<proteins.size();walker++) //Walk through all the proteins
    {
      int foundProtein=0;
      for (int walker2=0;walker2<proteins.get(walker).rel_refs.size();walker2++) //Walk thourhg all the connected IPR's
      {

        if (proteins.get(index).rel_refs.hasValue(proteins.get(walker).rel_refs.get(walker2))) //Check if the current protein contains IPRS which are also found in the walked protein.
        {
          // stroke(255);
          if (index!=walker) foundProtein++; // we dont like self contamination ;)
          //println("To " + walker + " x: " +cos(boundBegin.get(walker))*a + " y: " + sin(boundBegin.get(walker))*a);
          //println("Found a hit in " + proteins.get(walker).name);
        }
      }

      if (foundProtein>0) {
        translate(-300, +300);
        //line(cos(boundBegin.get(index))*a,sin(boundBegin.get(index))*a,cos(boundBegin.get(walker))*a,sin(boundBegin.get(walker))*a);
        int factor=5;
        stroke(color(10, 100, 100, 100));
        //if (foundProtein>10) foundProtein=10;
        strokeWeight(log(foundProtein)+1);
        println("Found : " + foundProtein + " so log is " + (log(foundProtein)+1));
        noFill();
        bezier(
        cos(boundBegin.get(index))*a, sin(boundBegin.get(index))*a, 
        cos(boundBegin.get(index))*a/factor, sin(boundBegin.get(index))*a/factor, 
        cos(boundBegin.get(walker))*a/factor, sin(boundBegin.get(walker))*a/factor, 
        cos(boundBegin.get(walker))*a, sin(boundBegin.get(walker))*a
          );
        strokeWeight(1);
        foundProtein=0;

        translate(300, -300);
      }
    }
  }
  //println("End walk");


  for (int k=0; k<interproList.size();k++) {  
    interproList.get(k).drawName(ys);
    ys=ys+20; 

    for (int j=0; j<interproList.get(k).matches.size();j++) {
      Match match_object = interproList.get(k).matches.get(j);
      interproList.get(k).matches.get(j).drawName(ys);
      ys=ys+22;

      for (int i=0; i<interproList.get(k).matches.get(j).locations.size();i++) {
        Location location_object = match_object.locations.get(i);
        //interproList.get(k).matches.get(j).locations.get(i).drawLine(ys-15);
        interproList.get(k).matches.get(j).locations.get(i).drawSequence(ys-15, proteins.get(index).sequence);
      }
    }
  }
}



void keyPressed() {

  if (key == CODED) {
    if (keyCode == UP) {
      keyValue = keyValue+1;
    } 
    else if (keyCode == DOWN) {
      keyValue = keyValue-1;
    }
  }

  if (keyCode == 80) //Save picture (P)
  {
    PImage cp = get (0, SPLIT, width, height-SPLIT);
    cp.save("screenshot/" + proteins.get(selIndex).name + random(10, 99) + ".jpg");
    save(random(300) + ".jpg");
    println ("save picture");
  }
  if (keyCode == 67) //Show connections (C)
  {

    if (showConnections==true) showConnections =false;
    else showConnections=true;
  }
  if (keyCode == 88) //Show classifications (X)
  {

    if (showClassification==true) showClassification =false;
    else showClassification=true;
  }

  /*
} 
   else {
   keyValue=0;
   }
   
   if (keyValue==-1) 
   {
   keyValue = proteins.size()-1;
   }
   
   if (keyValue==proteins.size())
   {
   keyValue = 0;
   }
   */
}



