//
//  AttackResolver.swift
//  EverCraft
//
//  Created by Ravi Desai on 1/6/16.
//  Copyright © 2016 RSD. All rights reserved.
//

import Foundation

class AttackResolver {
    static func resolveAttack(inout attacker: Character, inout victim: Character, roll: Int) {
        let (roll, damage) = attacker.rollAttack(10)
        let attackWorked = victim.wasHitByAttack(roll, damage: damage)
        attacker.succeededInAttacking(attackWorked)
    }
}