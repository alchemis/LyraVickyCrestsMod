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

    alias_method :tropcrest_irregularTypeMods, :irregularTypeMods if !method_defined?(:tropcrest_irregularTypeMods)
    def irregularTypeMods(attacker, opponent, typemod, type)
      typemod = tropcrest_irregularTypeMods(attacker, opponent, typemod, type)
      case opponent.crested
        when :TROPIUS
          if @battle.pbWeather(attacker) == :SUNNYDAY then
            typemod = Typemod.half * Typemod.half if [:ICE].include?(type)
          end
      end
      return typemod
    end

    alias_method :tropcrest_pbCalcDamage, :pbCalcDamage if !method_defined?(:tropcrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
      damage = tropcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)
      type = movetype.nil? ? pbType(attacker) : movetype
      feedbackMessages[opponent.index].push(:TropCrestThaw) if type == :ICE && opponent.crested == :TROPIUS && @battle.pbWeather(attacker) == :SUNNYDAY #@battle.pbLVC_OpposingCrestCheck(attacker,:TROPIUS)
      return damage
    end

    alias_method :tropcrest_damageCalcMessages, :damageCalcMessages if !method_defined?(:tropcrest_damageCalcMessages)
    def damageCalcMessages(attacker, feedbackMessages, late: false)
      #this shit doesnt work stupid bitch
        tropcrest_damageCalcMessages(attacker, feedbackMessages, late: late)
        if !late
            #too mentally unwell to rewrite this properly
            messageHash = {}
            feedbackMessages.each_pair do |index, messages|
              messages.each do |message|
                messageHash[message] = [] unless messageHash.has_key?(message)
                messageHash[message].push(index)
              end
            end
            messageHash.each do |message, indexes|
              indexes.each do |index|
                if message == :TropCrestThaw
                  @battle.pbShowAbilityBox(@battle.battlers[index], item: true)
                  @battle.pbDisplay(_INTL("The tropical sun thawed the move!"))
                  @battle.pbHideAbilityBox(@battle.battlers[index])
                end
              end
            end
        end
    end
end