import java.util.*; 
int CANVAS_WIDTH_DEFAULT  = 1800;
int CANVAS_HEIGHT_DEFAULT = 960;

String FILE_PATH = "./data.json";
JSONObject data;

SquarifiedTreemap squarifiedTreemap;

void setup(){
  int canvasWidth = CANVAS_WIDTH_DEFAULT;
  int canvasHeight = CANVAS_HEIGHT_DEFAULT;
  //size(canvasWidth, canvasHeight);
  surface.setSize(canvasWidth, canvasHeight);
  Node root = buildTreeFrom(FILE_PATH);
  squarifiedTreemap = new SquarifiedTreemap(0.0f, 0.0f, (float)canvasWidth, (float)canvasHeight, root);
}

void draw(){
  squarifiedTreemap.draw();
}

void mouseMoved(){
  squarifiedTreemap.onMouseMoved(mouseX, mouseY);
}

void mousePressed(){
  squarifiedTreemap.onMousePressed(mouseX, mouseY, mouseButton);
}

Node buildTreeFrom(String filePath){
  data = loadJSONObject(filePath);
  Set<String> keys = data.keys();
  //TODO change colors
  //the whole world is the root of the tree
  Node root = new Node(new Country("World","World", 0.0f, 0.0f, 0.0f), null, null);
  int currentCont = 0;
  ArrayList<CountryColor> colorList = new ArrayList();
  colorList.add(new CountryColor(201,0,2));
  colorList.add(new CountryColor(0,168,86));
  colorList.add(new CountryColor(1,101,185));
  colorList.add(new CountryColor(255,124,0));
  colorList.add(new CountryColor(97,38,151));
  colorList.add(new CountryColor(255,243,1));
  for(String key : keys){
    //We need to iterate over every continent, which is an array of countries
    JSONArray continent = data.getJSONArray(key);
    Country continentValue = new Country(key,key, 0.0f, 0.0f, 0.0f);
    Node continentNode = new Node(continentValue, root, colorList.get(currentCont));
    int i = 0;
    int contSize = continent.size();

    while(i < contSize){
      //Get the country JSON
      JSONObject countryJSON = continent.getJSONObject(i);
      //Parsing JSON data into country code
      Country countryValue = new Country(countryJSON.getString("countryCode"),countryJSON.getString("countryName"), countryJSON.getDouble("population"), countryJSON.getDouble("gdp"), countryJSON.getDouble("cpi"));
      //Agreggating continent value
      continentValue.setPopulation( continentValue.getPopulation() + countryValue.getPopulation() );
      continentValue.setCpi( continentValue.getCpi() + countryValue.getCpi() );
      continentValue.setGdp( continentValue.getGdp() + countryValue.getGdp() );
      CountryColor tmp = new CountryColor(colorList.get(currentCont).getR(),colorList.get(currentCont).getG(),colorList.get(currentCont).getB());
      //Setting random hue to each different country in the continent
      tmp.setR((int)(tmp.getR()*random(0.8,0.95)));
      tmp.setG((int)(tmp.getG()*random(0.8,0.95)));
      tmp.setB((int)(tmp.getB()*random(0.8,0.95)));
      Node leaf = new Node(countryValue, continentNode, tmp);
      continentNode.addChild(leaf);
      i++;
    }
    continentValue.setCpi( continentValue.getCpi() / contSize );
    root.addChild(continentNode);
    root.getValue().setPopulation( continentValue.getPopulation() + root.getValue().getPopulation() );
    root.getValue().setCpi( continentValue.getCpi() + root.getValue().getCpi() );
    root.getValue().setGdp( continentValue.getGdp() + root.getValue().getGdp() );
    currentCont += 1;
  }
  root.getValue().setGdp( root.getValue().getGdp() / keys.size() );
  //Setting up important tree values
  root.setupTree();
  return root;
}
