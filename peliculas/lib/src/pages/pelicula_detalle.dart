import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/pelicula_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBAr(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0,),
              _posterTitulo(context, pelicula),
              _descripcion(pelicula),
              _descripcion1(pelicula),
              _descripcion2(pelicula),
              _descripcion3(pelicula),
              _descripcion4(pelicula),
              _descripcion5(pelicula),
              _descripcion6(pelicula),
              _descripcion7(context),
              _crearCasting(pelicula),
             // _descripcion3(pelicula),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _crearAppBAr(Pelicula pelicula)
  {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigo,
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
      title: Text(pelicula.title,
      style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      background: FadeInImage(
        image: NetworkImage(pelicula.getBackgroundImg()),
        placeholder: AssetImage('assets/img/loading.gif'),
        fadeInDuration: Duration(milliseconds: 150),
        fit: BoxFit.cover,
      ),
    ),
    );
  }

Widget _posterTitulo(BuildContext context, Pelicula pelicula)
{
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      children: <Widget>[
        Hero(
          tag: pelicula.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
          child: Image(
              image: NetworkImage(pelicula.getPosterImg()),
              height: 180.0,
            ),
          ),
        ),
        SizedBox(width: 20.0),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(pelicula.title, style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.ellipsis),
              Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1,
              overflow: TextOverflow.ellipsis),
              Row(
                children: <Widget>[
                  Icon(Icons.star),
                  Text(pelicula.voteAverage.toString(),
                  style: Theme.of(context).textTheme.subtitle1,),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _descripcion(Pelicula pelicula)
{
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    child: Text(
      pelicula.overview,
      textAlign: TextAlign.justify,
    ),
  );
}

Widget _descripcion1(Pelicula pelicula)
{
  String a="";
  if(pelicula.adult == false)
  {
     a="No";
  }
  else{
     a="Si";
  }
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    child: Text('Pelicula para adultos: $a',textAlign: TextAlign.justify,),
  );
}
/*
Widget _descripcion2(Pelicula pelicula)
{
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 01.0),
    child: 
    
    Text(
      pelicula.adult.toString(),
      textAlign: TextAlign.justify,
    ),
  );
}*/
Widget _descripcion2(Pelicula pelicula)
{
  String a=pelicula.releaseDate.toString();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    child: Text('Fecha de lanzamiento: $a',textAlign: TextAlign.justify,),
  );
}
Widget _descripcion3(Pelicula pelicula)
{
  String a=pelicula.popularity.toString();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    child: Text('Popularidad: $a',textAlign: TextAlign.justify,),
  );
}
Widget _descripcion4(Pelicula pelicula)
{
  String a=pelicula.voteCount.toString();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    child: Text('Recuento de Votos: $a',textAlign: TextAlign.justify,),
  );
}
Widget _descripcion5(Pelicula pelicula)
{
  String a=pelicula.voteAverage.toString();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    child: Text('Promedio de Videos: $a',textAlign: TextAlign.justify,),
  );
}
Widget _descripcion6(Pelicula pelicula)
{
  String a="";
  if(pelicula.video == false)
  {
     a="No";
  }
  else{
     a="Si";
  }
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    child: Text('Contiene video: $a',textAlign: TextAlign.justify,),
  );
}

Widget _descripcion7(BuildContext context )
{
  
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    child: Text('Actores',style: Theme.of(context).textTheme.headline6,),
  );
}

Widget _crearCasting(Pelicula pelicula){
  final peliculaProvider = new PeliculasProvider();
  return FutureBuilder(
    future: peliculaProvider.getCast(pelicula.id.toString()),
    builder: (BuildContext ontext, AsyncSnapshot<List> snapshot ){
      if(snapshot.hasData)
      {
        return _crearActoresPageView(snapshot.data);
              }
              else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
          );
        }
        
          Widget _crearActoresPageView(List<Actor> actores) {
            return SizedBox(
              height: 200.0,
              child: PageView.builder(
                pageSnapping: false,
                controller: PageController(viewportFraction: 0.3, initialPage: 1),
                itemBuilder: (context, i) => _actorTarjeta(actores[i]),
                
              ),
            );
          }

    Widget _actorTarjeta(Actor actor)
    {
      return Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
                          child: FadeInImage(
                image: NetworkImage(actor.getFoto()),
                placeholder: AssetImage('assets/img/no-image.jpg'), 
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              actor.name,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }
}