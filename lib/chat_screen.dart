import 'package:chat_gpt_app/consts.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _openAI = OpenAI.instance.build(
    token: OPEN_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5
      ),
    ),
    enableLog: true,
  );

final ChatUser _currentUser = ChatUser(id: "1",firstName: "Arslan",lastName: "Tariq",);
final ChatUser _gptUser = ChatUser(id: "2",firstName: "Chat",lastName: "GPT",);
final List<ChatMessage> _messages = <ChatMessage>[];
final List<ChatUser> _typingUser = <ChatUser>[];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff009C74),
        centerTitle: true,
        title:  Text("GPT CHAT",style: GoogleFonts.dangrek(
            textStyle:const TextStyle(
                color: Colors.white

            )
        ),),
      ),

      body:DashChat(
          typingUsers: _typingUser,
          currentUser: _currentUser,
          messageOptions:const  MessageOptions(
            currentUserContainerColor:  Color(0xff009C74),
            containerColor: Colors.black,
            textColor: Colors.blue,
          ),
          onSend: (ChatMessage m ){
        getChatResponse(m);
      }, messages: _messages)
    );
  }
  Future<void > getChatResponse(ChatMessage m) async {

    setState(() {
      _messages.insert(0,m);
      _typingUser.add(_gptUser);
    });

   final  List<Messages> messagesHistory = _messages.reversed.map((m){

      if(m.user ==_currentUser){
        return Messages(role: Role.user,content: m.text);

      }else{
    return Messages(role: Role.assistant,content: m.text);
      }
    }).toList();
    final request = ChatCompleteText(
        model: GptTurbo0301ChatModel(),
        messages: messagesHistory,
      maxToken: 200,

    );
    final response =await  _openAI.onChatCompletion(request: request);
    for(var element in response!.choices){
      if(element.message!=null){
        setState(() {
          _messages.insert(0,ChatMessage(user: _gptUser, createdAt: DateTime.now(),text: element.message!.content));
        });
      }
    }
    setState(() {
      _typingUser.remove(_gptUser);
    });
  }
}
