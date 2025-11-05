enum DocumentType { pdf, img, other }

class DocumentModel {
  final String name;
  final String path;
  final String url;
  DocumentType type;
  DocumentModel({
    required this.name,
    required this.path,
    required this.url,
    required this.type,
  });
}
