
PBStuff::POKEMONTOCREST[:BRELOOM] = :LVCBRELCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCBRELCREST] = ItemData.new(:LVCBRELCREST, {
    name: "Breloom Crest",
    desc: "Works for either form. Grants a different effect based on ability.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}




class PokeBattle_Move
    alias brecrest_pbCalcDamage pbCalcDamage if !defined?(brecrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
      if movetype then
        damage = brecrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype) #attacker, opponent, hitnum, feedbackMessages, movetype
      else damage = brecrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages)
      end
      basedmg = @basedamage
      basedmg = pbBaseDamage(basedmg, attacker, opponent) 
      if attacker.crested == :BRELOOM
        damage *= 1.5 if attacker.ability == :TECHNICIAN && basedamage <= 80 && basedamage > 60 
        damage *= 1.3 if attacker.ability == :TOUGHCLAWS && self.pbIsPhysical?(attacker) && !self.contactMove?
      end
      return damage
      
    end
    
    alias brecrest_pbIsSpecial? pbIsSpecial? if !defined?(brecrest_pbIsSpecial?)
    def pbIsSpecial?(attacker, type = @type)
      if attacker.crested == :BRELOOM && attacker.ability == :TECHNICIAN then
        return false
      else return brecrest_pbIsSpecial?(attacker,type)
      end

    end

    alias brecrest_pbIsPhysical? pbIsPhysical? if !defined?(brecrest_pbIsPhysical?)
    def pbIsPhysical?(attacker, type = @type)
      if attacker.crested == :BRELOOM && attacker.ability == :TECHNICIAN then
        return true
      else return brecrest_pbIsPhysical?(attacker,type)
      end

    end

    alias brecrest_pbHitsSpecialStat? pbHitsSpecialStat? if !defined?(brecrest_pbHitsSpecialStat?)
    def pbHitsSpecialStat?(attacker, type = @type)
      if attacker.crested == :BRELOOM && attacker.ability == :TECHNICIAN then
        return !(@category == :special) if @function == 0x122 #psyshock, etc
        return @category == :special #check category directly instead of calling pbIsSpecial since we overrode the behavior on that
      else return brecrest_pbHitsSpecialStat?(attacker,type)
      end
    end

end

class PokeBattle_Battler

    alias brecrest_crestStats crestStats if !defined?(brecrest_crestStats)
    def crestStats
      brecrest_crestStats
      if @crested == :BRELOOM 
        case @ability
        when :POISONHEAL then
          @defense += (@attack*0.2)
          @spdef += (@attack*0.2)
        when :TOUGHCLAWS then @speed *= 1.1
        when :STATIC then @speed *= 1.1
        when :EFFECTSPORE then @speed *= 1.1
        end #technician handlded in pokebattle_move
      end
    end

    alias brecrest_pbResolveMoveEffects pbResolveMoveEffects if !defined?(brecrest_pbResolveMoveEffects)
    def pbResolveMoveEffects(user, basemove, targets, calcdamage, hitflag, hitcount, flags = { totaldamage: 0, UserFaintCause: [] })
      ret = brecrest_pbResolveMoveEffects(user, basemove, targets, calcdamage, hitflag, hitcount, flags)
      if user.crested == :BRELOOM && !(hitcount > 1)
        targets.each_with_index do |target, i|
          # Status Moves don't have secondary effects, so :StatusSuccess flag is getting skipped here as well
          next unless hitflag[i] == :Success && (target.ability != :SHIELDDUST || target.moldbroken) && !target.hasWorkingItem(:COVERTCLOAK)
          puts "brelcrest can effect!"
          if user.ability == :EFFECTSPORE && @battle.pbRandom(10) < 3
            rnd = @battle.pbRandom(3)
            case rnd
              when 0 then target.pbSleep if target.pbCanSleep?(target, user)
              when 1 then target.pbPoison(user) if target.pbCanPoison?(target, user)
              when 2 then target.pbParalyze(user) if target.pbCanParalyze?(target, user)
            end
          elsif user.ability ==:STATIC && @battle.pbRandom(10) < 5
            target.pbParalyze(user) if target.pbCanParalyze?(target, user)
          end
        end
      end

      return ret
    end
end

class PokeBattle_Battle
    alias brecrest_pbCrestEntry pbCrestEntry if !defined?(brecrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      brecrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      if battler.crested == :BRELOOM
        pbShowAbilityBox(battler, item: true)
        case battler.ability
        when :EFFECTSPORE then @battle.pbDisplay(_INTL("{1}'s claws are looking <c3=#{colorToRgb32(Color.new(237, 209, 99))},#{colorToRgb32(Color.new(157, 129, 19))}dire<\/c3>!", battler.pbThis))
        when :POISONHEAL then 
          @battle.pbDisplay(_INTL("{1}'s hunkers down!", battler.pbThis))
          battler.pbPoison(battler, true, message: _INTL("{1} was poisoned by its {2}!", battler.pbThis, getItemName(battler.item))) if battler.status != :POISON
        when :TECHNICIAN then @battle.pbDisplay(_INTL("{1} is feeling <c3=#{colorToRgb32(Color.new(237, 209, 99))},#{colorToRgb32(Color.new(157, 129, 19))}special<\/c3>!", battler.pbThis))
        when :TOUGHCLAWS then @battle.pbDisplay(_INTL("{1}'s claws look like they could cut\nfrom a <c3=#{colorToRgb32(Color.new(237, 209, 99))},#{colorToRgb32(Color.new(157, 129, 19))} distance<\/c3>!", battler.pbThis))
        when :STATIC then @battle.pbDisplay(_INTL("{1}'s claws are <c3=#{colorToRgb32(Color.new(237, 209, 99))},#{colorToRgb32(Color.new(157, 129, 19))}electrified<\/c3>!", battler.pbThis))
        end
        pbHideAbilityBox(battler)
      end
    end
end