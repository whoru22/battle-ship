import board.aleo;
import move.aleo;
import verify.aleo;

program battleship.aleo {
    transition initialize_board(
        carrier: u64,
        battleship: u64,
        cruiser: u64,
        destroyer: u64,
        player: address
    ) -> board.aleo/board_state.record {
        let valid_carrier: bool = verify.aleo/validate_ship(carrier, 5u64, 31u64, 4311810305u64);
        assert(valid_carrier);

        let valid_battleship: bool = verify.aleo/validate_ship(battleship, 4u64, 15u64, 16843009u64);
        assert(valid_battleship);

        let valid_cruiser: bool = verify.aleo/validate_ship(cruiser, 3u64, 7u64, 65793u64);
        assert(valid_cruiser);

        let valid_destroyer: bool = verify.aleo/validate_ship(destroyer, 2u64, 3u64, 257u64);
        assert(valid_destroyer);

        let board: u64 = verify.aleo/create_board(carrier, battleship, cruiser, destroyer);

        let state: board.aleo/board_state = board.aleo/new_board_state(board, player);

        return state;
    }

    transition offer_battleship(
        board: board.aleo/board_state.record,
    ) -> (board.aleo/board_state.record, move.aleo/move.record) {
        let state: board.aleo/board_state = board.aleo/start_board(board);
        let dummy: move.aleo/move = move.aleo/start_game(board.player_2);

        return (state, dummy);
    }

    transition start_battleship(
        board: board.aleo/board_state.record,
        move_start: move.aleo/move.record,
    ) -> (board.aleo/board_state.record, move.aleo/move.record) {
        assert_eq(board.player_1, move_start.player_2);
        assert_eq(board.player_2, move_start.player_1);

        let state: board.aleo/board_state = board.aleo/start_board(board);
        let dummy: move.aleo/move = move.aleo/start_game(board.player_2);

        return (state, dummy);
    }

    transition play(
        board: board.aleo/board_state.record,
        move_incoming: move.aleo/move.record,
        shoot: u64,
    ) -> (board.aleo/board_state.record, move.aleo/move.record) {
        assert(board.game_started);

        assert_eq(board.player_1, move_incoming.player_2);
        assert_eq(board.player_2, move_incoming.player_1);

        let hit_or_miss: board.aleo/board_state = board.aleo/update_played_tiles(board, shoot);

        let next_board: board.aleo/board_state = board.aleo/update_hits_and_misses(hit_or_miss, move_incoming.prev_hit_or_miss);

        let is_hit: u64 = move_incoming.incoming_fire_coordinate & board.ships;

        let next_move: move.aleo/move = move.aleo/create_move(move_incoming, shoot, is_hit);

        return (next_board, next_move);
    }
}
