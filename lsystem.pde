/*----------------------------------
    
 Copyright by Diana Lange 2015
 Don't use without any permission. Creative Commons: Attribution Non-Commercial.
    
 mail: kontakt@diana-lange.de
 web: diana-lange.de
 facebook: https://www.facebook.com/DianaLangeDesign
 flickr: http://www.flickr.com/photos/dianalange/collections/
 tumblr: http://dianalange.tumblr.com/
 twitter: http://twitter.com/DianaOnTheRoad
 vimeo: https://vimeo.com/dianalange/videos
  
 Based on a tutorial by Paul Bourke:
 http://paulbourke.net/fractals/lsys/
  
 You may also read Daniel Shiffman's chaptor about L-Systems:
 http://natureofcode.com/book/chapter-8-fractals/
    
 -----------------------------------*/
 
// erste Version: Feb. 2014
// Ã�berarbeitung: 05.07.2015
// Autoskalierung: 06-07.07.2015
// L-Systeme: 08.07.2015
 

final static boolean DEBUG = false;
LDrawer lmayer;
PFont font = null;
boolean showText = true;
 
void setup ()
{
  size (700, 700);
  smooth();
 
  lmayer = new LDrawer();
}
 
void draw() {
 
  background (#333333);
 
  stroke(#EEEEEE);
  strokeWeight(1.5);
  lmayer.display();
 
  if (showText) {
    displayText();
  }
}
 
void displayText() {
  if (font == null) {
    font = createFont("Arial", 12);
  }
 
  fill(255);
  float fSize = height / 60.0;
  textFont(font, fSize);
  textAlign(LEFT, BOTTOM);
 
 
  String s = lmayer.generator.noFormatString();
  float x = lmayer.border;
  float y = height - lmayer.border - fSize * 0.5;
  for (int i = 0; i < s.length(); i++) {
    text(s.charAt(i), x, y);
 
    x += textWidth(s.charAt(i));
    if (x > width - lmayer.border) {
      x = lmayer.border;
      y += fSize * 1.5;
    }
  }
}
 
void keyPressed () {
  if (key == '+') {
    lmayer.increaseIteration();
  } else if (key == '-') {
    lmayer.decreaseIteration();
  } else if (key == ' ') {
    lmayer.recreate();
  } else if (key == 'p') {
    println(lmayer.getGenerator());
  } else if (key == 'i') {
    println(lmayer.getGenerator().getText());
  } else if (keyCode == RIGHT) {
    lmayer.setAngle(lmayer.getAngle() + PI / 90);
  } else if (keyCode == LEFT) {
    lmayer.setAngle(lmayer.getAngle() - PI / 90);
  } else if (key == 't') {
    showText  = !showText;
  }
}
 
void mousePressed() {
  if (mouseButton == RIGHT) {
    lmayer.setAngle(map (mouseY, 0, height, 0, TWO_PI));
  }
  else {
    lmayer.reset();
  }
}
 
 
 
 
 
 
 
/**
 * Class for creating a lindenmayer drawing.
 * It contains a set of pre-setted Rulesets and
 * a Generator which will perform the replacements
 * based on an axiom and the replacement rules given by the Ruleset.
 * It will also interpret the final lindenmayer string (which is a string including the instructions for the drawing)
 */
class LDrawer {
   
  // stuff for position and look of the drawing
  float x;
  float y;
  float angle;
  float sw;
  float lineLength = 1;
  float lineLengthFactor = 1.36;
  float startX = 0;
  float angleSteps = PI / 6;
  float lHeight = -1;
  float lWidth = -1;
   
  // generator will hold and create the lindenmayer string
  LSystemGenerator generator;
   
  // run the replacement rules "iterations"-times
  int iterations = 5;
   
  // width of the border
  int border = (int) 50;
 
  LDrawer() {
    // array for all rules, that will be included in the ruleset
    LRule [] rules = new LRule[2];
     
    // new Replacement rule
    LRandomRule rRule = new LRandomRule("F", "FF");
     
    // alternatives for the replacement rule
    rRule.addReplacement("F-F[X]+F[X]");
    rRule.addReplacement("FF+[+F-F-F]-[-F+F+F]");
 
     // new Replacement rule
    LRandomRule rRule2 = new LRandomRule("X", "F-[[X]+X]+F[+FX]-X");
    // alternative for the second replacement rule
    rRule2.addReplacement("F[+X]F[-X]+X");
     
    // add the rules to the array
    rules [0] = rRule;
    rules [1] = rRule2;
 
    // create the rulset based on an axiom "X" and the replacement rules
    LRuleSet rset = new LRuleSet ("X", rules);
 
    // create the Lindenmayer creator (which will create the lindenmayer string based on the axiom and the replacement rules)
    generator = new LSystemGenerator(rset);
 
    // run the replacement rules "iterations"-times to create the lindenmayer string
    for (int i = 0; i < iterations; i++) {
      generator.update();
    }
  }
   
  LSystemGenerator getGenerator() {
    return generator;
  }
 
  /**
   * Get a random rulset from these included, pre-setted Rulesets.
   */
  LRuleSet getRuleset() {
    LRuleSet rset = null;
 
    int rVal = (int) random(11);
 
    if (rVal == 0) {
      LRandomRule rRule = new LRandomRule ("F", "FF");
      rRule.addReplacement("F-F[X]+F[X]");
      rRule.addReplacement("FF+[+F-F-F]-[-F+F+F]");
 
      LRandomRule rRule2 = new LRandomRule ("X", "F-[[X]+X]+F[+FX]-X");
      rRule2.addReplacement("F[+X]F[-X]+X");
 
      rset = new LRuleSet("X", new LRule[] {rRule, rRule2});
    } else if (rVal == 1) {
      LRandomRule rRule = new LRandomRule ("F", "FF");
      rRule.addReplacement("F");
 
      LRandomRule rRule2 = new LRandomRule ("X", "F[+X]F[-X]+X");
      rRule2.addReplacement("F[+X]F[-X]FX");
      rRule2.addReplacement(">[-FX]+FX");
      rRule2.addReplacement("<[-FX]+FX");
 
      rset = new LRuleSet("X", new LRule[] {rRule, rRule2});
    } else if (rVal == 2) {
      LRandomRule rRule = new LRandomRule ("X", "<[-FX]+FX");
      rRule.addReplacement("[-FX]+FX");
      rRule.addReplacement("<<[-FX]+FX");
      rRule.addReplacement("F+[-X]+X");
 
      rset = new LRuleSet("FX", new LRule[] {rRule});
    } else if (rVal == 3) {
      LRandomRule rRule = new LRandomRule ("F", "FF+[+F-F-F]-[-F+F+F]");
      rRule.addReplacement("FF+[-F+F+F]-[+F-F-F]");
      rRule.addReplacement("F-F[X]+F[X]");
 
      rset = new LRuleSet("F", new LRule[] {rRule});
    } else if (rVal == 4) {
      LRandomRule rRule = new LRandomRule ("F", "F[+FF][-FF]F[-F][+F]F");
      rRule.addReplacement("FF+[+F-F-F]-[-F+F+F]");
      rRule.addReplacement("-F[X]+F[X]");
      rset = new LRuleSet("F", new LRule[] {rRule});
    } else if (rVal == 5) {
      LRandomRule rRule = new LRandomRule ("F", ">F<");
      rRule.addReplacement(">FF<");
      rRule.addReplacement("FF");
      rRule.addReplacement("<F>");
      LRule rRule2 = new LRule ("a", "F[+x]Fb");
      LRule rRule3 = new LRule ("b", "F[-y]Fa");
      LRule rRule4 = new LRule ("x", "a");
      LRule rRule5 = new LRule ("y", "b");
 
      rset = new LRuleSet("a", new LRule[] {rRule, rRule2, rRule3, rRule4, rRule5});
    } else if (rVal == 6) {
      LRandomRule rRule = new LRandomRule ("X", "X[-FFF][+FFF]FX");
      rRule.addReplacement("X<[-FFF][+FFF]FX");
      rRule.addReplacement("X[-FFF]>[+FFF]FX");
      rRule.addReplacement("F-F[+FY]+F[-FY]");
      LRule rRule2 = new LRule ("Y", "YFX[+Y][-Y]");
 
      rset = new LRuleSet("Y", new LRule[] {rRule, rRule2});
    } else if (rVal == 7) {
      LRandomRule rRule = new LRandomRule ("F", "F[-F]F[+F][F]");
      rRule.addReplacement("FF");
      rRule.addReplacement("F[-F]<F>[+F][F]");
      rRule.addReplacement("FF+[+F-F-F]-[-F+F+F]");
      rRule.addReplacement("<F>[-F]F[+F][F]");
 
 
      rset = new LRuleSet("F", new LRule[] {rRule});
    } else if (rVal == 8) {
      LRandomRule rRule = new LRandomRule("V", "[+++W][--W]XV");
      rRule.addReplacement("[++W]F[-W]XF");
      rRule.addReplacement("[+F]F[-F]");
      rRule.addReplacement("[++W]>[---W]XV");
      rRule.addReplacement("[-F]FF[+F]");
      rRule.addReplacement(">VV<");
      LRule rRule2 = new LRule("W", "X[-W]Z");
      LRandomRule rRule3 = new LRandomRule("X", "W[+X]Z");
      rRule3.addReplacement("X[-FF][+FF]");
      LRandomRule rRule4 = new LRandomRule("Y", "[+FF]YZ");
      rRule4.addReplacement("[++FF]YZ");
      rRule4.addReplacement("[+FF]>YZ");
      LRandomRule rRule5 = new LRandomRule("Z", "[-FF]F");
      rRule5.addReplacement("[-F][+F]Z");
      rRule5.addReplacement("F>[+FF][-FF]<F[-F][+F]F");
 
      rset = new LRuleSet("FVFZFX", new LRule[] {rRule, rRule2, rRule3, rRule4, rRule5});
    } else if (rVal == 9) {
      LRandomRule rRule = new LRandomRule("F", "FF-[XY]+[XY]");
      rRule.addReplacement("[-XY]F[+YX]FF");
      rRule.addReplacement("FF");
      LRule rRule2 = new LRule("X", "+FY");
      LRule rRule3 = new LRule("Y", "-FX");
 
 
      rset = new LRuleSet("F", new LRule[] {rRule, rRule2, rRule3});
    } else {
 
      LRandomRule rRule = new LRandomRule ("F", ">FF<-[XY]+[XY]");
      rRule.addReplacement("F[+FF][-FF]F[-F][+F]F");
      rRule.addReplacement("FF-[<XY>]+[>XY<]");
      LRandomRule rRule2 = new LRandomRule ("X", "+FY");
      rRule2.addReplacement("F+F[+FY]");
      LRandomRule rRule3 = new LRandomRule ("Y", "-FX");
      rRule3.addReplacement("F-F[-FX]");
       
      rset = new LRuleSet("F", new LRule[] {rRule3, rRule2, rRule});
    }
 
    return rset;
  }
   
  float getAngle() {
    return angleSteps;
  }
 
  void setAngle(float angleSteps) {
    this.angleSteps = angleSteps;
    // width / height of the drawing needs to be re-calculated
    lHeight = lWidth = -1;
    lineLength = 1;
    startX = 0;
  }
 
  void increaseIteration() {
    iterations++;
     // width / height of the drawing needs to be re-calculated
    lHeight = lWidth = -1;
    generator.update();
    startX = 0;
  }
   
  void decreaseIteration() {
    // no negative values are allowed for the number of iterations
    iterations = --iterations < 0 ? 0 : iterations;
     
    // create new lindenmayer string
    recreate();
  }
   
  /**
   * Create a new drawing with default-Values. The default number of iterations is 4.
   * A random Ruleset will be chosen.
   * A new lindenmayer string will be created.
   */
  void reset() {
 
    iterations = 4;
    generator.setRuleset(getRuleset());
    recreate();
  }
 
  /**
   * Recreate the lindenmayer string with same untouched ruleset.
   * Due the fact, that the replacement rules are chosen randomly (by a given likelihood)
   * the lindenmayer string and the resulting drawing will look differently each time recreate() is called.
   */
  void recreate() {
     
    // start with an empty lindenmayer string
    generator.reset();
     
     // width / height of the drawing needs to be re-calculated
    lHeight = lWidth = -1;
    lineLength = 1;
    startX = 0;
 
    // run the replacement rules "iterations"-times to create the lindenmayer string
    for (int i = 0; i < iterations; i++) {
      generator.update();
    }
  }
 
  void display() {
     
    // draw the borders
    noFill();
    strokeWeight(1);
    rect(border, border, width-2*border, height-2.5*border);
     
    // because the lineLength will be multiplied and divided during the drawing process it's necessary to save an untouched version of it and restore its original value after the drawing
    float tempLineLength = lineLength;
     
    // This will save and restore the drawing state
    SPoint sp = new SPoint();
 
    // start angle of each drawing
    angle = -PI/2;
     
    // start location of each line
    x = width/2;
    y = height - border * 1.5;
 
    // calculating position and size of the drawing. Goal: Keep the drawing within the borders (with a certain padding to it)
    if (lHeight != -1) {
      float heightFactor = (height - 3.5 * border) / (float) lHeight;
      float widthFactor= (width - 3 * border) / (float) lWidth;
      float scaleFactor = heightFactor < widthFactor ? heightFactor : widthFactor;
 
      lineLength *= scaleFactor;
 
      float w = lWidth * scaleFactor;
 
      float leftHalf = dist(width/2, 0, startX, 0);
      leftHalf *= scaleFactor;
      x = (width - w) / 2 + leftHalf;
 
      if (DEBUG) {
        fill(0);
        noStroke();
        rect(width/2 - leftHalf, border, w, height - 2*border);
 
        fill(255, 40);
        rect((width - w) / 2, border, w, height - 2*border);
 
        stroke(255, 0, 0);
        line(width/2, border, width/2, height - border);
 
        stroke(120, 0, 0);
        line((width - w) / 2 + leftHalf, border, (width - w) / 2 + leftHalf, height - border);
 
        stroke(255);
      }
    }
 
 
     // for calculating the width and height of the drawing
    float minY = y;
    float maxX = 0, minX = width;
 
    // current strokeWeight
    sw = 1;
     
    // end location of each line
    float x2, y2;
 
    // get the whole lindenmayer string
    String s = generator.getText();
     
    // current letter of the lindenmayer string
    char c;
 
    // iterate through each letter of the lindenmayer string
    for (int i = 0; i < s.length(); i++) {
       
      // get the current letter
      c = s.charAt(i);
 
      switch(c) {
       case "F": //  case "F" with  case 'F' if you work in Java mode
       //case 'F':
         
        // calculate end of the line 
        x2 = x + cos(angle) * lineLength;
        y2 = y + sin(angle) * lineLength;
 
        // Just draw it, when the height of the drawing is calculated
        if (lHeight != -1) {
          strokeWeight(sw);
          line (x, y, x2, y2);
        }
         
        // the start of the next line will be the end of the current line
        x = x2;
        y = y2;
         
        // reduce the strokeWeight for the next line
        sw *= 0.99;
         
        // keep the strokeWeight within reasonable range
        if (sw < 0.5) {
          sw = 0.5;
        }
        break;
      //case '|':
      case "|":
        // Reverse direction: turn angle 180Â°
        angle *= PI;
        break;
      //case '>':
      case ">":
         
        // Multiply the line length by the line length scale factor
        lineLength *= lineLengthFactor;
        break;
      //case '<':
      case "<":
         
        // Divide the line length by the line length scale factor
        lineLength /= lineLengthFactor;
        break;
      case "f":
      //case 'f':
        // Move forward by line length without drawing a line   
        x2 = x + cos (angle) * lineLength;
        y2 = y + sin (angle) * lineLength;
 
        x = x2;
        y = y2;
 
        break;
      //case '-':
      case "-":
        // Turn right by angleSteps
        angle -= angleSteps;
        break;
      //case '+':
      case "+":
         
        // Turn left by angleSteps
        angle += angleSteps;
        break;
      //case '[':
      case "[":
         
        // Push current drawing state onto stack
        sp.push();
        break;
      //case ']':
      case "]":
         
        // Pop current drawing state from the stack
        sp.pop();
        break;
      }
       
      // again stuff for calculating the width and height of the drawing
      if (lHeight == -1 && y < minY) {
        minY = y;
      }
 
      if (lWidth == -1 && x < minX) {
        minX = x;
      }
      else if (lWidth == -1 && x > maxX) {
        maxX = x;
      }
    }
     
    // again stuff for calculating the width and height of the drawing
    if (lHeight == -1) {
      lHeight = abs(minY - height + border * 1.5);
    }
 
    if (lWidth == -1) {
      lWidth = dist(minX, 0, maxX, 0);
      startX = minX;
    }
 
    // restore original lineLength value
    lineLength = tempLineLength;
 
  }
 
  /**
   * Class for saving and restoring the drawing state
   */
  class SPoint {
     
    // Stack of drawing states
    ArrayList<SavePoint> sv = new ArrayList<SavePoint>();
    
    void push() {
       
      // add drawing state at the beginning of the stack
      sv.add(0, new SavePoint(x, y, angle, sw, lineLength));
    }
 
    void clear() {
      sv.clear();
    }
 
 
    void pop() {
       
      // restore drawing state and remove the state from the stack
      if (sv.size() > 0) {
        SavePoint p = sv.get(0);
        x = p.x;
        y = p.y;
        angle = p.angle;
        sw = p.sw;
        lineLength = p.lineLength;
        sv.remove(p);
      }
    }
  }
}
 
 
/**
 * Basic class for all rules. It includes a lookup and a replacement
 * ("replacement" will replace the "lookup")
 */
class LRule {
  String lookup;
  String replacement;
 
  LRule (String l, String r) {
    lookup = l;
    replacement = r;
  }
   
  String getLookup() {
    return lookup;
  }
 
  String getReplacement() {
    return replacement;
  }
   
  void setRandomProbability(int minVal, int maxVal) {
    // nothing to do here. This method will be used in inherit classes
  }
   
  String noFormatString() {
    return (lookup + " -> " + replacement);
  }
   
  String toString() {
    String s = "";
    s += lookup + "\t -> " + replacement;
    return s;
     
  }
}
 
/**
 * Class that holds one lookup and multiple replacements.
 * The executed replacement will be chosen randomly within a given likelihood.
 * (one of the "replacements" will replace the "lookup")
 */
class LRandomRule extends LRule {
   
  // Likelihood of each replacement to be chosen
  int[] props;
   
  LRandomRule (String l, String r) {
    // set the lookup and the first possible replacement
    super(l, r);
    props = new int[] {10};
  }
 
  /**
   * Add a replacement rule (random likelihood will be setted too).
   */
  void addReplacement(String replacement) {
    this.replacement += "," + replacement;
 
    props = append(props, (int) random(1, 4));
  }
 
  /**
   * Calculate the sum of all likelihoods.
   */
  int getPropsSum() {
    int summe = 0;
    for (int i : props) {
      summe += i;
    }
 
    return summe;
  }
 
  /**
   * Set a random likelihood for all replacements within the given range.
   * The likelihoods will be sorted beginning with the highest value.
   * This means, that the first replacement will be more likely to be chosen.
   */
  void setRandomProbability(int minVal, int maxVal) {
     
    // minVal should be smaller than maxVal
    if (minVal > maxVal) {
      int temp = minVal;
      minVal = maxVal;
      maxVal = temp;
    }
     
    // minVal should at least be 1
    if (minVal < 1) {
      minVal = 1;
    }
     
    // set all random likelihoods
    for (int i = 0; i < props.length; i++) {
      props[i] = (int) random(minVal, maxVal);
    }
     
    // sort the likelihood
    props = sort(props);
     
    // reverse it
    props = reverse(props);
     
    // the distance of the first and second replacement should at least be 1
    if (props.length > 1 && abs(props[0] - props[1]) <= 1) {
      props[0]+= 1;
    }
  }
 
  /*
   * Calculates the index of the replacement rule based on a number. The number (num) is within the range of [0, getPropsSum()]
   */
  int getIndex(int num) {
    int summe = 0;
 
    for (int i = 0; i < props.length; i++) {
      summe += props[i];
 
      if (summe > num) {
        return i;
      }
    }
 
    return props.length - 1;
  }
 
 
  /**
   * Get a random replacement for the lookup
   */
  String getReplacement() {
     
    // Split the replacement string at each comma
    String[] splitted = split(replacement, ',');
      
    // get the index of the replacement which should be executed
    int index = getIndex((int) random(getPropsSum()));
 
    // return the chosen replacement
    return splitted[index];
  }
   
   
  int getNumberOfDigits() {
    int maxNum = 0;
    for (int i : props) {
      if (i > maxNum) {
        maxNum = i;
      }
    }
     
    return ("" + maxNum).length();
  }
   
   String noFormatString() {
    String s = "";
 
    s += lookup + " -> {" + replacement + "} with {";
     
    for (int i : props) {
      s += nf(i, getNumberOfDigits()) + ":";
    }
    s = s.substring(0, s.length() - 1);
    s += "}";
     
    return s;
  }
   
  String toString() {
    String s = "";
     
    String[] splitted = split(replacement, ',');
     
    s += lookup + "\t -> [" + nf(props[0], getNumberOfDigits()) + "] " + splitted[0] + "\n";
     
    for (int i = 1; i < splitted.length; i++) {
      s += "\t -> [" + nf(props[i], getNumberOfDigits()) + "] " + splitted[i] + "\n";
    }
    return s;
     
  }
}
 
/**
 * Class that contains an axiom and an array of rules.
 */
class LRuleSet {
  String axiom;
  LRule[] rules;
 
  LRuleSet (String a, LRule [] r) {
    axiom = a;
    rules = r;
  }
 
  void setRandomProbability(int minVal, int maxVal) {
    for (LRule r : rules) {
      r.setRandomProbability(minVal, maxVal);
    }
  }
   
  LRule getRule(int index) {
    index = constrain(index, 0, rules.length - 1);
    return rules[index];
  }
   
  int getLength() {
    return rules.length;
  }
   
  String noFormatString() {
    String s = "Axiom: " + axiom + " | Rules:";
    for (int i = 0; i < rules.length; i++) {
      s += " #" + i + ": " + rules[i].noFormatString();
    }
    return s;
  }
 
 
  String toString() {
    String s = "";
    s += "Axiom: " + axiom;
    s += "\nRules:\n";
    s += "Lookup\t -> [Likelihood] Replacement\n";
    for (LRule l : rules) {
      s += l;
    }
 
    return s;
  }
}
 
/**
 * This class will perform the replacements
 * based on an axiom and the replacement rules given by the Ruleset.
 * It will create the final lindenmayer string (which is a string including the instructions for the drawing)
 */
class LSystemGenerator {
   
  // Ruleset containing the replacement rules and the axiom
  LRuleSet ruleset;
   
  // The current lindenmayer string
  String lSystem;
   
  // the start of the lindenmayer string = axiom of the ruleset
  String lStystemStart;
 
  LSystemGenerator (LRuleSet ruleset) {
    this.ruleset = ruleset;
    lSystem = ruleset.axiom;
    lStystemStart = lSystem;
  }
   
  /**
   * Get the lindenmayer string
   */
  String getText() {
    return lSystem;
  }
   
  /**
   * Set a new rulset.
   * The lindenmayer string will just include the axiom after calling setRuleset().
   */
  void setRuleset(LRuleSet ruleset) {
    this.ruleset = ruleset;
    lSystem = ruleset.axiom;
    lStystemStart = lSystem;
  }
   
  /**
   * Start over with empty lindenmayer string and random likelihoods for each replacement rule
   */
  void reset () {
    lSystem = lStystemStart;
    ruleset.setRandomProbability(0,10);
  }
   
  /**
   * Perform all replacements based on the rulesets
   */
  void update() {
    LRule rule;
     
    // iterate over all rules
    for (int i = 0; i < ruleset.getLength(); i++) {
      rule = ruleset.getRule(i);
 
      int j = 0;
      while (true) {
         
        j = lSystem.indexOf(rule.getLookup(), j);
        if (j == -1) {
          break;
        }
         
        /*
         * Cut the current lindenmayer string to 3 parts:
         * First part includes everything that's before the replacement
         * second part includes what should be replaced / is replaces
         * Last part includes everything that's after the replacement
         */
        String beforeCut = lSystem.substring(0, j);
        String repleacement = rule.getReplacement();
        String afterCut = lSystem.substring(j + 1, lSystem.length());
         
        // Put everthing together again
        lSystem = beforeCut + repleacement + afterCut;
         
        j += repleacement.length();
 
      }
 
    }
 
  }
   
  String noFormatString() {
    return ruleset.noFormatString();
  }
   
  String toString() {
    return "" + ruleset;
  }
}
 
/**
 * Class for saving and restoring the drawing state
 */
class SavePoint {
  float angle;
  float x;
  float y;
  float sw;
  float lineLength;
 
  SavePoint (float x, float y, float angle, float sw, float lineLength) {
    this.angle = angle;
    this.x = x;
    this.y = y;
    this.sw = sw;
    this.lineLength = lineLength;
  }
}
