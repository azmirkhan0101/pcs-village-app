import 'package:pcs_village/data/models/groups/member_model.dart';
import 'package:pcs_village/data/models/message/conversation_model.dart';

class ParticipantModel {

  final String name;
  final String profileImage;
  final String conversationId;

  ParticipantModel({
    required this.name,
    required this.profileImage,
    required this.conversationId
  });

  factory ParticipantModel.fromConversationModel(Conversation conversation){
    return ParticipantModel(
      name: conversation.opponentName,
      profileImage: conversation.opponentProfileImg,
      conversationId: conversation.id
    );
  }

  factory ParticipantModel.fromMemberModel(MemberModel member){
    return ParticipantModel(
      name: member.name,
      profileImage: member.profileImage,
      conversationId: member.conversationId
    );
  }

}