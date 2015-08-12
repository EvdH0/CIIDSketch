//Contains the regex part

boolean isEnzyme(String txt) {


  String re8="(a)";  // Any Single Word Character (Not Whitespace) 1
  String re9="(s)";  // Any Single Word Character (Not Whitespace) 2
  String re10="(e)";  // Any Single Word Character (Not Whitespace) 3


  Pattern p = Pattern.compile(re8+re9+re10, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
  Matcher m = p.matcher(txt);
  if (m.find())
  {
    String w1=m.group(1);
    String w2=m.group(2);
    String w3=m.group(3);
    //System.out.print("("+w1.toString()+")"+"("+w2.toString()+")"+"("+w3.toString()+")"+"\n");
    return true;
  }
  String re2="(synthesis)";  // Word 1

  p = Pattern.compile(re2, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
  m = p.matcher(txt);
  if (m.find())
  {
    //String word1=m.group(1);
    //System.out.print("("+word1.toString()+")"+"\n");
    return true;
  }

  return false;
}

boolean isTransporter(String txt)
{



  String re2="(transport)";  // Word 1

  Pattern p = Pattern.compile(re2, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
  Matcher m = p.matcher(txt);
  if (m.find())
  {
    //String word1=m.group(1);
    //System.out.print("("+word1.toString()+")"+"\n");
    return true;
  }
  else return false;
}

boolean isRegulator(String txt)
{


  String re1=".*?";  // Non-greedy match on filler
  String re2="(RNA)";  // Word 1

  Pattern p = Pattern.compile(re2, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
  Matcher m = p.matcher(txt);
  if (m.find())
  {

    return true;
  }
  re1=".*?";  // Non-greedy match on filler
  re2="(DNA)";  // Word 1

  p = Pattern.compile(re2, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
  m = p.matcher(txt);
  if (m.find())
  {

    return true;
  }
  re1=".*?";  // Non-greedy match on filler
  re2="(operator)";  // Word 1

  p = Pattern.compile(re2, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
  m = p.matcher(txt);
  if (m.find())
  {

    return true;
  }

  re1=".*?";  // Non-greedy match on filler
  re2="(ribo)";  // Word 1

  p = Pattern.compile(re2, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
  m = p.matcher(txt);
  if (m.find())
  {

    return true;
  }

  re2="(receptor)";  // Word 1

  p = Pattern.compile(re2, Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
  m = p.matcher(txt);
  if (m.find())
  {

    return true;
  }
  return false;
}

