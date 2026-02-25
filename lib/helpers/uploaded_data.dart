class UploadedData {
  static List<Map<String, dynamic>> allData = [];

  static void addData(Map<String, dynamic> data) {
    allData.add(data);
  }

  static void updateData(int index, Map<String, dynamic> data) {
    allData[index] = data;
  }

  static void deleteData(int index) {
    allData.removeAt(index);
  }
}