#PBStuff::POKEMONTOCREST[:NINETALES] = :LVCATALESCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCATALESCREST] = ItemData.new(:LVCATALESCREST, {
    name: "A. Ninetales Crest",
    desc: "Increases A. Ninetales' DEF and Sp.ATK by 20%. This is also treated as the Weather Rocks and Light Clay.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


ModCacheInjection.hook(:items) {
  $cache.items[:LVCNINETALESCREST] = ItemData.new(:LVCNINETALESCREST, {
    name: "K. Ninetales Crest",
    desc: "Increases Ninetales' Sp.ATK by 20% and places a Curse on contact, also it gains Ghost-Type STAB and resistances.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    #form check..
    alias_method :atalescrest_hasCrest?, :hasCrest? if !method_defined?(:atalescrest_hasCrest?)
    def hasCrest?(species = self.species)
        if species == :NINETALES then
          return true if @item == :LVCATALESCREST && form == 1
          return true if @item == :LVCNINETALESCREST && form == 0
          return false
        else return atalescrest_hasCrest?(species)
        end
    end


    #stats
    alias_method :atalescrest_crestStats, :crestStats if !method_defined?(:atalescrest_crestStats)
    def crestStats
      
      case @crested
        when :NINETALES && form == 1
            @defense *= 1.2
        when :NINETALES
            @spatk *= 1.2
      end
      atalescrest_crestStats
    end

    #item stuff
    alias_method :atalescrest_hasWorkingItem, :hasWorkingItem if !method_defined?(:atalescrest_hasWorkingItem)
    def hasWorkingItem(item, ignorefainted: false)
      ignorefainted = false if !defined?(ignorefainted)
      if @crested == :NINETALES && form == 1 then
        case item
        when :ICYROCK then return true
        when :HEATROCK then return true
        when :DAMPROCK then return true
        when :SMOOTHROCK then return true
        when :LIGHTCLAY then return true
        end
      end
      return atalescrest_hasWorkingItem(item, ignorefainted: ignorefainted)
    end

    #curse effect
    alias_method :atalescrest_pbEffectsOnDealingDamage, :pbEffectsOnDealingDamage if !method_defined?(:atalescrest_pbEffectsOnDealingDamage)
    def pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent = false, futureSight = false)
      if target.crested == :NINETALES && target.form == 0 then
        if user.makesContact?(move) && !user.effects[:Curse] 
          @battle.pbShowAbilityBox(target, item:true)
          @battle.pbDisplay(_INTL("Touching {1} put a curse on {2}!", target.pbThis, user.pbThis(true)))
          user.effects[:Curse] = true
          @battle.pbHideAbilityBox(target)
        end
      end
      return atalescrest_pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent, futureSight)
    end


end

class PokeBattle_Move

  alias_method :atalescrest_pbModifySTAB, :pbModifySTAB if !method_defined?(:atalescrest_pbModifySTAB)
  def pbModifySTAB(stabmult, type, attacker, opponent)
    if attacker.crested == :NINETALES && attacker.form == 0 && type == :GHOST then
        stabmult += 0.5 if stabmult <= 1
    end
    return atalescrest_pbModifySTAB(stabmult, type, attacker, opponent)
  end

  alias_method :atalescrest_irregularTypeMods, :irregularTypeMods if !method_defined?(:atalescrest_irregularTypeMods)
  def irregularTypeMods(attacker, opponent, typemod, type)
    typemod = atalescrest_irregularTypeMods(attacker, opponent, typemod, type)
    if opponent.crested == :NINETALES && opponent.form == 0
        typemod *= Typemod.half if [:POISON, :BUG].include?(type) 
        typemod *= Typemod.zero if [:NORMAL, :FIGHTING].include?(type) 
    end
    return typemod
  end


end