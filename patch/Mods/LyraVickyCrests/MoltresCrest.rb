PBStuff::POKEMONTOCREST[:MOLTRES] = :LVCMOLCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCMOLCREST] = ItemData.new(:LVCMOLCREST, {
    name: "Moltres Crest",
    desc: "Moltres causes harsh sunlight for 8 turns on switch-in, it resists Rock-type moves in the sun.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Move
  alias molcrest_irregularTypeMods irregularTypeMods if !defined?(molcrest_irregularTypeMods)
  def irregularTypeMods(attacker, opponent, typemod, type)
    typemod = molcrest_irregularTypeMods(attacker, opponent, typemod, type)
    case opponent.crested
      when :MOLTRES
        if @battle.pbWeather(attacker) == :SUNNYDAY then
          typemod = Typemod.half if [:ROCK].include?(type)
        end
    end
    return typemod
  end
end

class PokeBattle_Battle
    alias molcrest_pbCrestEntry pbCrestEntry if !defined?(molcrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      molcrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :MOLTRES
          return if !canSetWeather?(:SUNNYDAY)
          duration = [:DESERT, :MOUNTAIN, :SNOWYMOUNTAIN, :SKY].include?(@field.effect) ? 11 : 8
          pbShowAbilityBox(battler, item: true)
          pbSetWeather(:SUNNYDAY, duration)
          pbHideAbilityBox(battler)
      end
    end
end