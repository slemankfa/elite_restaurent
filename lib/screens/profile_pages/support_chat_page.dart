import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elite/core/firebase_chat_helper.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../core/fire_store_constant.dart';
import '../../models/chat_messages.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({Key? key, this.userInformation}) : super(key: key);

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();

  static const RouteName = "/chat-support";
  final UserModel? userInformation;
}

class _SupportChatPageState extends State<SupportChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];
  final FirebaseChatHelpersMethods _firebaseChatHelpersMethods =
      FirebaseChatHelpersMethods();

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';

  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  // checking if sent message
  bool isMessageSent(int index) {
    return true;
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      _firebaseChatHelpersMethods.sendChatMessage(content, type, groupChatId,
          currentUserId, FirestoreConstants.suppourtId);
      // return;
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      // _firebaseChatHelpersMethods.showToast(
      //     msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    // the user id from API

    if (widget.userInformation == null) return;
    currentUserId = widget.userInformation!.userId;
    log(currentUserId.toString());
    // create room ID
    groupChatId = '${FirestoreConstants.suppourtId} - $currentUserId';

    // _firebaseChatHelpersMethods.updateFirestoreData(
    //     FirestoreConstants.pathUserCollection,
    //     currentUserId,
    //     {FirestoreConstants.chattingWith: FirestoreConstants.suppourtId});
  }

  @override
  void initState() {
    super.initState();
    // chatProvider = context.read<ChatProvider>();
    // authProvider = context.read<AuthProvider>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Styles.grayColor),
          title: Text(
            "Live Support",
            style: Styles.appBarTextStyle,
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildListMessage(),
                buildMessageInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        return Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Styles.chipBackGroundColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(6),
                    // padding: EdgeInsets.all(5),
                    child: Text(
                      "You",
                      style: Styles.mainTextStyle.copyWith(
                        color: Styles.youChatTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        messageBubble(
                          chatContent: chatMessages.content,
                          color: Colors.white,
                          textColor: Colors.black,
                          margin: null,
                        ),
                        isMessageSent(index)
                            ? Container(
                                margin: const EdgeInsets.only(
                                    right: 0, top: 6, bottom: 6, left: 0),
                                child: Text(
                                  DateFormat('hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(chatMessages.timestamp),
                                    ),
                                  ),
                                  style: const TextStyle(
                                      color: Styles.midGrayColor,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  isMessageSent(index)
                      ? widget.userInformation != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  widget.userInformation!.userImage.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.topCenter,
                              width: 30,
                              height: 30,
                              // clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.black),
                                  color: Styles.listTileBorderColr),
                              // child:

                              child: SvgPicture.asset(
                                "assets/icons/profile.svg",
                                color: Styles.mainColor,
                              ))
                      : Container(
                          width: 35,
                        ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Styles.supportChatBBlMessageColor.withOpacity(0.8),
              border: Border.all(color: Styles.mainColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isMessageReceived(index)
                      // left side (received message)
                      ? Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.topCenter,
                          width: 30,
                          height: 30,
                          // clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Styles.mainColor),
                              color: Colors.white),
                          child: SvgPicture.asset(
                            "assets/icons/profile.svg",
                            color: Styles.mainColor,
                          ),
                        )
                      : Container(
                          width: 35,
                        ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "live support",
                          style: Styles.mainTextStyle
                              .copyWith(color: Styles.mainColor, fontSize: 12),
                        ),
                        messageBubble(
                          chatContent: chatMessages.content,
                          color: Colors.white,
                          textColor: Colors.black,
                          margin: const EdgeInsets.only(right: 10),
                        ),
                        isMessageReceived(index)
                            ? Container(
                                margin: const EdgeInsets.only(
                                    right: 0, top: 6, bottom: 6, left: 0),
                                child: Text(
                                  DateFormat('hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(chatMessages.timestamp),
                                    ),
                                  ),
                                  style: const TextStyle(
                                      color: Styles.midGrayColor,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget messageBubble(
      {required String chatContent,
      required EdgeInsetsGeometry? margin,
      Color? color,
      Color? textColor}) {
    return Container(
      // padding: const EdgeInsets.all(8),
      margin: margin,
      // width: 200,
      decoration: const BoxDecoration(
          // color: color,
          // borderRadius: BorderRadius.circular(8),
          ),
      child: Text(
        chatContent,
        style: Styles.mainTextStyle.copyWith(
            color: Styles.midGrayColor,
            fontSize: 14,
            fontWeight: FontWeight.w600),
        // textAlign: TextAlign.end,
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: _firebaseChatHelpersMethods.getChatMessage(
                  groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data?.docs[index]));
                  } else {
                    return Column(
                      children: [
                        welcomingMessages(),
                      ],
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Styles.mainColor,
                    ),
                  );
                }
              })
          : const Center(
              child: CircularProgressIndicator(
                color: Styles.mainColor,
              ),
            ),
    );
  }

  Widget welcomingMessages() {
    if (widget.userInformation == null) return Container();
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Styles.supportChatBBlMessageColor.withOpacity(0.8),
          border: Border.all(color: Styles.mainColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.topCenter,
                width: 30,
                height: 30,
                // clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Styles.mainColor),
                    color: Colors.white),
                child: SvgPicture.asset(
                  "assets/icons/profile.svg",
                  color: Styles.mainColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "live support",
                      style: Styles.mainTextStyle
                          .copyWith(color: Styles.mainColor, fontSize: 12),
                    ),
                    messageBubble(
                      chatContent:
                          "Hi ${widget.userInformation!.firstName} ${widget.userInformation!.lastName} 👋, How I can help you? ",
                      color: Colors.white,
                      textColor: Colors.black,
                      margin: const EdgeInsets.only(right: 10),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          right: 0, top: 6, bottom: 6, left: 0),
                      child: Text(
                        DateFormat('hh:mm a').format(
                          DateTime.now(),
                        ),
                        style: const TextStyle(
                            color: Styles.midGrayColor,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // height: 50,
      // margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Styles.mainColor)),

      child: Row(
        children: [
          Flexible(
              child: TextField(
            focusNode: focusNode,
            cursorColor: Styles.mainColor,
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: textEditingController,
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),

            // decoration:
            //     kTextInputDecoration.copyWith(hintText: 'write here...'),
            onSubmitted: (value) {
              onSendMessage(textEditingController.text, MessageType.text);
            },
          )),
          Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              // color: AppColors.burgundy,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                onSendMessage(textEditingController.text, MessageType.text);
              },
              icon: const Icon(Icons.send_rounded),
              color: Styles.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
