// The 'move' program.
program move.aleo {
    record move {
        owner: address,
        incoming_fire_coordinate: u64,
        player_1: address,
        player_2: address,
        // 한 개의 플립된 비트는 명중을 나타낸다. 플립된 비트가 없으면 실패한다.
        prev_hit_or_miss: u64,
    }

    // 상대방이 소유한 새로운 move 레코드를 반환한다.
    transition create_move(
        // 상대방이 생성한 move 레코드.
        move_record: move,
        // 상대방에게 전송할 incoming_fire_coordinate 비트열의 u64 표현.
        incoming_fire_coordinate: u64,
        // 이 플레이어의 이전 화성화 또는 실패로서의 prev_hit_or_miss 비트열의 u64 표현.
        prev_hit_or_miss: u64,
    ) -> move {
        // 새로운 move 레코드는 상대방이 소유해야 한다.
        let one_is_owner: bool = move_record.player_1 == move_record.owner;
        let opponent: address = one_is_owner ? move_record.player_2 : move_record.player_1;

        return move {
            owner: opponent,
            incoming_fire_coordinate,
            player_1: move_record.player_2,
            player_2: move_record.player_1,
            prev_hit_or_miss,
        };
    }

    // 상대방이 소유한 move 레코드를 반환한다.
    // 이 move 레코드에는 더미 화재 좌표 및 이전 명중 또는 실패가 포함되어 있다.
    transition start_game(player_2: address) -> move {
        return move {
            owner: player_2,
            incoming_fire_coordinate: 0u64,
            player_1: self.signer,
            player_2: player_2,
            prev_hit_or_miss: 0u64,
        };
    }
}
