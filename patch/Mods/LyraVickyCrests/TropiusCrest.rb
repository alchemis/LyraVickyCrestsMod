PBStuff::POKEMONTOCREST[:TROPIUS] = :LVCTROPCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCTROPCREST] = ItemData.new(:LVCTROPCREST, {
    name: "Tropius Crest",
    desc: "Tropius gains the Dragon-type on entry. In Sun, incoming ice-type moves become water. Boosts Atk, Sp. Atk and Speed slightly.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battle
    alias_method :tropcrest_pbCrestEntry, :pbCrestEntry if !defined?(tropcrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      tropcrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      if battler.crested == :TROPIUS
          pbShowAbilityBox(battler, item: true)
          pbDisplay(_INTL("{1} gained the Dragon type!", battler.pbThis))
          battler.effects[:TemporaryType] = :DRAGON
          pbHideAbilityBox(battler)
      end
    end

  alias_method :tropcrest_pbEndOfRoundPhase, :pbEndOfRoundPhase if !defined?(tropcrest_pbEndOfRoundPhase)
  def pbEndOfRoundPhase(skipcelebi = false)
      priority = setSpeedOrder
      for battler in priority
        battler.effects[:lvc_targetting_tropcrest] = false if battler.effects[:lvc_targetting_tropcrest]
      end
      tropcrest_pbEndOfRoundPhase(skipcelebi)
  end
end

class PokeBattle_Battler
    alias_method :tropcrest_crestStats, :crestStats if !defined?(tropcrest_crestStats)
    def crestStats
      
      if @crested == :TROPIUS
        @spatk *= 1.2
        @attack *= 1.2
        @speed *= 1.2
      end
      tropcrest_crestStats
    end
    alias_method :tropcrest_pbOnStartUse, :pbOnStartUse if !defined?(tropcrest_pbOnStartUse)
    def pbOnStartUse(user, targets, basemove, flags)
      for i in targets
        if i.crested == :TROPIUS && @battle.pbWeather(i) == :SUNNYDAY && basemove.pbType(user) == :ICE && basemove.pbIsDamaging?
            @battle.pbShowAbilityBox(i, item: true)
            @battle.pbDisplay(_INTL("The tropical sun thawed the move!", i.pbThis))
            @battle.pbHideAbilityBox(i)
            @effects[:lvc_targetting_tropcrest] = true
            break
        end
      end
      return tropcrest_pbOnStartUse(user, targets, basemove, flags)
    end
end #battler.effects[:lvc_targetting_tropcrest] = nil

class PokeBattle_Move
    alias_method :tropcrest_pbType, :pbType if !defined?(tropcrest_pbType)
    def pbType(battler)
      type = tropcrest_pbType(battler)
      if defined?(battler.effects[:lvc_targetting_tropcrest]) && battler.effects[:lvc_targetting_tropcrest] && type == :ICE
        type = :WATER
      end
      return type
    end

end
#make the ai aware of it, not of the spread effect
class PokeBattle_AI
    alias_method :tropcrest_pbTypeModNoMessages, :pbTypeModNoMessages if !defined?(tropcrest_pbTypeModNoMessages)
    def pbTypeModNoMessages(type = @move.type, attacker = @attacker, opponent = @opponent, move = @move, skill = @mondata.skill)
      typemod = tropcrest_pbTypeModNoMessages(type, attacker, opponent, move, skill)
      if skill >= HIGHSKILL && type == :ICE
          typemod = Typemod.half * Typemod.half  * Typemod.half if opponent.crested == :TROPIUS && @battle.pbWeather(opponent) == :SUNNYDAY
      end
      return typemod
    end
end
