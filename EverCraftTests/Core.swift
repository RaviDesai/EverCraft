//
//  Core.swift
//  EverCraft
//
//  Created by Ravi Desai on 1/6/16.
//  Copyright © 2016 RSD. All rights reserved.
//

import XCTest
@testable import EverCraft

class CoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateName() {
        let testCharacter = Character(name: "Bob")
        
        XCTAssertTrue(testCharacter.name=="Bob")
    }
    
    func testCharacterAlignment() {
        var testCharacter = Character(name: "Bob")
        testCharacter.alignment = CharacterAlignment.Good
        XCTAssertTrue(testCharacter.alignment == CharacterAlignment.Good)
    }
    
    func testBaseArmorClass() {
        var testCharacter = Character(name: "Bob")
        XCTAssertTrue(testCharacter.baseArmorClass == 10)
        testCharacter.baseArmorClass = 15
        XCTAssertTrue(testCharacter.baseArmorClass == 15)
    }
    
    func testBaseHitPoints() {
        var testCharacter = Character(name: "Bob")
        XCTAssertTrue(testCharacter.baseHitPoints == 5)
        testCharacter.baseHitPoints = 7
        XCTAssertTrue(testCharacter.baseHitPoints == 7)
    }
    
    func testCharacterDamaged() {
        var victimCharacter = Character(name: "Victor")
        XCTAssertTrue(victimCharacter.wasHitByAttack(12, damage: 1))
        XCTAssertTrue(victimCharacter.hitPoints == 4)
        XCTAssertTrue(victimCharacter.wasHitByAttack(20, damage: 2))
        XCTAssertTrue(victimCharacter.hitPoints == 2)
        XCTAssertTrue(victimCharacter.wasHitByAttack(20, damage: 2))
        XCTAssertTrue(victimCharacter.status == CharacterStatus.Dead)
    }
    
    func testCharacterCanAttack() {
        let testCharacter = Character(name: "Bob")
        var victimCharacter = Character(name: "Victor")
        
        let (roll, damage) = testCharacter.rollAttack(12)
        victimCharacter.wasHitByAttack(roll, damage: damage)
        XCTAssertTrue(victimCharacter.hitPoints == 4)
        XCTAssertTrue(victimCharacter.status == CharacterStatus.Alive)
    }
    
    func testCharacterHasAbilities() {
        var testCharacter = Character(name: "Bob")
    
        for ability in [CharacterAbilities.Strength, CharacterAbilities.Charisma, CharacterAbilities.Constitution, CharacterAbilities.Dexterity, CharacterAbilities.Intelligence, CharacterAbilities.Wisdom] {
            XCTAssertTrue(testCharacter.getAbility(ability) == 10)
            do {
                try testCharacter.setAbility(ability, value: 7)
            
            } catch {}
            
            XCTAssertTrue(testCharacter.getAbility(ability) == 7)
        }
    }
    
    func testMaxAbilityScore() {
        var testCharacter = Character(name: "Bob")
        var gotOverflowError: Bool = false
        
        do {
            try testCharacter.setAbility(CharacterAbilities.Strength, value: 21)
        } catch AttributeAssignmentError.OutOfRange {
            gotOverflowError = true
        } catch {
            
        }
        
        XCTAssertTrue(gotOverflowError)
    }
    
    func testModifiersForAbilities() {
        let resultTable = [1: -5, 2: -4, 3: -4, 4: -3, 5: -3, 6: -2, 7: -2, 8: -1, 9: -1, 10: 0, 11: 0, 12: 1, 13: 1, 14: 2, 15: 2, 16: 3, 17: 3, 18: 4, 19: 4, 20: 5]
        
        var testCharacter = Character(name: "Bob")
        
        for ability in [CharacterAbilities.Strength, CharacterAbilities.Charisma, CharacterAbilities.Constitution, CharacterAbilities.Dexterity, CharacterAbilities.Intelligence, CharacterAbilities.Wisdom] {
            
            for score in 1 ... 20 {
                do {
                    try testCharacter.setAbility(ability, value: score)
                    let modifier = testCharacter.getModifier(ability)
                    let resultShouldBe = resultTable[score] ?? -20
                    XCTAssertTrue(modifier == resultShouldBe)
                } catch {
                    XCTFail()
                }
            }
        }
    }
    
    func testArmorClassIsModifiedByDexterity() {
        let testCharacter = Character(name: "Bob")
        let dexterityModifier = testCharacter.getModifier(CharacterAbilities.Dexterity)
        XCTAssertTrue(testCharacter.armorClass == (testCharacter.armorClass + dexterityModifier))
        
    }
    
    func testHitPointsAreModifierByConstiution() {
        let testCharacter = Character(name: "Bob")
        let constitutionModifier = testCharacter.getModifier(CharacterAbilities.Constitution)
        XCTAssertTrue(testCharacter.hitPoints == testCharacter.hitPoints + constitutionModifier)
    }
    
    func testExperiencePointsAddedWithSuccessfulAttack() {
        var testCharacter = Character(name: "Bob")
        var victim = Character(name: "Victor")
        XCTAssertTrue(testCharacter.experiencePoints == 0)
        AttackResolver.resolveAttack(&testCharacter, victim: &victim, roll: 10)
        XCTAssertTrue(testCharacter.experiencePoints == 10)
    }
}
