DB = Sequel.connect('sqlite://db.db')
DB.create_table? :images do
  String :color, :null=>false, :unique=>true
  String :url, :null=>false
end
DB.create_table? :recents do
  String :source, :null=>false, :unique=>true
  String :result, :null=>false, :unique=>true
end
