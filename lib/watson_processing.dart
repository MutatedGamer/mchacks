import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

final String baseUrl = "https://gateway.watsonplatform.net/natural-language-understanding/api";
final String version = "/v1/analyze?version=2018-11-16";
final String apiKey = "CrFaIlAl4J3tsFYqyUfKrvCxgg523kHgQBj_5ZZ6fgAw";

final auth = base64Encode(utf8.encode("apikey:$apiKey"));

class Watson {

  /// Given a selection of the GET request parameters documented here:
  /// https://console.bluemix.net/apidocs/natural-language-understanding#analyze-text-get
  /// Returns the completed URL to be used for the GET request
  static String buildURL(String text, List<String> featureList, Map<String, String> params) {
    String encodedText = Uri.encodeQueryComponent(text);
    String features = featureList.elementAt(0).toString();
    for (var i = 1; i < featureList.length; i++) {
      features += "," + featureList.elementAt(i).toString();
    }

    String url = "$baseUrl$version&text=$encodedText&features=$features";
    params.forEach((k,v) => url += "&$k=$v");

    return url;
  }

  /// Makes a GET request, given a URL, and returns the response as a Future<Response>
  static Future<http.Response> makeGETRequest(String url) async {
    return http.get(Uri.parse(url), headers: {"Authorization":"Basic $auth"});
  }

  /// Returns the shortest keyword from a String as a Future<String>
  static Future<String> getShortestKeyword(String text) async {
    var response = await makeGETRequest(buildURL(text, ["keywords"], {"keywords.limit": "10"}));
    var keywordList = json.decode(response.body)['keywords'];
    List<String> keywords = new List();
    for (Map<String, dynamic> keywordInfo in keywordList) {
      keywords.add(keywordInfo['text']);
    }
    // find shortest keyword
    String shortestKeyword = keywords[0];
    for (String keyword in keywords) {
      if (keyword.split(" ").length < shortestKeyword.split(" ").length) {
        shortestKeyword = keyword;
      }
    }
    return shortestKeyword;
  }

  /// Returns a fill-in-the-blank version of the given String where the provided
  /// keyword is redacted.
  static String createFillInTheBlankAsString(String text, String keyword) {
    RegExp exp = new RegExp(r'\b'+"$keyword"+r'\b');
    List<String> visibleWordsList = text.split(exp);
    String result = visibleWordsList[0];
    for (var i = 1; i < visibleWordsList.length; i++) {
      result += "_____" + visibleWordsList[i];
    }
    return result;
  }

  static List<String> createFillInTheBlankAsList(String text, String keyword) {
    RegExp exp = new RegExp(r'\b'+"$keyword"+r'\b');
    List<String> visibleWordsList = text.split(exp);
    return visibleWordsList;
  }
}

void main() async {
  String text1 = "George Washington was the first president of the USA.";
  String keyword1 = await Watson.getShortestKeyword(text1);
  print(Watson.createFillInTheBlankAsString(text1, keyword1));
  print(Watson.createFillInTheBlankAsList(text1, keyword1));

  String text2 = "The capital of Washington State is Olympia.";
  String keyword2 = await Watson.getShortestKeyword(text2);
  print(Watson.createFillInTheBlankAsString(text2, keyword2));

  String text3 = "MIT is located in Cambridge, Massachusetts.";
  String keyword3 = await Watson.getShortestKeyword(text3);
  print(Watson.createFillInTheBlankAsString(text3, keyword3));
}