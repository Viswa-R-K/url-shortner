import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("URL Shortner"),
      centerTitle: true,),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Enter your url here",
              hintText: "http//www.example.com"),
            ),
            const SizedBox(height: 40,),
            ElevatedButton(onPressed: ()async{
              final url = await shortUrl(url: controller.text);
              if (url != null && context.mounted){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: const Text("The URL is successfully Shortened"),
                    content: SizedBox(height: 100,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async{
                                if (await canLaunchUrl(Uri.parse(url))){
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                              child: Container(
                                color: Colors.white.withOpacity(0.2),
                                child: Text(url),),
                            ),
                            IconButton(onPressed: (){
                              Clipboard.setData(ClipboardData(text: url)).then((value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("URL is copied to clipboard"))));
                            }, icon:const Icon(Icons.copy))
                          ],

                        ),
                        ElevatedButton.icon(onPressed: (){
                          controller.clear();
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.clear),
                        label: const Text("Close"),)
                      ],
                    ),),
                  );
                });
              }
            },
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey[400],),
            foregroundColor: const MaterialStatePropertyAll(Colors.black) ), child: const Text("Shorten URL"),),
            const SizedBox(height: 40,),

          ],
        ),
      ),
    ),);
  }

  Future<String?> shortUrl ({required String url}) async {

    try{
      final result = await http.post(Uri.parse("https://cleanuri.com/api/v1/shorten"),
      body: {
        'url':url
      });

      if (result.statusCode == 200){
        final out = jsonDecode(result.body);
        return out['result_url'];
      }

    }catch(e){

      print(e.toString());
    }
    return null;

  }
}
