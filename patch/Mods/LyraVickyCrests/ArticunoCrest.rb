PBStuff::POKEMONTOCREST[:ARTICUNO] = :LVCARTICREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCARTICREST] = ItemData.new(:LVCARTICREST, {
    name: "Articuno Crest",
    desc: "Articuno causes it to snow for 8 turns on entry, also removes its Ice-Type's weaknesses during snow.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Move
  alias articrest_irregularTypeMods irregularTypeMods if !defined?(articrest_irregularTypeMods)
  def irregularTypeMods(attacker, opponent, typemod, type)
    typemod = articrest_irregularTypeMods(attacker, opponent, typemod, type)
    case opponent.crested
      when :ARTICUNO
        if @battle.pbWeather(attacker) == :SNOW || @battle.pbWeather(attacker) == :HAIL  then
          typemod *= Typemod.half if [:FIGHTING, :ROCK, :FIRE, :STEEL].include?(type)
        end
    end
    return typemod
  end
end

class PokeBattle_Battle
    alias articrest_pbCrestEntry pbCrestEntry if !defined?(articrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      articrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :ARTICUNO
          return if !canSetWeather?(:SNOW)
          duration = [:ICY, :SNOWYMOUNTAIN, :FROZENDIMENSION, :SKY, :CLOUDS].include?(@field.effect) ? 11 : 8
          pbShowAbilityBox(battler, item: true)
          pbSetWeather(:SNOW, duration)
          pbHideAbilityBox(battler)
      end
    end
end