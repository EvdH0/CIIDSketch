void search(XML node, int Depth, String rInterpro, String rMatch)
{
  //println(counter + "x");
  counter++;

  ///DEBUG COUNTER
  if (counter==120)
  {
    //println("Current intrerpros size: " + tempInterpros.size());
    //println("How many matches are there inside? " + tempInterpros.get(0).matches.size());
  }

  ////////// DESCRIPTION ///////
  if (node.getName()=="description") {
    descriptions.append(node.getContent());
    /* SILENCE
     fill(0, 255, 255, 255);
     
     text(node.getContent(), 10, y+10); 
     y=y+15;
     SILENCE */
  }

  //////// PROTEIN //////////
  if (node.getName() == "protein") {
    proteinName = node.getString("id");
    proteinLength = node.getInt("length");
  }
  
  if (node.getName() == "rel_ref"){
    rel_ref.append(node.getString("ipr_ref"));
  }
  
    

  //////////////INTERPRO//////////////

  if (node.getName()=="interpro") {
    rInterpro = node.getString("name");
  
    
    /* SILENCE
     fill(100, 255, 0, 255);
     text(node.getString("name"), 10, y+10);
     y=y+15;
     SILENCE */

    //new interpro node
    if (!ipID.isEmpty())
    {

      tempMatches.add( new Match(matchID, node.getString("dbname"), tempLocations));
      tempInterpros.add( new Interpro(IPRid, ipID, descriptions, tempMatches));

      //Start Debug info
      println("I wrote a new Interpro with id "+ IPRid + " and name " + ipID + " with #" + tempMatches.size() + " matches");
      println("The "+tempMatches.size()+" match names inhere: " );
      for (int j=0; j<tempMatches.size();j++) 
      {
        Match match_object = tempMatches.get(j);
        println(">" + match_object.id);
      }
      //End debug info

      //destruct tempLocations
      tempLocations.clear();
      tempMatches.clear();
      descriptions.clear();
      matchID = "";
      println("I cleared the tempMatches");
    }

    ipID = node.getString("name");
    IPRid = node.getString("id");
  }

  ////////////MATCH////////////////////

  if (node.getName()=="match") //We are in match
  {
     matchCounter++;
    rMatch = node.getString("id");
    if (matchID != node.getString("id")) //Are we in a new match?
    {
      if (!matchID.isEmpty()) //Is it not the first one?
      {

        //Write the old match
        tempMatches.add( new Match(matchID, node.getString("dbname"), tempLocations));
        println("I wrote a new instance in tempMatches " + matchID + " with #" + tempLocations.size() + " location(s)");
        println("I cleared the tempLocations");
        //destruct tempLocations
        tempLocations.clear();
      }
      else
      {
        //It is the first one so its emtpy anyway
      }
    }
    else
    {
      println ("We ARE STILL IN THE SAME MATCH");
    }
    matchID = node.getString("id");
  }


  /////////LOCATION///////////////

  if (node.getName() == "location") { 
    //println("Found Start" + node.getInt("start") + "End " + node.getInt("end"));

    float score=0;
    String scoreString = node.getString("score");


    if (scoreString.equals("NA")) {
      score=1.0;
      //println("Now its NA");
    }
    else 
    {
      //println("!!!" + node.getString("score") + "!!!");
      score=node.getFloat("score");
    }


    tempLocations.add(new Location(node.getInt("start"), node.getInt("end"), score));  // Start by adding one element


    println("Location added to tempLocations, my interproID is: " +rInterpro + ", and mID " + rMatch +" with start " + node.getInt("start")+" end " +node.getInt("end"));


    

    y=y+5;
  }



  printDepth(Depth);
  //println(node.getChildren());

  Depth++; 
  for (int i = 0; i < node.getChildCount(); i++)
  {
    search(node.getChild(i), Depth, rInterpro, rMatch);
  }
} 


