import 'package:flutter_football/screens/team_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_football/theme/colors.dart';
import 'package:flutter_football/models/models.dart';

import 'package:flutter_football/widgets/logo_icon.dart';

class CompetitionTable extends StatelessWidget {
  final Standings standings;
  final bool showCompetition;

  const CompetitionTable(this.standings, this.showCompetition);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCompetition)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(standings.description, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child:
              //buildDataTable(context),
              buildPositions(context),
        ),
      ],
      // padding:
      // child:
    );
  }

  DataTable buildDataTable(BuildContext context) {
    return DataTable(
        horizontalMargin: 0,
        columnSpacing: 0,
        headingRowHeight: 30,
        dataRowHeight: 34,
        showCheckboxColumn: false,
        dividerThickness: 0,
        // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        // columnWidths: {
        //   0: IntrinsicColumnWidth(),
        //   1: IntrinsicColumnWidth(),
        //   2: IntrinsicColumnWidth(),
        //   3: IntrinsicColumnWidth(),
        //   4: IntrinsicColumnWidth(),
        //   5: IntrinsicColumnWidth(),
        //   6: IntrinsicColumnWidth(),
        //   7: IntrinsicColumnWidth(),
        //   8: IntrinsicColumnWidth(),
        // },
        columns: [
          DataColumn(
            label: Text(
              '',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          DataColumn(
              label: Container(
            width: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
              child: Text(
                '#',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          )),
          DataColumn(
              label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
          )),
          DataColumn(
              label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
            child: Text(
              'Team',
              style: Theme.of(context).textTheme.caption,
            ),
          )),
          DataColumn(
              label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Text(
              'Pl',
              style: Theme.of(context).textTheme.caption,
            ),
          )),
          DataColumn(
              label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Text(
              'W-D-L',
              style: Theme.of(context).textTheme.caption,
            ),
          )),
          DataColumn(
              label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Text(
              '+/-',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          )),
          DataColumn(
              label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Text(
              'GD',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.right,
            ),
          )),
          DataColumn(
              label: Text(
            'Pts',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          )),
        ],
        rows: getTableRows(context));
  }

  List<DataRow> getTableRows(BuildContext context) {
    var rows = List<DataRow>.empty(growable: true);
    // rows.add(buildTableHead(context));
    var lastDescription = '';
    for (int i = 0; i < standings.positions.length; ++i) {
      var position = standings.positions[i];

      rows.add(DataRow(
          onSelectChanged: (bool selected) {
            if (selected) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TeamDetail(position.team)));
            }
          },

          // decoration: BoxDecoration(
          //     color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
          //     border: Border(
          //         top: BorderSide(
          //             color:
          //                 (position.description != lastDescription ? Colors.black : Theme.of(context).dividerColor)))),
          cells: [
            DataCell(
              Container(
                // width: 10,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                decoration: BoxDecoration(
                    color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                    border: Border(
                        top: BorderSide(
                            color: (position.description != lastDescription
                                ? Colors.black
                                : Theme.of(context).dividerColor)))),

                child: getStatusIcon(position.status),
              ),
            ),
            DataCell(
              Container(
                width: 20,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                decoration: BoxDecoration(
                    color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                    border: Border(
                        top: BorderSide(
                            color: (position.description != lastDescription
                                ? Colors.black
                                : Theme.of(context).dividerColor)))),
                child: Text(
                  position.rank.toString(),
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                decoration: BoxDecoration(
                    color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                    border: Border(
                        top: BorderSide(
                            color: (position.description != lastDescription
                                ? Colors.black
                                : Theme.of(context).dividerColor)))),
                child: LogoIcon(position.team.logoUrl, 16, false),
              ),
            ),
            DataCell(
              Expanded(
                child: Container(
                  width: 170,
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  decoration: BoxDecoration(
                      color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                      border: Border(
                          top: BorderSide(
                              color: (position.description != lastDescription
                                  ? Colors.black
                                  : Theme.of(context).dividerColor)))),
                  child: Text(
                    position.team.shortName,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                decoration: BoxDecoration(
                    color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                    border: Border(
                        top: BorderSide(
                            color: (position.description != lastDescription
                                ? Colors.black
                                : Theme.of(context).dividerColor)))),
                child: Text(
                  position.played.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                decoration: BoxDecoration(
                    color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                    border: Border(
                        top: BorderSide(
                            color: (position.description != lastDescription
                                ? Colors.black
                                : Theme.of(context).dividerColor)))),
                child: Text(
                  '${position.wins}-${position.draws}-${position.losses}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                decoration: BoxDecoration(
                    color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                    border: Border(
                        top: BorderSide(
                            color: (position.description != lastDescription
                                ? Colors.black
                                : Theme.of(context).dividerColor)))),
                child: Text(
                  '${position.goalsFor}:${position.goalsAgainst}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            DataCell(
              Container(
                width: 20,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                decoration: BoxDecoration(
                    color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                    border: Border(
                        top: BorderSide(
                            color: (position.description != lastDescription
                                ? Colors.black
                                : Theme.of(context).dividerColor)))),
                child: Text(
                  position.goalsDifference.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            DataCell(
              Container(
                width: 30,
                decoration: BoxDecoration(
                    color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
                    border: Border(
                        top: BorderSide(
                            color: (position.description != lastDescription
                                ? Colors.black
                                : Theme.of(context).dividerColor)))),
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
                child: Text(
                  position.points.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ]));
      lastDescription = position.description;
    }
    return rows;
  }

  Widget getStatusIcon(Status status) {
    switch (status) {
      case Status.Down:
        return Icon(Icons.keyboard_arrow_down, size: 10);
        break;
      case Status.Up:
        return Icon(Icons.keyboard_arrow_up, size: 10);
        break;
      case Status.Same:
        return Icon(Icons.remove, size: 10);
        break;
    }
    return null;
  }

  Widget buildPositions(BuildContext context) {
    var rows = List<TableRow>.empty(growable: true);
    rows.add(buildTableHead(context));
    var lastDescription = '';

    for (int i = 0; i < standings.positions.length; ++i) {
      var position = standings.positions[i];
      rows.add(TableRow(
          decoration: BoxDecoration(
              color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
              border: Border(
                  top: BorderSide(
                      color:
                          (position.description != lastDescription ? Colors.black : Theme.of(context).dividerColor)))),
          children: [
            TableCell(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8.0),
                  child: getStatusIcon(position.status)),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8.0),
                child: Text(
                  position.rank.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8.0),
                  child: LogoIcon(position.team.logoUrl, 16, false)),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8.0),
                child: Text(
                  position.team.shortName,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8.0),
                child: Text(
                  position.played.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${position.wins}-${position.draws}-${position.losses}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${position.goalsFor}:${position.goalsAgainst}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  position.goalsDifference.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  position.points.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ]));

      lastDescription = position.description;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
            3: IntrinsicColumnWidth(),
            4: IntrinsicColumnWidth(),
            5: IntrinsicColumnWidth(),
            6: IntrinsicColumnWidth(),
            7: IntrinsicColumnWidth(),
          },
          children: rows),
    );
  }

  TableRow buildTableHead(BuildContext context) {
    return TableRow(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))), children: [
      TableCell(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Text(
              '',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            '#',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            'Team',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            'Pl',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            'W-D-L',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            '+/-',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            'GD',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            'Pts',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ),
    ]);
  }
}
