//
//  Levels.swift
//  MetalGame
//
//  Created by Alex Nascimento on 30/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

struct LevelManager {
    
    static func getLevel(_ number: Int) -> String {
        if number < 0 || number >= levels.count {
            return levels[0]
        } else { return levels[number] }
    }
    
    static let levels: [String] = [
    """
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......\
    .......
    """,
    """
    .11111.\
    1132311\
    122.221\
    1132311\
    1111111\
    1111111\
    1111111\
    11...11\
    1111111\
    1111111\
    1111111\
    211.112\
    .......\
    .......\
    .......\
    .......
    """,
    """
    1111111\
    2.111.2\
    2.222.2\
    2.222.2\
    2.....2\
    2.....2\
    2.....2\
    11...11\
    22...22\
    32...23\
    33...33\
    333.333\
    .......\
    2222222\
    .......\
    2222222
    """
    ]
}
