import 'package:FlutterFootball/models/api_football/models.dart' as ApiModels;
import 'package:FlutterFootball/models/models.dart';

enum CardType { Yellow, Red }
enum EventType { Card, Substitution, Goal, MissedPenalty, Message }
enum GoalType { Normal, Penalty, OwnGoal }

class IEventData {}

class Card implements IEventData {
  final Player booked;
  final CardType type;

  Card({this.booked, this.type});
}

class MissedPenalty implements IEventData {
  Player shooter;

  MissedPenalty({this.shooter});
}

class Goal implements IEventData {
  GoalType type;
  Player scorer;
  Player assist;
  Score score;

  Goal({this.scorer, this.assist, this.score, this.type});
}

class Substitution implements IEventData {
  final Player playerOut;
  final Player playerIn;

  Substitution({this.playerOut, this.playerIn});
}

class MatchEvent {
  String minute;
  String text;
  Team team;
  EventType type;
  IEventData data;

  MatchEvent({this.text, this.minute, this.team});
}

class MatchEvents {
  final String matchId;
  List<MatchEvent> events;

  MatchEvents({this.matchId, this.events});
}

class MatchEventFactory {
  static MatchEvent createFrom(
      ApiModels.FixtureEvent event, List<ApiModels.FixturePlayersStatistics> playerStatistics, Score currentScore) {
    MatchEvent matchEvent = MatchEvent(minute: event.time.elapsed.toString());
    matchEvent.team = Team(id: event.team.id, name: event.team.name, logoUrl: event.team.logo);

    switch (event.type.toLowerCase()) {
      case 'goal':
        if (event.detail == 'Missed Penalty') {
          var shooter = Player(
              id: event.player.id,
              name: event.player.name,
              pictureUrl: getPlayerPicture(playerStatistics, event.team.id, event.player?.id));
          matchEvent.type = EventType.MissedPenalty;
          matchEvent.text = event.detail;
          matchEvent.data = MissedPenalty(shooter: shooter);
        } else {
          var scorer = Player(
              id: event.player?.id,
              name: event.player?.name,
              pictureUrl: getPlayerPicture(playerStatistics, event.team.id, event.player?.id));
          var assist = Player(
              id: event.assist?.id,
              name: event.assist?.name,
              pictureUrl: getPlayerPicture(playerStatistics, event.team.id, event.assist?.id));

          matchEvent.type = EventType.Goal;
          matchEvent.text = 'Goal';
          matchEvent.data = Goal(scorer: scorer, assist: assist, score: currentScore, type: getGoalType(event.detail));
        }
        break;
      case 'subst':
        matchEvent.type = EventType.Substitution;
        matchEvent.text = 'Substitution';
        matchEvent.data = Substitution(
            playerIn: Player(
                id: event.player.id,
                name: event.player.name,
                pictureUrl: getPlayerPicture(playerStatistics, event.team.id, event.player?.id)),
            playerOut: Player(
                id: event.assist.id,
                name: event.assist.name,
                pictureUrl: getPlayerPicture(playerStatistics, event.team.id, event.assist?.id)));
        break;
      case 'card':
        matchEvent.type = EventType.Card;
        matchEvent.text = event.comments;
        matchEvent.data = Card(
            booked: Player(
                id: event.player.id,
                name: event.player.name,
                pictureUrl: getPlayerPicture(playerStatistics, event.team.id, event.player.id)),
            type: event.detail == 'Yellow Card' ? CardType.Yellow : CardType.Red);
        break;
      default:
        matchEvent.type = EventType.Message;
    }

    return matchEvent;
  }

  static GoalType getGoalType(String type) {
    switch (type.toLowerCase()) {
      case 'penalty':
        return GoalType.Penalty;
        break;
      case 'own goal':
        return GoalType.OwnGoal;
        break;
    }
    return GoalType.Normal;
  }

  static String getPlayerPicture(List<ApiModels.FixturePlayersStatistics> playerStatistics, int teamId, int playerId) {
    ApiModels.PlayerStatistics apiPlayer;
    try {
      playerStatistics.forEach((element) {
        apiPlayer = element.playerStatistics.firstWhere((p) => p.player.id == playerId, orElse: () => apiPlayer);
      });
      if (apiPlayer != null) return apiPlayer?.player?.photo;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
