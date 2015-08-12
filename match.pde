class Match implements Serializable 
{
  String id;
  String dbase;
  ArrayList<Location> locations;

  
  Match(String _id, String _dbase, ArrayList<Location> _tempLocations) {
    id = _id;
    locations = (ArrayList) _tempLocations.clone();
    dbase = _dbase;
  
  }
  
  void drawName(int _y)
  {
    fill(255, 0, 255);
    text(id,30,_y);
  }
}

