// Packages
import 'package:floor/floor.dart';

@entity
class MovieCategories {
  @primaryKey
  int? categoryId;
  String? categoryName;

  MovieCategories({
    this.categoryId,
    this.categoryName,
  });
}
