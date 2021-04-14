import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider{
  String _apiKey = '5b594a275e987b4ce687888f7856a64a';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = 
        StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
   // print(decodedData);
  // print(decodedData['results']);
  final peliculas = new Peliculas.fromJsonList(decodedData['results']);
  //print (peliculas.items[0].title);
  //print (peliculas.items[1].title);
    return peliculas.items;
  
  }


  Future<List<Pelicula>> getEnCines() async{
    final url =  Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language, 
    });
    return await _procesarRespuesta(url);
    }

  Future<List<Pelicula>> getPopulares() async{
    if(_cargando) return[];
    _cargando = true;
    _popularesPage++;
   // print('Crgando Siguientes...');
    final url =  Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language, 
      'page': _popularesPage.toString(),
    });
    final resp= await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando=false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliculaId) async{
    final url =  Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key': _apiKey,
      'language': _language, 
    });
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }
}