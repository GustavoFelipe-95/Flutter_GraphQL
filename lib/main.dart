import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final HttpLink httpLink =
    HttpLink(uri: "https://countries.trevorblades.com/");

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject,
        ),
      ),
    );
    /*
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Teste Funcional"),
    );
    */
    return GraphQLProvider(
      child: MyHomePage(),
      client: client,
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final String query = r"""
                    query GetContinent($code : String!){
                      continent(code:$code){
                        name
                        countries{
                          name
                        }
                      }
                    }
                  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GraphlQL Client"),
      ),
      body: Query(
        options: QueryOptions(
            document: query, variables: <String, dynamic>{"code": "AS"}),
        builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {

          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.data == null) {
            return Text("No Data Found !");
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title:
                Text(result.data['continent']['countries'][index]['name']),
              );
            },
            itemCount: result.data['continent']['countries'].length,

          );
        },
      ),
    );
  }
}
