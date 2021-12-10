import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

/// Local DataBase to save User Blogs
class LocalDataBase {
  LocalDataBase._init();

  /// instance of the database
  static final LocalDataBase instance = LocalDataBase._init();
  static Database? _database;

  static const String _userTable = "UserTable";
  static const String _userBlogTable = "UserBlogTable";

  static const String _userID = "UserID";
  static const String _email = "email";
  static const String _age = "age";
  static const String _accessToken = "accessToken";
  static const String _currentProfile = "currentProfile";

  static const String _blogsIDs = "blogsIDs";
  static const String _blogsNames = "blogsNames";
  static const String _avatars = "avatars";
  static const String _avatarShapes = "avatarShapes";
  static const String _headerImages = "headerImages";
  static const String _titles = "titles";
  static const String _descriptions = "descriptions";
  static const String _allowAsk = "allowAsk";
  static const String _allowSubmission = "allowSubmission";

  /// Getter for the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB("DB.db");
    return _database!;
  }

  Future<Database> _initDB(final String filePath) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(final Database db, final int version) async {
    const String textType = "TEXT NOT NULL";
    const String boolType = "BOOLEAN NOT NULL";
    const String integerType = "INTEGER NOT NULL";

    await db.execute(
      """
        CREATE TABLE $_userTable ( 
          $_userID $textType, 
          $_email $textType,
          $_age $integerType,
          $_accessToken $textType,
          $_currentProfile $integerType
          )
        """,
    );

    await db.execute(
      """
        CREATE TABLE $_userBlogTable ( 
          $_blogsIDs "TEXT PRIMARY KEY NOT NULL", 
          $_blogsNames $textType,
          $_avatars $textType,
          $_avatarShapes $textType,
          $_headerImages $textType,
          $_titles $textType,
          $_descriptions $textType,
          $_allowAsk $boolType,
          $_allowSubmission $boolType
          )
        """,
    );
  }

  /// Insert into User Blog Table the
  /// [userID], [email], [age]
  /// [accessToken], [currentProfile]
  Future<void> insertIntoUserTable(
    final String userID,
    final String email,
    final int age,
    final String accessToken,
    final int currentProfile,
  ) async {
    final Database db = await instance.database;

    final Map<String, dynamic> values = <String, dynamic>{
      _userID: userID,
      _email: email,
      _age: age,
      _accessToken: accessToken,
      _currentProfile: currentProfile,
    };

    await db.insert(_userTable, values);
    return;
  }

  /// Insert into User Blog Table
  Future<void> insertIntoUserBlogTable(
    final String blogsIDs,
    final String blogsNames,
    final String avatars,
    final String avatarShapes,
    final String headerImages,
    final String titles,
    final String descriptions,
    final bool allowAsk,
    final bool allowSubmission,
  ) async {
    final Database db = await instance.database;

    final Map<String, dynamic> values = <String, dynamic>{
      _blogsIDs: blogsIDs,
      _blogsNames: blogsNames,
      _avatars: avatars,
      _avatarShapes: avatarShapes,
      _headerImages: headerImages,
      _titles: titles,
      _descriptions: descriptions,
      _allowAsk: allowAsk,
      _allowSubmission: allowSubmission,
    };

    try {
      await db.insert(_userBlogTable, values);
    } on Exception {
      return;
    }
    return;
  }

  /// To get the Main Data of the User
  Future<Map<String, dynamic>> getUserTable() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> user = await db.query(_userTable);
    if (user.isNotEmpty)
      return user[0];
    else
      return <String, dynamic>{};
  }

  /// To get the Blog Data of the User
  Future<List<Map<String, dynamic>>> getUserBlogTable() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> blogs = await db.query(_userBlogTable);
    return blogs;
  }

  /// Delete all rows in User Table
  Future<void> deleteUserTable()async{
    final Database db = await instance.database;
    await db.delete(_userTable);
  }
  /// Delete all rows in User Blog Table
  Future<void> deleteUserBlogTable()async{
    final Database db = await instance.database;
    await db.delete(_userBlogTable);
  }

  /// Delete all both  User Table and User Blog Table
  Future<void> deleteAllTable()async{
    final Database db = await instance.database;
    await db.delete(_userTable);
    await db.delete(_userBlogTable);
  }

  /// To Close the instance of the db
  Future<void> close() async {
    final Database db = await instance.database;
    await db.close();
  }
}
