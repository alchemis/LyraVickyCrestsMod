PBStuff::POKEMONTOCREST[:RAPIDASH] = :LVCRAPIDCREST

ModCacheInjection.hook(:items) {
  $cache.items[:LVCRAPIDCREST] = ItemData.new(:LVCRAPIDCREST, {
    name: "Rapidash Crest",
    desc: "Rapidash's Special Attack equals its Speed, also its Speed is boosted whenever a Ball or Bomb move is used.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias_method :rapidcrest_crestStats, :crestStats if !method_defined?(:rapidcrest_crestStats)
    def crestStats
      case @crested
        when :RAPIDASH
          @spatk = @speed
      end
      rapidcrest_crestStats
    end

   alias_method :rapidcrest_applyPostMoveEffects, :applyPostMoveEffects if !method_defined?(:rapidcrest_applyPostMoveEffects)
   def applyPostMoveEffects(basemove, user, targets, hitflag)
     ret = rapidcrest_applyPostMoveEffects(basemove, user, targets, hitflag)
     if [:Success, :StatusSuccess].intersect?(hitflag)
       id = basemove.move
       priority = @battle.setSpeedOrder
       for i in priority
          if i.crested == :RAPIDASH && $cache.moves[id]&.checkFlag?(:ballmove)
            if i.pbCanIncreaseAnyStat?([PBStats::SPEED], i, nil, showMessage: false)
              @battle.pbShowAbilityBox(i, item: true)
              @battle.pbDisplay(_INTL("{1} is off to the races!", i.pbThis))
              i.pbChangeStats([PBStats::SPEED], 1, i, nil, abilitycheck: :skip)
              @battle.pbHideAbilityBox(i)
            end
          end
          if i.crested == :RAPIDASH && $cache.moves[id]&.checkFlag?(:bombmove)
            if i.pbCanIncreaseAnyStat?([PBStats::SPEED], i, nil, showMessage: false)
              @battle.pbShowAbilityBox(i, item: true)
              @battle.pbDisplay(_INTL("{1} is off to the races!", i.pbThis))
              i.pbChangeStats([PBStats::SPEED], 1, i, nil, abilitycheck: :skip)
              @battle.pbHideAbilityBox(i)
            end
          end
        end
      end
    return ret
  end
end

# Lyra oh merciful goddess please somehow make the Speed increase also update the SpATK = Speed stuff :pray: