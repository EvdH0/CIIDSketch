class Protein implements Serializable  {
  ArrayList<Interpro> interpros;
  int aminoacids;
  String name;
  String filename;
  String type;
  String sequence;
  StringList rel_refs;

  Protein(String _name, String _filename, int _aminoacids, String _sequence, ArrayList<Interpro> _interpros, StringList _rel_ref) {
    name = _name;
    filename = _filename;
    aminoacids = _aminoacids;
    interpros = (ArrayList) _interpros.clone();
    sequence = _sequence;
    rel_refs = _rel_ref.copy();
    setType();
    //println(rel_refs);
  }
  

  void drawName(int _y)
  {
    fill(0, 0, 255);
    type = determineType();
    text("AA: " + aminoacids + " type: " + type +" N: " + name + " F:" + filename, 5, _y);
  }

  void setType()
  {
    type = determineType();
  }

  void drawSequence(int _y) {


    fill(255, 255, 255);
    //textSize(11);
    setMono();
    text(sequence, 0+10, _y+3);
    setAno();
    //textSize(13);
  }
  String determineType()
  {
    int enzyme=0, regulator=0, transporter=0, unknown=0;

    //Call every derterminetype of the interpro parts and counts every enzyme, regulator and transporer entry

    for (Interpro i: interpros)
    {
      if (i.determineType()=="Enzyme") enzyme++;
      else if (i.determineType()=="Regulator") regulator++;
      else if (i.determineType()=="Transporter") transporter++;
      else unknown++;
    }
    if (enzyme>regulator && enzyme>transporter) return "Enzyme";
    else if (regulator>enzyme && regulator>transporter) return "Regulator";
    else if (transporter>enzyme && transporter>regulator) return "Transporter";
    return "Unknown/Other";
  }
}


