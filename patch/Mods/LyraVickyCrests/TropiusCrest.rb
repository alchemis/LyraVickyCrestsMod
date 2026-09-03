PBStuff::POKEMONTOCREST[:TROPIUS] = :LVCTROPCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCTROPCREST] = ItemData.new(:LVCTROPCREST, {
    name: "Tropius Crest",
    desc: "Tropius gains the Dragon-Type on entry and incoming Ice moves become Water in the Sun. Boosts offenses and Speed.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battle
    alias_method :tropcrest_pbCrestEntry, :pbCrestEntry if !method_defined?(:tropcrest_pbCrestEntry)
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

  alias_method :tropcrest_pbEndOfRoundPhase, :pbEndOfRoundPhase if !method_defined?(:tropcrest_pbEndOfRoundPhase)
  def pbEndOfRoundPhase(skipcelebi = false)
      priority = setSpeedOrder
      for battler in priority
        battler.effects[:lvc_targetting_tropcrest] = false if battler.effects[:lvc_targetting_tropcrest]
      end
      tropcrest_pbEndOfRoundPhase(skipcelebi)
  end
end

class PokeBattle_Battler
    alias_method :tropcrest_crestStats, :crestStats if !method_defined?(:tropcrest_crestStats)
    def crestStats
      
      if @crested == :TROPIUS
        @spatk *= 1.2
        @attack *= 1.2
        @speed *= 1.2
      end
      tropcrest_crestStats
    end
end 

class PokeBattle_Move

    alias_method :tropcrest_pbType, :pbType if !method_defined?(:tropcrest_pbType)
    def pbType(attacker, type = @type)
      type = tropcrest_pbType(attacker, type)
      if type == :ICE && @battle.pbWeather(nil) == :SUNNYDAY && (@battle.pbLVC_OpposingCrestCheck(attacker,:TROPIUS))
        type = :WATER
      end
      return type
    end

    alias_method :tropcrest_pbCalcDamage, :pbCalcDamage if !method_defined?(:tropcrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
      damage = tropcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)
      type = movetype.nil? ? pbType(attacker) : movetype
      feedbackMessages[opponent.index].push(:TropCrestThaw) if type == :ICE && @type == :WATER && @battle.pbLVC_OpposingCrestCheck(attacker,:TROPIUS)
      return damage
    end

    alias_method :tropcrest_damageCalcMessages, :damageCalcMessages if !method_defined?(:tropcrest_damageCalcMessages)
    def damageCalcMessages(attacker, feedbackMessages, late: false)
        tropcrest_damageCalcMessages(attacker, feedbackMessages, late: late)
        if late
            #too mentally unwell to rewrite this properly
            messageHash = {}
            feedbackMessages.each_pair do |index, messages|
              messages.each do |message|
                messageHash[message] = [] unless messageHash.has_key?(message)
                messageHash[message].push(index)
              end
            end
            messageHash.each do |message, indexes|  
                if message == :TropCrestThaw
                  pbShowAbilityBox(@battle.battlers[index], item: true)
                  pbDisplay(_INTL("The tropical sun thawed the move!"))
                  pbHideAbilityBox(@battle.battlers[index])
                  break  
                end
            end
        end
    end
end
#make the ai aware of it, not of the spread effect
#shouldnt be needed anymore
# class PokeBattle_AI
#     alias_method :tropcrest_pbTypeModNoMessages, :pbTypeModNoMessages if !method_defined?(:tropcrest_pbTypeModNoMessages)
#     def pbTypeModNoMessages(type = @move.type, attacker = @attacker, opponent = @opponent, move = @move, skill = @mondata.skill)
#       if skill >= HIGHSKILL && type == :ICE && @battle.pbWeather(opponent) == :SUNNYDAY &&
#         (opponent.crested == :TROPIUS || #single target move targetting tropius
#         (@battle.pbLVC_OpposingCrestCheck(attacker,:TROPIUS) && (move.pbTargetsAll?(attacker) || attacker.pbTarget(move) == :AllOpposing))) #spread move targetting tropius & its ally
#         typemod = tropcrest_pbTypeModNoMessages(:WATER, attacker, opponent, move, skill)
#         puts "This targets tropcrest! The typemod is #{typemod.multiplier}"
#       else
#         typemod = tropcrest_pbTypeModNoMessages(type, attacker, opponent, move, skill) 
#       end
#       return typemod
#     end
# end
