import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

final String url = "https://gateway.watsonplatform.net/natural-language-understanding/api";
final String version = "/v1/analyze?version=2018-11-16";
final String apiKey = "CrFaIlAl4J3tsFYqyUfKrvCxgg523kHgQBj_5ZZ6fgAw";

void main() {
  String features = "keywords";
  String keywordsLimit = "keywords.limit=10";
  String fullUrl = "$url$version&url=www.ibm.com&features=$features&$keywordsLimit";
  Uri uri = Uri.parse("$url$version&url=www.ibm.com&features=$features&keywords.limit=10");
  final auth = base64Encode(utf8.encode("apikey:$apiKey"));

  Future future = http.get(fullUrl, headers: {"Authorization":"Basic $auth"}).then((response)
  => print(response.body));
//  http.get(fullUrl, headers: {"Authorization":"Basic $auth"});
//  var client = new http.Client();
//  var request = new http.Request("GET", uri);
//  request.headers = {'authorization': "Basic $auth"};
//  Future future = client.send(request).then((response)
//  => response.stream.bytesToString().then((value)
//  => print(value.toString()))).catchError((error) => print(error.toString()));


//  var client = new http.Client();
//  var request = new http.MultipartRequest('POST', uri);
//  final auth = base64Encode(utf8.encode("apikey:$apiKey"));
//  request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
//  request.headers['authorization'] = "Basic $auth";
//
//  request.fields['text'] = jsonEncode("IBM is an American multinational technology company headquartered in Armonk, New York, United States, with operations in over 170 countries.");
//
//  request.fields['features'] = jsonEncode({
//    "entities": {
//      "emotion": true,
//      "sentiment": true,
//      "limit": 2,
//    },
//    "keywords": {
//      "emotion": false,
//      "sentiment": false,
//      "limit": 2,
//    }
//  });
//
//  Future future = client.send(request).then((response)
//  => response.stream.bytesToString().then((value)
//  => print(value.toString()))).catchError((error) => print(error.toString()));
