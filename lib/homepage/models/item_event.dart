// untuk admin : agar bisa menambahkan event 

class Item {
  final String bookTitle;
  final int title;
  final String description;
  static final List<Item> listEvent = [];
  
  Item(this.bookTitle, this.title, this.description);

  get fields => null;
}