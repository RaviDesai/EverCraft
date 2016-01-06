//
//  Character.swift
//  EverCraft
//
//  Created by Ravi Desai on 1/6/16.
//  Copyright © 2016 RSD. All rights reserved.
//

import Foundation

struct Character {
    var name: String
    var alignment: CharacterAlignment = CharacterAlignment.Neutral
    var baseArmorClass = 10
    var baseHitPoints = 5
    var damage = 0
    var experiencePoints = 0

    var armorClass: Int {
        return baseArmorClass + getModifier(CharacterAbilities.Dexterity)
    }
    
    var hitPoints: Int {
        let constitutionModifier = getModifier(CharacterAbilities.Constitution)
        var hp = baseHitPoints + constitutionModifier
        
        if hp <= 0 { hp = 1}

        return hp - self.damage
    }
    
    mutating func succeededInAttacking(success: Bool) {
        if (success) { self.experiencePoints += 10}
    }
    
    private var abilities: [CharacterAbilities: Int] =
        [CharacterAbilities.Strength : 10,
        CharacterAbilities.Constitution : 10,
        CharacterAbilities.Wisdom : 10,
        CharacterAbilities.Dexterity : 10,
        CharacterAbilities.Intelligence : 10,
        CharacterAbilities.Charisma : 10]
    
    func getAbility(ability: CharacterAbilities) -> Int {
        return abilities[ability] ?? 10
    }
    
    func getModifier(ability: CharacterAbilities) -> Int {
        let score = getAbility(ability)
        
        return (score + 10) / 2 - 10
    }
    
    mutating func setAbility(ability: CharacterAbilities, value: Int) throws {
        if value > 20 || value <= 0 {
            throw AttributeAssignmentError.OutOfRange
        }
        abilities[ability] = value
    }
    
    init(name: String) {
        self.name = name
    }
    
    mutating func wasHitByAttack(attackRoll: Int, damage: Int) -> Bool {
        if (attackRoll >= self.armorClass) {
            self.damage += damage
            return true
        }
        return false
    }
    
    var status: CharacterStatus {
        get {
            return (hitPoints > 0) ? CharacterStatus.Alive : CharacterStatus.Dead
        }
    }
    
    func rollAttack(roll: Int) -> (attack: Int, damage: Int) {
        let strengthModifier = getModifier(CharacterAbilities.Strength)
        var attackRoll = roll + strengthModifier
        var damage = 1 + strengthModifier
        if (roll == 20) {
            attackRoll += strengthModifier
            damage += 1 + strengthModifier
        }
        
        if (damage <= 0) { damage = 1 }
        
        return (attack: attackRoll, damage: damage)
    }
}