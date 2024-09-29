// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:image_picker/image_picker.dart';

// class ImgNutritionAI extends StatefulWidget {
//   const ImgNutritionAI({super.key, required this.title});

//   final String title;

//   @override
//   State<ImgNutritionAI> createState() => _ImgNutritionAIState();
// }

// class _ImgNutritionAIState extends State<ImgNutritionAI> {
//   Uint8List? image;
//   bool imgSelected = false;
//   bool loading = false;
//   String nutritionInfo = "Select an image to analyze its nutritional content.";

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       image = await pickedFile.readAsBytes();
//       imgSelected = true;
//       setState(() {});
//     }
//   }

//   void reset() {
//     setState(() {
//       imgSelected = false;
//       image = null;
//       nutritionInfo = "Select an image to analyze its nutritional content.";
//     });
//   }

//   // Future<void> generateNutritionInfo() async {
//   //   setState(() {
//   //     loading = true;
//   //   });
//   //   final model = GenerativeModel(
//   //     model: 'gemini-1.5-flash-latest',
//   //     apiKey:
//   //         "AIzaSyCcLWJMgkqSXzYNF_ND9qWY1RIhiHYUDKU", // Replace with your Gemini API key
//   //     // systemInstruction: Content.text(
//   //     //     """Analyze the provided image and extract relevant nutritional information. If the image depicts a food item, provide detailed nutritional data, including:
//   //     //       Calories
//   //     //       Macros (protein, carbohydrates, fat)
//   //     //       Vitamins (vitamins A, C, B12, etc.)
//   //     //       Minerals (calcium, iron, potassium, etc.)
//   //     //       Other relevant nutrients
//   //     //       If the image is not directly related to a specific food item, provide a helpful response suggesting the user upload an image of a recognizable food."""),
//   //   );

//   //   final content = Content.multi([
//   //     // TextPart(
//   //     //     // "Extract detailed nutritional information from this image, including calories, macronutrients, and any notable health benefits or concerns."),
//   //     //     "Analyze the nutritional content of the food item depicted in this image."),
//   //     DataPart('image/jpeg', image!),
//   //   ]);

//   //   try {
//   //     final response = await model.generateContent([content]);
//   //     setState(() {
//   //       nutritionInfo =
//   //           response.text ?? "Could not extract nutrition information.";
//   //       loading = false;
//   //     });
//   //   } catch (error) {
//   //     setState(() {
//   //       nutritionInfo = "Error occurred: $error";
//   //       loading = false;
//   //     });
//   //   }
//   // }

//   Future<void> generateNutritionInfo() async {
//     print("start..........");
//     setState(() {
//       loading = true;
//     });
//     final model = GenerativeModel(
//       model: 'gemini-1.5-flash-latest',
//       apiKey:
//           "AIzaSyCcLWJMgkqSXzYNF_ND9qWY1RIhiHYUDKU", // Replace with your Gemini API key
//       systemInstruction: Content.text(
//           """Analyze the provided image and extract relevant nutritional information. If the image depicts a food item, provide detailed nutritional data, including:
//             Calories
//             Macros (protein, carbohydrates, fat)
//             Vitamins (vitamins A, C, B12, etc.)
//             Minerals (calcium, iron, potassium, etc.)
//             Other relevant nutrients
//             If the image is not directly related to a specific food item, provide a helpful response suggesting the user upload an image of a recognizable food."""),
//     );
//     print("start..........2");
//     final things = Content.multi([
//       DataPart('image/jpeg', image!), // The image data
//     ]);

//     try {
//       print("start..........3");
//       final response = await model.generateContent([things]);
//       // final response = await model.generateContent([
//       //   Content.multi([
//       //     DataPart('image/png', image!),
//       //   ]),
//       //   Content.text("hello")
//       // ]);
//       print(response);
//       setState(() {
//         nutritionInfo =
//             response.text ?? "Could not extract nutrition information.";
//         loading = false;
//       });
//     } catch (error) {
//       setState(() {
//         nutritionInfo = "Error occurred: $error";
//         loading = false;
//       });
//       print("Error occurred while generating nutrition info: $error");
//     }
//   }

// ignore_for_file: invalid_return_type_for_catch_error

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.teal,
//         title: Text(widget.title, style: const TextStyle(color: Colors.white)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: reset,
//             tooltip: "Reset",
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       if (imgSelected)
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.memory(
//                             image!,
//                             height: 200,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       else
//                         Container(
//                           height: 200,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(Icons.image,
//                               size: 80, color: Colors.grey),
//                         ),
//                       const SizedBox(height: 16),
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.add_photo_alternate),
//                         label:
//                             Text(imgSelected ? "Change Image" : "Select Image"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.teal,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12),
//                         ),
//                         onPressed: _pickImage,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Nutrition Information",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         nutritionInfo,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: image == null ? null : generateNutritionInfo,
//         tooltip: 'Analyze Nutrition',
//         label: const Text('Analyze'),
//         icon: loading
//             ? const CircularProgressIndicator(color: Colors.white)
//             : const Icon(Icons.restaurant_menu),
//         backgroundColor: Colors.teal,
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class ImgNutritionAI extends StatefulWidget {
  const ImgNutritionAI({super.key, required this.title});

  final String title;

  @override
  State<ImgNutritionAI> createState() => _ImgNutritionAIState();
}

class _ImgNutritionAIState extends State<ImgNutritionAI> {
  Uint8List? image;
  bool imgSelected = false;
  bool loading = false;
  String nutritionInfo = "Select an image to analyze its nutritional content.";

  // Replace with your Gemini API key
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: "AIzaSyCcLWJMgkqSXzYNF_ND9qWY1RIhiHYUDKU",
  );

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = await pickedFile.readAsBytes(); // Convert to Uint8List
      imgSelected = true;
      setState(() {});
    }
  }

  // Reset the state to clear the selected image
  void reset() {
    setState(() {
      imgSelected = false;
      image = null;
      nutritionInfo = "Select an image to analyze its nutritional content.";
    });
  }

  // Send the image to the Gemini API and generate nutritional information
  Future<void> generateNutritionInfo() async {
    setState(() {
      loading = true;
    });

    // Prepare the content with the image
    final content = Content.multi([
      DataPart('image/jpeg', image!), // The image as DataPart
    ]);

    try {
      // Call the API to generate the content
      final response = await model.generateContent([content]);

      setState(() {
        nutritionInfo =
            response.text ?? "Could not extract nutrition information.";
        loading = false;
      });
    } catch (error) {
      setState(() {
        nutritionInfo = "Error occurred: $error";
        loading = false;
      });
      print("Error: $error");
    }
  }

  // // final file = File('assets/img.png');
  // Future<void> img() async {
  //   final gemini = Gemini.instance;
  //   await gemini.textAndImage(
  //       text: "What is this picture?",

  //       /// text
  //       images: [image!]

  //       /// list of images
  //       ).then((value) {
  //     print("start.....");
  //     print(value!.content?.parts?.last.text);
  //     log(value.content?.parts?.last.text ?? '');
  //   }).catchError((e) => log('textAndImageInput', error: e));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: reset,
            tooltip: "Reset",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (imgSelected)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            image!,
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.9,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.image,
                              size: 80, color: Colors.grey),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_photo_alternate),
                        label:
                            Text(imgSelected ? "Change Image" : "Select Image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nutrition Information",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        nutritionInfo,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: image == null ? null : generateNutritionInfo,
        tooltip: 'Analyze Nutrition',
        label: const Text(
          'Analyze',
          style: TextStyle(color: Colors.white),
        ),
        icon: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.restaurant_menu),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
