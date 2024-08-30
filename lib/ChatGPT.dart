import "dart:convert";
import "package:http/http.dart" as http;
import "./Config.dart";

class ChatGPTclass{

  static String apiKey = Configs.OpenAI;
  static String url = "https://api.openai.com/v1/chat/completions";


  static Future<dynamic> getCharting(String transcription) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    var body = jsonEncode({
      "model": "gpt-4o",
      "messages": [
        {
          "role": "system",
          "content": """
          You are an AI designed for helping Nurses in Charting Patient Data. 
          Rewrite the user data in markdown format while only using ( # , ## , ###, - ).
          and no other markdown symbols. Don't leave any important detail. Use headers of markdown and dont use emphasis (etc ** emphasis **).
          Make time of event and aa title as heading. In case of no medical data in prompt, just give empty response with patient name.
          """
        },
        {
          "role": "user",
          "content": "The following is transcription of Nurse Audio\n\n ${transcription}"
        }
      ]
    });
    var response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var content = jsonResponse['choices'][0]['message']['content'];
      print(content);
      return content;
    } else {
      print('Failed to get a response. Status code: ${response.statusCode}');
      return response.body;
    }
  }

  static Future<dynamic> getTabularData(String data)async{
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    var body = jsonEncode({
      "model": "gpt-4o",
      "messages": [
        {
          "role": "system",
          "content": """
            You need to extract medical data from text for tabular charting. Your
            output should only be a table in csv format and nothing else. For empty positions, use space as position holder.
            The headers in the table might include,
            - Time
            - HR / Rhythm
            - Pulse Palpable 
            - Chest Compressions
            - Blood Pressure
            - Respirations 
            - Pulse Oximetry
            - ET CO2
            - Epinephrine 
            - Atropine 
            - Vasopressin 
            - NaHCO3 
            - Amiodarone 
            - Calcium Chloride
            - Magnesium 
            - Adenosine 
            
           The table must not contain irregular row lengths and should be properly formatted. In case of no data provided, give empty csv.
          """
        },
        {
          "role": "user",
          "content": "The following is transcription of Nurse Audio\n\n ${data}"
        }
      ]
    });
    var response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var content = jsonResponse['choices'][0]['message']['content'];
      print(content);
      return content;
    } else {
      print('Failed to get a response. Status code: ${response.statusCode}');
      return response.body;
    }
  }

}
// Few of these items will be there in the text.
// - Time
// - HR / Rhythm
// - Pulse Palpable (+/-)
// - Chest Compressions (Manual/Automatic) as (M/A)
// - Blood Pressure
// - Respirations (Spont/Assisted)
// - Pulse Oximetry
// - ET CO2
// - Epinephrine mg
// - Atropine mg
// - Vasopressin Units
// - NaHCO3 mEq
// - Amiodarone mg
// - Calcium Chloride
// - Magnesium gm
// - Adenosine mg