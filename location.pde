class Location implements Serializable  {


  int start, end;
  float score;

  Location(int _start, int _end, float _score)
  {
    //store 1 location
    start=_start;
    end=_end;
    score=_score;
  }

  int getLength()
  {
    return end-start;
  }
  color getColor()
  {
    color from = color(255, 0, 0);
    color to = color(0, 255, 0);
    return lerpColor(from, to, map(log(score), -100, 10, 1, 0));
  }

  color getColorType(String _etype)
  {
    color from = color(255, 0, 0);
    color to = color(0, 255, 0);
    //return lerpColor(from, to, map(log(score), -100, 10, 1, 0));

    if (_etype.equals("Enzyme")) return color(255, 0, 0);
    else if (_etype.equals("Transporter")) return color(0, 255, 0);
    else if (_etype.equals("Regulator")) return color(0, 0, 255);
    else return color(255, 255, 255);
  }


  void drawLine(int _y)
  {
    stroke(getColor());
    line((float)start+30, (float)_y, (float)end+30, (float)_y);
  }

  void drawSequence(int _y, String _sequence)
  {
    //textSize(10);
    setMono();
    fill(getColor());
    text(_sequence.substring(start, end), 10+start*6, _y+3);
    setAno();
    //textSize(13);
    stroke(color(10,100,100,100));
    line(start*6+10,SPLIT+30,start*6+10,_y+3);
     line(end*6+10,SPLIT+30 ,end*6+10,_y+3);
  }

  void drawVert(int _x, String _etype)
  {
    stroke(getColorType(_etype));
    stroke(getColor());
    line(_x, end/2+30, _x, start/2+30);
  }
}

