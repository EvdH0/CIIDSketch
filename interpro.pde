class Interpro implements Serializable 
{
  StringList classification;
  int proteinLength;
  ArrayList<Match> matches;
  String name;  
  String IPRid;
  
  Interpro(String _IPRid, String _name, StringList _class, ArrayList<Match> _tempMatches)
  {
    IPRid = _IPRid;
    name = _name;
    matches = (ArrayList) _tempMatches.clone();
    //println("Construtor says: "+_tempMatches.size());
    classification = (StringList) _class.copy();
  }

  String determineType()
  {

   


    //First check the annotations in the name
    if (isEnzyme(name))return "Enzyme";
    else if (isTransporter(name)) return "Transporter";
    else if (isRegulator(name)) return "Regulator";

    //If nothing has been found go through the (possibly annotated) descriptions

    for (String s: classification)
    {
      if (isEnzyme(s))return "Enzyme";
      else if (isTransporter(s)) return "Transporter";
      else if (isRegulator(s)) return "Regulator";
    }

    //Nothing there then its something else
    return "Unknown/Other";
  }
  void drawName(int _y)
  {
    String tempStringholder=" |";
    fill(0, 255, 255);
    for (String s: classification)
    {
      //println(s);
      tempStringholder=tempStringholder + ", " + s;
    }
    tempStringholder = tempStringholder + "| type: " + determineType();  
    text(name + tempStringholder, 10, _y);
  }
}

