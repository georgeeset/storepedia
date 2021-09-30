class StringProcessor{

  ///generate search keywords and remove articles that does not
  ///give direct meaning to the search item been searched.
   ///check if element is one of the excluded elements.
  ///so we dont have to add unnecessary Strings to search list and 
  ///improve the search speed.
  ///ALL is converted UPPERCASE  so to help us compare accurately
  
    List<String> searchKeywords(String searchString){
   // print(combinedString);
    var combinedString=searchString.toUpperCase();
    var splitString=combinedString.split(' ');
    var removedRepititionsAndArticles=splitString.toSet().toList();
   // print(removedRepititionsAndArticles);
    removedRepititionsAndArticles.removeWhere((element) => isArticle(element));
   print('completeList ${removedRepititionsAndArticles.toString()}');
    return removedRepititionsAndArticles;
  }

  ///check if element is one of the excluded elements.
  ///so we dont have to add unnecessary Strings to search list and 
  ///improve the search speed.
  ///ALL text must be UPPERCASE  so to help us compare accurately
  bool isArticle(String element){
    var articleList= ['THE','AND','WITH','THE','FOR'];
    if(element.length<3){
      return true;
    }
    return articleList.contains(element);
  }
}