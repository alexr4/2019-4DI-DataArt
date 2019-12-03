class TreeData {
  int jsaIndex;
  JSONObject fields;

  TreeData(int jsaIndex, JSONObject fields) {
    this.jsaIndex = jsaIndex;
    this.fields = fields;
  }
}

class TreeList {
  HashMap<String, ArrayList<TreeData>> treesList;

  TreeList() {
    treesList = new HashMap<String, ArrayList<TreeData>>();
  }
  
  void addTree(TreeData tree){
    String libelle = tree.fields.getString("libellefrancais");
    if (treesList.get(libelle) != null) {
      treesList.get(tree.fields.getString("libellefrancais")).add(tree);
    } else {
      ArrayList<TreeData> trees = new ArrayList<TreeData>();
      trees.add(tree);
      treesList.put(libelle, trees);
    }
  }
}
