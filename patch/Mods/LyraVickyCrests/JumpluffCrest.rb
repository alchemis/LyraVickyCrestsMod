PBStuff::POKEMONTOCREST[:JUMPLUFF] = :LVCJMPLFFCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCJMPLFFCREST] = ItemData.new(:LVCJMPLFFCREST, {
    name: "Jumpluff Crest",
    desc: "Jumpluff's ability becomes Wind Rider, also it sets a 2-turn Tailwind on entry.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battle
  alias jmplffcrest_pbCrestEntry pbCrestEntry if !defined?(jmplffcrest_pbCrestEntry)
  def pbCrestEntry(index, pokemon)
    
    battler = @battlers[index]
    case battler.crested
      when :JUMPLUFF
        pbShowAbilityBox(battler, item: true)
        pbAnimation(:TAILWIND, battler, nil)
        if battler.pbOwnSide.effects[:Tailwind] == 0
          pbDisplay(_INTL("{1} stirred up a short Tailwind!", battler.pbThis))
          jmplffcrest_noabilcheck_pbSetTailwind(2, battler.pbOwnSide)
        else
          pbDisplay(_INTL("{1} replenished the Tailwind!", battler.pbThis))
          jmplffcrest_noabilcheck_pbSetTailwind(battler.pbOwnSide.effects[:Tailwind] + 1, battler.pbOwnSide)
        end
        pbHideAbilityBox(battler)
    end    
    jmplffcrest_pbCrestEntry(index, pokemon)
  end

  def jmplffcrest_noabilcheck_pbSetTailwind(duration, side)
    side.effects[:Tailwind] = duration
    if [:MOUNTAIN, :SNOWYMOUNTAIN, :VOLCANICTOP, :SKY].include?(@field.effect) && canSetWeather?(:STRONGWINDS)
      duration = @field.effect == :SKY ? duration+3 : duration+1
      pbSetWeather(:STRONGWINDS, duration)
    end
  end


end

class PokeBattle_Battler
    alias jmplffcrest_crestStats crestStats
    def crestStats
      
      case @crested
        when :JUMPLUFF
            @ability = :WINDRIDER
            # @attack, @defense, @spatk, @spdef += @speed * 0.1 # maybe Jumpluff should hurt people
      end
      jmplffcrest_crestStats
    end
end