import 'package:flutter/material.dart';
import 'package:supabase_app/constants/supabase_apikey.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseApiKey.url,
    anonKey: SupabaseApiKey.apikey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final stream =
        Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Nodata'),
              );
            }
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]['body']),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                children: [
                  TextFormField(
                    onFieldSubmitted: (value) async {
                      await Supabase.instance.client.from('notes').insert(
                        {'body': value},
                      );
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
