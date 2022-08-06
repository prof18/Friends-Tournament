import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider_impl.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/setup_repository.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';


DatabaseProvider _databaseProvider = DatabaseProviderImpl.get;
LocalDataSource _localDataSource = LocalDataSource(_databaseProvider);

final tournamentRepository = TournamentRepository(_localDataSource);
final SetupRepository setupRepository = new SetupRepository(_localDataSource);
