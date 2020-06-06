public class Node extends Viewport{
  private Country value;
  private CountryColor colorCode;
  private Node parent;
  private ArrayList<Node> children;
  private int descendants = 1;
  public Node(Country value, Node parent, CountryColor colorCode){
    super();
    this.value = value;
    this.parent = parent;
    this.children = new ArrayList<Node>();
    if( colorCode == null ) colorCode = new CountryColor(255,255,255);
    this.colorCode = colorCode;
  }

  public Country getValue(){
    return this.value;
  }
  public void setupTree(){
    this.setDescendantAmount();
    this.sortDescendants();
  }
  public void sortDescendants(){
    ArrayList<Node> children = new ArrayList<Node>();
    while(!this.children.isEmpty()){
      Node max = this.children.get(0);
      for(int i = 1; i < this.children.size(); i++){
        Node target = this.children.get(i);
        if(target.getDescendantAmount() > max.getDescendantAmount())
          max = target;
      }
      children.add(max);
      this.children.remove(max);
    }
    this.children = children;
    for(Node child : this.children){
      child.sortDescendants();
    }
  }
  public int setDescendantAmount(){
    int descendants = this.children.size() == 0 ? 1 : 0; //When it's a leaf, we give it an initial value
    for(Node child : this.children){
      descendants += child.setDescendantAmount(); //Recursively add the values 
    }
    this.descendants = descendants;
    return this.descendants;
  }
  
  public int getDescendantAmount(){
    return this.descendants;
  }
  
  public void setParent(Node parent){
    this.parent = parent;
  }
  
  public String getId(){
    return value.getCountryCode();
  }
  
  public Node getParent(){
    return this.parent;
  }

  public boolean isRoot(){
    return this.parent == null;
  }
  
  public boolean isLeaf(){
    return this.children.isEmpty();
  }
  public int getChildrenAmount(){
    return this.children.size();
  }
  public ArrayList<Node> getChildren(){
    return this.children;
  }
  public Node getChildAt(int index){
    return this.children.get(index);
  }
  public void addChild(Node child){
    this.children.add(child);
  }

  public void draw(float offset, int level){
    if(this.isHighlighted())
      fill(102, 102, 255);
    else
      fill(this.colorCode.r, this.colorCode.g, this.colorCode.b);
    rect(this.getX() + offset, this.getY() + offset, this.getWidth() - (2.0f * offset), this.getHeight() - (2.0f * offset));
    textSize(14);
    textAlign(CENTER, CENTER);
    if(this.isHighlighted())
      fill(255);
    else
      fill(0);
    if((this.colorCode.getR() * 0.299 + this.colorCode.getG() * 0.587 + this.colorCode.getB() * 0.114) > 186){
      fill(0);
    } else{
      fill(255);
    } 
    //Depending on the level of detail, we display different things
    switch(level){
      case 0:
        text(this.getId(), this.getCenterX(), this.getCenterY());
        break;
      case 1:
        text(this.getValue().getCountryName().split(",")[0], this.getCenterX(), this.getCenterY());
        text("Pob: " + Double.toString(this.getValue().getPopulation()), this.getCenterX(), this.getCenterY() + 15);
        break;
      case 2:
        text(this.getValue().getCountryName(), this.getCenterX(), this.getCenterY());
        text("Población: " + Double.toString(this.getValue().getPopulation()), this.getCenterX(), this.getCenterY() + 15);
        text("IPC: " + Double.toString(this.getValue().getCpi()), this.getCenterX(), this.getCenterY() + 30);
        text("PIB: " + Double.toString(this.getValue().getGdp()), this.getCenterX(), this.getCenterY() + 45);
        break;
    }
    for(int i = 0; i < this.getChildrenAmount(); i++)
      this.getChildAt(i).draw(offset, level);
  }

  //@Override
  public String toString(){
    String parentID = ""; //ad-hoc
    if(!this.isRoot())
      parentID = this.getParent().getId();
    String childrenIDs = "[";
    for(int i = 0 ; i < this.children.size(); i++)
      childrenIDs += this.children.get(i).getId() + " ";
    childrenIDs += "]";
    return "VALUE:"       + this.getDescendantAmount()  + "," +
           "PARENT_ID:"   + parentID    + "," +
           "CHILDREN_IDS" + childrenIDs;
  }

  public void printTree(){
    println(this.toString());
    for(int i = 0; i < this.children.size(); i++)
      this.children.get(i).printTree();
  }
}
