//Contains some helper functions
//float[]g_values = {};
void printDepth(int Depth)
{

  for (int i=0;i<Depth;i++)
  {
    //print('-');
  }
}

File[] finder( String dirName) {
  println(dirName);
  File dir = new File(dirName);

  return dir.listFiles(new FilenameFilter() { 
    public boolean accept(File dir, String filename)
    { 
      return filename.endsWith(".xml");
    }
  } 
  );
}


String fmt(float d)
{
  if (d == (int) d)
    return String.format("%d", (int)d);
  else
    return String.format("%s", d);
}

void debug()
{
  int ys=10; 
  // println(interproList.get(1).matches.get(1).locations.get(1).start);
  println("_____________________");
  println("    START THE OUTPUT");
  println("_____________________");

  for (int k=0; k<interproList.size();k++)
  {
    Interpro interpro_object = interproList.get(k);
    fill(0, 255, 255);
    text(interpro_object.name, 10, ys);
    ys=ys+20;
    println("++++INTERPRO: " + interpro_object.name + "++++++");
    println("++++contains : " +interpro_object.matches.size() + " matches");
    //isEnzyme(interpro_object.name);
    //isTransporter(interpro_object.name);
    println("classification:");
    println( interproList.get(k).classification.get(0));

    //for (int j=0; j<interpro_object.matches.size();j++) 
    for (int j=0; j<interproList.get(k).matches.size();j++) 
    {
      Match match_object = interpro_object.matches.get(j);
      fill(255, 0, 255);
      text(interproList.get(k).matches.get(j).id, 30, ys);

      ys=ys+20;

      println(".......MATCH: " + match_object.id + "......");
      println(".......contains : " +match_object.locations.size() + " locations");

      // for (int i=0; i<match_object.locations.size(); i++) 
      for (int i=0; i<interproList.get(k).matches.get(j).locations.size();i++) 
      {
        Location location_object = match_object.locations.get(i);

        println(interproList.get(k).matches.get(j).locations.get(i).getLength());
        interproList.get(k).matches.get(j).locations.get(i).drawLine(ys-15);
        println("y ticker" + ys);
      }
    }
  }
}

void sortList() {

  //Hacky way to sort the proteins by the four types, but works awesome

  ArrayList<Protein>  enzymes;
  ArrayList<Protein>  regulators;
  ArrayList<Protein>  transporters;
  ArrayList<Protein>  unknowns;

  enzymes = new ArrayList<Protein>();
  regulators = new ArrayList<Protein>();
  transporters = new ArrayList<Protein>();
  unknowns = new ArrayList<Protein>();

  for (Protein p: proteins)
  {
    if (p.determineType()=="Enzyme") enzymes.add(p);
    else if (p.determineType()=="Regulator") regulators.add(p);
    else if (p.determineType()=="Transporter") transporters.add(p);
    else unknowns.add(p);
  }

  proteins.clear();

  for (Protein p: enzymes)
  {
    proteins.add(p);
  }
  for (Protein p: regulators)
  {
    proteins.add(p);
  }
  for (Protein p: transporters)
  {
    proteins.add(p);
  }
  for (Protein p: unknowns)
  {
    proteins.add(p);
  }
}


String getSequence(String filename)
{
  
   BufferedReader reader;
  String line, line2;
  
  //String fname = (String)files[i].getName();
  
    String[] fname2 = filename.split("\\.");
   // println(fname);
    //println(fname2.length);
    String sequenceFile = SEQDIR + fname2[0] + ".sequence.txt.x"; //Beware that I use here a scrambled version of the FASTA data due to a non-public data set, so remove the .x to use your own dataset

    reader = createReader(sequenceFile);    

    try {
      line = reader.readLine();
       line2 = reader.readLine();
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
      line2= null;
    }
    if (line == null) {
      // Stop reading because of an error or file is empty
      noLoop();
    } 
    else {
     
      //print(line2);
    }

return line2;
  
}

void countType() {

  int enzyme=0, regulator=0, transporter=0, unknown=0;
  for (Protein p: proteins)
  {
    if (p.determineType()=="Enzyme") enzyme++;
    else if (p.determineType()=="Regulator") regulator++;
    else if (p.determineType()=="Transporter") transporter++;
    else unknown++;
  }
  println("Enz: " + enzyme + " Reg: " + regulator + " trans: " + transporter + " unk: " + unknown);
  //float[] g_values = { enzyme,regulator,transporter,unknown};
}


String shuffleString(String input){
        ArrayList<Character> characters = new ArrayList<Character>();
        for(char c:input.toCharArray()){
            characters.add(c);
        }
        StringBuilder output = new StringBuilder(input.length());
        while(characters.size()!=0){
            int randPicker = (int)(Math.random()*characters.size());
            output.append(characters.remove(randPicker));
        }
        return output.toString();
    }



